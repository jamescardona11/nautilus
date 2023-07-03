import 'nautilus_page.dart';

class NavRoute {
  NavRoute({
    required this.path,
    required this.handler,
  });

  final String path;
  final HandlerBuilder handler;

  NavRoute refactorDash() => NavRoute(
        path: startWihDash ? path : '/$path',
        handler: handler,
      );

  bool get startWihDash => path.startsWith('/');

  @override
  String toString() => 'ElevenNavRoute= path: $path';
}
