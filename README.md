<div>
  <h1 align="center">fl_toast</h1>
  <p align="center" >
    <a title="Discord" href="https://discord.gg/674gpDQUVq">
      <img src="https://img.shields.io/discord/809528329337962516?label=discord&logo=discord" />
    </a>
    <a title="Pub" href="https://pub.dartlang.org/packages/fl_toast" >
      <img src="https://img.shields.io/pub/v/fl_toast.svg?style=popout&include_prereleases" />
    </a>
    <a title="Github License">
      <img src="https://img.shields.io/github/license/bdlukaa/fl_toast" />
    </a>
    <a title="PRs are welcome">
      <img src="https://img.shields.io/badge/PRs-welcome-brightgreen.svg" />
    </a>
  <div>
  <p align="center">
    <a title="Buy me a coffee" href="https://www.buymeacoffee.com/bdlukaa">
      <img src="https://img.buymeacoffee.com/button-api/?text=Buy me a coffee&emoji=&slug=bdlukaa&button_colour=FF5F5F&font_colour=ffffff&font_family=Lato&outline_colour=000000&coffee_colour=FFDD00">
    </a>
  </p>

</div>

A simple yet powerful Toast Library for Flutter

- [Usage](#usage)
  - [Basic usage](#basic-usage)
  - [Platform-styled toast](#show-the-platform-styled-toast)
  - [Multi-toasts](#multi-toasts)
  - [Toast Provider](#toast-provider)
  - [Animations](#animations)
- [Cookbook](#cookbook)
  - [Snackbar](#snackbar)
  - [Drawer](#drawer)
- [Advanced usage](#advanced-usage)
  - [Dismiss a toast programatically](#dismiss-a-toast-programatically)
- [Apps using this library](#apps-using-this-library)
  - [Color Picker](#color-picker)

### Features

✔️ Easy-to-use - Made for new and advanced developers\
✔️ Animations - Supports any kind of animation\
✔️ Made Fully in flutter - No need to use platform channels to show toasts\
✔️ `BuildContext` is not necessary

## Usage

`context` in all show toast methods are required and can't be `null`, otherwise an `AssertionError` is thrown.

### Basic usage

```dart
import 'package:flutter_toast/flutter_toast.dart';

/// Shows a plaftform-styled toast with a text.
await showTextToast(
  text: 'My Awesome Toast',
  context: context,
);
```

### Show the platform-styled toast

You can use `showPlatformToast` to show the toast that best fits the running platform. Shows an `AndroidToast` in `Android` and `Fuchsia`. Shows a `StyledToast` in the other platforms.

```dart
await showPlatformToast(
  child: Text('My Platform Toast'),
  context: context,
);
```

```dart
await showAndroidToast(
  child: Text('My awesome Android Toast'),
  context: context,
);
```

### Multi-toasts

You can use `showMultiToast` to show multiple toasts at the same time.

```dart
await showMultiToast(
  toasts: [
    Toast(child: Text('Toast 1')),
    Toast(child: Text('Toast 2')),
  ],
  context: context,
);
```

You can use `showSequencialToasts` to show one toast after another. The duration of the toasts can NOT be `null`.

```dart
await showSequencialToasts(
  toasts: [
    Toast(child: Text('First toast'), duration: Duration(seconds: 2)),
    Toast(child: Text('Second toast'), duration: Duration(seconds: 1)),
  ],
  context: context,
);
```

### Toast Provider

Ofter some people say: "I'd like to display toasts without context". Well, you can with `ToastProvider`. Just wrap your widgets in a `ToastProvider` and call `ToastProvider.context` in the `context` parameter:

```dart
MaterialApp(
  home: ToastProvider(child: Home()),
),
```

```dart
void displayToast() {
  showStyledToast(
    child: Text('Awesome styled toast'),
    context: ToastProvider.context,
  );
}
```

There must be an `Overlay` widget above `ToastProvider`. In the example above, the `Overlay` created by `MaterialApp`'s `Navigator` is used. 

### Animations

You can highly customize the animation by setting `animationBuilder`. The default animation is a `FadeTransition`. The following snippet animate the toast with a scale transition.

```dart
await showStyledToast(
  child: Text('Styled toast with custom scale animation'),
  context: context,
  animationBuilder: (context, animation, child) {
    return ScaleTransition(
      scale: animation,
      child: child,
    );
  }
);
```

Flutter already has a set of pre-built transitions for you to use. They are:

- `FadeTransition` (default)
- `ScaleTransition`
- `SlideTransition`
- `RotationTransition`
- `SizeTransition`
- `AlignTransition`

You can combine multilpe transitions to build the best experience to the user:

```dart
await showPlatformToast(
  child: Text('Platform toast with multiple custom animations'),
  context: context,
  animationBuilder: (context, animation, child) {
    return ScaleTransition(
      scale: animation,
      child: RotationTransition(
        turns: animation,
        child: child,
      ),
    );
  }
);
```

You can even use the [animations package](https://pub.dev/packages/animations). We're gonna be using [FadeScaleTransition](https://pub.dev/packages/animations#fade)

```dart
import 'package:animations/animations.dart';

await showStyledToast(
  child: Text('Styled toast using animations package'),
  context: context,
  animationBuilder: (context, animation, child) {
    return FadeScaleTransition(
      animation: animation,
      child: child,
    );
  }
);
```

If none of the animations above have satisfied you, you can create your own [implicit animations](https://flutter.dev/docs/development/ui/animations/implicit-animations).

# Cookbook

Learn how to create beautiful toasts.

## Snackbar

The snippet below shows how to create a beautiful toast that act like a `Snackbar`. It's useful when you don't have a parent `Scaffold` avaiable to show a [proper snackbar](https://flutter.dev/docs/cookbook/design/snackbars).

According to the Material Design Guidelines:

> They (Snackbars) automatically disappear from the screen after a minimum of 4 (four) seconds, and a maximum of 10 (ten) seconds.

> Snackbars can span the entire width of a UI. However, they should not appear in front of navigation or other important UI elements like floating action buttons.

```dart
showToast(
  interactive: true,
  padding: EdgeInsets.zero,
  alignment: Alignment(0, 1),
  /// The duration the toast will be on the screen
  duration: Duration(seconds: 4),
  /// The duration of the animation
  animationDuration: Duration(milliseconds: 200),
  /// Animate the toast to show up from the bottom 
  animationBuilder: (context, animation, child) {
    return SlideTransition(
      child: child,
      position: Tween<Offset>(
        begin: Offset(0, 1),
        end: Offset(0, 0),
      ).animate(CurvedAnimation(
        parent: animation,
        curve: Curves.fastOutSlowIn,
      )),
    );
  },
  child: Dismissible(
    key: ValueKey<String>('Snackbar'),
    direction: DismissDirection.down,
    child: Material(
      elevation: Theme.of(context)?.snackBarTheme?.elevation ?? 6.0,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        color: Color(0xFF323232),
        child: Text('My Awesome Snackbar', style: TextStyle(color: Colors.white)),
      ),
    ),
  ),
  context: context,
);
```

## Drawer

### 1. Create the `ToastDrawer` Widget.

It will be responsible by handling the dismiss color animation.

```dart
class ToastDrawer extends StatefulWidget {
  const ToastDrawer({
    Key key,
    @required this.onCloseRequested,
    @required this.content,
  }) : super(key: key);

  final Function onCloseRequested;
  final Widget content;

  @override
  _ToastDrawerState createState() => _ToastDrawerState();
}

class _ToastDrawerState extends State<ToastDrawer> {
  final key = GlobalKey<ToastState>();
  final animDuration = Duration(milliseconds: 246);
  Color backgroundColor = Colors.black54;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: GestureDetector(
            onTap: () async {
              setState(() => backgroundColor = Colors.transparent);
              await key.currentState.dismissToastAnim();
              widget.onCloseRequested();
            },
            child: AnimatedContainer(
              duration: animDuration,
              curve: Curves.ease,
              color: backgroundColor,
            ),
          ),
        ),
        Positioned.fill(
          child: Toast(
            key: key,
            // Duration needs to be null, otherwise the toast will be in the screen
            // but the reverse animation will be called.
            duration: null,
            alignment: Alignment.topLeft,
            animationDuration: animDuration,
            animationBuilder: (context, animation, child) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: Offset(-1, 0),
                  end: Offset(0, 0),
                ).animate(CurvedAnimation(
                  parent: animation,
                  curve: Curves.ease,
                )),
                child: child,
              );
            },
            child: Dismissible(
              key: ValueKey(1),
              direction: DismissDirection.endToStart,
              onDismissed: (_) => widget.onCloseRequested(),
              child: Material(
                elevation: 8,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.75,
                  height: double.infinity,
                  // color: Colors.white,
                  child: widget.content,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
```

### 2. Open the drawer

Open the drawer using a persistent toast. A persistent toast is a toast that will only dismiss when asked so.

Note: Don't forget to set `duration: null` in `Toast`, otherwise the toast will leave the screen but won't be dismissed

```dart
void openDrawer(Widget content) async {
  OverlayEntry entry;
  entry = showPersistentToast(
    context: context,
    toast: ToastDrawer(
      onCloseRequested: () => ToastManager.dismiss(entry),
      content: content,
    ),
  );
}
```

# Advanced usage

## Dismiss a toast programatically

To dismiss all the toasts in the screen, use `ToastManager.dismissAll()`. To dismiss a toast programatically, you can just call `ToastManager.dismiss(entry)`. The only way to get the `entry` of a toast is to using `showPersitentToast`.

To dismiss with animation, you'll need a `GlobalKey` to access the toast state. The snippet below shows you how to do so:

```dart
final toastKey = GlobalKey<ToastState>();

final entry = showPersistentToast(
  context: context,
  toast: Toast(
    key: toastKey,
    duration: null,
  ),
);

Future.delayed(Duration(milliseconds: 250), () async {
  await toastKey.currentState?.dismissToastAnim();
  ToastManager.dismiss(entry);
});
```

## Contribution

Feel free to [open an issue](https://github.com/bdlukaa/flutter_toast/issues/new) if you find an error or [make pull requests](https://github.com/bdlukaa/flutter_toast/pulls).

## Apps using this library

### Color Picker

<p align="center" >
  <a href="https://github.com/bdlukaa/color-picker" >
    <img src="https://github-readme-stats.vercel.app/api/pin/?username=bdlukaa&repo=color-picker&show_icons=true&theme=dark" />
  </a>
</p>

[Color picker](https://github.com/bdlukaa/color-picker) is an app to help developers pick the best color that best suits their designs. You can pick colors from:

- [x] Wheel
- [x] Palette
- [x] Value
- [x] Named
- [x] Image

---

### TODO:

- Add screenshots to the readme
- Null-safety
