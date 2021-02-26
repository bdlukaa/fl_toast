import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'toast.dart';

/// Show one toast after another finished
Future<void> showSequencialToasts({
  @required List<Toast> toasts,
  @required BuildContext context,
}) async {
  assert(toasts != null);
  assert(context != null);
  for (var toast in toasts) {
    assert(
      toast.duration != null,
      'To show sequencial toasts, the toast duration can NOT be null',
    );
    await showToastWidget(
      toast: toast,
      context: context,
    );
  }
}

/// Show a text toast. The toast is defined according to the platform.
/// See `showPlatformToast`.
///
/// `text` and `context` must not be null.
Future<void> showTextToast({
  @required String text,
  @required BuildContext context,
  TextStyle style,
  TextOverflow overflow,
  TextAlign textAlign = TextAlign.center,
  TextDirection textDirection,
  StrutStyle strutStyle,
  double textScaleFactor,
  Duration duration,
  Duration animationDuration,
  VoidCallback onDismiss,
  AlignmentGeometry alignment,
  EdgeInsets padding,
  EdgeInsets margin,
  ToastAnimationBuilder animationBuilder,
  bool usePlatform = false,
}) {
  assert(text != null);
  assert(context != null);
  assert(usePlatform != null);
  final textWidget = Text(
    text,
    style: style,
    overflow: overflow,
    softWrap: true,
    textAlign: textAlign,
    textDirection: textDirection,
    strutStyle: strutStyle,
    textScaleFactor: textScaleFactor,
  );
  if (usePlatform)
    return showPlatformToast(
      child: textWidget,
      context: context,
      duration: duration,
      animationDuration: animationDuration,
      alignment: alignment,
      padding: padding,
      margin: margin,
      animationBuilder: animationBuilder,
    );
  else
    return showStyledToast(
      child: textWidget,
      context: context,
      duration: duration,
      animationDuration: animationDuration,
      alignment: alignment,
      margin: margin,
      animationBuilder: animationBuilder,
    );
}

/// Show a toast according to the platform
///
/// If the platform is `android` or `fuchsia` (or the `child` is an AndroidToast),
/// then an `AndroidToast` will be showed, otherwise, a `StyledToast` will be showed
Future<void> showPlatformToast({
  @required Widget child,
  @required BuildContext context,
  Duration duration,
  Duration animationDuration,
  VoidCallback onDismiss,
  AlignmentGeometry alignment,
  EdgeInsets padding,
  EdgeInsets margin,
  ToastAnimationBuilder animationBuilder,
}) {
  assert(child != null);
  assert(context != null);
  if ([TargetPlatform.android, TargetPlatform.fuchsia]
          .contains(defaultTargetPlatform) ||
      child is AndroidToast) {
    return showAndroidToast(
      context: context,
      child: child,
      duration: duration,
      animationDuration: animationDuration,
      alignment: alignment,
      padding: padding,
      margin: margin,
      animationBuilder: animationBuilder,
    );
  } else {
    return showStyledToast(
      child: child,
      context: context,
      duration: duration,
      animationDuration: animationDuration,
      alignment: alignment,
      contentPadding: padding,
      margin: margin,
      animationBuilder: animationBuilder,
    );
  }
}

/// Shows multi toasts at the same time.
///
/// `toasts` and `context` must not be null.
Future<void> showMultiToast({
  @required List<Toast> toasts,
  @required BuildContext context,
}) async {
  assert(toasts != null);
  assert(context != null);
  for (Toast toast in toasts)
    await showToastWidget(toast: toast, context: context);
}

/// Shows an `AndroidToast`.
///
/// `child` must not be null. It is usually a text widget.
///
/// `context` must not be null.
Future<void> showAndroidToast({
  @required Widget child,
  @required BuildContext context,
  Color backgroundColor,
  Duration duration,
  Duration animationDuration,
  VoidCallback onDismiss,
  AlignmentGeometry alignment,
  EdgeInsets padding,
  EdgeInsets margin,
  ToastAnimationBuilder animationBuilder,
}) {
  assert(child != null);
  assert(context != null);
  return showToast(
    child: child is AndroidToast
        ? child
        : AndroidToast(
            text: child,
            backgroundColor: backgroundColor,
          ),
    context: context,
    duration: duration,
    animationDuration: animationDuration,
    alignment: alignment,
    padding: padding,
    animationBuilder: animationBuilder,
  );
}

class AndroidToast extends StatelessWidget {
  /// A toast just like android's
  const AndroidToast({
    Key key,
    @required this.text,
    this.backgroundColor,
  }) : super(key: key);

  /// The text of the toast
  final Widget text;

  /// The background color of the toast
  ///
  /// If null, the color will be based on the theme of
  final Color backgroundColor;

  Color nullColor(Brightness theme) {
    if (theme == Brightness.dark)
      return Colors.grey;
    else
      return Colors.grey[200];
  }

  /// Show the toast.
  ///
  /// `context` must not be null
  Future<void> show(
    BuildContext context, {
    Duration duration,
    Duration animationDuration,
    VoidCallback onDismiss,
    TextDirection textDirection,
    AlignmentGeometry alignment,
    EdgeInsets padding,
    EdgeInsets margin,
    ToastAnimationBuilder animationBuilder,
  }) =>
      showAndroidToast(
        context: context,
        child: text,
        backgroundColor: backgroundColor,
        duration: duration,
        alignment: alignment,
        padding: padding,
        animationBuilder: animationBuilder,
      );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).brightness;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 25),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: backgroundColor ?? nullColor(theme),
        borderRadius: BorderRadius.circular(25),
      ),
      child: DefaultTextStyle(
        child: text,
        style: TextStyle(
          color: theme == Brightness.dark ? Colors.white : Colors.black,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

/// Shows a styledToast
Future<void> showStyledToast({
  @required Widget child,
  @required BuildContext context,
  Color backgroundColor,
  EdgeInsetsGeometry contentPadding,
  EdgeInsetsGeometry margin,
  BorderRadiusGeometry borderRadius,
  Duration duration,
  Duration animationDuration,
  VoidCallback onDismiss,
  AlignmentGeometry alignment,
  ToastAnimationBuilder animationBuilder,
}) {
  assert(child != null);
  assert(context != null);
  return showToast(
    child: child is StyledToast
        ? child
        : StyledToast(
            child: child,
            backgroundColor: backgroundColor,
            contentPadding: contentPadding,
            margin: margin,
            borderRadius: borderRadius,
          ),
    context: context,
    duration: duration,
    animationDuration: animationDuration,
    alignment: alignment,
    padding: EdgeInsets.zero,
    animationBuilder: animationBuilder,
  );
}

class StyledToast extends StatelessWidget {
  const StyledToast({
    Key key,
    this.child,
    this.contentPadding,
    this.margin,
    this.borderRadius,
    this.backgroundColor,
  }) : super(key: key);

  /// The content of the widget
  final Widget child;

  /// The content padding
  final EdgeInsetsGeometry contentPadding;

  /// The margin of the toast
  final EdgeInsetsGeometry margin;

  /// The borderRadius of the toast
  final BorderRadiusGeometry borderRadius;

  /// The color of the toast
  final Color backgroundColor;

  Future<void> show(
    BuildContext context, {
    Duration duration,
    Duration animationDuration,
    VoidCallback onDismiss,
    AlignmentGeometry alignment,
    ToastAnimationBuilder animationBuilder,
  }) =>
      showStyledToast(
        child: this,
        context: context,
        duration: duration,
        animationDuration: animationDuration,
        alignment: alignment,
        animationBuilder: animationBuilder,
      );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final bool isThemeDark = theme.brightness == Brightness.dark;
    final Brightness brightness =
        isThemeDark ? Brightness.light : Brightness.dark;
    final ColorScheme colorScheme = theme.colorScheme;
    final Color themeBackgroundColor = isThemeDark
        ? colorScheme.onSurface
        : Color.alphaBlend(
            colorScheme.onSurface.withOpacity(0.80), colorScheme.surface);

    final ThemeData inverseTheme = ThemeData(
      brightness: brightness,
      backgroundColor: themeBackgroundColor,
      colorScheme: ColorScheme(
        primary: colorScheme.onPrimary,
        primaryVariant: colorScheme.onPrimary,
        // For the button color, the spec says it should be primaryVariant, but for
        // backward compatibility on light themes we are leaving it as secondary.
        secondary:
            isThemeDark ? colorScheme.primaryVariant : colorScheme.secondary,
        secondaryVariant: colorScheme.onSecondary,
        surface: colorScheme.onSurface,
        background: themeBackgroundColor,
        error: colorScheme.onError,
        onPrimary: colorScheme.primary,
        onSecondary: colorScheme.secondary,
        onSurface: colorScheme.surface,
        onBackground: colorScheme.background,
        onError: colorScheme.error,
        brightness: brightness,
      ),
      snackBarTheme: theme.snackBarTheme,
    );

    Widget w = Container(
      margin: margin ?? EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      padding: contentPadding ?? EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: backgroundColor ??
            theme?.snackBarTheme?.backgroundColor ??
            themeBackgroundColor,
        borderRadius: borderRadius ?? BorderRadius.circular(6),
      ),
      child: child == null
          ? SizedBox()
          : Material(
              type: MaterialType.transparency,
              elevation: theme?.snackBarTheme?.elevation ?? 6,
              child: DefaultTextStyle(
                child: child,
                style: theme?.snackBarTheme?.contentTextStyle ??
                    inverseTheme.textTheme.subtitle1,
                textAlign: TextAlign.center,
              ),
            ),
    );

    return w;
  }
}
