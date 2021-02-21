import 'package:flutter/material.dart';

class ToastManager {
  ToastManager._();

  static List<OverlayEntry> _entries = [];

  /// The list of current toasts on the screen. Use
  /// `ToastManager.dismissAll()` to clear the list
  /// and remove all the toasts from the screen.
  ///
  /// To remove one specific toast, use `ToastManager.dismiss(entry)`
  static List<OverlayEntry> get entries => _entries;

  /// Dismiss all the toasts in the screen
  static void dismissAll() {
    for (var entry in entries) entry?.remove();
    entries.clear();
  }

  /// Dismiss a specific toast
  static void dismiss(OverlayEntry entry) {
    entry.remove();
    if (entries.contains(entry)) entries.remove(entry);
  }

  /// Insert a new toast in the screen
  static void insert(OverlayEntry entry) {
    if (!entries.contains(entry)) entries.add(entry);
  }
}
