import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sarmayex_interview_project/app/core/model/base/sse_event_model.dart';
import 'package:sarmayex_interview_project/app/features/market/domain/repositories/market_repository.dart';

abstract class SseConnectionEvent extends Equatable {
  const SseConnectionEvent();

  @override
  List<Object?> get props => [];
}

class ChangeMarket extends SseConnectionEvent {
  final String symbol;

  const ChangeMarket(this.symbol);

  @override
  List<Object?> get props => [symbol];
}

class _ConnectionStatusChanged extends SseConnectionEvent {
  final bool isConnecting;

  const _ConnectionStatusChanged(this.isConnecting);

  @override
  List<Object?> get props => [isConnecting];
}

class SseConnectionState extends Equatable {
  final String currentMarket;
  final bool isConnecting;

  const SseConnectionState({
    required this.currentMarket,
    this.isConnecting = true,
  });

  SseConnectionState copyWith({
    String? currentMarket,
    bool? isConnecting,
  }) {
    return SseConnectionState(
      currentMarket: currentMarket ?? this.currentMarket,
      isConnecting: isConnecting ?? this.isConnecting,
    );
  }

  @override
  List<Object?> get props => [currentMarket, isConnecting];
}

class ConnectionBloc extends Bloc<SseConnectionEvent, SseConnectionState> {
  final MarketRepository _repository;
  StreamSubscription? _statusSub;

  Stream<SseEventModel> get sseStream => _repository.stream;

  ConnectionBloc(this._repository) : super(const SseConnectionState(currentMarket: 'USDT_IRT', isConnecting: true)) {
    on<ChangeMarket>((event, emit) {
      emit(state.copyWith(currentMarket: event.symbol, isConnecting: true));
      _connect(event.symbol);
    });

    on<_ConnectionStatusChanged>((event, emit) {
      emit(state.copyWith(isConnecting: event.isConnecting));
    });

    _statusSub = _repository.connectionStateStream.listen((isConnecting) {
      add(_ConnectionStatusChanged(isConnecting));
    });
  }

  void _connect(String symbol) {
    _repository.subscribeToMarket(symbol);
  }

  @override
  Future<void> close() {
    _statusSub?.cancel();
    _repository.disconnect();
    return super.close();
  }
}
