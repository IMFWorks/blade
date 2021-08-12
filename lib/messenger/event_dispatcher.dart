import 'dart:convert';

import 'package:blade/messenger/FlutterEventResponse.dart';
import 'package:blade/messenger/NativeEvent.dart';
import 'package:blade/messenger/page_info.dart';
import 'package:flutter/services.dart';

typedef _EventHandler = dynamic Function(dynamic arguments);

class EventDispatcher {
  final MethodChannel _channel = const MethodChannel('com.imf.blade');
  final PageEventListener pageEventListener;
  final Map<String, _EventHandler> eventHandlers = Map<String, _EventHandler>();

  late final String ok = jsonEncode(FlutterEventResponse(Status.ok).toJson());
  late final String noContent = jsonEncode(FlutterEventResponse(Status.noContent).toJson());
  late final String notFound = jsonEncode(FlutterEventResponse(Status.notFound).toJson());

  EventDispatcher(this.pageEventListener) {
    _registerHandler();

    _channel.setMethodCallHandler(_methodCallHandler);
  }

  Future<dynamic> _methodCallHandler(MethodCall call) async {
    final handler = eventHandlers[call.method];
    if (handler != null) {
      return handler(call.arguments);
    }

    return notFound;
  }

  _registerHandler() {
    // register handler
    eventHandlers["pagePushed"] = (dynamic arguments) async {
      final pageInfo = _decodePageInfo(arguments);
      if (pageInfo != null) {
        pageEventListener.pushPage(pageInfo);
      }

      return ok;
    };

    eventHandlers["pagePopped"] = (dynamic arguments) async {
      final pageInfo = _decodePageInfo(arguments);
      if (pageInfo != null) {
        pageEventListener.popPage(pageInfo);
      }

      return ok;
    };

    eventHandlers["pageDestroyed"] = (dynamic arguments) async {
      final pageInfo = _decodePageInfo(arguments);
      if (pageInfo != null) {
        pageEventListener.removePage(pageInfo);
      }

      return ok;
    };

    eventHandlers["pageAppeared"] = (dynamic arguments) async {
      final pageInfo = _decodePageInfo(arguments);
      if (pageInfo != null) {
        pageEventListener.onPageAppeared(pageInfo);
      }

      return ok;
    };

    eventHandlers["pageDisappeared"] = (dynamic arguments) async {
      final pageInfo = _decodePageInfo(arguments);
      if (pageInfo != null) {
        pageEventListener.onPageDisappeared(pageInfo);
      }

      return ok;
    };

    eventHandlers["onForeground"] = (dynamic arguments) async {
      pageEventListener.onForeground();
      return ok;
    };

    eventHandlers["onBackground"] = (dynamic arguments) async {
      pageEventListener.onBackground();
      return ok;
    };
  }

  PageInfo? _decodePageInfo(dynamic arguments) {
    if (arguments == null) {
      return null;
    }

    return PageInfo.fromJson(jsonDecode(arguments));
  }

  Future<T?> sendNativeEvent<T>(NativeEvent event) async {
    return _channel.invokeMethod(event.method, jsonEncode(event.pageInfo.toJson()));
  }
}

abstract class PageEventListener {
  void pushPage(PageInfo pageInfo);
  void popPage(PageInfo pageInfo);
  void removePage(PageInfo pageInfo);
  void onPageAppeared(PageInfo pageInfo);
  void onPageDisappeared(PageInfo pageInfo);
  void onForeground();
  void onBackground();
}