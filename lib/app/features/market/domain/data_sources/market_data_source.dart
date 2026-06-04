import 'package:sarmayex_interview_project/app/model/base/sse_event_model.dart';

abstract class MarketDataSource {
  Stream<SseEventModel> get stream;
  Stream<bool> get connectionStateStream;

  Stream<SseEventModel> subscribeToMarket(String symbol);

  void disconnect();
}
