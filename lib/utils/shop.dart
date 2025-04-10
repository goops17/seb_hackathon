import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:seb_hackaton/utils/transaction_overlay.dart';
import 'package:seb_hackaton/utils/info/investment_info.dart';

class InvestmentShop extends StatefulWidget {
  final InvestmentInfo investmentInfo;

  const InvestmentShop({super.key, required this.investmentInfo});

  @override
  State<InvestmentShop> createState() => _InvestmentShopState();
}

class _InvestmentShopState extends State<InvestmentShop> {
  void _showTransactionOverlay(bool isBuying) {
    final overlay = Overlay.of(context);
    final entry = OverlayEntry(
      builder: (_) => TransactionOverlay(isBuying: isBuying),
    );
    overlay.insert(entry);
    Future.delayed(const Duration(seconds: 2), () {
      entry.remove();
    });
  }

  void _toggleItem(String item, double cost, bool isOwned) async {
    HapticFeedback.heavyImpact();
    double current = widget.investmentInfo.initialAmount;

    bool hasPet = widget.investmentInfo.hasPet;
    bool hasCar = widget.investmentInfo.hasCar;
    bool hasHouse = widget.investmentInfo.hasHouse;
    bool hasTravel = widget.investmentInfo.hasTravel;

    double petAmount = widget.investmentInfo.petAmount;
    double carAmount = widget.investmentInfo.carAmount;
    double travelAmount = widget.investmentInfo.travelAmount;
    double houseAmount = widget.investmentInfo.houseAmount;

    double refund = 0;

    if (item == "Pet") {
      if (isOwned) refund = petAmount;
      hasPet = !isOwned;
      petAmount = isOwned ? 0 : cost;
    } else if (item == "Car") {
      if (isOwned) refund = carAmount;
      hasCar = !isOwned;
      carAmount = isOwned ? 0 : cost;
    } else if (item == "Travel") {
      if (isOwned) refund = travelAmount;
      hasTravel = !isOwned;
      travelAmount = isOwned ? 0 : cost;
    } else if (item == "House") {
      if (isOwned) refund = houseAmount;
      hasHouse = !isOwned;
      houseAmount = isOwned ? 0 : cost;
    }

    if (!isOwned && current < cost) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Not enough funds to buy \$item")));
      return;
    }

    _showTransactionOverlay(!isOwned);

    double updatedAmount = isOwned ? current + refund : current - cost;

    await widget.investmentInfo.update(
      initialAmount: updatedAmount,
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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isOwned ? "You sold your $item." : "You bought a $item! 🎉",
        ),
      ),
    );
  }

  Widget _buildShopItem(String name, double cost, String iconPath) {
    bool isOwned = false;
    if (name == "Pet") isOwned = widget.investmentInfo.hasPet;
    if (name == "Car") isOwned = widget.investmentInfo.hasCar;
    if (name == "Travel") isOwned = widget.investmentInfo.hasTravel;
    if (name == "House") isOwned = widget.investmentInfo.hasHouse;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        leading: Image.asset(iconPath, width: 40, height: 40),
        title: Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text("${isOwned ? "Sell" : "Buy"} \$name for \\$cost"),
        trailing: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: isOwned ? Colors.red : Colors.deepPurple,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: () => _toggleItem(name, cost, isOwned),
          child: Text(isOwned ? "Sell" : "Buy"),
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
