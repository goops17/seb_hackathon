import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:seb_hackaton/utils/info/investment_info.dart';

class InvestmentSetting extends StatefulWidget {
  final InvestmentInfo investmentInfo;

  const InvestmentSetting({super.key, required this.investmentInfo});

  @override
  _InvestmentSettingState createState() => _InvestmentSettingState();
}

class _InvestmentSettingState extends State<InvestmentSetting> {
  bool saveChangeEnabled = false;
  String selectedPeriod = "None";
  final TextEditingController amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadDataFromInfo();
  }

  void _loadDataFromInfo() {
    final info = widget.investmentInfo;
    saveChangeEnabled = info.monthlyContribution >= 50;
    selectedPeriod = info.monthlyContribution > 0 ? "Monthly" : "None";
    amountController.text = info.monthlyContribution.toStringAsFixed(0);
  }

  Future<void> _saveRecurringInvestment() async {
    double amount = double.tryParse(amountController.text.trim()) ?? 0.0;
    await widget.investmentInfo.update(monthlyContribution: amount);
    if (mounted) setState(() {});
  }

  Future<void> _saveOneTimeInvestment() async {
    double amount = double.tryParse(amountController.text.trim()) ?? 0.0;
    await widget.investmentInfo.update(
      initialAmount: widget.investmentInfo.initialAmount + amount,
    );
    if (mounted) setState(() {});
  }

  void _showWithdrawOptions(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder:
          (BuildContext context) => CupertinoActionSheet(
            title: const Text("Withdraw Options"),
            message: const Text("This will reduce your initial investment."),
            actions: [
              _buildWithdrawAction(
                context,
                "Instant Withdraw (0.5 EUR charge)",
              ),
              _buildWithdrawAction(context, "Slow Withdraw (takes 1 week)"),
            ],
            cancelButton: CupertinoActionSheetAction(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
          ),
    );
  }

  CupertinoActionSheetAction _buildWithdrawAction(
    BuildContext parentContext,
    String title,
  ) {
    return CupertinoActionSheetAction(
      onPressed: () async {
        HapticFeedback.heavyImpact();
        double amount = double.tryParse(amountController.text.trim()) ?? 0.0;
        double current = widget.investmentInfo.initialAmount;
        double updatedAmount = current - amount;

        print("before withdrawing: $current");

        if (updatedAmount < 0) {
          Navigator.pop(parentContext);
          Future.delayed(const Duration(milliseconds: 100), () {
            if (mounted) {
              ScaffoldMessenger.of(parentContext).showSnackBar(
                const SnackBar(
                  content: Text("Insufficient balance to withdraw"),
                ),
              );
            }
          });
          return;
        }

        await widget.investmentInfo.update(initialAmount: updatedAmount);
        print("after withdrawing: $updatedAmount");

        if (mounted) setState(() {});
        Navigator.pop(parentContext);
      },
      child: Text(title),
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
            _buildSaveChangeSwitch(),
            const SizedBox(height: 20),
            _buildRecurringInvestmentCard(),
            const SizedBox(height: 20),
            _buildOneTimeInvestmentButton(),
            const SizedBox(height: 20),
            _buildWithdrawButton(),
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

  Widget _buildSaveChangeSwitch() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.green[200]!, width: 1),
      ),
      child: Row(
        children: [
          const Icon(Icons.monetization_on, color: Colors.green, size: 28),
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
              if (mounted) setState(() => saveChangeEnabled = value);
              await widget.investmentInfo.update(
                monthlyContribution: value ? 50.0 : 0.0,
              );
            },
            activeColor: Colors.green,
          ),
        ],
      ),
    );
  }

  Widget _buildRecurringInvestmentCard() {
    return Container(
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
              const Icon(Icons.calendar_today, color: Colors.blue, size: 28),
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
                child: DropdownButtonFormField<String>(
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
                      ["Monthly", "Weekly", "None"].map((String period) {
                        return DropdownMenuItem(
                          value: period,
                          child: Text(period),
                        );
                      }).toList(),
                  onChanged: (value) async {
                    HapticFeedback.heavyImpact();
                    if (mounted) setState(() => selectedPeriod = value!);
                    await _saveRecurringInvestment();
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: amountController,
                  decoration: InputDecoration(
                    labelText: "Amount",
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOneTimeInvestmentButton() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Colors.deepPurple, Colors.purple],
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
          Future.delayed(const Duration(milliseconds: 100), () {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('One-time investment saved')),
              );
            }
          });
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
    );
  }

  Widget _buildWithdrawButton() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(colors: [Colors.red, Colors.orange]),
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
          HapticFeedback.heavyImpact();
          Navigator.pop(context);
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
    );
  }
}
