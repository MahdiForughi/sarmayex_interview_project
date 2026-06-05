import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/market_model.dart';
import '../bloc/sse_connection_bloc.dart';

abstract class MarketEvent extends Equatable {
  const MarketEvent();

  @override
  List<Object?> get props => [];
}

class _MarketDataReceived extends MarketEvent {
  final List<MarketModel> markets;

  const _MarketDataReceived(this.markets);

  @override
  List<Object?> get props => [markets];
}

class MarketState extends Equatable {
  final List<MarketModel> markets;

  const MarketState({
    required this.markets,
  });

  factory MarketState.initial() => const MarketState(
    markets: [],
  );

  MarketState copyWith({
    List<MarketModel>? markets,
  }) {
    return MarketState(
      markets: markets ?? this.markets,
    );
  }

  @override
  List<Object?> get props => [markets];
}

class MarketBloc extends Bloc<MarketEvent, MarketState> {
  final ConnectionBloc _connectionBloc;
  StreamSubscription? _subscription;

  MarketBloc(this._connectionBloc) : super(MarketState.initial()) {
    on<_MarketDataReceived>((event, emit) {
      emit(state.copyWith(markets: event.markets));
    });

    _initialize();
  }

  void _initialize() {
    _subscription = _connectionBloc.sseStream
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

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
