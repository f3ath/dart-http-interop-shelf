import 'dart:convert';
import 'dart:io';

import 'package:http_interop/extensions.dart';
import 'package:http_interop/http_interop.dart';
import 'package:http_interop_shelf/http_interop_shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

void main() {
  late HttpClient httpClient;
  late HttpServer httpServer;
  final host = 'localhost';
  final port = 8000;

  setUp(() async {
    httpClient = HttpClient();
    httpClient.userAgent = null;
    httpServer = await shelf_io.serve(echo.shelfHandler, host, port);
  });

  tearDown(() async {
    httpClient.close();
    await httpServer.close();
  });

  test('can convert request', () async {
    final httpRequest = await httpClient.post(host, port, '/foo/bar');
    httpRequest.headers.add('Vary', ['Accept', 'Accept-Encoding']);
    httpRequest.write('Hello!');
    final httpResponse = await httpRequest.close();
    final body = await httpResponse.transform(Utf8Decoder()).join();
    final response = jsonDecode(body);
    expect(response['method'], equals('post'));
    expect(response['body'], equals('Hello!'));
    expect(response['headers']['vary'], equals(['Accept, Accept-Encoding']));
  });
}

Future<Response> echo(Request request) async => Response(
    200,
    Body.json({
      'method': request.method,
      'body': await request.body.decode(utf8),
      'headers': request.headers,
    }),
    Headers.from({
      'Content-Type': ['application/json']
    }));
