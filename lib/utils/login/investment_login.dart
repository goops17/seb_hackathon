import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:seb_hackaton/main.dart';
import 'package:seb_hackaton/utils/databse/investment_database.dart';
import 'package:seb_hackaton/utils/info/investment_info.dart';
import 'package:uuid/uuid.dart';

class InvestmentLoginFlow extends StatefulWidget {
  const InvestmentLoginFlow({super.key});

  @override
  State<InvestmentLoginFlow> createState() => _InvestmentLoginFlowState();
}

class _InvestmentLoginFlowState extends State<InvestmentLoginFlow> {
  final PageController _controller = PageController();
  String userName = '';
  int age = 18;
  String gender = 'Male';
  String investmentHistory = '';
  String riskTolerance = '';
  double initialDeposit = 20000;

  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final depositController = TextEditingController();

  int currentPage = 0;

  void _nextPage() {
    if (_controller.page!.round() < 5) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _submitData();
    }
  }

  void _previousPage() {
    if (_controller.page!.round() > 0) {
      _controller.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _submitData() async {
    final info = InvestmentInfo(
      userName: userName,
      udid: const Uuid().v4(),
      initialAmount: 20000,
      futurePredictedAmount: 0,
      growthRate: 0.07,
      monthlyContribution: 0,
      oneTimeContribution: initialDeposit,
      isMale: gender == 'Male',
      hasCar: false,
      hasPet: false,
      hasHouse: false,
      hasTravel: false,
      travelAmount: 0,
      houseAmount: 0,
      petAmount: 0,
      carAmount: 0,
    );
    print("update login: initial amount: ${info.initialAmount}");
    await InvestmentDatabase.create(info);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Investment Profile Saved!")));

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const MyApp()),
    );
  }

  Widget _buildPage({required String title, required Widget child}) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 30),
              Expanded(child: child),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (currentPage > 0)
                    TextButton.icon(
                      onPressed: _previousPage,
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.black,
                      ),
                      label: const Text(
                        "Back",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ElevatedButton(
                    onPressed: _nextPage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                    child: Text(currentPage < 5 ? 'Next' : 'Finish'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    ageController.dispose();
    depositController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _controller,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (index) => setState(() => currentPage = index),
        children: [
          _buildPage(
            title: 'What’s your name?',
            child: TextField(
              controller: nameController,
              onChanged: (value) => userName = value,
              decoration: const InputDecoration(
                hintText: 'Enter your name',
                filled: true,
                fillColor: Color(0xFFF4F4F4),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          _buildPage(
            title: 'What’s your age?',
            child: TextField(
              controller: ageController,
              keyboardType: TextInputType.number,
              onChanged: (value) => age = int.tryParse(value) ?? 18,
              decoration: const InputDecoration(
                hintText: 'Enter your age',
                filled: true,
                fillColor: Color(0xFFF4F4F4),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          _buildPage(
            title: 'What’s your gender?',
            child: DropdownButtonFormField<String>(
              value: gender,
              items:
                  ['Male', 'Female', 'Other']
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
              onChanged: (value) => setState(() => gender = value ?? 'Male'),
              decoration: const InputDecoration(
                filled: true,
                fillColor: Color(0xFFF4F4F4),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          _buildPage(
            title: 'Any investment experience?',
            child: DropdownButtonFormField<String>(
              value: investmentHistory.isNotEmpty ? investmentHistory : null,
              items:
                  ['None', 'Some', 'Extensive']
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
              onChanged:
                  (value) => setState(() => investmentHistory = value ?? ''),
              decoration: const InputDecoration(
                filled: true,
                fillColor: Color(0xFFF4F4F4),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          _buildPage(
            title: 'What’s your risk tolerance?',
            child: DropdownButtonFormField<String>(
              value: riskTolerance.isNotEmpty ? riskTolerance : null,
              items:
                  ['Low', 'Medium', 'High']
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
              onChanged: (value) => setState(() => riskTolerance = value ?? ''),
              decoration: const InputDecoration(
                filled: true,
                fillColor: Color(0xFFF4F4F4),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          _buildPage(
            title: 'How much do you want to invest initially?',
            child: TextField(
              controller: depositController,
              keyboardType: TextInputType.number,
              onChanged:
                  (value) => initialDeposit = double.tryParse(value) ?? 0.0,
              decoration: const InputDecoration(
                hintText: '\$0.00',
                filled: true,
                fillColor: Color(0xFFF4F4F4),
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
