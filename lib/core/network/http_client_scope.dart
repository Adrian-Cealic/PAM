import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

class HttpClientScope extends InheritedWidget {
  const HttpClientScope({super.key, required this.client, required super.child});

  final http.Client client;

  static http.Client? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<HttpClientScope>()?.client;

  @override
  bool updateShouldNotify(HttpClientScope oldWidget) => client != oldWidget.client;
}
