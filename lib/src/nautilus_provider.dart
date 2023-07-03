import 'package:flutter/material.dart';

import 'nautilus_nav.dart';

class NautilusProvider extends InheritedWidget {
  const NautilusProvider({
    Key? key,
    required this.elevenNav,
    required Widget child,
  }) : super(key: key, child: child);

  final NautilusNav elevenNav;

  static NautilusProvider? of(BuildContext context) => context.dependOnInheritedWidgetOfExactType<NautilusProvider>();

  @override
  bool updateShouldNotify(covariant NautilusProvider oldWidget) => false;
}
