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

class PlaygroundControls extends StatefulWidget {
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
  State<PlaygroundControls> createState() => _PlaygroundControlsState();
}

class _PlaygroundControlsState extends State<PlaygroundControls> with Cards {
  late PlaygroundState _localState;

  @override
  void initState() {
    super.initState();
    _localState = widget.state;
  }

  void _updateState(PlaygroundState newState) {
    setState(() => _localState = newState);
    widget.onChanged(newState);
  }

  @override
  Widget build(BuildContext context) {
    return bluredCard(
      context: context,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      margin: EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: MediaQuery.of(context).padding.bottom + 24,
      ),
      sigmaX: 20,
      sigmaY: 20,
      color: Colors.black.withValues(alpha: 0.6),
      borderRadius: BorderRadius.circular(24),
      border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Glass Properties',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close, size: 16, color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _buildSlider(
            'Blur: ${_localState.sigmaX.toStringAsFixed(1)}',
            _localState.sigmaX,
            0,
            50,
            (val) =>
                _updateState(_localState.copyWith(sigmaX: val, sigmaY: val)),
          ),
          if (widget.showBorderRadius)
            _buildSlider(
              'Radius: ${_localState.borderRadius.toStringAsFixed(1)}',
              _localState.borderRadius,
              0,
              100,
              (val) => _updateState(_localState.copyWith(borderRadius: val)),
            ),
          _buildSlider(
            'Border Width: ${_localState.borderWidth.toStringAsFixed(1)}',
            _localState.borderWidth,
            0,
            5,
            (val) => _updateState(_localState.copyWith(borderWidth: val)),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Glass Color',
                      style: TextStyle(fontSize: 12, color: Colors.white70),
                    ),
                    const SizedBox(height: 4),
                    _buildColorPicker(
                      selectedColor: _localState.glassColor,
                      onColorSelected: (c) => _updateState(
                        _localState.copyWith(
                          glassColor: c,
                          clearGlassColor: c == null,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Border Color',
                      style: TextStyle(fontSize: 12, color: Colors.white70),
                    ),
                    const SizedBox(height: 4),
                    _buildColorPicker(
                      selectedColor: _localState.borderColor,
                      onColorSelected: (c) => _updateState(
                        _localState.copyWith(
                          borderColor: c,
                          clearBorderColor: c == null,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 2.0),
      child: Row(
        children: [
          SizedBox(
            width: 70,
            child: Text(
              label,
              style: const TextStyle(fontSize: 12, color: Colors.white),
            ),
          ),
          Expanded(
            child: SliderTheme(
              data: SliderThemeData(
                trackHeight: 2,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                overlayShape: const RoundSliderOverlayShape(overlayRadius: 12),
                activeTrackColor: Colors.white,
                inactiveTrackColor: Colors.white30,
                thumbColor: Colors.white,
              ),
              child: Slider(
                value: value,
                min: min,
                max: max,
                onChanged: onChanged,
              ),
            ),
          ),
        ],
      ),
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
    ];

    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children: colors.map((c) {
        final isSelected = selectedColor == c;
        return GestureDetector(
          onTap: () => onColorSelected(c),
          child: Container(
            width: 24,
            height: 24,
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
                ? const Icon(Icons.close, size: 12, color: Colors.white38)
                : null,
          ),
        );
      }).toList(),
    );
  }
}
