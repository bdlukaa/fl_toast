Date format: DD/MM/YYYY

## [3.2.0] - [25/08/2023]

- **FIX** Flutter 3.0.0 support ([#5](https://github.com/bdlukaa/fl_toast/pull/5))

## [3.1.0] - [07/03/2021]

- **NEW** `ToastProvider`, a way to show the toasts without context
- **FIX** Make sure there's an overlay widget above the current context (Fixes [#1](https://github.com/bdlukaa/fl_toast/issues/1))
## [3.0.1] - [06/03/2021]

- **FIX** Null check operator used on a null value
- **EXAMPLE APP** Created windows and web app

## [3.0.0] - Null Safety Update - [04/03/2021]

- Null safety 🎉

## [2.0.0] - Theming Update - [26/02/2021]

- 🔶 `ToastTheme` now works properly
- 🌌 `StyledToast` now uses Snackbar's Theme Data
- 📔 Improved snackbar fidelity in example app and cookbook
- ⏳ Change animation controller duration when updated on the widget
- **NEW** 🦡 `Toast.semanticsLabel`
- **NEW** ⏰ `Toast.reverseAnimationDuration`

## [1.0.1] - The major update - [21/02/2021]

- 📦 Example app
- 🎯 Support web
- 📂 Formatted files
- 📃 Improved documentation
- 🍪 New Cookbook
- **NEW** 📜 `showPermanentToast`

## [1.0.0+1] - [20/02/2021]

- Readme update

## [1.0.0] - Initial Release - [20/02/2021]

- Show toasts:
  - `showToast`
  - `showMultiToast`
  - `showStyledToast`
  - `showAndroidToast`
  - `showPlatformToast`
  - `showSequencialToast`
