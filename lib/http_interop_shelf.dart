library;

import 'dart:typed_data';

import 'package:http_interop/http_interop.dart';
import 'package:shelf/shelf.dart' as s;

extension ShelfHandler on Handler {
  /// Handles a Shelf request using this Interop handler.
  ///
  /// The Interop request receives [s.Request.requestedUri], preserving the
  /// original absolute URI even when Shelf has consumed a mount prefix.
  /// For example, mounting under `/api` leaves `/api/users` as the Interop
  /// request's path, while [s.Request.url] has the relative path `users`.
  Future<s.Response> shelfHandler(s.Request request) =>
      this(request.toInterop()).then(
        (it) => s.Response(
          it.statusCode,
          body: it.body.bytes,
          headers: it.headers.toMap(),
          context: Map.fromEntries(
            it.context.entries
                .where((entry) => entry.value != null)
                .map((entry) => MapEntry(entry.key, entry.value!)),
          ),
        ),
      );
}

extension on s.Request {
  Request toInterop() => Request(
    method,
    requestedUri,
    Body(
      read().map(
        (chunk) => chunk is Uint8List ? chunk : Uint8List.fromList(chunk),
      ),
    ),
    Headers.from(
      headersAll.map((key, values) => MapEntry(key, List<String>.of(values))),
    ),
  )..context.addAll(context);
}
