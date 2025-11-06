import 'package:flutter/material.dart';

import 'package:flutter/animation.dart';

/// A specialized [CurvedAnimation] tailored for the `flow_box_popup` package.
///
/// This class encapsulates the animation curve logic used to smoothly transition
/// a child widget into a full-screen popup with a "pop" effect.
///
/// ## Purpose
/// - Provide a consistent, reusable animation for popup open/close transitions
/// - Allow independent control of **forward** (open) and **reverse** (close) curves
/// - Default to a subtle "pop-out" easing for a modern, native feel
///
/// ## Default Curve
/// Uses `Cubic(1.0, 0.155, 0.155, 1.0)` — a custom easing similar to a soft
/// `easeOutBack`, giving a slight overshoot when the popup appears.
///
/// ## Example
/// ```dart
/// final animator = FlowPopupAnimator(
///   parent: controller,
///   curve: Curves.easeInOutQuart,
///   reverseCurve: Curves.easeOutCubic,
/// );
/// ```
///
/// > Must be used with the same [AnimationController] that drives the popup.
class FlowPopupAnimator extends CurvedAnimation {
  /// Creates a [FlowPopupAnimator] with customizable easing curves.
  ///
  /// ### Parameters
  ///
  /// - [parent]: The [AnimationController] that drives the animation.
  ///   Must have a defined `duration` and be attached to a `vsync`.
  ///
  /// - [curve]: The easing curve for the **forward** animation (opening the popup).
  ///   Defaults to `Cubic(1.0, 0.155, 0.155, 1.0)` — creates a gentle "pop" effect.
  ///
  /// - [reverseCurve]: Optional curve for the **reverse** animation (closing).
  ///   If `null`, the same [curve] is used in reverse.
  ///
  /// ### Notes
  /// - The default curve is carefully chosen to feel responsive and modern.
  /// - You can replace it with named curves like:
  ///   - `Curves.easeInOutExpo`
  ///   - `Curves.bounceOut`
  ///   - `Curves.elasticOut`
  FlowPopupAnimator({
    required AnimationController super.parent,
    super.curve = const Cubic(1.0, 0.155, 0.155, 1.0),
    Curve? reverseCurve,
  }) : super(reverseCurve: reverseCurve ?? curve);
}