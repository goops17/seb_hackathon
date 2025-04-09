import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:seb_hackaton/utils/info/investment_info.dart';

class Simulation extends StatefulWidget {
  final InvestmentInfo info;
  final void Function(InvestmentInfo updatedInfo) onUpdate;

  const Simulation({super.key, required this.info, required this.onUpdate});

  @override
  State<Simulation> createState() => _SimulationState();
}

class _SimulationState extends State<Simulation> {
  void _updateInvestment(String category, String action) {
    setState(() {
      switch (category) {
        case 'Overall':
          if (action == 'monthly') {
            widget.info.update(initialAmount: widget.info.initialAmount + 5000);
            widget.info.hasHouse = true;
            widget.info.houseAmount += 2000;
            widget.info.hasPet = true;
            widget.info.petAmount += 500;
            widget.info.hasCar = true;
            widget.info.carAmount += 1000;
            widget.info.hasTravel = true;
            widget.info.travelAmount += 1000;
          } else if (action == 'onetime') {
            widget.info.update(
              initialAmount: widget.info.initialAmount + 10000,
            );
            widget.info.hasHouse = true;
            widget.info.houseAmount += 10000;
            widget.info.hasPet = true;
            widget.info.petAmount += 2000;
            widget.info.hasCar = true;
            widget.info.carAmount += 7000;
            widget.info.hasTravel = true;
            widget.info.travelAmount += 3000;
          } else if (action == 'withdraw') {
            widget.info.update(initialAmount: 0);
            widget.info.houseAmount = 0;
            widget.info.petAmount = 0;
            widget.info.carAmount = 0;
            widget.info.travelAmount = 0;
          } else if (action == 'skip') {
            widget.info.update(
              initialAmount: widget.info.initialAmount - 10000,
            );
            widget.info.houseAmount -= 1000;
            widget.info.petAmount -= 200;
            widget.info.carAmount -= 1500;
            widget.info.travelAmount -= 500;
          }
          break;
        case 'House':
          if (action == 'monthly')
            widget.info.houseAmount += 2000;
          else if (action == 'onetime')
            widget.info.houseAmount += 10000;
          else if (action == 'withdraw')
            widget.info.houseAmount = 0;
          else if (action == 'skip')
            widget.info.houseAmount -= 1000;
          widget.info.hasHouse = true;
          break;
        case 'Pet':
          if (action == 'monthly')
            widget.info.petAmount += 500;
          else if (action == 'onetime')
            widget.info.petAmount += 2000;
          else if (action == 'withdraw')
            widget.info.petAmount = 0;
          else if (action == 'skip')
            widget.info.petAmount -= 200;
          widget.info.hasPet = true;
          break;
        case 'Car':
          if (action == 'monthly')
            widget.info.carAmount += 1000;
          else if (action == 'onetime')
            widget.info.carAmount += 7000;
          else if (action == 'withdraw')
            widget.info.carAmount = 0;
          else if (action == 'skip')
            widget.info.carAmount -= 1500;
          widget.info.hasCar = true;
          break;
        case 'Travel':
          if (action == 'monthly')
            widget.info.travelAmount += 1000;
          else if (action == 'onetime')
            widget.info.travelAmount += 3000;
          else if (action == 'withdraw')
            widget.info.travelAmount = 0;
          else if (action == 'skip')
            widget.info.travelAmount -= 500;
          widget.info.hasTravel = true;
          break;
      }
    });

    HapticFeedback.mediumImpact();
    widget.onUpdate(widget.info);
  }

  Widget _buildRow(String category) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              category,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Wrap(
            spacing: 4,
            runSpacing: 4,
            children: [
              _buildIconButton(
                () => _updateInvestment(category, 'monthly'),
                color: Colors.green.shade600,
              ),
              _buildIconButton(
                () => _updateInvestment(category, 'onetime'),
                color: Colors.green.shade400,
              ),
              _buildIconButton(
                () => _updateInvestment(category, 'withdraw'),
                color: Colors.red,
              ),
              if ([
                'Overall',
                'House',
                'Pet',
                'Car',
                'Travel',
              ].contains(category))
                _buildIconButton(
                  () => _updateInvestment(category, 'skip'),
                  color: Colors.amber,
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _legendBox(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 16, height: 16, color: color),
        const SizedBox(width: 4),
        Text(label, style: TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _buildIconButton(VoidCallback onPressed, {Color? color}) {
    return SizedBox(
      width: 30,
      height: 30,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          backgroundColor: color ?? Colors.green.shade700,
          foregroundColor: Colors.white,
        ),
        child: const SizedBox.shrink(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Center(
        child: Text(
          'Simulate Scenarios',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Expanded(
                  child: Text(
                    "Category",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Row(
                  children: [
                    Icon(Icons.calendar_view_month, size: 16),
                    SizedBox(width: 4),
                    Icon(Icons.attach_money, size: 16),
                    SizedBox(width: 4),
                    Icon(Icons.remove_circle, size: 16),
                    SizedBox(width: 4),
                    Icon(Icons.skip_next, size: 16),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Legend
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Wrap(
                spacing: 8,
                runSpacing: 4,
                children: [
                  _legendBox(Colors.green.shade600, 'Monthly'),
                  _legendBox(Colors.green.shade400, 'Onetime'),
                  _legendBox(Colors.red, 'Withdraw'),
                  _legendBox(Colors.amber, 'Skip'),
                ],
              ),
            ),

            _buildRow('Overall'),
            _buildRow('House'),
            _buildRow('Pet'),
            _buildRow('Car'),
            _buildRow('Travel'),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close', style: TextStyle(color: Colors.green)),
        ),
      ],
    );
  }
}

void openSimulationDialog(
  BuildContext context,
  InvestmentInfo info,
  final void Function(InvestmentInfo updatedInfo) onUpdate,
) {
  showDialog(
    context: context,
    builder: (_) => Simulation(info: info, onUpdate: onUpdate),
  );
}
