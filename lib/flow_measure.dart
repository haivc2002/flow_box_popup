import 'package:flutter/material.dart';

/// Measures the rendered size of a popup widget **off-screen**.
///
/// Temporarily inserts the widget into the [Overlay] at a hidden position,
/// waits one frame for layout, then reads the resulting [RenderBox.size].
/// The measurement entry is removed immediately afterward.
///
/// Returns the laid-out [Size] of the content (including padding).
///
/// Example usage:
/// ```dart
/// final contentSize = await measurePopupContent(
///   context: context,
///   builder: (context) => MyPopupContent(),
///   padding: const EdgeInsets.all(8.0),
///   maxWidth: MediaQuery.of(context).size.width * 0.8,
/// );
/// ```
Future<Size> measurePopupContent({
  /// The build context used to access the overlay and render tree.
  required BuildContext context,

  /// The widget builder that returns the popup content to measure.
  required Widget Function(BuildContext) builder,

  /// The maximum width constraint used during measurement.
  required double maxWidth,
}) async {
  /// Key to locate the render object for size measurement.
  final measureKey = GlobalKey();

  /// Access the nearest [Overlay] for temporary insertion.
  final overlay = Overlay.of(context);

  /// Off-screen overlay entry used purely for layout measurement.
  final measureEntry = OverlayEntry(
    builder: (_) => Positioned(
      left: -10000,
      top: -10000,
      width: maxWidth,
      child: Material(
        key: measureKey,
        color: Colors.transparent,
        child: builder(context),
      ),
    ),
  );

  /// Insert temporarily for one frame to trigger layout.
  overlay.insert(measureEntry);

  /// Wait for layout to complete.
  await WidgetsBinding.instance.endOfFrame;

  try {
    /// Read the final laid-out size from the render tree.
    final renderBox =
        measureKey.currentContext!.findRenderObject() as RenderBox;
    return renderBox.size;
  } finally {
    /// Clean up: remove the measurement entry regardless of success or failure.
    measureEntry.remove();
  }
}