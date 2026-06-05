import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sarmayex_interview_project/app/features/order_book/domain/entities/order_book_model.dart';
import 'package:sarmayex_interview_project/app/features/order_book/domain/entities/order_model.dart';
import 'package:sarmayex_interview_project/app/core/utils/context_extension.dart';
import 'package:sarmayex_interview_project/app/core/utils/numeric_extension.dart';

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

        return Column(
          children: [
            _buildHeaders(context),
            const Divider(height: 1),
            Expanded(
              child: ListView.builder(
                itemCount: _getMaxLength(values.orderBook.bids, values.orderBook.asks),
                itemBuilder: (context, index) {
                  final bid = index < values.orderBook.bids.length ? values.orderBook.bids[index] : null;
                  final ask = index < values.orderBook.asks.length ? values.orderBook.asks[index] : null;

                  return Row(
                    children: [
                      Expanded(
                        child: _buildOrderRow(context, bid, Colors.green),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildOrderRow(context, ask, Colors.red),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  int _getMaxLength(List<OrderModel> bids, List<OrderModel> asks) {
    return bids.length > asks.length ? bids.length : asks.length;
  }

  Widget _buildHeaders(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Text(
                  context.localizations.bids,
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(context.localizations.price, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                    Text(context.localizations.amount, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              children: [
                Text(
                  context.localizations.asks,
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(context.localizations.price, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                    Text(context.localizations.amount, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderRow(BuildContext context, OrderModel? order, Color color) {
    if (order == null) {
      return const SizedBox.shrink(); // Empty space if one side is shorter
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
  }
}
