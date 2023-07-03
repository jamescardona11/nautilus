import 'dart:async';

import 'package:flutter/material.dart';

import 'nautilus_delegate.dart';
import 'nautilus_parser.dart';
import 'nautilus_provider.dart';
import 'nav_route.dart';
import 'navigator_actions.dart';

class NautilusNav implements NavigationActions {
  NautilusNav({
    this.initialRoute,
    this.routes = const [],
  }) {
    final formatRoutes = routes.map((route) => route.refactorDash()).toList();

    _delegate = NautilusDelegate(
      routes: formatRoutes,
      navBuilder: (nav) => NautilusProvider(
        elevenNav: this,
        child: nav,
      ),
    );
  }

  final String? initialRoute;
  final List<NavRoute> routes;

  final _routeInformationParser = NautilusInformationParser();
  late NautilusDelegate _delegate;

  NautilusDelegate get delegate => _delegate;
  NautilusInformationParser get parser => _routeInformationParser;

  static NautilusNav of(BuildContext context) {
    final inherited = context.dependOnInheritedWidgetOfExactType<NautilusProvider>();
    assert(inherited != null, 'No ElevenNav found in context');
    return inherited!.elevenNav;
  }

  @override
  Future<dynamic> nav(String route, {Map<String, dynamic>? params}) {
    return _delegate.nav(route, params: params);
  }

  @override
  Future<void> start(String route, {Map<String, dynamic>? params}) {
    return _delegate.start(route, params: params);
  }

  @override
  Future<dynamic> replace(String route, {Map<String, dynamic>? params}) {
    return _delegate.replace(route, params: params);
  }

  @override
  Future<bool> back([dynamic result]) {
    return _delegate.back(result);
  }

  @override
  Future<bool> backUntil(String route) {
    return _delegate.backUntil(route);
  }

  @override
  Future<bool> backToFirst() {
    return _delegate.backToFirst();
  }
}

/// Information before navigate send for delegate
class ElevenNavState {
  final String name;
  final Map<String, dynamic>? params;

  const ElevenNavState({
    required this.name,
    this.params,
  });
}

/// The signature of the widget builder callback for a matched ElevenNavRouter
typedef ProviderBuilder = Widget Function(Navigator nav);
