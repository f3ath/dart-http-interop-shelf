import 'dart:convert';
import 'dart:io';

import 'package:http_interop/extensions.dart';
import 'package:http_interop/http_interop.dart';
import 'package:http_interop_shelf/http_interop_shelf.dart';
import 'package:shelf/shelf_io.dart';

void main() async {
  const host = 'localhost';
  const port = 8080;
  final shelfHandler = echo.shelfHandler;
  final server = await serve(shelfHandler, host, port);
  ProcessSignal.sigint.watch().listen((event) async {
    print('Shutting down...');
    await server.close();
    exit(0);
  });
  print('Listening on http://$host:$port. Press Ctrl+C to exit.');
}

/// This is a http_interop handler that echos the request back to the client.
Future<Response> echo(Request request) async => Response(
    200,
    Body.json({
      'method': request.method,
      'body': await request.body.decode(utf8),
      'headers': request.headers
    }),
    Headers.from({
      'Content-Type': ['application/json']
    }));
