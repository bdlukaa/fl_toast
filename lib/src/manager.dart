import 'package:flutter/material.dart';

class ToastManager {

  static List<OverlayEntry> entries = [];

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