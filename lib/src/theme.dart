import 'package:flutter/material.dart';

import 'toast.dart';

class ToastTheme extends InheritedWidget {
  final Widget child;

  /// The data of this ToastTheme
  final ToastThemeData data;

  const ToastTheme({
    @required this.child,
    this.data,
  }) : super(child: child);

  @override
  bool updateShouldNotify(oldWidget) => true;

  static ToastThemeData of(context) =>
      context.dependOnInheritedWidgetOfExactType<ToastTheme>()?.data;
}

class ToastThemeData {
  /// Padding for the text and the container edges
  final EdgeInsets padding;

  /// Alignment of animation, like size, rotate animation.
  final AlignmentGeometry alignment;

  /// Callback when toast is dismissed
  final VoidCallback onDismiss;

  /// The default toast animation builder
  final ToastAnimationBuilder animationBuilder;

  /// The duration the toast will be on the screen.
  final Duration duration;

  const ToastThemeData({
    this.padding,
    this.alignment,
    this.onDismiss,
    this.animationBuilder,
    this.duration,
  });

  /// Copy [this] with more data
  ToastThemeData copyWith({
    Alignment alignment,
    VoidCallback onDismiss,
    EdgeInsets padding,
    ToastAnimationBuilder animationBuilder,
    Duration duration,
  }) {
    return ToastThemeData(
      alignment: alignment ?? this.alignment,
      onDismiss: onDismiss ?? this.onDismiss,
      padding: padding ?? this.padding,
      animationBuilder: animationBuilder ?? this.animationBuilder,
      duration: duration ?? this.duration,
    );
  }
}
