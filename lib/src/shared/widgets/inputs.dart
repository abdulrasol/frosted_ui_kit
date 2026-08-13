import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:starter/src/utils/app_themes.dart';

/// A modern, customizable text field widget with form validation, themed styling, and label/error support.
class AppTextField extends StatelessWidget {
  /// Creates an [AppTextField] with comprehensive configuration options.
  const AppTextField({
    super.key,
    this.label,
    this.placeholder,
    this.controller,
    this.initialValue,
    this.keyboardType = TextInputType.text,
    this.textInputAction,
    this.obscureText = false,
    this.obscuringCharacter = '•',
    this.prefix,
    this.suffix,
    this.minLines,
    this.maxLines = 1,
    this.maxLength,
    this.readOnly = false,
    this.enabled = true,
    this.autofocus = false,
    this.focusNode,
    this.onTap,
    this.onChanged,
    this.onSubmitted,
    this.onEditingComplete,
    this.errorText,
    this.validator,
    this.inputFormatters = const [],
    this.textCapitalization = TextCapitalization.none,
    this.contentPadding,
    this.borderRadius,
    this.fillColor,
    this.style,
    this.placeholderStyle,
    this.labelStyle,
    this.errorStyle,
  });

  /// Optional top label text displayed above the input field.
  final String? label;

  /// Placeholder/hint text displayed inside the field when empty.
  final String? placeholder;

  /// Controller managing the text being edited.
  final TextEditingController? controller;

  /// Initial text value when [controller] is not provided.
  final String? initialValue;

  /// Type of keyboard to display for editing (e.g., text, number, emailAddress).
  final TextInputType keyboardType;

  /// Action button configuration for the keyboard (e.g., done, next, search).
  final TextInputAction? textInputAction;

  /// Whether to hide the text being entered (e.g., for passwords).
  final bool obscureText;

  /// Character used to mask text when [obscureText] is true (defaults to '•').
  final String obscuringCharacter;

  /// Widget displayed before the text input (leading icon/widget).
  final Widget? prefix;

  /// Widget displayed after the text input (trailing icon/widget).
  final Widget? suffix;

  /// Minimum number of lines to display.
  final int? minLines;

  /// Maximum number of lines to display (defaults to 1).
  final int? maxLines;

  /// Maximum character length allowed.
  final int? maxLength;

  /// Whether the field is read-only and ignores user interactions.
  final bool readOnly;

  /// Whether the input field is enabled.
  final bool enabled;

  /// Whether the field should automatically focus when mounted.
  final bool autofocus;

  /// Focus node controlling keyboard focus for this widget.
  final FocusNode? focusNode;

  /// Callback function executed when the field is tapped.
  final VoidCallback? onTap;

  /// Callback function executed whenever text changes.
  final ValueChanged<String>? onChanged;

  /// Callback function executed when user submits the field (e.g., presses Done on keyboard).
  final ValueChanged<String>? onSubmitted;

  /// Callback function executed when editing is complete.
  final VoidCallback? onEditingComplete;

  /// Explicit error message text displayed below the field.
  final String? errorText;

  /// Validator function used within a [Form] context.
  final FormFieldValidator<String>? validator;

  /// Optional input formatters to restrict or format typed text.
  final List<TextInputFormatter> inputFormatters;

  /// Controls automatic capitalization of text (e.g., words, sentences, characters).
  final TextCapitalization textCapitalization;

  /// Custom padding inside the input field container.
  final EdgeInsetsGeometry? contentPadding;

  /// Custom border radius for the input field box.
  final BorderRadius? borderRadius;

  /// Background fill color for the input field container.
  final Color? fillColor;

  /// Text style for the entered text.
  final TextStyle? style;

  /// Text style for the placeholder text.
  final TextStyle? placeholderStyle;

  /// Text style for the top label text.
  final TextStyle? labelStyle;

  /// Text style for the error message text.
  final TextStyle? errorStyle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveBorderRadius = borderRadius ?? BorderRadius.circular(16);
    final defaultFillColor = fillColor ?? theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: labelStyle ?? theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600, color: theme.colorScheme.onSurface),
          ),
          const SizedBox(height: 8),
        ],
        FormField<String>(
          initialValue: controller?.text ?? initialValue,
          validator: validator,
          builder: (FormFieldState<String> state) {
            final hasError = state.hasError || (errorText != null && errorText!.isNotEmpty);
            final displayError = state.errorText ?? errorText;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                CupertinoTextField(
                  controller: controller,
                  placeholder: placeholder,
                  placeholderStyle: placeholderStyle ?? theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.6)),
                  style: style ?? theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface),
                  keyboardType: keyboardType,
                  textInputAction: textInputAction,
                  obscureText: obscureText,
                  obscuringCharacter: obscuringCharacter,
                  inputFormatters: inputFormatters,
                  prefix: prefix != null ? Padding(padding: const EdgeInsets.only(left: 12, right: 8), child: prefix) : null,
                  suffix: suffix != null ? Padding(padding: const EdgeInsets.only(left: 8, right: 12), child: suffix) : null,
                  minLines: minLines,
                  maxLines: maxLines,
                  maxLength: maxLength,
                  readOnly: readOnly,
                  enabled: enabled,
                  autofocus: autofocus,
                  focusNode: focusNode,
                  textCapitalization: textCapitalization,
                  onTap: onTap,
                  onSubmitted: onSubmitted,
                  onEditingComplete: onEditingComplete,
                  onChanged: (value) {
                    state.didChange(value);
                    if (onChanged != null) onChanged!(value);
                  },
                  padding: contentPadding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: defaultFillColor,
                    borderRadius: effectiveBorderRadius,
                    border: Border.all(color: hasError ? theme.colorScheme.error : AppThemes.border.top.color, width: 1),
                  ),
                ),
                if (hasError && displayError != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 6, left: 4),
                    child: Text(displayError, style: errorStyle ?? theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.error)),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}

/// A mixin providing utility methods for constructing input text fields.
mixin Inputs {
  /// Returns a configured [AppTextField] widget with all available options.
  Widget textField({
    required BuildContext context,
    String? label,
    String? placeholder,
    TextEditingController? controller,
    String? initialValue,
    TextInputType keyboardType = TextInputType.text,
    TextInputAction? textInputAction,
    bool obscureText = false,
    String obscuringCharacter = '•',
    Widget? prefix,
    Widget? suffix,
    int? minLines,
    int? maxLines = 1,
    int? maxLength,
    bool readOnly = false,
    bool enabled = true,
    bool autofocus = false,
    FocusNode? focusNode,
    VoidCallback? onTap,
    ValueChanged<String>? onChanged,
    ValueChanged<String>? onSubmitted,
    VoidCallback? onEditingComplete,
    String? errorText,
    FormFieldValidator<String>? validator,
    List<TextInputFormatter> inputFormatters = const [],
    TextCapitalization textCapitalization = TextCapitalization.none,
    EdgeInsetsGeometry? contentPadding,
    BorderRadius? borderRadius,
    Color? fillColor,
    TextStyle? style,
    TextStyle? placeholderStyle,
    TextStyle? labelStyle,
    TextStyle? errorStyle,
  }) {
    return AppTextField(
      label: label,
      placeholder: placeholder,
      controller: controller,
      initialValue: initialValue,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      obscureText: obscureText,
      obscuringCharacter: obscuringCharacter,
      prefix: prefix,
      suffix: suffix,
      minLines: minLines,
      maxLines: maxLines,
      maxLength: maxLength,
      readOnly: readOnly,
      enabled: enabled,
      autofocus: autofocus,
      focusNode: focusNode,
      onTap: onTap,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      onEditingComplete: onEditingComplete,
      errorText: errorText,
      validator: validator,
      inputFormatters: inputFormatters,
      textCapitalization: textCapitalization,
      contentPadding: contentPadding,
      borderRadius: borderRadius,
      fillColor: fillColor,
      style: style,
      placeholderStyle: placeholderStyle,
      labelStyle: labelStyle,
      errorStyle: errorStyle,
    );
  }
}
