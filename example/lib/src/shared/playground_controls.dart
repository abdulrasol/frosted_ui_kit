import 'package:flutter/material.dart';
import 'package:frosted_ui_kit/frosted_ui_kit.dart';

class PlaygroundState {
  final double sigmaX;
  final double sigmaY;
  final Color? glassColor;
  final double borderRadius;
  final double borderWidth;
  final Color? borderColor;

  const PlaygroundState({
    this.sigmaX = 10.0,
    this.sigmaY = 10.0,
    this.glassColor,
    this.borderRadius = 16.0,
    this.borderWidth = 1.0,
    this.borderColor,
  });

  PlaygroundState copyWith({
    double? sigmaX,
    double? sigmaY,
    Color? glassColor,
    double? borderRadius,
    double? borderWidth,
    Color? borderColor,
    bool clearGlassColor = false,
    bool clearBorderColor = false,
  }) {
    return PlaygroundState(
      sigmaX: sigmaX ?? this.sigmaX,
      sigmaY: sigmaY ?? this.sigmaY,
      glassColor: clearGlassColor ? null : (glassColor ?? this.glassColor),
      borderRadius: borderRadius ?? this.borderRadius,
      borderWidth: borderWidth ?? this.borderWidth,
      borderColor: clearBorderColor ? null : (borderColor ?? this.borderColor),
    );
  }

  BoxBorder? get border {
    if (borderWidth <= 0 || borderColor == null) return null;
    return Border.all(color: borderColor!, width: borderWidth);
  }
}

class PlaygroundControls extends StatelessWidget with Cards {
  final PlaygroundState state;
  final ValueChanged<PlaygroundState> onChanged;
  final bool showBorderRadius;

  const PlaygroundControls({
    super.key,
    required this.state,
    required this.onChanged,
    this.showBorderRadius = true,
  });

  @override
  Widget build(BuildContext context) {
    return bluredCard(
      context: context,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(16),
      sigmaX: 15,
      sigmaY: 15,
      color: Colors.black.withValues(alpha: 0.3),
      borderRadius: BorderRadius.circular(24),
      border: Border.all(color: Colors.white24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Glass Properties',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          _buildSlider(
            'Sigma X & Y: ${state.sigmaX.toStringAsFixed(1)}',
            state.sigmaX,
            0,
            50,
            (val) => onChanged(state.copyWith(sigmaX: val, sigmaY: val)),
          ),
          if (showBorderRadius)
            _buildSlider(
              'Border Radius: ${state.borderRadius.toStringAsFixed(1)}',
              state.borderRadius,
              0,
              100,
              (val) => onChanged(state.copyWith(borderRadius: val)),
            ),
          _buildSlider(
            'Border Width: ${state.borderWidth.toStringAsFixed(1)}',
            state.borderWidth,
            0,
            5,
            (val) => onChanged(state.copyWith(borderWidth: val)),
          ),
          const SizedBox(height: 16),
          const Text(
            'Glass Color',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          _buildColorPicker(
            selectedColor: state.glassColor,
            onColorSelected: (c) => onChanged(
              state.copyWith(glassColor: c, clearGlassColor: c == null),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Border Color',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          _buildColorPicker(
            selectedColor: state.borderColor,
            onColorSelected: (c) => onChanged(
              state.copyWith(borderColor: c, clearBorderColor: c == null),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSlider(
    String label,
    double value,
    double min,
    double max,
    ValueChanged<double> onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14)),
        Slider(value: value, min: min, max: max, onChanged: onChanged),
      ],
    );
  }

  Widget _buildColorPicker({
    Color? selectedColor,
    required ValueChanged<Color?> onColorSelected,
  }) {
    final colors = [
      null, // Transparent / None
      Colors.white.withValues(alpha: 0.1),
      Colors.white.withValues(alpha: 0.3),
      Colors.black.withValues(alpha: 0.1),
      Colors.black.withValues(alpha: 0.3),
      Colors.blue.withValues(alpha: 0.2),
      Colors.red.withValues(alpha: 0.2),
      Colors.green.withValues(alpha: 0.2),
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: colors.map((c) {
        final isSelected = selectedColor == c;
        return GestureDetector(
          onTap: () => onColorSelected(c),
          child: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: c ?? Colors.transparent,
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected
                    ? Colors.white
                    : (c == null ? Colors.white38 : Colors.transparent),
                width: isSelected ? 2 : 1,
              ),
            ),
            child: c == null
                ? const Icon(Icons.close, size: 16, color: Colors.white38)
                : null,
          ),
        );
      }).toList(),
    );
  }
}
