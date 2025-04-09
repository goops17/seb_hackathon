import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:seb_hackaton/utils/info/investment_info.dart';
import 'dart:math';

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

  String _formatCurrency(double amount) =>
      "\$${(amount / 1000).toStringAsFixed(0)}K";

  @override
  Widget build(BuildContext context) {
    final oneTime = _calculateOneTimeInvestment();
    final monthly = _calculateMonthlyContributions();

    final double endValueOneTime = oneTime.last.y * 1000;
    final double endValueMonthly = monthly.last.y * 1000;
    final double maxChartY =
        [...oneTime, ...monthly].map((e) => e.y).reduce(max) * 1.1;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 380),
        child: Card(
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          color: const Color(0xFFF7FDF7), // Light SEB background
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Investment Projection",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF006734), // SEB green
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 12,
                  runSpacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Icon(Icons.savings, color: Color(0xFF006734), size: 20),
                    Text(
                      "Initial Investment: \$${widget.investmentInfo.initialAmount.toStringAsFixed(2)}",
                    ),
                    SizedBox(height: 20),
                    Icon(Icons.trending_up, color: Color(0xFF006734), size: 20),
                    Text(
                      "Monthly Contribution: \$${widget.investmentInfo.monthlyContribution.toStringAsFixed(2)}",
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
                                "${spot.barIndex == 0 ? "One-time" : "Monthly"}: \$${value}K",
                                const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF006734),
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
                                '\$$formatted',
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
                          color: const Color(0xFF88C891),
                          barWidth: 4,
                          isStrokeCapRound: true,
                          belowBarData: BarAreaData(
                            show: true,
                            color: const Color(0xFF88C891).withOpacity(0.2),
                          ),
                          dotData: FlDotData(show: false),
                        ),
                        LineChartBarData(
                          spots: monthly,
                          isCurved: true,
                          gradient: const LinearGradient(
                            colors: [Color(0xFF006734), Color(0xFF88C891)],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          barWidth: 4,
                          isStrokeCapRound: true,
                          belowBarData: BarAreaData(
                            show: true,
                            gradient: LinearGradient(
                              colors: [
                                const Color(0xFF006734).withOpacity(0.3),
                                const Color(0xFF88C891).withOpacity(0.1),
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
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
                  children: const [
                    LegendItem(
                      color: Color(0xFF88C891),
                      label: "One-Time Contributions",
                    ),
                    SizedBox(width: 16),
                    LegendItem(
                      gradient: LinearGradient(
                        colors: [Color(0xFF006734), Color(0xFF88C891)],
                      ),
                      label: "Monthly Contributions",
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  "30Y One-Time: ${_formatCurrency(endValueOneTime)} | With Contributions: ${_formatCurrency(endValueMonthly)}",
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Color(0xFF006734),
                  ),
                ),
                const SizedBox(height: 14),
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
