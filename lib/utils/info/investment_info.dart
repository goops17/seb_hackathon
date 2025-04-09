import 'package:seb_hackaton/utils/databse/investment_database.dart';

class InvestmentInfo {
  String userId;
  String udid;
  double initialAmount;
  double futurePredictedAmount;
  double growthRate;
  double monthlyContribution;
  double oneTimeContribution;

  InvestmentInfo({
    required this.userId,
    required this.udid,
    required this.initialAmount,
    required this.futurePredictedAmount,
    required this.growthRate,
    required this.monthlyContribution,
    required this.oneTimeContribution,
  });

  Future<void> update({
    String? userId,
    String? udid,
    double? initialAmount,
    double? futurePredictedAmount,
    double? growthRate,
    double? monthlyContribution,
    double? oneTimeContribution,
  }) async {
    this.userId = userId ?? this.userId;
    this.udid = udid ?? this.udid;
    this.initialAmount = initialAmount ?? this.initialAmount;
    this.futurePredictedAmount =
        futurePredictedAmount ?? this.futurePredictedAmount;
    this.growthRate = growthRate ?? this.growthRate;
    this.monthlyContribution = monthlyContribution ?? this.monthlyContribution;
    this.oneTimeContribution = oneTimeContribution ?? this.oneTimeContribution;
    await InvestmentDatabase.update(this);
  }

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'udid': udid,
    'initialAmount': initialAmount,
    'futurePredictedAmount': futurePredictedAmount,
    'growthRate': growthRate,
    'monthlyContribution': monthlyContribution,
    'oneTimeContribution': oneTimeContribution,
  };

  factory InvestmentInfo.fromJson(Map<String, dynamic> json) {
    return InvestmentInfo(
      userId: json['userId'],
      udid: json['udid'],
      initialAmount: (json['initialAmount'] ?? 0).toDouble(),
      futurePredictedAmount: (json['futurePredictedAmount'] ?? 0).toDouble(),
      growthRate: (json['growthRate'] ?? 0).toDouble(),
      monthlyContribution: (json['monthlyContribution'] ?? 0).toDouble(),
      oneTimeContribution: (json['oneTimeContribution'] ?? 0).toDouble(),
    );
  }
}
