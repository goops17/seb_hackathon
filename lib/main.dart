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
  ValueNotifier<InvestmentInfo>? infoNotifier;

  @override
  void initState() {
    super.initState();
    _checkProfile();
  }

  Future<void> _checkProfile() async {
    final info = await InvestmentDatabase.read();
    setState(() {
      hasProfile = info != null;
      isLoading = false;
      if (info != null) infoNotifier = ValueNotifier(info);
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
              ? InvestmentChartScreen(infoNotifier: infoNotifier!)
              : const InvestmentLoginFlow(),
    );
  }
}

class InvestmentChartScreen extends StatefulWidget {
  final ValueNotifier<InvestmentInfo> infoNotifier;
  const InvestmentChartScreen({super.key, required this.infoNotifier});

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

  Future<void> _openSettingsDialog() async {
    final info = widget.infoNotifier.value;
    String genderValue = info.isMale ? 'Male' : 'Female';

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setInnerState) {
            return AlertDialog(
              title: const Text('Settings'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('👤 Name: ${info.userName}'),
                  const SizedBox(height: 16),
                  const Text('Gender:'),
                  const SizedBox(height: 4),
                  DropdownButton<String>(
                    value: genderValue,
                    items:
                        ['Male', 'Female']
                            .map(
                              (gender) => DropdownMenuItem(
                                value: gender,
                                child: Text(gender),
                              ),
                            )
                            .toList(),
                    onChanged: (value) async {
                      setInnerState(() => genderValue = value!);
                      await info.update(isMale: value == "Male");
                      widget.infoNotifier.value = info.copyWith();
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                TextButton(
                  style: TextButton.styleFrom(foregroundColor: Colors.red),
                  child: const Text('Delete Records'),
                  onPressed: () async {
                    await InvestmentDatabase.delete();
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Investment Projection'),
        leading: IconButton(
          icon: const Icon(Icons.settings),
          tooltip: 'Settings',
          onPressed: _openSettingsDialog,
        ),
        actions: [
          Row(
            children: [
              Switch(
                value: showChart,
                activeColor: Colors.green,
                activeTrackColor: Colors.greenAccent,
                onChanged: (value) {
                  setState(() {
                    showChart = value;
                  });
                },
              ),
            ],
          ),
        ],
      ),
      body: ValueListenableBuilder<InvestmentInfo>(
        valueListenable: widget.infoNotifier,
        builder: (context, info, _) {
          return InvestmentDashboard(
            investmentInfo: info,
            showChart: showChart,
            onToggleChart: _toggleView,
          );
        },
      ),
    );
  }
}
