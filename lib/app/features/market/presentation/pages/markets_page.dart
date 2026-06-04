import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sarmayex_interview_project/app/features/order_book/presentation/widgets/order_book_widget.dart';

import '../bloc/market_bloc.dart';
import '../widgets/markets_widget.dart';

class MarketsPage extends StatelessWidget {
  const MarketsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<MarketBloc, MarketState>(
          buildWhen: (previous, current) => previous.currentMarket != current.currentMarket,
          builder: (context, state) {
            return Text('Market: ${state.currentMarket}');
          },
        ),
      ),
      body: const Column(
        children: [
          SizedBox(
            height: 90,
            child: MarketsWidget(),
          ),
          Divider(),
          Expanded(
            child: OrderBookWidget(),
          ),
        ],
      ),
    );
  }
}
