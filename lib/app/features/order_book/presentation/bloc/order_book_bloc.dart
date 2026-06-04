import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sarmayex_interview_project/app/features/market/domain/repositories/market_repository.dart';
import 'package:sarmayex_interview_project/app/features/order_book/domain/entities/order_book_model.dart';

abstract class OrderBookEvent extends Equatable {
  const OrderBookEvent();

  @override
  List<Object?> get props => [];
}

class _OrderBookDataReceived extends OrderBookEvent {
  final OrderBookModel orderBook;

  const _OrderBookDataReceived(this.orderBook);

  @override
  List<Object?> get props => [orderBook];
}

class _ConnectionStatusChanged extends OrderBookEvent {
  final bool isConnecting;

  const _ConnectionStatusChanged(this.isConnecting);

  @override
  List<Object?> get props => [isConnecting];
}

class OrderBookState extends Equatable {
  final OrderBookModel orderBook;
  final bool isConnecting;

  const OrderBookState({
    required this.orderBook,
    this.isConnecting = false,
  });

  factory OrderBookState.initial() => OrderBookState(
    orderBook: OrderBookModel.empty(),
    isConnecting: true,
  );

  OrderBookState copyWith({
    OrderBookModel? orderBook,
    bool? isConnecting,
  }) {
    return OrderBookState(
      orderBook: orderBook ?? this.orderBook,
      isConnecting: isConnecting ?? this.isConnecting,
    );
  }

  @override
  List<Object?> get props => [orderBook, isConnecting];
}

class OrderBookBloc extends Bloc<OrderBookEvent, OrderBookState> {
  final MarketRepository _repository;
  StreamSubscription? _orderBookSub;
  StreamSubscription? _connectionSub;

  OrderBookBloc(this._repository) : super(OrderBookState.initial()) {
    on<_OrderBookDataReceived>((event, emit) {
      emit(state.copyWith(orderBook: event.orderBook, isConnecting: false));
    });

    on<_ConnectionStatusChanged>((event, emit) {
      if (event.isConnecting) {
        emit(state.copyWith(isConnecting: true, orderBook: OrderBookModel.empty()));
      } else {
        emit(state.copyWith(isConnecting: false));
      }
    });

    _orderBookSub = _repository.stream.listen((event) {
      if (event.event == 'order_book') {
        try {
          final orderBook = OrderBookModel.fromJson(event.data);
          add(_OrderBookDataReceived(orderBook));
        } catch (_) {}
      }
    });

    _connectionSub = _repository.connectionStateStream.listen((isConnecting) {
      add(_ConnectionStatusChanged(isConnecting));
    });
  }

  @override
  Future<void> close() {
    _orderBookSub?.cancel();
    _connectionSub?.cancel();
    return super.close();
  }
}
