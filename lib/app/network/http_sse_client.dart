import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:sarmayex_interview_project/app/abstracts/base_sse_client.dart';

class HttpSseClient extends BaseSseClient {
  http.Client? _client;

  @override
  Future<void> connect(String url) async {
    if (isConnecting) return;
    super.connect(url);
    isConnecting = true;
    isConnected = false;
    currentUrl = url;

    try {
      _client?.close();
      _client = http.Client();

      final request = http.Request('GET', Uri.parse(url));
      request.headers.addAll(sseHeaders);

      final response = await _client!.send(request);

      /// Prevent overlapping connections during rapid switching!
      /// If the user switched markets while we were awaiting the response,
      /// `currentUrl` will no longer match the `url` this function started with.
      if (currentUrl != url) return;

      isConnecting = false;

      if (response.statusCode == 200) {
        if (currentUrl == null) return;
        isConnected = true;
        debugPrint('connected');
        subscription = response.stream
            .transform(utf8.decoder)
            .transform(const LineSplitter())
            .listen(
              handleResponse,
              onError: (_) => scheduleReconnect,
              onDone: scheduleReconnect,
            );
      } else {
        scheduleReconnect();
      }
    } catch (e) {
      /// Ignore exceptions thrown by requests that were cancelled
      /// because the user switched markets quickly.
      if (currentUrl != url || currentUrl == null) return;

      isConnecting = false;
      scheduleReconnect();
    }
  }

  @override
  void disconnect() {
    _client?.close();
    _client = null;
    super.disconnect();
  }
}
