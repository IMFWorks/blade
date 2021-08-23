import 'package:blade/container/blade_page.dart';
import 'package:blade/container/blade_container.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:blade/blade_app.dart';

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