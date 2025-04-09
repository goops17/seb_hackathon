import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:seb_hackaton/utils/databse/investment_database.dart';
import 'package:seb_hackaton/utils/info/investment_info.dart';

class InvestmentSetting extends StatefulWidget {
  @override
  _InvestmentSettingState createState() => _InvestmentSettingState();
}

class _InvestmentSettingState extends State<InvestmentSetting> {
  bool saveChangeEnabled = false;
  String selectedPeriod = "None";
  TextEditingController recurringAmountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadInvestmentInfo();
  }

  Future<void> _loadInvestmentInfo() async {
    final info = await InvestmentDatabase.read();
    if (info != null) {
      setState(() {
        saveChangeEnabled = info.monthlyContribution > 0;
        selectedPeriod = info.monthlyContribution > 0 ? "Monthly" : "None";
        recurringAmountController.text = info.monthlyContribution
            .toStringAsFixed(0);
      });
    }
  }

  Future<void> _saveRecurringInvestment() async {
    final info =
        await InvestmentDatabase.read() ??
        InvestmentInfo(
          userId: "user",
          udid: "device123",
          initialAmount: 0,
          futurePredictedAmount: 0,
          growthRate: 0.07,
          monthlyContribution: 0,
          oneTimeContribution: 0,
        );

    double amount =
        double.tryParse(recurringAmountController.text.trim()) ?? 0.0;

    await info.update(
      monthlyContribution: selectedPeriod == "None" ? 0.0 : amount,
    );
  }

  Future<void> _saveOneTimeInvestment() async {
    final info =
        await InvestmentDatabase.read() ??
        InvestmentInfo(
          userId: "user",
          udid: "device123",
          initialAmount: 0,
          futurePredictedAmount: 0,
          growthRate: 0.07,
          monthlyContribution: 0,
          oneTimeContribution: 0,
        );

    await info.update(oneTimeContribution: 500); // or get from user input
  }

  void _showWithdrawOptions(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder:
          (BuildContext context) => CupertinoActionSheet(
            title: const Text("Withdraw Options"),
            actions: [
              CupertinoActionSheetAction(
                onPressed: () {
                  HapticFeedback.heavyImpact();
                  Navigator.pop(context);
                  // Add logic if needed
                },
                child: const Text("Instant Withdraw (0.5 EUR charge)"),
              ),
              CupertinoActionSheetAction(
                onPressed: () {
                  HapticFeedback.heavyImpact();
                  Navigator.pop(context);
                  // Add logic if needed
                },
                child: const Text("Slow Withdraw (takes 1 week)"),
              ),
            ],
            cancelButton: CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Center(
        child: Text(
          "Investment Options",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.deepPurple,
          ),
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Save the Change
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.green[200]!, width: 1),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.monetization_on,
                    color: Colors.green,
                    size: 28,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Save the Change",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.green[800],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Automatically invest spare change from your purchases.",
                          style: TextStyle(color: Colors.green[700]),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: saveChangeEnabled,
                    onChanged: (value) async {
                      HapticFeedback.heavyImpact();
                      setState(() => saveChangeEnabled = value);

                      final info =
                          await InvestmentDatabase.read() ??
                          InvestmentInfo(
                            userId: "user",
                            udid: "device123",
                            initialAmount: 0,
                            futurePredictedAmount: 0,
                            growthRate: 0.07,
                            monthlyContribution: 0,
                            oneTimeContribution: 0,
                          );
                      await info.update(
                        monthlyContribution: value ? 50.0 : 0.0,
                      );
                    },
                    activeColor: Colors.green,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Recurring Investment
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.blue[200]!, width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today,
                        color: Colors.blue,
                        size: 28,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "Recurring Investment",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.blue[800],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Investment Period"),
                            const SizedBox(height: 5),
                            DropdownButtonFormField<String>(
                              value: selectedPeriod,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 5,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              items:
                                  ["Monthly", "Weekly", "None"].map((
                                    String period,
                                  ) {
                                    return DropdownMenuItem(
                                      value: period,
                                      child: Text(period),
                                    );
                                  }).toList(),
                              onChanged: (value) async {
                                HapticFeedback.heavyImpact();
                                setState(() => selectedPeriod = value!);
                                await _saveRecurringInvestment();
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Investment Amount"),
                            const SizedBox(height: 5),
                            TextField(
                              controller: recurringAmountController,
                              onChanged: (value) => _saveRecurringInvestment(),
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 5,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                hintText: "\$",
                              ),
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // One-Time Investment Button
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(
                  colors: [Colors.deepPurple, Colors.purple],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                onPressed: () async {
                  HapticFeedback.heavyImpact();
                  Navigator.pop(context);
                  await _saveOneTimeInvestment();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('One-time investment saved')),
                  );
                },
                child: const Text(
                  "One-Time Investment",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Withdraw Button
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(
                  colors: [Colors.red, Colors.orange],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  HapticFeedback.heavyImpact();
                  _showWithdrawOptions(context);
                },
                child: const Text(
                  "Withdraw",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        TextButton(
          onPressed: () {
            HapticFeedback.heavyImpact();
            Navigator.of(context).pop();
          },
          child: const Text(
            "Close",
            style: TextStyle(
              color: Colors.deepPurple,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
