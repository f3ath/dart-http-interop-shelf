library http_interop_shelf;

import 'dart:typed_data';

import 'package:http_interop/http_interop.dart' as i;
import 'package:shelf/shelf.dart';

extension ShelfExt on i.Handler {
  Future<Response> shelfHandler(Request request) =>
      this(request.toInteropRequest()).then((it) => it.toShelfResponse());
}

extension on Request {
  i.Request toInteropRequest() => i.Request(method, requestedUri,
      i.Body.stream(read().map(Uint8List.fromList)), i.Headers.from(headersAll))
    ..context.addAll(context);
}

extension on i.Response {
  Response toShelfResponse() => Response(statusCode,
      body: body.bytes,
      headers: headers.toMap(),
      context: Map.fromEntries(
          context.entries.whereType<MapEntry<String, Object>>()));
}
