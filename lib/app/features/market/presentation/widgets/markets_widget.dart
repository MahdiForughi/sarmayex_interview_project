import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sarmayex_interview_project/app/core/utils/numeric_extension.dart';
import 'package:sarmayex_interview_project/app/features/market/domain/entities/market_model.dart';

import '../bloc/market_bloc.dart';
import '../bloc/sse_connection_bloc.dart';

class MarketsWidget extends StatelessWidget {
  const MarketsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MarketBloc, MarketState>(
      builder: (context, marketState) {
        if (marketState.markets.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        final currentMarket = context.select((ConnectionBloc b) => b.state.currentMarket);
        final markets = marketState.markets;

        final sortedMarkets = List<MarketModel>.from(markets);
        final currentIndex = sortedMarkets.indexWhere((m) => m.symbol == currentMarket);
        if (currentIndex > 0) {
          final activeItem = sortedMarkets.removeAt(currentIndex);
          sortedMarkets.insert(0, activeItem);
        }

        return ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: sortedMarkets.length,
          itemBuilder: (context, index) {
            final market = sortedMarkets[index];
            final isSelected = market.symbol == currentMarket;
            final isPositive = (market.changePct ?? 0) >= 0;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: ChoiceChip(
                onSelected: (selected) {
                  if (selected && !isSelected) {
                    context.read<ConnectionBloc>().add(ChangeMarket(market.symbol));
                  }
                },
                selected: isSelected,
                label: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(market.symbol, style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text(
                      ((market.price ?? 0) < 1
                          ? '${market.price?.toStringAsFixed(3) ?? 0}'
                          : '${market.price?.toPriceFormatter ?? 0}'),
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
