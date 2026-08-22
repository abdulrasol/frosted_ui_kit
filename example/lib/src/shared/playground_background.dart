import 'package:example_app/main.dart';
import 'package:flutter/material.dart';

class PlaygroundBackground extends StatelessWidget {
  const PlaygroundBackground({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = MySandboxApp.of(context).isDarkMode;

    return Stack(
      children: [
        // Base Gradient
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDark
                    ? const [
                        Color(0xFF2C1930), // Deep Purple
                        Color(0xFF14243A), // Deep Blue
                        Color(0xFF20132B), // Very Dark Violet
                        Color(0xFF0F1E28), // Dark Cyan tint
                      ]
                    : const [
                        Color(0xFFF9D423), // Warm yellow
                        Color(0xFFFF4E50), // Vibrant Red/Pink
                        Color(0xFF6dd5ed), // Sky Blue
                        Color(0xFF2193b0), // Deep Blue
                      ],
                stops: const [0.0, 0.4, 0.7, 1.0],
              ),
            ),
          ),
        ),
        // Abstract floating shapes to make blur look great
        Positioned(
          top: -50,
          right: -50,
          child: _buildOrb(
            size: 300,
            color: isDark
                ? Colors.purpleAccent.withValues(alpha: 0.3)
                : Colors.yellow.withValues(alpha: 0.5),
          ),
        ),
        Positioned(
          bottom: 100,
          left: -100,
          child: _buildOrb(
            size: 400,
            color: isDark
                ? Colors.cyanAccent.withValues(alpha: 0.2)
                : Colors.blueAccent.withValues(alpha: 0.3),
          ),
        ),
        Positioned(
          top: MediaQuery.of(context).size.height * 0.4,
          right: 50,
          child: _buildOrb(
            size: 200,
            color: isDark
                ? Colors.pinkAccent.withValues(alpha: 0.2)
                : Colors.orangeAccent.withValues(alpha: 0.4),
          ),
        ),
      ],
    );
  }

  Widget _buildOrb({required double size, required Color color}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        boxShadow: [BoxShadow(color: color, blurRadius: 100, spreadRadius: 50)],
      ),
    );
  }
}
