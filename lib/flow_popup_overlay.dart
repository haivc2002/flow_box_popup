import 'package:flutter/material.dart';
import 'flow_popup_decoration.dart';

/// A widget that handles the animated transition of a popup expanding
/// from its source widget into an overlay with smooth interpolation
/// between size, position, and decoration.
///
/// This widget is designed to be used inside an [OverlayEntry].
/// It supports automatic repositioning and resizing when the keyboard appears.
class FlowPopupOverlay extends StatelessWidget {
  /// Animation controller that drives the transition between
  /// the child and popup states.
  final Animation<double> animation;

  /// The starting position of the popup (the source widget’s global offset).
  final Offset startPosition;

  /// The target position for the fully expanded popup.
  final Offset targetPosition;

  /// The initial size (source widget’s size).
  final Size startSize;

  /// The final size (popup content’s target size).
  final Size targetSize;

  /// The decoration used for the child before expansion.
  final FlowPopupDecoration childDecoration;

  /// The decoration used for the popup after full expansion.
  final FlowPopupDecoration popDecoration;

  /// The builder that constructs the popup’s inner content.
  final Widget Function(BuildContext) popBuilder;

  /// Called when the overlay background (dimmed area) is tapped.
  final VoidCallback onClose;
  final Color barrierColor;

  const FlowPopupOverlay({
    super.key,
    required this.animation,
    required this.startPosition,
    required this.targetPosition,
    required this.startSize,
    required this.targetSize,
    required this.childDecoration,
    required this.popDecoration,
    required this.popBuilder,
    required this.onClose,
    required this.barrierColor
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, _) {
        final t = animation.value;

        /// Interpolate position, size, and visual styles between
        /// the "child" and "popup" states based on animation progress.
        final position = Offset.lerp(startPosition, targetPosition, t)!;
        final size = Size.lerp(startSize, targetSize, t)!;
        final decoration = FlowPopupDecoration.lerp(childDecoration, popDecoration, t)!;

        final mediaQuery = MediaQuery.of(context);
        final screenHeight = mediaQuery.size.height;
        final screenWidth = mediaQuery.size.width;
        final keyboardHeight = mediaQuery.viewInsets.bottom;

        double top = position.dy;
        double height = size.height;

        /// --- Keyboard adjustment logic ---
        ///
        /// If the keyboard is visible and overlaps the popup,
        /// shift the popup upward and reduce its height to maintain visibility.
        if (keyboardHeight > 0) {
          final bottom = top + height;
          final overlap = bottom - (screenHeight - keyboardHeight);
          if (overlap > 0) {
            /// Keep at least 100px margin from the top for visual breathing room.
            top = (top - overlap - 20).clamp(100.0, top);
          }
        }

        /// The popup’s height dynamically adapts to screen height
        /// minus reserved spaces for top margin and keyboard.
        final availableHeight = screenHeight - 140 - keyboardHeight;
        height = height.clamp(0, availableHeight);

        return Stack(
          children: [
            /// --- Dimmed background layer ---
            ///
            /// Appears when animation starts; intercepts taps to close the popup.
            if (t > 0)
              Positioned.fill(
                child: Opacity(
                  opacity: t,
                  child: GestureDetector(
                    onTap: onClose,
                    child: ColoredBox(color: barrierColor),
                  ),
                ),
              ),

            /// --- Main popup container ---
            ///
            /// Smoothly transitions between source widget and popup dimensions.
            Positioned(
              left: position.dx,
              top: top,
              width: size.width,
              height: height,
              child: RepaintBoundary(
                child: Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: decoration.color,
                    borderRadius: decoration.radius,
                    boxShadow: [decoration.boxShadows],
                    border: decoration.border,
                  ),
                  child: Material(
                    color: Colors.transparent,
                    animationDuration: Duration.zero,
                    child: OverflowBox(
                      maxHeight: double.infinity,
                      maxWidth: double.infinity,
                      alignment: Alignment.topCenter,
                      child: Center(
                        child: SizedBox(
                          width: screenWidth * 0.8,
                          height: height,
                          child: Padding(
                            padding: decoration.padding,
                            child: Opacity(
                              opacity: animation.value,
                              child: popBuilder(context),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
