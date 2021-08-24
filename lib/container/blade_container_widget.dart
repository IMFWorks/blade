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
      : super(key: key) {
  }

  final BladeContainer container;

  @override
  State<StatefulWidget> createState() => BladeContainerWidgetState();
}

class BladeContainerWidgetState extends State<BladeContainerWidget> {

  void _updatePagesList(BladePage page, dynamic result) {
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
    return Navigator(
      key: widget.container.navKey,
      pages: List<Page<dynamic>>.of(widget.container.pages),
      onPopPage: (Route<dynamic> route, dynamic result) {
        if (route.didPop(result)) {
          _updatePagesList(route as BladePage, result);
          return true;
        }

        return false;
      },
      observers: <NavigatorObserver>[
        BladeNavigatorObserver(widget.container.pages, widget.container.pageInfo.id),
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
  List<BladePage<dynamic>> _pageList;
  String _uniqueId;

  BladeNavigatorObserver(this._pageList, this._uniqueId);

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    PageLifecycle.shared.dispatchAppearedEvent(route);
    if (previousRoute != null) {
      PageLifecycle.shared.dispatchDisappearedEvent(previousRoute);
    }

    super.didPush(route, previousRoute);
    _disablePanGesture();
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    PageLifecycle.shared.dispatchDisappearedEvent(route);
    if (previousRoute != null) {
      PageLifecycle.shared.dispatchAppearedEvent(previousRoute);
    }
    super.didPop(route, previousRoute);
    _enablePanGesture();
  }

  bool canDisable = true;

  void _disablePanGesture() {
    if (Platform.isIOS) {
      if (_pageList.length > 1 && canDisable) {
        // BladeNavigator.of().enablePanGesture(_uniqueId, false);
        canDisable = false;
      }
    }
  }

  void _enablePanGesture() {
    if (Platform.isIOS) {
      if (_pageList.length == 1) {
        // BladeNavigator.of().enablePanGesture(_uniqueId, true);
        canDisable = true;
      }
    }
  }
}