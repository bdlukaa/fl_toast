import 'package:flutter/widgets.dart';

class ToastProvider extends StatelessWidget {
  const ToastProvider({Key? key, this.child}) : super(key: key);

  final Widget? child;

  static GlobalKey _toastKey = GlobalKey();

  static BuildContext get context => _toastKey.currentContext!;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: _toastKey,
      child: this.child,
    );
  }
}
