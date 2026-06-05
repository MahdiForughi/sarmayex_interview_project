import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sarmayex_interview_project/app/features/market/data/data_sources/market_sse_source.dart';
import 'package:sarmayex_interview_project/app/features/market/data/repositories/market_repository_impl.dart';
import 'package:sarmayex_interview_project/app/core/network/http_sse_client.dart';

void main() {
  test('Test receiving OrderBook server-side events', () async {
    final repository = MarketRepositoryImpl(MarketSseSource(HttpSseClient()));

    final stream = repository.subscribeToMarket('USDT_IRT');

    int count = 0;
    await for (final sseEvent in stream) {
      debugPrint(sseEvent.toJson().toString());
      count++;
      if (count > 2) {
        break;
      }
    }

    repository.disconnect();
  });
}
