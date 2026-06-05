import 'package:sarmayex_interview_project/app/core/model/base/sse_event_model.dart';

import '../../domain/data_sources/market_data_source.dart';
import '../../domain/repositories/market_repository.dart';

class MarketRepositoryImpl extends MarketRepository {
  final MarketDataSource _dataSource;

  MarketRepositoryImpl(this._dataSource);

  @override
  Stream<SseEventModel> get stream => _dataSource.stream;
  
  @override
  Stream<bool> get connectionStateStream => _dataSource.connectionStateStream;

  @override
  Stream<SseEventModel> subscribeToMarket(String symbol) {
    return _dataSource.subscribeToMarket(symbol).map((event) {
      return SseEventModel(
        event: event.event,
        data: event.data,
      );
    });
  }

  @override
  void disconnect() {
    _dataSource.disconnect();
  }
}
