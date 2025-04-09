import 'package:flutter/material.dart';
import 'package:seb_hackaton/utils/dashboard/investment_dashboard.dart';
import 'package:seb_hackaton/utils/info/investment_info.dart';
import 'package:seb_hackaton/utils/login/investment_login.dart';
import 'package:seb_hackaton/utils/databse/investment_database.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLoading = true;
  bool hasProfile = false;
  InvestmentInfo? info;

  @override
  void initState() {
    super.initState();
    _checkProfile();
  }

  Future<void> _checkProfile() async {
    info = await InvestmentDatabase.read();
    setState(() {
      hasProfile = info != null;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Investment Chart Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: const Color(0xFFEFFAF0),
      ),
      home:
          isLoading
              ? const Scaffold(body: Center(child: CircularProgressIndicator()))
              : hasProfile
              ? InvestmentChartScreen(info: info!)
              : const InvestmentLoginFlow(),
    );
  }
}

class InvestmentChartScreen extends StatefulWidget {
  final InvestmentInfo info;
  const InvestmentChartScreen({super.key, required this.info});

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
        leading: IconButton(
          icon: const Icon(Icons.settings),
          tooltip: 'Settings',
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Settings'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('👤 Name: ${widget.info.userName}'),
                      const SizedBox(height: 16),
                      const Text(
                        'You can delete all investment records below:',
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      child: const Text('Cancel'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      style: TextButton.styleFrom(foregroundColor: Colors.red),
                      child: const Text('Delete Records'),
                      onPressed: () async {
                        InvestmentDatabase.delete();
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('All investment records deleted'),
                          ),
                        );
                      },
                    ),
                  ],
                );
              },
            );
          },
        ),
        actions: [
          IconButton(
            icon: Icon(showChart ? Icons.swap_horiz : Icons.show_chart),
            tooltip: 'Toggle View',
            onPressed: _toggleView,
          ),
        ],
      ),
      body: InvestmentDashboard(
        investmentInfo: widget.info,
        showChart: showChart,
        onToggleChart: _toggleView,
      ),
    );
  }
}
