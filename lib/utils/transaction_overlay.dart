import 'package:lottie/lottie.dart';
import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'dart:math';

class TransactionOverlay extends StatefulWidget {
  final bool isBuying;
  const TransactionOverlay({super.key, required this.isBuying});

  @override
  State<TransactionOverlay> createState() => _TransactionOverlayState();
}

class _TransactionOverlayState extends State<TransactionOverlay>
    with TickerProviderStateMixin {
  bool _showConfetti = false;
  bool _showLottie = true;
  late final AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this);

    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _showLottie = false;
          _showConfetti = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withOpacity(0.85),
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (_showLottie)
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Lottie.asset(
                  widget.isBuying
                      ? 'lib/assets/lottie/money_in.json'
                      : 'lib/assets/lottie/money_out.json',
                  width: 180,
                  repeat: false,
                  onLoaded:
                      (composition) =>
                          _animationController.duration = composition.duration,
                ),
                const SizedBox(height: 20),
                const CircularProgressIndicator(color: Colors.white),
                const SizedBox(height: 20),
                Text(
                  widget.isBuying
                      ? "Fetching money from bank..."
                      : "Depositing back to bank...",
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          if (_showConfetti)
            Center(
              child: CelebrationConfetti(
                text: widget.isBuying ? "Funds Received!" : "Funds Returned!",
                duration: const Duration(seconds: 2),
              ),
            ),
        ],
      ),
    );
  }
}

class CelebrationConfetti extends StatefulWidget {
  final String text;
  final Duration duration;
  const CelebrationConfetti({
    super.key,
    required this.text,
    required this.duration,
  });

  @override
  State<CelebrationConfetti> createState() => _CelebrationConfettiState();
}

class _CelebrationConfettiState extends State<CelebrationConfetti> {
  late final ConfettiController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ConfettiController(duration: widget.duration);
    _controller.play();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        ConfettiWidget(
          confettiController: _controller,
          blastDirectionality: BlastDirectionality.explosive,
          maxBlastForce: 30,
          minBlastForce: 10,
          emissionFrequency: 0.02,
          numberOfParticles: 80,
          gravity: 0.3,
          shouldLoop: false,
          colors: const [
            Colors.greenAccent,
            Colors.blueAccent,
            Colors.orangeAccent,
            Colors.purpleAccent,
            Colors.yellow,
          ],
        ),
        Text(
          widget.text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
