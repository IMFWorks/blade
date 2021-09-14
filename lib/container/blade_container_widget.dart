import 'dart:io';

import 'package:blade/container/blade_page.dart';
import 'package:blade/container/blade_container.dart';
import 'package:blade/container/page_lifecycle.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class BladeContainerWidget extends StatefulWidget {
  BladeContainerWidget(
      {LocalKey? key,required this.container})
      : super(key: key);

  final BladeContainer container;

  @override
  State<StatefulWidget> createState() => BladeContainerWidgetState();
}

class BladeContainerWidgetState extends State<BladeContainerWidget> {

  void _popPage(BladePage page, dynamic result) {
    widget.container.popPage(page, result);
  }

  @override
  void initState() {
    super.initState();
    widget.container.addListener(refresh);
  }

  @override
  void didUpdateWidget(covariant BladeContainerWidget oldWidget) {
    if (oldWidget != widget) {
      oldWidget.container.removeListener(refresh);
      widget.container.addListener(refresh);
    }
    super.didUpdateWidget(oldWidget);
  }

  void refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // todo-wrs pages not work
    // final pages = widget.container.pages;
    final pages = List.of(widget.container.pages);

    return Navigator(
      key: widget.container.navKey,
      pages: pages,
      onPopPage: (Route<dynamic> route, dynamic result) {
        _popPage(route.settings as BladePage, result);
        route.didPop(result);
        return true;
      },
      observers: <NavigatorObserver>[
        BladeNavigatorObserver()
      ],
    );
  }

  @override
  void dispose() {
    widget.container.removeListener(refresh);
    super.dispose();
  }
}

class BladeNavigatorObserver extends NavigatorObserver {
  BladeNavigatorObserver();

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
        PageLifecycle.shared.dispatchAppearedEvent(route);
    });

    if (previousRoute != null) {
      PageLifecycle.shared.dispatchDisappearedEvent(previousRoute);
    }

    super.didPush(route, previousRoute);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    PageLifecycle.shared.dispatchDisappearedEvent(route);

    if (previousRoute != null) {
      PageLifecycle.shared.dispatchAppearedEvent(previousRoute);
    }
    super.didPop(route, previousRoute);
  }
}