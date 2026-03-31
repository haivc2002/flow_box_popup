import 'package:flutter/material.dart';


/// A [CurvedAnimation] preset for the `flow_box_popup` morph transition.
///
/// Wraps a parent [AnimationController] with configurable forward and reverse
/// easing curves, defaulting to `Cubic(1.0, 0.155, 0.155, 1.0)` — a subtle
/// overshoot similar to `easeOutBack` for a snappy, modern feel.
///
/// Example:
/// ```dart
/// final animator = FlowPopupAnimator(
///   parent: controller,
///   curve: Curves.easeInOutQuart,
///   reverseCurve: Curves.easeOutCubic,
/// );
/// ```
class FlowPopupAnimator extends CurvedAnimation {
  /// Creates a [FlowPopupAnimator].
  ///
  /// - [parent]: The [AnimationController] driving the popup animation.
  /// - [curve]: Forward easing curve. Defaults to a soft overshoot cubic.
  /// - [reverseCurve]: Reverse easing curve. Defaults to the same as [curve].
  FlowPopupAnimator({
    required super.parent,
    super.curve = const Cubic(1.0, 0.155, 0.155, 1.0),
    Curve reverseCurve = const Cubic(1.0, 0.155, 0.155, 1.0),
  }) : super(reverseCurve: reverseCurve);
}