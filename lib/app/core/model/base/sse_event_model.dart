import 'package:flutter/widgets.dart';

@immutable
class SseEventModel {
  final String event;
  final Map<String, dynamic> data;

  const SseEventModel({required this.event, required this.data});

  factory SseEventModel.fromJson(Map<String, dynamic> response) {
    final jsonResponse = response;

    return SseEventModel(event: jsonResponse['event'], data: jsonResponse['data']);
  }

  Map<String, dynamic> toJson() => {'event': event, 'data': data};
}
