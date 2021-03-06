import 'package:blade/blade_app.dart';
import 'package:blade_example/return_result_page.dart';
import 'package:blade_example/simple_widget.dart';
import 'package:flutter/material.dart';

import 'flutter_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
  }

  static Map<String, PageBuilder> routerMap = {
    '/': (context, settings) {
      return Container(color: Colors.amber);
    },

    ///可以在native层通过 getContainerParams 来传递参数
    'flutterPage': (context, settings) {
      return FlutterPage(
          params: settings.arguments as Map<String, dynamic>);
    },
    'flutterPageA': (context, settings) {
      return FlutterPage(
          params: settings.arguments as Map<String, dynamic>);
    },
    'tab_friend': (context, settings) {
      return SimpleWidget("", settings.arguments as Map<dynamic, dynamic>,
          "This is a flutter fragment");
    },
    'tab_message': (context, settings) {
      return SimpleWidget("", settings.arguments as Map<dynamic, dynamic>,
          "This is a flutter fragment");
    },
    'tab_flutter1': (context, settings) {
      return SimpleWidget("", settings.arguments as Map<dynamic, dynamic>,
          "This is a custom FlutterView");
    },
    'tab_flutter2': (context, settings) {
      return SimpleWidget("", settings.arguments as Map<dynamic, dynamic>,
          "This is a custom FlutterView");
    },

    'returnResult': (context, settings) {
      return ReturnResultPage(params: settings.arguments as Map<dynamic, dynamic>);
    },
  };

  Route<dynamic> routeFactory(RouteSettings settings, String uniqueId) {
    return MaterialPageRoute<dynamic>(
        settings: settings,
        builder: (context) {
          final PageBuilder? func = routerMap[settings.name];
          if (func != null) {
            return func(context, settings);
          } else {
            // 404
            return Container();
          }
        });
    // return PageRouteBuilder<dynamic>(
    //     settings: settings,
    //     pageBuilder: (context, __, ___) {
    //       final PageBuilder? func = routerMap[settings.name];
    //       if (func != null) {
    //         return func(context, settings);
    //       } else {
    //         // 404
    //         return Container();
    //       }
    //     }
    // ,
    // transitionsBuilder: (BuildContext context, Animation<double> animation,
    //     Animation<double> secondaryAnimation, Widget child) {
    //   return SlideTransition(
    //     position: Tween<Offset>(
    //       begin: const Offset(1.0, 0),
    //       end: Offset.zero,
    //     ).animate(animation),
    //     child: SlideTransition(
    //       position: Tween<Offset>(
    //         begin: Offset.zero,
    //         end: const Offset(-1.0, 0),
    //       ).animate(secondaryAnimation),
    //       child: child,
    //     ),
    //   );
    // },
    // );
  }

  @override
  Widget build(BuildContext context) {
    return BladeApp(routeFactory);
  }
}
