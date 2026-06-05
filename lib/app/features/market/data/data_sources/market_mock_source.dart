import 'dart:async';
import 'dart:math';

import 'package:sarmayex_interview_project/app/core/model/base/sse_event_model.dart';

import '../../domain/data_sources/market_data_source.dart';

class MarketMockSource extends MarketDataSource {
  StreamController<SseEventModel>? _streamController;
  Timer? _timer;

  @override
  Stream<SseEventModel> get stream => _streamController?.stream ?? const Stream.empty();

  @override
  Stream<bool> get connectionStateStream => const Stream.empty();

  @override
  Stream<SseEventModel> subscribeToMarket(String symbol) {
    disconnect(); // Ensure any previous connection is closed

    _streamController = StreamController<SseEventModel>.broadcast();

    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_streamController?.isClosed == false) {
        _streamController?.add(
          SseEventModel(
            event: 'update',
            data: {
              'event': 'order_book',
              'data': {
                'asks': [
                  {'p': Random(170290).nextInt(173290).toString(), 'a': '91.03'},
                ],
                'bids': [
                  {'p': Random(172000).nextInt(175000).toString(), 'a': '18.79'},
                ],
              },
            },
          ),
        );
      }
    });

    return _streamController!.stream;
  }

  @override
  void disconnect() {
    _timer?.cancel();
    _timer = null;

    _streamController?.close();
    _streamController = null;
  }
}
