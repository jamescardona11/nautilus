import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import 'nautilus_nav.dart';
import 'nautilus_page.dart';
import 'nav_route.dart';
import 'navigator_actions.dart';

class NautilusDelegate extends RouterDelegate<String>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<String>
    implements NavigationActions {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  NautilusDelegate({
    required this.routes,
    required this.navBuilder,
    this.initialRoute,
  }) {
    _initFirstRoute();
  }

  final String? initialRoute;
  final List<NavRoute> routes;
  final ProviderBuilder navBuilder;

  List<NautilusPage> _pages = <NautilusPage>[];
  final Map<String, Completer<dynamic>> _resultCompleter = {};

  @override
  GlobalKey<NavigatorState>? get navigatorKey => _navigatorKey;

  @override
  String? get currentConfiguration {
    if (_pages.isEmpty) return null;

    return _pages.last.name;
  }

  @override
  Widget build(BuildContext context) {
    return navBuilder.call(
      Navigator(
        key: navigatorKey,
        pages: _pages,
        onPopPage: (route, dynamic result) {
          if (!route.didPop(result)) return false;
          // pop();
          return true;
        },
      ),
    );
  }

  @override
  Future<void> setNewRoutePath(String configuration) async {
    final elevenNavRoute = routes.firstWhereOrNull((element) => element.path == configuration);

    if (elevenNavRoute == null) return;

    //remove if exists
    removeIfExists(configuration);

    final dynamicParams = _extractParamsFromUrl(configuration);

    _pages = [
      ..._pages,
      NautilusPage(
        key: ValueKey(elevenNavRoute.path),
        path: elevenNavRoute.path,
        child: elevenNavRoute.handler,
        params: dynamicParams,
      )
    ];

    notifyListeners();
  }

  @override
  Future<dynamic> nav(String route, {Map<String, dynamic>? params}) async {
    final elevenNavRoute = routes.firstWhereOrNull((element) => element.path == route);

    if (elevenNavRoute == null) {
      throw Exception('Route not found');
    }

    //remove if exists
    removeIfExists(route);
    final dynamicParams = _extractParamsFromUrl(route);

    final newParams = {
      ...dynamicParams,
      ...?params,
    };

    _pages = [
      ..._pages,
      NautilusPage(
        key: ValueKey(elevenNavRoute.path),
        path: elevenNavRoute.path,
        child: elevenNavRoute.handler,
        params: newParams,
      )
    ];

    notifyListeners();

    Completer<dynamic> completer = Completer<dynamic>();

    _resultCompleter[elevenNavRoute.path] = completer;
    return completer.future;
  }

  @override
  Future<void> start(String route, {Map<String, dynamic>? params}) async {
    final elevenNavRoute = routes.firstWhereOrNull((element) => element.path == route);

    if (elevenNavRoute == null) {
      throw Exception('Route not found');
    }

    final dynamicParams = _extractParamsFromUrl(route);

    final newParams = {
      ...dynamicParams,
      ...?params,
    };

    _pages = [
      NautilusPage(
        key: ValueKey(elevenNavRoute.path),
        path: elevenNavRoute.path,
        child: elevenNavRoute.handler,
        params: newParams,
      )
    ];

    notifyListeners();
  }

  @override
  Future<dynamic> replace(String route, {Map<String, dynamic>? params}) async {
    final elevenNavRoute = routes.firstWhereOrNull((element) => element.path == route);

    if (elevenNavRoute == null) {
      throw Exception('Route not found');
    }

    if (_pages.isEmpty) return false;
    _pages.removeLast();

    final dynamicParams = _extractParamsFromUrl(route);
    final newParams = {
      ...dynamicParams,
      ...?params,
    };

    _pages = [
      ..._pages,
      NautilusPage(
        key: ValueKey(elevenNavRoute.path),
        path: elevenNavRoute.path,
        child: elevenNavRoute.handler,
        params: newParams,
      )
    ];

    notifyListeners();

    Completer<dynamic> completer = Completer<dynamic>();

    _resultCompleter[elevenNavRoute.path] = completer;
    return completer.future;
  }

  @override
  Future<bool> back([dynamic result]) async {
    if (_pages.length <= 1) return false;

    final pages = List<NautilusPage>.from(_pages);

    final completer = _resultCompleter[_pages.last.name];
    if (completer != null) {
      completer.complete(result);
      _resultCompleter.remove(_pages.last.name);
    }

    pages.removeLast();
    _pages = pages;

    notifyListeners();

    return true;
  }

  @override
  Future<bool> popRoute() async {
    return back();
  }

  @override
  Future<bool> backToFirst() async {
    if (_pages.length <= 1) return false;

    _pages = [_pages.first];
    notifyListeners();

    _resultCompleter.clear();

    return true;
  }

  @override
  Future<bool> backUntil(String route) async {
    if (_pages.length <= 1) return false;

    final index = _pages.indexWhere((element) => element.name == route);

    if (index == -1) {
      throw Exception('Route not found');
    }

    _pages = _pages.sublist(0, index + 1);
    _resultCompleter.removeWhere((key, value) => key != route);
    notifyListeners();

    return true;
  }

  void removeIfExists(String path) {
    _pages.removeWhere((element) => element.name == path);
  }

  Map<String, dynamic> _extractParamsFromUrl(String url) {
    final List<String> segments = url.split('/');

    Map<String, String> params = {};

    for (int i = 0; i < segments.length; i += 2) {
      if (i + 1 < segments.length) {
        final String paramName = segments[i].replaceAll(RegExp(r'[^a-zA-Z0-9]'), '');
        final String paramValue = segments[i + 1].replaceAll(RegExp(r'[^a-zA-Z0-9]'), '');
        params[paramName] = paramValue;
      }
    }

    return params;
  }

  void _initFirstRoute() {
    final index = _initialRouteIndex();

    _pages.add(
      NautilusPage(
        key: ValueKey(routes[index].path),
        path: routes[index].path,
        child: routes.first.handler,
      ),
    );
  }

  int _initialRouteIndex() {
    if (initialRoute == null || initialRoute!.isEmpty) {
      return 0;
    }

    bool isPath = initialRoute!.startsWith('/');
    int index = 0;

    if (isPath) {
      index = routes.indexWhere((element) => element.path == initialRoute);
    }

    return index > 0 ? index : 0;
  }
}
