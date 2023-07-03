import 'package:flutter/material.dart';

import 'nautilus_nav.dart';

typedef HandlerBuilder = Widget Function(
  BuildContext context,
  ElevenNavState state,
);

class NautilusPage extends Page {
  const NautilusPage({
    super.key,
    required this.child,
    required String path,
    this.params = const {},
  }) : super(name: path);

  final HandlerBuilder child;
  final Map<String, dynamic> params;

  @override
  Route createRoute(BuildContext context) {
    // params from path

    return MaterialPageRoute(
      settings: this,
      builder: (context) => child.call(
        context,
        ElevenNavState(
          name: name!,
          params: params,
        ),
      ),
    );
  }
}
