import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'dart:math';

import 'package:seb_hackaton/utils/info/investment_info.dart';

class InvestmentChart extends StatefulWidget {
  final InvestmentInfo investmentInfo;
  final int years;

  const InvestmentChart({
    super.key,
    required this.investmentInfo,
    this.years = 30,
  });

  @override
  State<InvestmentChart> createState() => _InvestmentChartState();
}

class _InvestmentChartState extends State<InvestmentChart> {
  List<FlSpot> _calculateOneTimeInvestment() {
    return List.generate(widget.years + 1, (year) {
      double value =
          widget.investmentInfo.initialAmount *
          pow(1 + widget.investmentInfo.growthRate, year);
      return FlSpot(year.toDouble(), value / 1000); // in K
    });
  }

  List<FlSpot> _calculateMonthlyContributions() {
    return List.generate(widget.years + 1, (year) {
      double futureValue = 0;
      for (int m = 1; m <= year * 12; m++) {
        futureValue +=
            widget.investmentInfo.monthlyContribution *
            pow(1 + widget.investmentInfo.growthRate / 12, (year * 12) - m + 1);
      }
      futureValue +=
          widget.investmentInfo.initialAmount *
          pow(1 + widget.investmentInfo.growthRate, year);
      return FlSpot(year.toDouble(), futureValue / 1000); // in K
    });
  }

  int _getLevel(double amount) {
    if (amount >= 50000) return 1;
    if (amount >= 30000) return 2;
    if (amount >= 20000) return 3;
    if (amount >= 10000) return 4;
    if (amount >= 5000) return 5;
    return 6;
  }

  Color _getLevelColor(int level) {
    switch (level) {
      case 1:
        return Colors.green.shade800;
      case 2:
        return Colors.green;
      case 3:
        return Colors.orange.shade700;
      case 4:
        return Colors.orange;
      case 5:
        return Colors.deepOrange;
      default:
        return Colors.redAccent;
    }
  }

  String _formatCurrency(double amount) =>
      "\€${(amount / 1000).toStringAsFixed(0)}K";

  Widget _buildGoalProgress(String label, double current, double target) {
    final percent = target == 0 ? 0.0 : (current / target).clamp(0.0, 1.0);
    final percentText = (percent * 100).toStringAsFixed(0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("$label: $percentText%"),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: percent,
          backgroundColor: Colors.grey.shade300,
          color: _getLevelColor(_getLevel(current)),
          minHeight: 8,
        ),
        const SizedBox(height: 14),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final oneTime = _calculateOneTimeInvestment();
    final monthly = _calculateMonthlyContributions();

    final double endValueOneTime = oneTime.last.y * 1000;
    final double endValueMonthly = monthly.last.y * 1000;
    final double maxChartY =
        [...oneTime, ...monthly].map((e) => e.y).reduce(max) * 1.1;

    final initial = widget.investmentInfo.initialAmount;
    final monthlyContribution = widget.investmentInfo.monthlyContribution;

    if (initial == 0 && monthlyContribution == 0) {
      return const Center(
        child: Text(
          "You don’t have any assets to project yet.",
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    final totalAmount = initial + monthlyContribution * 12;
    final level = _getLevel(totalAmount);
    final levelColor = _getLevelColor(level);
    final levelBackground = Colors.grey.shade100;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 380),
        child: Card(
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          color: levelBackground,
          child: SizedBox(
            height: 640, // Adjust height as needed
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Investment Projection",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: levelColor,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 12,
                      runSpacing: 8,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Icon(Icons.savings, color: levelColor, size: 20),
                        Text(
                          "Initial Investment: \€${initial.toStringAsFixed(2)}",
                          style: TextStyle(color: levelColor),
                        ),
                        const SizedBox(height: 20),
                        Icon(Icons.trending_up, color: levelColor, size: 20),
                        Text(
                          "Monthly Contribution: \$${monthlyContribution.toStringAsFixed(2)}",
                          style: TextStyle(color: levelColor),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    AspectRatio(
                      aspectRatio: 1.7,
                      child: LineChart(
                        LineChartData(
                          maxY: maxChartY,
                          minY: 0,
                          lineTouchData: LineTouchData(
                            handleBuiltInTouches: true,
                            touchTooltipData: LineTouchTooltipData(
                              tooltipRoundedRadius: 12,
                              showOnTopOfTheChartBoxArea: true,
                              getTooltipItems: (touchedSpots) {
                                return touchedSpots.map((spot) {
                                  final value = spot.y.toStringAsFixed(1);
                                  return LineTooltipItem(
                                    "${spot.barIndex == 0 ? "One-time" : "Monthly"}: \€${value}K",
                                    TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: levelColor,
                                    ),
                                  );
                                }).toList();
                              },
                            ),
                          ),
                          gridData: FlGridData(
                            show: true,
                            drawVerticalLine: true,
                            getDrawingHorizontalLine:
                                (value) => FlLine(
                                  color: Colors.grey.shade300,
                                  strokeWidth: 1,
                                ),
                            getDrawingVerticalLine:
                                (value) => FlLine(
                                  color: Colors.grey.shade200,
                                  strokeWidth: 1,
                                ),
                          ),
                          titlesData: FlTitlesData(
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                interval: 5,
                                getTitlesWidget:
                                    (value, _) => Padding(
                                      padding: const EdgeInsets.only(top: 8),
                                      child: Text(
                                        '${value.toInt()}Y',
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ),
                              ),
                            ),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                interval: maxChartY / 5,
                                getTitlesWidget: (value, _) {
                                  final formatted = NumberFormat.compact(
                                    locale: 'en_US',
                                  ).format(value * 1000);
                                  return Text(
                                    '\€$formatted',
                                    style: const TextStyle(fontSize: 12),
                                  );
                                },
                                reservedSize: 48,
                              ),
                            ),
                            rightTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            topTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                          ),
                          borderData: FlBorderData(show: false),
                          minX: 0,
                          maxX: widget.years.toDouble(),
                          lineBarsData: [
                            LineChartBarData(
                              spots: oneTime,
                              isCurved: true,
                              color: levelColor.withOpacity(0.8),
                              barWidth: 4,
                              isStrokeCapRound: true,
                              belowBarData: BarAreaData(
                                show: true,
                                color: levelColor.withOpacity(0.2),
                              ),
                              dotData: FlDotData(show: false),
                            ),
                            LineChartBarData(
                              spots: monthly,
                              isCurved: true,
                              color: levelColor,
                              barWidth: 4,
                              isStrokeCapRound: true,
                              belowBarData: BarAreaData(
                                show: true,
                                color: levelColor.withOpacity(0.15),
                              ),
                              dotData: FlDotData(show: false),
                            ),
                          ],
                        ),
                        duration: const Duration(milliseconds: 800),
                        curve: Curves.easeInOut,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        LegendItem(
                          color: levelColor,
                          label: "One-Time & Monthly",
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "30Y One-Time: ${_formatCurrency(endValueOneTime)} | With Contributions: ${_formatCurrency(endValueMonthly)}",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: levelColor,
                      ),
                    ),
                    const SizedBox(height: 20),
                    if (widget.investmentInfo.hasHouse)
                      _buildGoalProgress(
                        "🏠 House",
                        widget.investmentInfo.houseAmount,
                        50000,
                      ),
                    if (widget.investmentInfo.hasCar)
                      _buildGoalProgress(
                        "🚗 Car",
                        widget.investmentInfo.carAmount,
                        50000,
                      ),
                    if (widget.investmentInfo.hasPet)
                      _buildGoalProgress(
                        "🐾 Pet",
                        widget.investmentInfo.petAmount,
                        50000,
                      ),
                    if (widget.investmentInfo.hasTravel)
                      _buildGoalProgress(
                        "🌍 Travel",
                        widget.investmentInfo.travelAmount,
                        50000,
                      ),
                    const SizedBox(height: 12),
                    const Text(
                      "📊 Underlying Assets",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const Text("• SPY (S&P 500 ETF): 10%"),
                    const Text("• VOO (Vanguard S&P 500): 30%"),
                    const Text("• QQQ (Nasdaq 100): 10%"),
                    const Text("• INF (Invest For Future ETF)): 50%"),
                    const SizedBox(height: 20),
                    const Text(
                      "* Respective ETFs have management fee. INF has management fee of 0.2%",
                      style: TextStyle(
                        color: Colors.redAccent,
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const Text(
                      "* Past performance does not guarantee future results.",
                      style: TextStyle(
                        color: Colors.redAccent,
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class LegendItem extends StatelessWidget {
  final Color? color;
  final Gradient? gradient;
  final String label;

  const LegendItem({super.key, this.color, this.gradient, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 10,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: color,
            gradient: gradient,
          ),
        ),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 10)),
      ],
    );
  }
}
