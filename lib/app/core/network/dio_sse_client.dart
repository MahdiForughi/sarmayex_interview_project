import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:sarmayex_interview_project/app/core/abstracts/base_sse_client.dart';

class DioSseClient extends BaseSseClient {
  Dio? _client;

  CancelToken? cancelToken;

  @override
  Future<void> connect(String url) async {
    if (isConnecting) return;
    super.connect(url);
    isConnecting = true;
    isConnected = false;
    currentUrl = url;

    try {
      cancelToken?.cancel();
      cancelToken = CancelToken();
      _client?.close(); // Ensure previous client is closed if any.
      _client = Dio();

      final Response<ResponseBody> response = await _client!.request<ResponseBody>(
        url,
        cancelToken: cancelToken,
        options: Options(
          headers: sseHeaders,
          responseType: ResponseType.stream,
        ),
      );
      
      if (currentUrl != url) return;

      isConnecting = false;

      if (response.statusCode == 200) {
        debugPrint('connected');
        if (cancelToken?.isCancelled == true) return;

        isConnected = true;
        subscription = response.data?.stream
            .transform(unit8Transformer)
            .transform(const Utf8Decoder())
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
      if (currentUrl != url) return;
      if (e is DioException && CancelToken.isCancel(e)) {
        debugPrint('Connection cancelled');
        return;
      }
      isConnecting = false;
      scheduleReconnect();
    }
  }

  StreamTransformer<Uint8List, List<int>> unit8Transformer = StreamTransformer.fromHandlers(
    handleData: (data, sink) {
      sink.add(List<int>.from(data));
    },
  );

  @override
  void disconnect() {
    cancelToken?.cancel();
    _client?.close();
    _client = null;
    super.disconnect();
  }
}
