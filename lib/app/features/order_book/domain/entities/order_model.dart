import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

@immutable
class OrderModel extends Equatable {
  /// p
  final double? price;

  /// a
  final double? amount;

  const OrderModel({this.price, this.amount});

  factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
    price: double.tryParse(json['p'].toString()),
    amount: double.tryParse(json['a'].toString()),
  );

  @override
  List<Object?> get props => [price, amount];
}
