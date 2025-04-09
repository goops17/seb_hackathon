import 'package:flutter/material.dart';

class CircularIconButton extends StatefulWidget {
  final String name;
  final String assetImagePath;
  final VoidCallback onTap;

  const CircularIconButton({
    super.key,
    required this.name,
    required this.assetImagePath,
    required this.onTap,
  });

  @override
  State<CircularIconButton> createState() => _CircularIconButtonState();
}

class _CircularIconButtonState extends State<CircularIconButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 120),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.92,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  Future<void> _animateClick() async {
    await _controller.forward();
    await _controller.reverse();
    widget.onTap();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: _animateClick,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage(widget.assetImagePath),
                  fit: BoxFit.cover,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    offset: const Offset(0, 5),
                    blurRadius: 8,
                  ),
                  const BoxShadow(
                    color: Colors.white,
                    offset: Offset(-1, -1),
                    blurRadius: 2,
                  ),
                ],
                border: Border.all(
                  color: Colors.white.withOpacity(0.6),
                  width: 1.5,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          widget.name,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            shadows: [
              Shadow(
                offset: Offset(0.5, 0.5),
                color: Colors.black12,
                blurRadius: 1,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
