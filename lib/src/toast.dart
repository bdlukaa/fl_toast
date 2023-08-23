import 'package:flutter/material.dart';

import 'manager.dart';
import 'theme.dart';

export 'manager.dart';
export 'provider.dart';
export 'theme.dart';
export 'toasts.dart';

/// Default toast duration. 4 seconds
const kDefaultToastDuration = Duration(seconds: 4);

/// Default animation duration
/// When you use Curves.elasticOut, you can specify a longer duration to achieve beautiful effect
/// But [animDuration] * 2  <= toast [duration], conditions must be met for toast to display properly
/// so when you specify a longer animation duration, you must also specify toast duration to satisfy conditions above
const kDefaultToastAnimationDuration = Duration(milliseconds: 250);

/// Show a toast.
///
/// `child` and `context` must not be null.
///
/// If `child` is a `Toast`, then all other arguments will be discarted
Future<void> showToast({
  required Widget child,
  required BuildContext context,
  Duration? duration,
  Duration? animationDuration,
  VoidCallback? onDismiss,
  AlignmentGeometry? alignment,
  EdgeInsets? padding,
  ToastAnimationBuilder? animationBuilder,
}) async {
  if (child is Toast)
    await showToastWidget(
      toast: child,
      context: context,
    );
  else {
    await showToastWidget(
      context: context,
      toast: Toast(
        duration: duration,
        animationDuration: animationDuration,
        alignment: alignment,
        padding: padding,
        onDismiss: onDismiss,
        animationBuilder: animationBuilder,
        child: child,
      ),
    );
  }
}

/// Show a toast widget
Future<void> showToastWidget({
  required Toast toast,
  required BuildContext context,
}) async {
  final entry = OverlayEntry(builder: (context) => toast);

  assert(debugCheckHasOverlay(context));
  Overlay.of(context).insert(entry);

  ToastManager.insert(entry);

  await Future.delayed(
    (toast.duration ?? kDefaultToastDuration) +
        (toast.animationDuration ?? kDefaultToastAnimationDuration) * 2,
    () {
      ToastManager.dismiss(entry);
      toast.onDismiss?.call();
    },
  );
}

OverlayEntry showPersistentToast({
  required Widget toast,
  required BuildContext context,
  bool interactive = true,
}) {
  assert(debugCheckHasOverlay(context));
  final entry = OverlayEntry(
    builder: (context) => IgnorePointer(
      child: toast,
      ignoring: !interactive,
    ),
  );
  Overlay.of(context).insert(entry);

  ToastManager.insert(entry);

  return entry;
}

typedef ToastAnimationBuilder = Widget Function(
  BuildContext context,
  Animation<double> animation,
  Widget child,
);

class Toast extends StatefulWidget {
  /// The content of the toast. This can not be null
  final Widget child;

  /// The duration of the toast. Default to 4 seconds.
  /// If this is `Duration.zero`, it will never be dismissed and needs
  /// to be dismissed manually.
  ///
  /// See [this](https://pub.dev/packages/fl_toast#dismiss-a-toast-programatically) for more info
  final Duration? duration;

  /// The duration of the animation. Default to 250ms
  final Duration? animationDuration;

  /// The duration of the reverse animation. Default to 250ms
  final Duration? reverseAnimationDuration;

  /// The alignment of the toast. Defaults to `Alignment.bottomCenter`
  final AlignmentGeometry? alignment;

  /// The padding of the toast. Default to `EdgeInsets.zero`
  final EdgeInsets? padding;

  /// A callback called when the toast is dismissed.
  final VoidCallback? onDismiss;

  /// Toast animation builder. Default to fade animation.
  ///
  /// It will go forward when the toast start and reverse
  /// when the toast is dismissed.
  ///
  /// A slide animation example with `animationBuilder`:
  /// ``` dart
  /// animationBuilder: (context, animation, child) {
  ///   return SlideTransition(
  ///     position: CurvedAnimation(
  ///       parent: animation,
  ///       curve: Curves.elasticInOut,
  ///     ).drive(Tween<Offset>(
  ///       begin: Offset(-3, 0),
  ///       end: Offset(0, 0),
  ///     )),
  ///     child: child,
  ///   );
  /// },
  /// ```
  final ToastAnimationBuilder? animationBuilder;

  /// Creates a semantic annotation.
  final String? semanticsLabel;

  const Toast({
    Key? key,
    required this.child,
    this.duration,
    this.animationDuration = kDefaultToastAnimationDuration,
    this.reverseAnimationDuration = kDefaultToastAnimationDuration,
    this.alignment = Alignment.bottomCenter,
    this.animationBuilder,
    this.padding,
    this.onDismiss,
    this.semanticsLabel,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => ToastState();

  Future<void> show(BuildContext context) => showToastWidget(
        context: context,
        toast: this,
      );
}

class ToastState extends State<Toast> with TickerProviderStateMixin<Toast> {
  /// Animation controller
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: widget.animationDuration ?? kDefaultToastAnimationDuration,
      reverseDuration:
          widget.reverseAnimationDuration ?? kDefaultToastAnimationDuration,
    );

    // Start animation
    Future.delayed(const Duration(milliseconds: 30), () async {
      if (!mounted) return;
      try {
        await _animationController.forward().orCancel;
      } catch (e) {}
    });

    if (widget.duration != Duration.zero)
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final theme = ToastTheme.of(context);
        final duration =
            (widget.duration ?? theme?.duration ?? kDefaultToastDuration) -
                (widget.animationDuration ?? kDefaultToastAnimationDuration) -
                Duration(milliseconds: 30);
        Future.delayed(duration, dismissToastAnim);
      });
  }

  @override
  void didUpdateWidget(Toast oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.animationDuration != oldWidget.animationDuration)
      _animationController.duration = widget.animationDuration;

    if (widget.reverseAnimationDuration != oldWidget.reverseAnimationDuration)
      _animationController.reverseDuration = widget.reverseAnimationDuration;
  }

  @override
  Widget build(BuildContext context) {
    Widget w;

    w = _createAnimWidget(
      Material(
        child: widget.child,
        color: Colors.transparent,
      ),
    );

    final toastTheme = ToastTheme.of(context);

    w = Container(
      padding: widget.padding ?? toastTheme?.padding ?? EdgeInsets.zero,
      alignment:
          widget.alignment ?? toastTheme?.alignment ?? Alignment.bottomCenter,
      child: w,
    );

    if (widget.semanticsLabel != null)
      w = Semantics(
        label: widget.semanticsLabel,
        child: w,
      );

    return w;
  }

  /// Create animation widget
  Widget _createAnimWidget(Widget w) {
    if (widget.animationBuilder != null)
      return widget.animationBuilder!(context, _animationController, w);

    final toastTheme = ToastTheme.of(context);
    if (toastTheme?.animationBuilder != null)
      return toastTheme!.animationBuilder!(context, _animationController, w);

    return FadeTransition(
      opacity: _animationController.drive(Tween<double>(begin: 0, end: 1)),
      child: w,
    );
  }

  /// Dismiss toast with animation
  Future<void> dismissToastAnim() async {
    if (!mounted) return;
    try {
      await _animationController.reverse().orCancel;
    } on TickerCanceled {}
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
