import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  String investmentHistory = '';
  String riskTolerance = '';
  double initialDeposit = 0;

  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final depositController = TextEditingController();

  int currentPage = 0;

  void _nextPage() {
    if (_controller.page!.round() < 4) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    } else {
      _submitData();
    }
  }

  void _previousPage() {
    if (_controller.page!.round() > 0) {
      _controller.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    }
  }

  Future<void> _submitData() async {
    final info = InvestmentInfo(
      userName: userName,
      udid: const Uuid().v4(),
      initialAmount: initialDeposit,
      futurePredictedAmount: 0,
      growthRate: 0.07,
      monthlyContribution: 0,
      oneTimeContribution: initialDeposit,
      isMale: false,
      hasCar: false,
      hasPet: false,
      hasHouse: false,
      hasTravel: false,
      travelAmount: 0,
      houseAmount: 0,
      petAmount: 0,
      carAmount: 0,
    );
    await InvestmentDatabase.create(info);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Investment Profile Saved!")));
    Navigator.pop(context);
  }

  Widget _buildPage({required String title, required Widget child}) {
    return Scaffold(
      backgroundColor: CupertinoColors.activeOrange,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 40),
              child,
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (currentPage > 0)
                    IconButton(
                      onPressed: _previousPage,
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                      ),
                    ),
                  ElevatedButton(
                    onPressed: _nextPage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(currentPage < 4 ? 'Next' : 'Submit'),
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
            title: 'What\'s your name?',
            child: TextField(
              controller: nameController,
              onChanged: (value) => userName = value,
              decoration: const InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Enter your name',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          _buildPage(
            title: 'How old are you?',
            child: TextField(
              controller: ageController,
              keyboardType: TextInputType.number,
              onChanged: (value) => age = int.tryParse(value) ?? 18,
              decoration: const InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Enter your age',
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
                fillColor: Colors.white,
                border: OutlineInputBorder(),
              ),
            ),
          ),
          _buildPage(
            title: 'What\'s your risk tolerance?',
            child: DropdownButtonFormField<String>(
              value: riskTolerance.isNotEmpty ? riskTolerance : null,
              items:
                  ['Low', 'Medium', 'High']
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
              onChanged: (value) => setState(() => riskTolerance = value ?? ''),
              decoration: const InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(),
              ),
            ),
          ),
          _buildPage(
            title: 'Initial deposit amount?',
            child: TextField(
              controller: depositController,
              keyboardType: TextInputType.number,
              onChanged:
                  (value) => initialDeposit = double.tryParse(value) ?? 0.0,
              decoration: const InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: '\$0.00',
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
