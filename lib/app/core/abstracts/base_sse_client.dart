import 'dart:async';
import 'dart:convert';

import 'package:flutter/widgets.dart';

import '../model/base/sse_event_model.dart';

abstract class BaseSseClient {
  final sseHeaders = {
    'Accept': 'text/event-stream',
    'Cache-Control': 'no-cache',
  };

  StreamSubscription? subscription;

  final eventController = StreamController<SseEventModel>.broadcast();
  final connectionStateController = StreamController<bool>.broadcast();

  bool _isConnecting = false;

  bool get isConnecting => _isConnecting;

  set isConnecting(bool value) {
    if (_isConnecting != value) {
      _isConnecting = value;
      connectionStateController.add(value);
    }
  }

  bool isConnected = false;
  String? currentUrl;
  Timer? reconnectTimer;

  Stream<SseEventModel> get stream => eventController.stream;

  Stream<bool> get connectionStateStream => connectionStateController.stream;

  @mustCallSuper
  Future<void> connect(String url) async {
    debugPrint('Start connecting to $url');
  }

  void handleResponse(String line) {
    if (line.startsWith('data:')) {
      try {
        final dataStr = line.substring(5).trim();
        if (dataStr.isEmpty) return;

        final Map<String, dynamic> json = jsonDecode(dataStr);
        final event = json['event'] as String?;
        final data = json['data'];

        if (event != null && data != null && data is Map<String, dynamic>) {
          eventController.add(SseEventModel(event: event, data: data));
        }
      } catch (e) {
        // ignore parse errors for partial/invalid lines
      }
    }
  }

  @mustCallSuper
  void scheduleReconnect() {
    final urlToReconnect = currentUrl;
    disconnect();
    if (urlToReconnect != null) {
      currentUrl = urlToReconnect;
      reconnectTimer?.cancel();
      reconnectTimer = Timer(const Duration(seconds: 3), () {
        if (currentUrl != null) {
          connect(currentUrl!);
        }
      });
    }
  }

  @mustCallSuper
  void disconnect() {
    if (isConnecting == true || isConnected == true) debugPrint('Disconnect');
    isConnecting = false;
    isConnected = false;
    currentUrl = null;
    reconnectTimer?.cancel();
    reconnectTimer = null;
    subscription?.cancel();
    subscription = null;
  }

  @mustCallSuper
  void dispose() {
    disconnect();
    eventController.close();
    connectionStateController.close();
  }
}
