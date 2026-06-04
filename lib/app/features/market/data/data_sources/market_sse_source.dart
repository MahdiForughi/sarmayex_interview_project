import 'package:sarmayex_interview_project/app/abstracts/base_sse_client.dart';
import 'package:sarmayex_interview_project/app/constants/base_urls.dart';
import 'package:sarmayex_interview_project/app/model/base/sse_event_model.dart';

import '../../domain/data_sources/market_data_source.dart';

class MarketSseSource extends MarketDataSource {
  final BaseSseClient _sseClient;

  MarketSseSource(this._sseClient);

  @override
  Stream<SseEventModel> get stream => _sseClient.stream;
  
  @override
  Stream<bool> get connectionStateStream => _sseClient.connectionStateStream;

  @override
  Stream<SseEventModel> subscribeToMarket(String symbol) {
    _sseClient.disconnect();
    final url = BaseUrls.subscribeMarketUrl(symbol);
    _sseClient.connect(url);
    return _sseClient.stream;
  }

  @override
  void disconnect() => _sseClient.disconnect();
}
