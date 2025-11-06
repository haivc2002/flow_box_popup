import 'package:flutter/material.dart';

/// A configuration class that defines the visual styling for both the
/// **child trigger** and **popup** in the `flow_box_popup` package.
///
/// It encapsulates common decoration properties such as:
/// - Background color
/// - Border radius
/// - Padding
/// - Box shadow
/// - Border
///
/// This allows smooth interpolation (lerp) between child and popup styles
/// during the morphing animation.
///
/// ## Design Goal
/// Enable a seamless **morph transition** from a small button-like child
/// into a centered, elevated popup with different styling.
///
/// ## Example
/// ```dart
/// FlowPopupDecoration(
///   color: Colors.white,
///   radius: BorderRadius.circular(16),
///   padding: EdgeInsets.all(16),
///   boxShadows: BoxShadow(
///     color: Colors.black26,
///     blurRadius: 12,
///     offset: Offset(0, 4),
///   ),
/// )
/// ```
@immutable
class FlowPopupDecoration {
  /// The corner radius of the decorated box.
  ///
  /// Defaults to `BorderRadius.circular(10)` if not provided.
  final BorderRadius radius;

  /// Background fill color. If `null`, inherits from parent or theme.
  final Color? color;

  /// Inner spacing between the content and the edges of the box.
  ///
  /// Uses [EdgeInsetsGeometry] to support advanced layouts (e.g., `EdgeInsetsDirectional`).
  /// Defaults to `EdgeInsets.all(8.0)`.
  final EdgeInsetsGeometry padding;

  /// The shadow cast by the box. Defaults to transparent (no shadow).
  ///
  /// Use [BoxShadow] to create elevation effects.
  final BoxShadow boxShadows;

  /// Optional border around the box.
  ///
  /// Use [Border] or [BorderSide] for stroke styling.
  final Border? border;

  /// Creates a [FlowPopupDecoration] with optional styling.
  ///
  /// ### Parameters
  /// - [color]: Background color.
  /// - [border]: Border stroke.
  /// - [boxShadows]: Shadow effect. Defaults to transparent.
  /// - [radius]: Corner rounding. Defaults to `circular(10)`.
  /// - [padding]: Inner padding. Defaults to `all(8.0)`.
  const FlowPopupDecoration({
    this.color,
    this.border,
    this.boxShadows = const BoxShadow(color: Colors.transparent),
    BorderRadius? radius,
    this.padding = const EdgeInsets.all(8.0),
  }) : radius = radius ?? const BorderRadius.all(Radius.circular(10));

  /// Linearly interpolates between two [FlowPopupDecoration] objects.
  ///
  /// Used during the animation to smoothly transition from
  /// child style to popup style (and back).
  ///
  /// ### Parameters
  /// - [a]: Starting decoration (or `null`).
  /// - [b]: Ending decoration (or `null`).
  /// - [t]: Progress value in range `[0.0, 1.0]`.
  ///
  /// ### Returns
  /// A new [FlowPopupDecoration] that blends properties of [a] and [b].
  /// Returns `null` only if both [a] and [b] are `null`.
  ///
  /// > Handles `null` values gracefully by falling back to defaults.
  static FlowPopupDecoration? lerp(
      FlowPopupDecoration? a,
      FlowPopupDecoration? b,
      double t,
      ) {
    // If both are null, return null
    if (a == null && b == null) return null;

    // Use defaults if one is null
    a ??= const FlowPopupDecoration();
    b ??= const FlowPopupDecoration();

    return FlowPopupDecoration(
      color: Color.lerp(a.color, b.color, t),
      border: Border.lerp(a.border, b.border, t),
      boxShadows: BoxShadow.lerp(a.boxShadows, b.boxShadows, t) ??
          const BoxShadow(color: Colors.transparent),
      radius: BorderRadius.lerp(a.radius, b.radius, t),
      padding: EdgeInsetsGeometry.lerp(a.padding, b.padding, t) ?? a.padding,
    );
  }

  /// Creates a copy of this decoration with some properties replaced.
  ///
  /// Useful for creating variations (e.g., popup version with more padding).
  ///
  /// ```dart
  /// final popupStyle = childStyle.copyWith(
  ///   padding: EdgeInsets.all(16),
  ///   boxShadows: elevationShadow,
  /// );
  /// ```
  FlowPopupDecoration copyWith({
    Color? color,
    Border? border,
    BoxShadow? boxShadows,
    BorderRadius? radius,
    EdgeInsetsGeometry? padding,
  }) {
    return FlowPopupDecoration(
      color: color ?? this.color,
      border: border ?? this.border,
      boxShadows: boxShadows ?? this.boxShadows,
      radius: radius ?? this.radius,
      padding: padding ?? this.padding,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FlowPopupDecoration &&
        other.radius == radius &&
        other.color == color &&
        other.padding == padding &&
        other.boxShadows == boxShadows &&
        other.border == border;
  }

  @override
  int get hashCode {
    return Object.hash(radius, color, padding, boxShadows, border);
  }

  @override
  String toString() {
    return 'FlowPopupDecoration(color: $color, radius: $radius, padding: $padding)';
  }
}