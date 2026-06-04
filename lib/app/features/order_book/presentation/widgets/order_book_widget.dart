import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sarmayex_interview_project/app/features/order_book/domain/entities/order_book_model.dart';
import 'package:sarmayex_interview_project/app/features/order_book/domain/entities/order_model.dart';
import 'package:sarmayex_interview_project/app/utils/context_extension.dart';
import 'package:sarmayex_interview_project/app/utils/numeric_extension.dart';

import '../bloc/order_book_bloc.dart';

class OrderBookWidget extends StatelessWidget {
  const OrderBookWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<OrderBookBloc, OrderBookState, ({OrderBookModel orderBook, bool isLoading})>(
      selector: (state) => (orderBook: state.orderBook, isLoading: state.isConnecting),
      builder: (context, values) {
        if (values.isLoading) return const Center(child: CircularProgressIndicator());

        if (values.orderBook.bids.isEmpty && values.orderBook.asks.isEmpty) {
          return const Center(child: Text('No order book data'));
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _buildOrderList(
                context,
                context.localizations.bids,
                orders: values.orderBook.bids,
                color: Colors.green,
              ),
            ),
            const VerticalDivider(width: 1),
            Expanded(
              child: _buildOrderList(
                context,
                context.localizations.asks,
                orders: values.orderBook.asks,
                color: Colors.red,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildOrderList(BuildContext context, String title, {required List<OrderModel> orders, required Color color}) {
    return Column(
      children: [
        Padding(
          padding: const .all(8.0),
          child: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
        Padding(
          padding: const .symmetric(horizontal: 8.0),
          child: Row(
            mainAxisAlignment: .spaceBetween,
            children: [
              Text(
                context.localizations.price,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              Text(
                context.localizations.amount,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];

              return Padding(
                padding: const .symmetric(horizontal: 8, vertical: 4),
                child: Row(
                  mainAxisAlignment: .spaceBetween,
                  children: [
                    Text(
                      '${order.price?.toPriceFormatter ?? 0}',
                      style: TextStyle(color: color, fontSize: 13),
                    ),
                    Text(
                      '${order.amount?.toStringAsFixed(2) ?? 0}',
                      style: const TextStyle(fontSize: 13),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
