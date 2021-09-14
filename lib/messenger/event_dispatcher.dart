import 'dart:convert';

import 'package:blade/messenger/FlutterEventResponse.dart';
import 'package:blade/messenger/NativeEvents/base/native_event.dart';
import 'package:blade/messenger/event_sender.dart';
import 'package:blade/messenger/page_info.dart';
import 'package:flutter/services.dart';

typedef _EventHandler = dynamic Function(dynamic arguments);

class EventDispatcher with EventSender {
  final MethodChannel _channel = const MethodChannel('com.imf.blade');
  final Map<String, _EventHandler> _eventHandlers = Map<String, _EventHandler>();

  PageEventListener? _pageEventListener;
  set pageEventListener(PageEventListener pageEventListener) {
    _pageEventListener = pageEventListener;
  }

  late final String ok = jsonEncode(FlutterEventResponse(Status.ok).toJson());
  late final String noContent = jsonEncode(FlutterEventResponse(Status.noContent).toJson());
  late final String notFound = jsonEncode(FlutterEventResponse(Status.notFound).toJson());

  EventDispatcher() {
    _registerHandler();
    _channel.setMethodCallHandler(_methodCallHandler);
  }

  Future<dynamic> _methodCallHandler(MethodCall call) async {
    final handler = _eventHandlers[call.method];
    if (handler != null) {
      return handler(call.arguments);
    }

    return notFound;
  }

  _registerHandler() {
    // register handler
    _eventHandlers["pagePushed"] = (dynamic arguments) async {
      final pageInfo = _decodePageInfo(arguments);
      if (pageInfo != null) {
        _pageEventListener?.pushPage(pageInfo);
      }

      return ok;
    };

    _eventHandlers["pagePopped"] = (dynamic arguments) async {
      final pageInfo = _decodePageInfo(arguments);
      if (pageInfo != null) {
        _pageEventListener?.popPage(pageInfo);
      }

      return ok;
    };

    _eventHandlers["pageDestroyed"] = (dynamic arguments) async {
      final pageInfo = _decodePageInfo(arguments);
      if (pageInfo != null) {
        _pageEventListener?.removePage(pageInfo);
      }

      return ok;
    };

    _eventHandlers["pageAppeared"] = (dynamic arguments) async {
      final pageInfo = _decodePageInfo(arguments);
      if (pageInfo != null) {
        _pageEventListener?.onPageAppeared(pageInfo);
      }

      return ok;
    };

    _eventHandlers["pageDisappeared"] = (dynamic arguments) async {
      final pageInfo = _decodePageInfo(arguments);
      if (pageInfo != null) {
        _pageEventListener?.onPageDisappeared(pageInfo);
      }

      return ok;
    };

    _eventHandlers["foreground"] = (dynamic arguments) async {
      _pageEventListener?.onForeground();
      return ok;
    };

    _eventHandlers["background"] = (dynamic arguments) async {
      _pageEventListener?.onBackground();
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
    return _channel.invokeMethod(event.method, jsonEncode(event.toJson()));
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