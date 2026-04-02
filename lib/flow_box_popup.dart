import 'package:flow_box_popup/flow_popup_animator.dart';
import 'package:flow_box_popup/flow_popup_overlay.dart';
import 'package:flutter/material.dart';

import 'flow_measure.dart';

/// A smart animated popup widget that morphs from a child widget into
/// a floating overlay with smooth decoration transitions.
///
/// Ideal for contextual menus, tooltips, or detail previews that expand
/// above existing content with animated size, position, and decoration
/// interpolation. Automatically adjusts when the keyboard appears.
///
/// Uses [BoxDecoration] for styling both the child and popup states,
/// enabling seamless lerp transitions via [BoxDecoration.lerp].
///
/// Example:
/// ```dart
/// FlowBoxPopup(
///   child: Text("Tap Me"),
///   popupBuilder: (context) => ListView(
///     shrinkWrap: true,
///     children: [TextField(), SizedBox(height: 300)],
///   ),
/// );
/// ```
class FlowBoxPopup extends StatefulWidget {
  /// The child widget that triggers the popup when tapped.
  final Widget child;

  /// The [BoxDecoration] applied to the child widget in its resting state.
  /// Falls back to a theme-based default if `null`.
  final BoxDecoration? boxDecoration;

  /// The [BoxDecoration] applied to the popup in its fully expanded state.
  /// Falls back to a theme-based default if `null`.
  final BoxDecoration? popupDecoration;

  /// Inner padding for the child widget content.
  final EdgeInsetsGeometry boxPadding;

  /// The duration of the popup animation.
  final Duration duration;

  /// Builder that constructs the popup's inner content when expanded.
  final Widget Function(BuildContext context) popupBuilder;
  /// The color of the dimmed background behind the popup overlay.
  final Color barrierColor;

  FlowBoxPopup({
    super.key,
    required this.child,
    this.boxDecoration,
    this.popupDecoration,
    this.boxPadding = const EdgeInsets.all(8.0),
    this.duration = const Duration(milliseconds: 350),
    required this.popupBuilder,
    Color? barrierColor
  }) : barrierColor = barrierColor ?? Colors.black.withValues(alpha: 0.6);

  @override
  State<FlowBoxPopup> createState() => _FlowBoxPopupState();
}

/// Manages popup lifecycle: measuring content size off-screen,
/// using [Navigator.push] to show the popup route, and driving morph animation.
class _FlowBoxPopupState extends State<FlowBoxPopup> {
  /// Global key used to locate the child widget's render box.
  final GlobalKey _childKey = GlobalKey();

  /// Resolved [BoxDecoration] for the child (resting) state.
  late BoxDecoration _childDecoration;

  /// Resolved [BoxDecoration] for the popup (expanded) state.
  late BoxDecoration _popDecoration;

  /// Whether the child is hidden during popup display.
  bool _isChildHidden = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(covariant FlowBoxPopup oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.boxDecoration != widget.boxDecoration ||
        oldWidget.popupDecoration != widget.popupDecoration) {
      _resolveDecorations(context);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  /// Resolves [BoxDecoration]s by applying widget overrides or theme-based defaults.
  void _resolveDecorations(BuildContext context) {
    final theme = Theme.of(context);
    final defaultColor = theme.colorScheme.surfaceDim;
    const defaultRadius = BorderRadius.all(Radius.circular(10));

    _childDecoration = widget.boxDecoration ??
        BoxDecoration(
          color: defaultColor,
          borderRadius: defaultRadius,
        );

    _popDecoration = widget.popupDecoration ??
        BoxDecoration(
          color: defaultColor,
          borderRadius: defaultRadius,
        );
  }

  /// Measures popup content and pushes a [PageRoute] to display the popup.
  Future<void> _showPopup() async {
    if (_isChildHidden) return;

    final screenSize = MediaQuery.of(context).size;
    final maxWidth = screenSize.width * 0.8;
    final maxHeight = screenSize.height * 0.6;

    final childBox = _childKey.currentContext!.findRenderObject() as RenderBox;
    final childPos = childBox.localToGlobal(Offset.zero);
    final childSize = childBox.size;

    final contentSize = await measurePopupContent(
      context: context,
      builder: widget.popupBuilder,
      maxWidth: maxWidth,
    );

    final double popupHeight = (contentSize.height).clamp(0, maxHeight);
    final popupWidth = maxWidth;

    final targetPos = Offset(
      (screenSize.width - popupWidth) / 2,
      (screenSize.height - popupHeight) / 2,
    );
    if (mounted) {
      final route = PageRouteBuilder(
        opaque: false,
        barrierColor: Colors.transparent,
        barrierLabel: "Dismiss",
        transitionDuration: widget.duration,
        reverseTransitionDuration: widget.duration,
        pageBuilder: (context, animation, secondaryAnimation) {
          final animator = FlowPopupAnimator(parent: animation);
          return FlowPopupOverlay(
            animation: animator,
            startPosition: childPos,
            targetPosition: targetPos,
            startSize: childSize,
            targetSize: Size(popupWidth, popupHeight),
            childDecoration: _childDecoration,
            popDecoration: _popDecoration,
            childPadding: widget.boxPadding,
            popBuilder: widget.popupBuilder,
            barrierColor: widget.barrierColor,
            triggerChild: widget.child,
            onClose: () => Navigator.of(context).pop(),
          );
        },
      );

      Navigator.of(context).push(route);
      Future.delayed(const Duration(milliseconds: 50), () {
        if (mounted) setState(() => _isChildHidden = true);
      });

      // Wait for the close animation to fully finish before showing the original child
      route.animation!.addStatusListener((status) {
        if (status == AnimationStatus.dismissed) {
          if (mounted) setState(() => _isChildHidden = false);
        }
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _resolveDecorations(context);
  }

  /// Safely extracts [BorderRadius] from a [BoxDecoration], returning [BorderRadius.zero] if unresolvable.
  BorderRadius _extractBorderRadius(BoxDecoration decoration) {
    final br = decoration.borderRadius;
    if (br is BorderRadius) return br;
    return BorderRadius.zero;
  }

  @override
  Widget build(BuildContext context) {
    _resolveDecorations(context);

    return GestureDetector(
      key: _childKey,
      onTap: _showPopup,
      child: Visibility(
        visible: !_isChildHidden,
        maintainSize: true,
        maintainAnimation: true,
        maintainState: true,
        child: ClipRRect(
          borderRadius: _extractBorderRadius(_childDecoration),
          clipBehavior: Clip.none,
          child: DecoratedBox(
            decoration: _childDecoration,
            child: Padding(
              padding: widget.boxPadding,
              child: widget.child,
            ),
          ),
        ),
      ),
    );
  }
}