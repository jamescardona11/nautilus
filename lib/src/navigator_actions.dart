import 'dart:async';

abstract class NavigationActions {
  Future<dynamic> nav(String route, {Map<String, dynamic>? params});

  Future<void> start(String route, {Map<String, dynamic>? params});

  Future<dynamic> replace(String route, {Map<String, dynamic>? params});

  Future<bool> back([dynamic result]);

  Future<bool> backToFirst();

  Future<bool> backUntil(String route);
}
