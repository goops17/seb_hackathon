import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InvestmentShare extends StatelessWidget {
  const InvestmentShare({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Center(
        child: Text(
          "Share Your Journey",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.deepPurple,
          ),
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          children: [
            const Text(
              "Let your friends know how you're growing your wealth!",
              style: TextStyle(fontSize: 14, color: Colors.black87),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              alignment: WrapAlignment.center,
              children: [
                _buildSocialIcon(
                  context,
                  Icons.facebook,
                  "Facebook",
                  Colors.blue,
                ),
                _buildSocialIcon(
                  context,
                  Icons.camera_alt,
                  "Instagram",
                  Colors.purple,
                ),
                _buildSocialIcon(
                  context,
                  Icons.chat,
                  "X (Twitter)",
                  Colors.black,
                ),
                _buildSocialIcon(
                  context,
                  Icons.work,
                  "LinkedIn",
                  Colors.blueAccent,
                ),
                _buildSocialIcon(context, Icons.copy, "Copy Link", Colors.grey),
              ],
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

  Widget _buildSocialIcon(
    BuildContext context,
    IconData icon,
    String label,
    Color color,
  ) {
    return InkWell(
      onTap: () {
        HapticFeedback.lightImpact();
        Navigator.pop(context);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Shared via $label")));
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            backgroundColor: color.withOpacity(0.1),
            radius: 26,
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 6),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}
