import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

import 'order_model.dart';

@immutable
class OrderBookModel extends Equatable {
  final List<OrderModel> bids;
  final List<OrderModel> asks;

  const OrderBookModel({required this.bids, required this.asks});

  factory OrderBookModel.empty() => const OrderBookModel(bids: [], asks: []);

  factory OrderBookModel.fromJson(Map<String, dynamic> json) => OrderBookModel(
    bids: json['bids'] == null ? [] : (json['bids'] as List).map((e) => OrderModel.fromJson(e)).toList(),
    asks: json['asks'] == null ? [] : (json['asks'] as List).map((e) => OrderModel.fromJson(e)).toList(),
  );

  @override
  List<Object?> get props => [bids, asks];
}
