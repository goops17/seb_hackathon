import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:seb_hackaton/utils/charts.dart';
import 'package:seb_hackaton/utils/circular_button.dart';
import 'package:seb_hackaton/utils/settings.dart';
import 'package:seb_hackaton/utils/shop.dart';
import 'package:seb_hackaton/utils/info/investment_info.dart';

class InvestmentDashboard extends StatefulWidget {
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
  State<InvestmentDashboard> createState() => _InvestmentDashboardState();
}

class _InvestmentDashboardState extends State<InvestmentDashboard> {
  late String avatarPath;
  late String backgroundPath;
  late String petPath;
  late String carPath;

  @override
  void initState() {
    super.initState();
    _updateVisuals();
  }

  void _updateVisuals() {
    final info = widget.investmentInfo;
    int level = getLevel(info.initialAmount);
    String genderPath = info.isMale ? 'male' : 'female';

    avatarPath = 'lib/assets/avatar/$genderPath/$level.png';
    backgroundPath = 'lib/assets/bg/$level.png'; // Background stays absolute
    petPath = info.hasPet ? 'lib/assets/pet/$level.png' : '';
    carPath = info.hasCar ? 'lib/assets/car/$level.png' : '';
  }

  int getLevel(double amount) {
    if (amount >= 50000) return 1;
    if (amount >= 30000) return 2;
    if (amount >= 20000) return 3;
    if (amount >= 10000) return 4;
    if (amount >= 5000) return 5;
    return 6;
  }

  void _openSettingsDialog() async {
    await showDialog(
      context: context,
      builder: (_) => InvestmentSetting(investmentInfo: widget.investmentInfo),
    );
    setState(() => _updateVisuals());
  }

  void _openShopDialog() async {
    print("shop button clicked");
    await showDialog(
      context: context,
      builder: (_) => InvestmentShop(investmentInfo: widget.investmentInfo),
    );

    setState(() => _updateVisuals());
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final avatarY = screenHeight * 0.67;
    final avatarSize = screenHeight * 0.20;
    final petCarSize = screenHeight * 0.10;

    return Stack(
      children: [
        // Background image
        Positioned.fill(child: Image.asset(backgroundPath, fit: BoxFit.cover)),

        // Light blur
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 1.0, sigmaY: 1.0),
            child: Container(color: Colors.transparent),
          ),
        ),

        Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  Positioned(
                    top: avatarY - avatarSize,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if (carPath.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: SizedBox(
                              height: petCarSize,
                              child: Image.asset(carPath, fit: BoxFit.contain),
                            ),
                          ),
                        SizedBox(
                          height: avatarSize,
                          child: Image.asset(avatarPath, fit: BoxFit.fitWidth),
                        ),
                        if (petPath.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(left: 12),
                            child: SizedBox(
                              height: petCarSize,
                              child: Image.asset(petPath, fit: BoxFit.contain),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (widget.showChart)
              Positioned.fill(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: InvestmentChart(investmentInfo: widget.investmentInfo),
                ),
              ),
            const SizedBox(height: 8),

            // Bottom menu
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CircularIconButton(
                    name: "Shop",
                    assetImagePath: "lib/assets/icons/shop.png",
                    onTap: _openShopDialog,
                  ),
                  CircularIconButton(
                    name: "Settings",
                    assetImagePath: "lib/assets/icons/settings.png",
                    onTap: _openSettingsDialog,
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
        ),
      ],
    );
  }
}
