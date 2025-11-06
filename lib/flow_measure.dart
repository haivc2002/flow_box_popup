import 'package:flutter/material.dart';

/// Measures the intrinsic size of a popup widget **off-screen** without
/// displaying it to the user.
///
/// This is useful when you need to know a widget's rendered dimensions
/// before actually positioning or animating it in the visible overlay.
///
/// Internally, it temporarily inserts the widget into the [Overlay] at an
/// off-screen position, waits for a frame to complete, then reads its
/// [RenderBox.size].
///
/// Returns the rendered [Size] of the popup content after padding.
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

  /// Padding applied around the widget when measuring its size.
  required EdgeInsetsGeometry padding,

  /// The maximum width constraint used during measurement.
  required double maxWidth,
}) async {
  /// A unique key to locate the render object of the test widget.
  final measureKey = GlobalKey();

  /// Access the nearest overlay from the provided context.
  final overlay = Overlay.of(context);

  /// Create an off-screen overlay entry at a far negative coordinate.
  /// This prevents it from appearing on-screen during measurement.
  final measureEntry = OverlayEntry(
    builder: (_) => Positioned(
      left: -10000,
      top: -10000,
      width: maxWidth,
      child: Material(
        color: Colors.transparent,
        child: Padding(
          key: measureKey,
          padding: padding,
          child: builder(context),
        ),
      ),
    ),
  );

  /// Insert the entry temporarily into the overlay for layout measurement.
  overlay.insert(measureEntry);

  /// Wait until the current frame completes so layout information is available.
  await WidgetsBinding.instance.endOfFrame;

  /// Retrieve the RenderBox to read its final laid-out size.
  final renderBox = measureKey.currentContext!.findRenderObject() as RenderBox;
  final size = renderBox.size;

  /// Remove the measurement entry immediately after obtaining the size.
  measureEntry.remove();

  /// Return the measured size to the caller.
  return size;
}
