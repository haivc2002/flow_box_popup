import 'package:flow_box_popup/flow_popup_animator.dart';
import 'package:flow_box_popup/flow_popup_overlay.dart';
import 'package:flutter/material.dart';

import 'flow_popup_decoration.dart';
import 'flow_measure.dart';

/// A smart animated popup widget that expands from a child widget into
/// a floating overlay.
///
/// This widget is ideal for contextual menus, tooltips, or detail previews
/// that appear above existing content while keeping smooth transition
/// animations and keyboard awareness.
///
/// Example:
/// ```dart
/// FlowBoxPopup(
///   child: Text("Tap Me"),
///   popBuilder: (context) => ListView(
///     shrinkWrap: true,
///     children: [TextField(), SizedBox(height: 300)],
///   ),
/// );
/// ```
class FlowBoxPopup extends StatefulWidget {
  /// The child widget that triggers the popup when tapped.
  final Widget child;

  /// The decoration applied to the child before expansion.
  final FlowPopupDecoration? childDecoration;

  /// The decoration applied to the popup after expansion.
  final FlowPopupDecoration? popDecoration;

  /// The duration of the popup animation.
  final Duration duration;

  /// The animation curve for showing the popup.
  final Curve? curve;

  /// The reverse curve for dismissing the popup.
  final Curve? reverseCurve;

  /// The builder function for constructing the popup content.
  final Widget Function(BuildContext context) popBuilder;
  final Color barrierColor;

  FlowBoxPopup({
    super.key,
    required this.child,
    this.childDecoration,
    this.popDecoration,
    this.duration = const Duration(milliseconds: 350),
    this.curve,
    this.reverseCurve,
    required this.popBuilder,
    Color? barrierColor
  }) : barrierColor = barrierColor ?? Colors.black.withValues(alpha: 0.6);

  @override
  State<FlowBoxPopup> createState() => _FlowBoxPopupState();
}

/// Internal state class that handles popup measurement, overlay insertion,
/// and animation lifecycle.
class _FlowBoxPopupState extends State<FlowBoxPopup>
    with SingleTickerProviderStateMixin {
  /// Global key used to locate the child widget's render box.
  final GlobalKey _childKey = GlobalKey();

  /// Controller that drives the popup animation.
  late AnimationController _controller;

  /// The active overlay entry containing the popup.
  OverlayEntry? _overlayEntry;

  /// Cached resolved decorations for child and popup states.
  late FlowPopupDecoration _childDecoration;
  late FlowPopupDecoration _popDecoration;

  /// Whether the child is hidden during popup display.
  bool _isChildHidden = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
  }

  @override
  void didUpdateWidget(covariant FlowBoxPopup oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.duration != widget.duration) {
      _controller.duration = widget.duration;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _closePopup(immediate: true);
    super.dispose();
  }

  /// Resolves decorations by merging theme defaults and widget overrides.
  void _resolveDecorations(BuildContext context) {
    final theme = Theme.of(context);
    final defaultColor = theme.colorScheme.surfaceDim;
    const defaultRadius = BorderRadius.all(Radius.circular(10));
    const defaultPadding = EdgeInsets.all(8.0);

    _childDecoration = widget.childDecoration ??
        FlowPopupDecoration(
          color: defaultColor,
          radius: defaultRadius,
          padding: defaultPadding,
        );

    _popDecoration = widget.popDecoration ??
        FlowPopupDecoration(
          color: defaultColor,
          radius: defaultRadius,
          padding: defaultPadding,
        );
  }

  /// Displays the popup overlay and animates its expansion.
  Future<void> _showPopup() async {
    if (_overlayEntry != null) return;

    setState(() => _isChildHidden = true);

    final screenSize = MediaQuery.of(context).size;
    final maxWidth = screenSize.width * 0.8;
    final maxHeight = screenSize.height * 0.6;

    final childBox = _childKey.currentContext!.findRenderObject() as RenderBox;
    final childPos = childBox.localToGlobal(Offset.zero);
    final childSize = childBox.size;

    final contentSize = await measurePopupContent(
      context: context,
      builder: widget.popBuilder,
      padding: _popDecoration.padding,
      maxWidth: maxWidth,
    );

    final double popupHeight =
    (contentSize.height).clamp(0, maxHeight);
    final popupWidth = maxWidth;

    final targetPos = Offset(
      (screenSize.width - popupWidth) / 2,
      (screenSize.height - popupHeight) / 2,
    );

    final animator = FlowPopupAnimator(
      parent: _controller,
      curve: widget.curve ?? const Cubic(1.0, 0.155, 0.155, 1.0),
      reverseCurve: widget.reverseCurve,
    );

    _overlayEntry = OverlayEntry(
      builder: (_) => FlowPopupOverlay(
        animation: animator,
        startPosition: childPos,
        targetPosition: targetPos,
        startSize: childSize,
        targetSize: Size(popupWidth, popupHeight),
        childDecoration: _childDecoration,
        popDecoration: _popDecoration,
        popBuilder: widget.popBuilder,
        barrierColor: widget.barrierColor,
        onClose: _closePopup,
      ),
    );

    if(mounted) Overlay.of(context).insert(_overlayEntry!);
    await _controller.forward(from: 0.0);
  }

  /// Closes the popup overlay with optional immediate removal.
  Future<void> _closePopup({bool immediate = false}) async {
    if (_overlayEntry == null) return;

    if (immediate) {
      _overlayEntry?.remove();
    } else {
      final viewInsets = WidgetsBinding.instance.platformDispatcher.views.first.viewInsets;
      final keyboardHeight = viewInsets.bottom / WidgetsBinding.instance.platformDispatcher.views.first.devicePixelRatio;

      if (keyboardHeight > 0) {
        FocusManager.instance.primaryFocus?.unfocus();
        return;
      }
      await _controller.reverse();
      _overlayEntry?.remove();
    }

    _overlayEntry = null;
    if (mounted) setState(() => _isChildHidden = false);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _resolveDecorations(context);
  }

  @override
  Widget build(BuildContext context) {
    // _resolveDecorations(context);

    return PopScope(
      canPop: !_isChildHidden,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _closePopup();
      },
      child: GestureDetector(
        key: _childKey,
        onTap: _showPopup,
        child: Opacity(
          opacity: _isChildHidden ? 0 : 1,
          child: ClipRRect(
            borderRadius: _childDecoration.radius,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: _childDecoration.color,
                boxShadow: [_childDecoration.boxShadows],
                border: _childDecoration.border,
                borderRadius: _childDecoration.radius
              ),
              child: Padding(
                padding: _childDecoration.padding,
                child: AnimatedOpacity(
                  opacity: _isChildHidden ? 0 : 1,
                  duration: const Duration(milliseconds: 150),
                  child: widget.child,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}