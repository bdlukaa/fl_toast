<div>
  <h1 align="center">flutter_toast</h1>
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

Flutter Toast Library for Flutter

- [Usage](#usage)
  - [Basic usage](#basic-usage)
  - [Platform-styled toast](#show-the-platform-styled-toast)
  - [Multi-toasts](#multi-toasts)
  - [Animations](#animations)
- [Cookbook](#cookbook)
  - [Snackbar](#snackbar)

### Features

✔️ Easy-to-use - Made for new and advanced developers
✔️ Animations
✔️ Made Fully in flutter - No need to use platform channels

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

```dart
await showPlatformToast(
  child: Text('My Platform Toast'),
  context: context,
);
```

```dart
/// Android-Styled Toast
///
/// Shows an Android Toast
await showAndroidToast(
  child: 'My awesome Android Toast'
  context: context,
);
```

### Multi-toasts

```dart
/// Show toasts at the same time
await showMultiToast(
  toasts: [
    Toast(child: Text('Toast 1')),
    Toast(child: Text('Toast 2')),
  ],
  context: context,
);

/// Shows one toast after another
await showSequencialToasts(
  toasts: [
    Toast(child: Text('First toast'), duration: Duration(seconds: 2)),
    Toast(child: Text('Second toast'), duration: Duration(seconds: 1)),
  ],
  context: context,
);
```

### Animations

You can customize the animation by setting `animationBuilder`. The default animation is a `FadeTransition`. The following snippet animate the widget with a scale transition.

```dart
await showStyledToast(
  child: Text('Styled toast with custom animation'),
  context: context,
  animationBuilder: (context, animation, child) {
    return ScaleTransition(
      scale: animation,
      child: child,
    );
  }
);
```

## Cookbook

Learn how to create beautiful toasts.

### Snackbar

```dart
showToast(
  interactive: true,
  padding: EdgeInsets.zero,
  alignment: Alignment(0, 1),
  duration: Duration(seconds: 4),
  animationDuration: Duration(milliseconds: 200),
  animationBuilder: (context, animation, child) {
    return SlideTransition(
      child: child,
      position: Tween<Offset>(
        begin: Offset(0, 1),
        end: Offset(0, 0),
      ).animate(animation),
    );
  },
  child: Dismissible(
  key: ValueKey<String>(text),
  direction: DismissDirection.down,
    child: Material(
      elevation: 8,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        color: Theme.of(context).scaffoldBackgroundColor,
        child: content,
      ),
    ),
  ),
  context: context,
);
```

## Contribution

Feel free to [open an issue](https://github.com/bdlukaa/flutter_toast/issues/new) if you find an error or [make pull requests](https://github.com/bdlukaa/flutter_toast/pulls).

### TODO:

- Add screenshots to the readme
- Increment the cookbook
