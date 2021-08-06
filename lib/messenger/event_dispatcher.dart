import 'dart:convert';

import 'package:blade/messenger/page_info.dart';
import 'package:flutter/services.dart';

typedef _EventHandler = dynamic Function(dynamic arguments);

class EventDispatcher {
  final MethodChannel _channel = const MethodChannel('blade');
  final PageEventListener pageEventListener;
  final Map<String, _EventHandler> eventHandlers = Map<String, _EventHandler>();

  EventDispatcher(this.pageEventListener) {
    _registerHandler();

    _channel.setMethodCallHandler((call) async => {
      _handleCall(call)
    });
  }

  dynamic _handleCall(MethodCall call) async {
    final handler = eventHandlers[call.method];
    if (handler != null) {
      return handler(call.arguments);
    }

    return false;
  }

  _registerHandler() {
    // register handler
    eventHandlers["pushPage"] = (dynamic arguments) async {
      final pageInfo = _decodePageInfo(arguments);
      if (pageInfo != null) {
        pageEventListener.pushPage(pageInfo);
      }

      return true;
    };

    eventHandlers["popPage"] = (dynamic arguments) async {
      final pageInfo = _decodePageInfo(arguments);
      if (pageInfo != null) {
        pageEventListener.popPage(pageInfo);
      }

      return true;
    };

    eventHandlers["removePage"] = (dynamic arguments) async {
      final pageInfo = _decodePageInfo(arguments);
      if (pageInfo != null) {
        pageEventListener.removePage(pageInfo);
      }

      return true;
    };

    eventHandlers["onPageAppeared"] = (dynamic arguments) async {
      final pageInfo = _decodePageInfo(arguments);
      if (pageInfo != null) {
        pageEventListener.onPageAppeared(pageInfo);
      }

      return true;
    };

    eventHandlers["onPageDisappeared"] = (dynamic arguments) async {
      final pageInfo = _decodePageInfo(arguments);
      if (pageInfo != null) {
        pageEventListener.onPageDisappeared(pageInfo);
      }

      return true;
    };

    eventHandlers["onForeground"] = (dynamic arguments) async {
      pageEventListener.onForeground();
      return true;
    };

    eventHandlers["onBackground"] = (dynamic arguments) async {
      pageEventListener.onBackground();
      return true;
    };
  }

  PageInfo? _decodePageInfo(dynamic arguments) {
    if (arguments == null) {
      return null;
    }

    return PageInfo.fromJson(jsonDecode(arguments));
  }
}

abstract class PageEventListener {
  void pushPage(PageInfo pageInfo);
  void popPage(PageInfo pageInfo) ;
  void removePage(PageInfo pageInfo);
  void onPageAppeared(PageInfo pageInfo);
  void onPageDisappeared(PageInfo pageInfo);
  void onForeground();
  void onBackground();
}




