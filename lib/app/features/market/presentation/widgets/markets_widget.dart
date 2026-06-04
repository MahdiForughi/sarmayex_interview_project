import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sarmayex_interview_project/app/features/market/domain/entities/market_model.dart';
import 'package:sarmayex_interview_project/app/utils/numeric_extension.dart';

import '../bloc/market_bloc.dart';

class MarketsWidget extends StatelessWidget {
  const MarketsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<MarketBloc, MarketState, ({List<MarketModel> markets, String currentMarket})>(
      selector: (state) => (markets: state.markets, currentMarket: state.currentMarket),
      builder: (context, values) {
        if (values.markets.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: values.markets.length,
          itemBuilder: (context, index) {
            final market = values.markets[index];
            final isSelected = market.symbol == values.currentMarket;
            final isPositive = (market.changePct ?? 0) >= 0;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: ChoiceChip(
                onSelected: (selected) {
                  if (selected && !isSelected) {
                    context.read<MarketBloc>().add(SubscribeToMarket(market.symbol));
                  }
                },
                selected: isSelected,
                label: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(market.symbol, style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text(
                      market.price?.toPriceFormatter ?? '0',
                      style: const TextStyle(fontSize: 12),
                    ),
                    Text(
                      '${market.changePct?.toStringAsFixed(2) ?? 0}%',
                      style: TextStyle(
                        fontSize: 10,
                        color: isPositive ? Colors.green : Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
