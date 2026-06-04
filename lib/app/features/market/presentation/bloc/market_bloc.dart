import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/market_model.dart';
import '../../domain/repositories/market_repository.dart';

abstract class MarketEvent extends Equatable {
  const MarketEvent();

  @override
  List<Object?> get props => [];
}

class SubscribeToMarket extends MarketEvent {
  final String symbol;

  const SubscribeToMarket(this.symbol);

  @override
  List<Object?> get props => [symbol];
}

class _MarketDataReceived extends MarketEvent {
  final List<MarketModel> markets;

  const _MarketDataReceived(this.markets);

  @override
  List<Object?> get props => [markets];
}

class MarketState extends Equatable {
  final String currentMarket;
  final List<MarketModel> markets;

  const MarketState({
    required this.currentMarket,
    required this.markets,
  });

  factory MarketState.initial() => const MarketState(
    currentMarket: 'USDT_IRT',
    markets: [],
  );

  MarketState copyWith({
    String? currentMarket,
    List<MarketModel>? markets,
  }) {
    return MarketState(
      currentMarket: currentMarket ?? this.currentMarket,
      markets: markets ?? this.markets,
    );
  }

  @override
  List<Object?> get props => [currentMarket, markets];
}

class MarketBloc extends Bloc<MarketEvent, MarketState> {
  final MarketRepository _repository;
  StreamSubscription? _subscription;

  MarketBloc(this._repository) : super(MarketState.initial()) {
    on<SubscribeToMarket>(_onSubscribeToMarket);
    on<_MarketDataReceived>((event, emit) {
      emit(state.copyWith(markets: event.markets));
    });

    _initialize();
  }

  void _initialize() {
    _subscription = _repository
        .subscribeToMarket('USDT_IRT')
        .where((event) => event.event == 'markets')
        .listen((event) => add(_MarketDataReceived(_parseMarkets(event.data))));
  }

  List<MarketModel> _parseMarkets(Map<String, dynamic> data) {
    final changes = data['changes'] as Map<String, dynamic>?;
    if (changes == null) return [];

    return changes.entries.map((e) {
      final symbol = e.key;
      final details = e.value as Map<String, dynamic>;
      return MarketModel.fromJson(symbol, details);
    }).toList();
  }

  void _onSubscribeToMarket(SubscribeToMarket event, Emitter<MarketState> emit) {
    emit(state.copyWith(currentMarket: event.symbol));
    _repository.subscribeToMarket(event.symbol);
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    _repository.disconnect();
    return super.close();
  }
}
