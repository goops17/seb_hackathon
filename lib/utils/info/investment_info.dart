import 'package:seb_hackaton/utils/databse/investment_database.dart';

class InvestmentInfo {
  String userName;
  String udid;
  double initialAmount;
  double futurePredictedAmount;
  double growthRate;
  double monthlyContribution;
  double oneTimeContribution;
  bool hasPet;
  bool hasCar;
  bool isMale;
  bool hasHouse;
  bool hasTravel;
  double travelAmount;
  double houseAmount;
  double petAmount;
  double carAmount;

  InvestmentInfo({
    required this.userName,
    required this.udid,
    required this.initialAmount,
    required this.futurePredictedAmount,
    required this.growthRate,
    required this.monthlyContribution,
    required this.oneTimeContribution,
    required this.hasPet,
    required this.hasCar,
    required this.isMale,
    required this.hasHouse,
    required this.hasTravel,
    required this.travelAmount,
    required this.houseAmount,
    required this.petAmount,
    required this.carAmount,
  });

  InvestmentInfo copyWith({
    String? userName,
    String? udid,
    double? initialAmount,
    double? futurePredictedAmount,
    double? growthRate,
    double? monthlyContribution,
    double? oneTimeContribution,
    bool? hasPet,
    bool? hasCar,
    bool? isMale,
    bool? hasHouse,
    bool? hasTravel,
    double? travelAmount,
    double? houseAmount,
    double? petAmount,
    double? carAmount,
  }) {
    return InvestmentInfo(
      userName: userName ?? this.userName,
      udid: udid ?? this.udid,
      initialAmount: initialAmount ?? this.initialAmount,
      futurePredictedAmount:
          futurePredictedAmount ?? this.futurePredictedAmount,
      growthRate: growthRate ?? this.growthRate,
      monthlyContribution: monthlyContribution ?? this.monthlyContribution,
      oneTimeContribution: oneTimeContribution ?? this.oneTimeContribution,
      hasPet: hasPet ?? this.hasPet,
      hasCar: hasCar ?? this.hasCar,
      isMale: isMale ?? this.isMale,
      hasHouse: hasHouse ?? this.hasHouse,
      hasTravel: hasTravel ?? this.hasTravel,
      travelAmount: travelAmount ?? this.travelAmount,
      houseAmount: houseAmount ?? this.houseAmount,
      petAmount: petAmount ?? this.petAmount,
      carAmount: carAmount ?? this.carAmount,
    );
  }

  Future<void> replace(InvestmentInfo newInfo) async {
    userName = newInfo.userName;
    udid = newInfo.udid;
    initialAmount = newInfo.initialAmount;
    futurePredictedAmount = newInfo.futurePredictedAmount;
    growthRate = newInfo.growthRate;
    monthlyContribution = newInfo.monthlyContribution;
    oneTimeContribution = newInfo.oneTimeContribution;
    hasPet = newInfo.hasPet;
    hasCar = newInfo.hasCar;
    isMale = newInfo.isMale;
    hasHouse = newInfo.hasHouse;
    hasTravel = newInfo.hasTravel;
    travelAmount = newInfo.travelAmount;
    houseAmount = newInfo.houseAmount;
    petAmount = newInfo.petAmount;
    carAmount = newInfo.carAmount;

    await InvestmentDatabase.update(this);
  }

  Future<InvestmentInfo> update({
    String? userName,
    String? udid,
    double? initialAmount,
    double? futurePredictedAmount,
    double? growthRate,
    double? monthlyContribution,
    double? oneTimeContribution,
    bool? hasPet,
    bool? hasCar,
    bool? isMale,
    bool? hasHouse,
    bool? hasTravel,
    double? travelAmount,
    double? houseAmount,
    double? petAmount,
    double? carAmount,
  }) async {
    this.userName = userName ?? this.userName;
    this.udid = udid ?? this.udid;
    this.initialAmount = initialAmount ?? this.initialAmount;
    this.futurePredictedAmount =
        futurePredictedAmount ?? this.futurePredictedAmount;
    this.growthRate = growthRate ?? this.growthRate;
    this.monthlyContribution = monthlyContribution ?? this.monthlyContribution;
    this.oneTimeContribution = oneTimeContribution ?? this.oneTimeContribution;
    this.hasPet = hasPet ?? this.hasPet;
    this.hasCar = hasCar ?? this.hasCar;
    this.isMale = isMale ?? this.isMale;
    this.hasHouse = hasHouse ?? this.hasHouse;
    this.hasTravel = hasTravel ?? this.hasTravel;
    this.travelAmount = travelAmount ?? this.travelAmount;
    this.houseAmount = houseAmount ?? this.houseAmount;
    this.petAmount = petAmount ?? this.petAmount;
    this.carAmount = carAmount ?? this.carAmount;

    final updatedInstance = copyWith(
      userName: userName,
      udid: udid,
      initialAmount: initialAmount,
      futurePredictedAmount: futurePredictedAmount,
      growthRate: growthRate,
      monthlyContribution: monthlyContribution,
      oneTimeContribution: oneTimeContribution,
      hasPet: hasPet,
      hasCar: hasCar,
      isMale: isMale,
      hasHouse: hasHouse,
      hasTravel: hasTravel,
      travelAmount: travelAmount,
      houseAmount: houseAmount,
      petAmount: petAmount,
      carAmount: carAmount,
    );

    await InvestmentDatabase.update(updatedInstance);
    return updatedInstance;
  }

  Map<String, dynamic> toJson() => {
    'userName': userName,
    'udid': udid,
    'initialAmount': initialAmount,
    'futurePredictedAmount': futurePredictedAmount,
    'growthRate': growthRate,
    'monthlyContribution': monthlyContribution,
    'oneTimeContribution': oneTimeContribution,
    'hasPet': hasPet,
    'hasCar': hasCar,
    'isMale': isMale,
    'hasHouse': hasHouse,
    'hasTravel': hasTravel,
    'travelAmount': travelAmount,
    'houseAmount': houseAmount,
    'petAmount': petAmount,
    'carAmount': carAmount,
  };

  factory InvestmentInfo.fromJson(Map<String, dynamic> json) {
    return InvestmentInfo(
      userName: (json['userName'] ?? '') as String,
      udid: (json['udid'] ?? '') as String,
      initialAmount: (json['initialAmount'] ?? 0).toDouble(),
      futurePredictedAmount: (json['futurePredictedAmount'] ?? 0).toDouble(),
      growthRate: (json['growthRate'] ?? 0).toDouble(),
      monthlyContribution: (json['monthlyContribution'] ?? 0).toDouble(),
      oneTimeContribution: (json['oneTimeContribution'] ?? 0).toDouble(),
      hasPet: (json['hasPet'] ?? false) as bool,
      hasCar: (json['hasCar'] ?? false) as bool,
      isMale: (json['isMale'] ?? true) as bool,
      hasHouse: (json['hasHouse'] ?? false) as bool,
      hasTravel: (json['hasTravel'] ?? false) as bool,
      travelAmount: (json['travelAmount'] ?? 0).toDouble(),
      houseAmount: (json['houseAmount'] ?? 0).toDouble(),
      petAmount: (json['petAmount'] ?? 0).toDouble(),
      carAmount: (json['carAmount'] ?? 0).toDouble(),
    );
  }
}
