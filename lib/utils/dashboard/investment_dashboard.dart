import 'package:flutter/material.dart';
import 'package:seb_hackaton/utils/charts.dart';
import 'package:seb_hackaton/utils/circular_button.dart';
import 'package:seb_hackaton/utils/settings.dart';
import 'package:seb_hackaton/utils/info/investment_info.dart';

class InvestmentDashboard extends StatelessWidget {
  final bool showChart;
  final VoidCallback onToggleChart;
  final InvestmentInfo investmentInfo;
  const InvestmentDashboard({
    super.key,
    required this.investmentInfo,
    required this.showChart,
    required this.onToggleChart,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child:
                showChart
                    ? InvestmentChart(investmentInfo: investmentInfo)
                    : const Center(
                      child: Text(
                        'Welcome to your financial dashboard!',
                        style: TextStyle(
                          fontSize: 18,
                          color: Color(0xFF006734),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CircularIconButton(
                name: "Shop",
                assetImagePath: "lib/assets/icons/shop.png",
                onTap: () => print("Shop tapped"),
              ),
              CircularIconButton(
                name: "Settings",
                assetImagePath: "lib/assets/icons/settings.png",
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return InvestmentSetting(investmentInfo: investmentInfo);
                    },
                  );
                },
              ),
              CircularIconButton(
                name: "Simulation",
                assetImagePath: "lib/assets/icons/simulation.png",
                onTap: () => print("Simulation tapped"),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
