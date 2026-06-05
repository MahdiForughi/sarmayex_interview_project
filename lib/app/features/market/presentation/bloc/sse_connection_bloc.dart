import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sarmayex_interview_project/app/features/market/domain/repositories/market_repository.dart';
import 'package:sarmayex_interview_project/app/core/model/base/sse_event_model.dart';

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

class _SseDataReceived extends SseConnectionEvent {
  final SseEventModel event;

  const _SseDataReceived(this.event);

  @override
  List<Object?> get props => [event];
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
  final SseEventModel? lastEvent;

  const SseConnectionState({
    required this.currentMarket,
    this.isConnecting = true,
    this.lastEvent,
  });

  SseConnectionState copyWith({
    String? currentMarket,
    bool? isConnecting,
    SseEventModel? lastEvent,
  }) {
    return SseConnectionState(
      currentMarket: currentMarket ?? this.currentMarket,
      isConnecting: isConnecting ?? this.isConnecting,
      lastEvent: lastEvent ?? this.lastEvent,
    );
  }

  @override
  List<Object?> get props => [currentMarket, isConnecting, lastEvent];
}

class ConnectionBloc extends Bloc<SseConnectionEvent, SseConnectionState> {
  final MarketRepository _repository;
  StreamSubscription? _dataSub;
  StreamSubscription? _statusSub;

  ConnectionBloc(this._repository) : super(const SseConnectionState(currentMarket: 'USDT_IRT', isConnecting: true)) {
    on<ChangeMarket>((event, emit) {
      emit(state.copyWith(currentMarket: event.symbol, isConnecting: true));
      _connect(event.symbol);
    });

    on<_SseDataReceived>((event, emit) {
      emit(state.copyWith(lastEvent: event.event));
    });

    on<_ConnectionStatusChanged>((event, emit) {
      emit(state.copyWith(isConnecting: event.isConnecting));
    });

    _dataSub = _repository.stream.listen((event) {
      add(_SseDataReceived(event));
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
    _dataSub?.cancel();
    _statusSub?.cancel();
    _repository.disconnect();
    return super.close();
  }
}
