import 'package:fl_toast/fl_toast.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Toast Example app',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      home: ToastProvider(child: MyHomePage()),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('fl_toast example app')),
      body: ListView(
        padding: EdgeInsets.all(8),
        children: <Widget>[
          Builder(
            builder: (context) => TextButton(
              child: Text('Show Snackbar'),
              onPressed: () => showSnackbar(context),
            ),
          ),
          TextButton(
            child: Text('Open drawer'),
            onPressed: () => openDrawer(Container(
              color: Colors.white,
              child: SafeArea(
                child: ListView(children: [
                  ListTile(title: Text('A list in a drawer')),
                ]),
              ),
            )),
          ),
          TextButton(
            child: Text('Show styled toast without context'),
            onPressed: () => showStyledToast(
              child: Text('Awesome styled toast'),
              context: ToastProvider.context,
            ),
          ),
        ],
      ),
    );
  }

  void showSnackbar(BuildContext context) {
    showToast(
      padding: EdgeInsets.zero,
      alignment: Alignment(0, 1),

      /// The duration the toast will be on the screen
      duration: Duration(seconds: 4),

      /// The duration of the animation
      animationDuration: Duration(milliseconds: 200),
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
          elevation: Theme.of(context).snackBarTheme.elevation ?? 6.0,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            color: Color(0xFF323232),
            child: Text(
              'My Awesome Snackbar',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
      context: context,
    );
  }

  void openDrawer(Widget content) async {
    late OverlayEntry entry;
    entry = showPersistentToast(
      context: context,
      toast: ToastDrawer(
        onCloseRequested: () => ToastManager.dismiss(entry),
        content: content,
      ),
    );
  }
}

class ToastDrawer extends StatefulWidget {
  const ToastDrawer({
    Key? key,
    required this.onCloseRequested,
    required this.content,
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
              await key.currentState!.dismissToastAnim();
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
            duration: Duration.zero,
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
