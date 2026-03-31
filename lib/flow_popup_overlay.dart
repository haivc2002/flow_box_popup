import 'package:flutter/material.dart';

/// Renders the animated morph transition of a popup expanding from its
/// source widget into a centered overlay.
///
/// Interpolates position, size, and [BoxDecoration] between the child
/// and popup states using [BoxDecoration.lerp] for smooth visual transitions.
///
/// Designed to be used inside a [PageRoute]. Automatically repositions
/// and resizes when the software keyboard appears.
class FlowPopupOverlay extends StatelessWidget {
  /// The animation driving the morph transition (typically a [CurvedAnimation]).
  final Animation<double> animation;

  /// The starting position of the popup (the source widget's global offset).
  final Offset startPosition;

  /// The target position for the fully expanded popup.
  final Offset targetPosition;

  /// The initial size (source widget's size).
  final Size startSize;

  /// The final size (popup content's target size).
  final Size targetSize;

  /// The [BoxDecoration] for the child widget in its resting state.
  final BoxDecoration childDecoration;

  /// The [BoxDecoration] for the popup in its fully expanded state.
  final BoxDecoration popDecoration;

  /// Inner padding applied to the child content during the morph transition.
  final EdgeInsetsGeometry childPadding;

  /// Builder that creates the popup's inner content.
  final Widget Function(BuildContext) popBuilder;

  /// Callback invoked when the dimmed barrier is tapped to dismiss the popup.
  final VoidCallback onClose;

  /// The color of the dimmed barrier behind the popup.
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
    required this.childPadding,
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

        /// Interpolate position, size, and decoration between the child
        /// and popup states using the current animation progress [t].
        final position = Offset.lerp(startPosition, targetPosition, t)!;
        final size = Size.lerp(startSize, targetSize, t)!;
        final decoration = BoxDecoration.lerp(childDecoration, popDecoration, t)!;

        final mediaQuery = MediaQuery.of(context);
        final screenHeight = mediaQuery.size.height;
        final screenWidth = mediaQuery.size.width;
        final keyboardHeight = mediaQuery.viewInsets.bottom;

        double top = position.dy;
        double height = size.height;

        /// --- Keyboard-aware repositioning ---
        ///
        /// Shifts the popup upward and constrains its height when the
        /// software keyboard overlaps the popup area.
        if (keyboardHeight > 0) {
          final bottom = top + height;
          final overlap = bottom - (screenHeight - keyboardHeight);
          if (overlap > 0) {
            /// Preserve at least 100px from the top edge for visual breathing room.
            top = (top - overlap - 20).clamp(100.0, top);
          }
        }

        /// Constrain popup height to fit within the visible area,
        /// accounting for top margin (140px) and keyboard.
        final availableHeight = screenHeight - 140 - keyboardHeight;
        height = height.clamp(0, availableHeight);

        return Stack(
          children: [
            /// --- Dimmed barrier ---
            ///
            /// Fades in with the animation; tapping dismisses the popup.
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

            /// --- Morphing popup container ---
            ///
            /// Smoothly interpolates between child and popup decoration, size, and position.
            Positioned(
              left: position.dx,
              top: top,
              width: size.width,
              height: height,
              child: RepaintBoundary(
                child: Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.002) // perspective
                    ..rotateX(0.2) // top xa, bottom gần
                    ..rotateY(-0.4),
                  child: Container(
                    clipBehavior: Clip.antiAlias,
                    decoration: decoration,
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
