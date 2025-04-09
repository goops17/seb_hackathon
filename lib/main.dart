import 'package:flutter/material.dart';
import 'package:seb_hackaton/utils/charts.dart';

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
  bool showChart = true;

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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child:
            showChart
                ? const InvestmentChart()
                : const Placeholder(
                  fallbackHeight: 300,
                  fallbackWidth: double.infinity,
                  color: Colors.green,
                ),
      ),
    );
  }
}
