import '../../../../model/base/sse_event_model.dart';

abstract class MarketRepository {
  Stream<SseEventModel> get stream;
  Stream<bool> get connectionStateStream;

  Stream<SseEventModel> subscribeToMarket(String symbol);

  void disconnect();
}
