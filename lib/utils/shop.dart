import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:seb_hackaton/utils/info/investment_info.dart';

class InvestmentShop extends StatefulWidget {
  final InvestmentInfo investmentInfo;

  const InvestmentShop({super.key, required this.investmentInfo});

  @override
  State<InvestmentShop> createState() => _InvestmentShopState();
}

class _InvestmentShopState extends State<InvestmentShop> {
  void _buyItem(String item, double cost) async {
    HapticFeedback.heavyImpact();
    double current = widget.investmentInfo.initialAmount;

    if (current < cost) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Not enough funds to buy $item")));
      return;
    }

    // Prepare updated values
    bool hasPet = widget.investmentInfo.hasPet;
    bool hasCar = widget.investmentInfo.hasCar;
    bool hasHouse = widget.investmentInfo.hasHouse;
    bool hasTravel = widget.investmentInfo.hasTravel;

    double petAmount = widget.investmentInfo.petAmount;
    double carAmount = widget.investmentInfo.carAmount;
    double travelAmount = widget.investmentInfo.travelAmount;
    double houseAmount = widget.investmentInfo.houseAmount;

    if (item == "Pet") {
      hasPet = true;
      petAmount += cost;
    } else if (item == "Car") {
      hasCar = true;
      carAmount += cost;
    } else if (item == "Travel") {
      hasTravel = true;
      travelAmount += cost;
    } else if (item == "House") {
      hasHouse = true;
      houseAmount += cost;
    }

    await widget.investmentInfo.update(
      hasPet: hasPet,
      hasCar: hasCar,
      hasHouse: hasHouse,
      hasTravel: hasTravel,
      petAmount: petAmount,
      carAmount: carAmount,
      travelAmount: travelAmount,
      houseAmount: houseAmount,
    );

    if (mounted) setState(() {});

    Navigator.of(context).pop();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("You bought a $item! 🎉")));
  }

  Widget _buildShopItem(String name, double cost, String iconPath) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        leading: Image.asset(iconPath, width: 40, height: 40),
        title: Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text("Buy $name for \$$cost/m"),
        trailing: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: () => _buyItem(name, cost),
          child: const Text("Buy"),
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
          "Shop",
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
            _buildShopItem("Pet", 20, 'lib/assets/icons/pet.png'),
            _buildShopItem("Travel", 50, 'lib/assets/icons/travel.png'),
            _buildShopItem("House", 200, 'lib/assets/icons/house.png'),
            _buildShopItem("Car", 100, 'lib/assets/icons/car.png'),
            const SizedBox(height: 12),
            Text(
              "Disclaimer: These are future lifestyle goals represented as investment targets (not physical goods).",
              style: TextStyle(fontSize: 12, color: Colors.red[700]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
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
