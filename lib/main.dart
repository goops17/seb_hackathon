import 'package:flutter/material.dart';
import 'package:seb_hackaton/utils/charts.dart';
import 'package:seb_hackaton/utils/circular_button.dart';
import 'package:seb_hackaton/utils/settings.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Investment Chart Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: const Color(0xFFEFFAF0),
      ),
      home: const InvestmentChartScreen(),
    );
  }
}

class InvestmentChartScreen extends StatefulWidget {
  const InvestmentChartScreen({super.key});

  @override
  State<InvestmentChartScreen> createState() => _InvestmentChartScreenState();
}

class _InvestmentChartScreenState extends State<InvestmentChartScreen> {
  bool showChart = false;

  void _toggleView() {
    setState(() {
      showChart = !showChart;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Investment Projection'),
        actions: [
          IconButton(
            icon: Icon(showChart ? Icons.swap_horiz : Icons.show_chart),
            tooltip: 'Toggle View',
            onPressed: _toggleView,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child:
                  showChart
                      ? const InvestmentChart()
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
                        return InvestmentSetting();
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
      ),
    );
  }
}
