import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:seb_hackaton/utils/charts.dart';
import 'package:seb_hackaton/utils/circular_button.dart';
import 'package:seb_hackaton/utils/settings.dart';
import 'package:seb_hackaton/utils/simulation.dart';
import 'package:seb_hackaton/utils/shop.dart';
import 'package:seb_hackaton/utils/share.dart';
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
  late String travelPath;

  @override
  void initState() {
    super.initState();
    _updateVisuals();
  }

  @override
  void didUpdateWidget(covariant InvestmentDashboard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.investmentInfo != oldWidget.investmentInfo) {
      _updateVisuals();
    }
  }

  void _updateVisuals() {
    final info = widget.investmentInfo;
    int level = getLevel(info.initialAmount);
    int houseLevel = getLevel(info.houseAmount);
    int petLevel = getLevel(info.petAmount);
    int carLevel = getLevel(info.carAmount);
    int travelLevel = getLevel(info.travelAmount);
    String genderPath = info.isMale ? 'male' : 'female';

    avatarPath = 'lib/assets/avatar/$genderPath/$level.png';
    backgroundPath =
        info.hasHouse ? 'lib/assets/bg/$houseLevel.png' : 'lib/assets/bg/7.png';
    petPath = info.hasPet ? 'lib/assets/pet/$petLevel.png' : '';
    carPath = info.hasCar ? 'lib/assets/car/$carLevel.png' : '';
    travelPath = info.hasTravel ? 'lib/assets/travel/$travelLevel.png' : '';

    setState(() {}); // Refresh UI
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
    _updateVisuals();
  }

  void _openShareDialog() async {
    await showDialog(context: context, builder: (_) => InvestmentShare());
    _updateVisuals();
  }

  void _openShopDialog() async {
    await showDialog(
      context: context,
      builder: (_) => InvestmentShop(investmentInfo: widget.investmentInfo),
    );
    _updateVisuals();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final avatarY = screenHeight * 0.7;
    final avatarSize = screenHeight * 0.25;
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
                  if (travelPath.isNotEmpty)
                    Positioned(
                      top: avatarY - (avatarSize + petCarSize * 2),
                      left: 0,
                      right: 0,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 0),
                        child: SizedBox(
                          height: petCarSize * 2,
                          child: Image.asset(travelPath, fit: BoxFit.contain),
                        ),
                      ),
                    ),
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
                            padding: const EdgeInsets.only(right: 0),
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
                            padding: const EdgeInsets.only(left: 0),
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
                    name: "Share",
                    assetImagePath: "lib/assets/icons/share.png",
                    onTap: _openShareDialog,
                  ),
                  CircularIconButton(
                    name: "Simulation",
                    assetImagePath: "lib/assets/icons/simulation.png",
                    onTap: () async {
                      openSimulationDialog(context, widget.investmentInfo, (
                        InvestmentInfo updatedInfo,
                      ) async {
                        await widget.investmentInfo.replace(updatedInfo);
                        _updateVisuals();
                      });
                    },
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
