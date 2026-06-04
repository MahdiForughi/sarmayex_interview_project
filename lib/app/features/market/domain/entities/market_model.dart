import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

@immutable
class MarketModel extends Equatable {
  final String symbol;

  /// lp
  final double? price;

  /// pct
  final double? changePct;

  const MarketModel({required this.symbol, this.price, this.changePct});

  factory MarketModel.fromJson(String symbol, Map<String, dynamic> json) => MarketModel(
    symbol: symbol,
    price: double.tryParse(json['lp'].toString()),
    changePct: double.tryParse(json['pct'].toString()),
  );

  @override
  List<Object?> get props => [symbol, price, changePct];
}
