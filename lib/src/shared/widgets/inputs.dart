import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frosted_ui_kit/src/shared/widgets/cards.dart';
import 'package:frosted_ui_kit/src/utils/app_themes.dart';

/// Pre-configured input field types for common form scenarios in `frosted_ui_kit`.
enum AppTextFieldType {
  /// Standard text input field.
  text,

  /// Email address input field with email keyboard and email icon.
  email,

  /// Password input field with obscure toggle support and lock icon.
  password,

  /// Full display name input field with person icon.
  name,

  /// Phone number input field with phone keyboard and phone icon.
  phone,

  /// Multiline text area field.
  multiline,

  /// Numeric input field with number keyboard.
  number,
}

/// A modern, customizable glassmorphic text field widget built on [BlurredCard] supporting
/// pre-configured field types, form validation, themed styling, and label/error feedback.
class AppTextField extends StatefulWidget {
  /// Creates an [AppTextField] with comprehensive configuration options.
  const AppTextField({
    super.key,
    this.type = AppTextFieldType.text,
    this.label,
    this.placeholder,
    this.controller,
    this.initialValue,
    this.keyboardType,
    this.textInputAction,
    this.obscureText,
    this.obscuringCharacter = '•',
    this.prefix,
    this.suffix,
    this.minLines,
    this.maxLines,
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
    this.textCapitalization,
    this.contentPadding,
    this.borderRadius,
    this.fillColor,
    this.style,
    this.placeholderStyle,
    this.labelStyle,
    this.errorStyle,
    this.sigmaX = 10.0,
    this.sigmaY = 10.0,
    this.borderColor,
    this.border,
    this.boxShadow,
    this.margin,
    this.clipBehavior = Clip.antiAlias,
    this.useGlass = true,
  });

  /// Factory constructor pre-configured for email inputs.
  factory AppTextField.email({
    Key? key,
    String? label = 'Email',
    String? placeholder = 'name@example.com',
    TextEditingController? controller,
    String? initialValue,
    TextInputAction? textInputAction = TextInputAction.next,
    Widget? prefix = const Icon(Icons.email_outlined, size: 20),
    Widget? suffix,
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
    double sigmaX = 10.0,
    double sigmaY = 10.0,
    Color? fillColor,
    Color? borderColor,
    BoxBorder? border,
    List<BoxShadow>? boxShadow,
    EdgeInsetsGeometry? margin,
    Clip clipBehavior = Clip.antiAlias,
  }) {
    return AppTextField(
      key: key,
      type: AppTextFieldType.email,
      label: label,
      placeholder: placeholder,
      controller: controller,
      initialValue: initialValue,
      textInputAction: textInputAction,
      prefix: prefix,
      suffix: suffix,
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
      sigmaX: sigmaX,
      sigmaY: sigmaY,
      fillColor: fillColor,
      borderColor: borderColor,
      border: border,
      boxShadow: boxShadow,
      margin: margin,
      clipBehavior: clipBehavior,
    );
  }

  /// Factory constructor pre-configured for password inputs.
  factory AppTextField.password({
    Key? key,
    String? label = 'Password',
    String? placeholder = '••••••••',
    TextEditingController? controller,
    String? initialValue,
    TextInputAction? textInputAction = TextInputAction.done,
    Widget? prefix = const Icon(Icons.lock_outline, size: 20),
    Widget? suffix,
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
    double sigmaX = 10.0,
    double sigmaY = 10.0,
    Color? fillColor,
    Color? borderColor,
    BoxBorder? border,
    List<BoxShadow>? boxShadow,
    EdgeInsetsGeometry? margin,
    Clip clipBehavior = Clip.antiAlias,
  }) {
    return AppTextField(
      key: key,
      type: AppTextFieldType.password,
      label: label,
      placeholder: placeholder,
      controller: controller,
      initialValue: initialValue,
      textInputAction: textInputAction,
      prefix: prefix,
      suffix: suffix,
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
      sigmaX: sigmaX,
      sigmaY: sigmaY,
      fillColor: fillColor,
      borderColor: borderColor,
      border: border,
      boxShadow: boxShadow,
      margin: margin,
      clipBehavior: clipBehavior,
    );
  }

  /// Factory constructor pre-configured for name inputs.
  factory AppTextField.name({
    Key? key,
    String? label = 'Name',
    String? placeholder = 'John Doe',
    TextEditingController? controller,
    String? initialValue,
    TextInputAction? textInputAction = TextInputAction.next,
    Widget? prefix = const Icon(Icons.person_outline, size: 20),
    Widget? suffix,
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
    double sigmaX = 10.0,
    double sigmaY = 10.0,
    Color? fillColor,
    Color? borderColor,
    BoxBorder? border,
    List<BoxShadow>? boxShadow,
    EdgeInsetsGeometry? margin,
    Clip clipBehavior = Clip.antiAlias,
  }) {
    return AppTextField(
      key: key,
      type: AppTextFieldType.name,
      label: label,
      placeholder: placeholder,
      controller: controller,
      initialValue: initialValue,
      textInputAction: textInputAction,
      prefix: prefix,
      suffix: suffix,
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
      sigmaX: sigmaX,
      sigmaY: sigmaY,
      fillColor: fillColor,
      borderColor: borderColor,
      border: border,
      boxShadow: boxShadow,
      margin: margin,
      clipBehavior: clipBehavior,
    );
  }

  /// Pre-configured input field type variant.
  final AppTextFieldType type;

  /// Optional top label text displayed above the input field.
  final String? label;

  /// Placeholder/hint text displayed inside the field when empty.
  final String? placeholder;

  /// Controller managing the text being edited.
  final TextEditingController? controller;

  /// Initial text value when [controller] is not provided.
  final String? initialValue;

  /// Type of keyboard to display for editing (defaults based on [type]).
  final TextInputType? keyboardType;

  /// Action button configuration for the keyboard (e.g., done, next).
  final TextInputAction? textInputAction;

  /// Whether to hide the text being entered (defaults based on [type]).
  final bool? obscureText;

  /// Character used to mask text when obscured (defaults to '•').
  final String obscuringCharacter;

  /// Widget displayed before the text input (leading icon/widget).
  final Widget? prefix;

  /// Widget displayed after the text input (trailing icon/widget).
  final Widget? suffix;

  /// Minimum number of lines to display.
  final int? minLines;

  /// Maximum number of lines to display (defaults based on [type]).
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

  /// Callback function executed when user submits the field.
  final ValueChanged<String>? onSubmitted;

  /// Callback function executed when editing is complete.
  final VoidCallback? onEditingComplete;

  /// Explicit error message text displayed below the field.
  final String? errorText;

  /// Validator function used within a [Form] context.
  final FormFieldValidator<String>? validator;

  /// Optional input formatters to restrict or format typed text.
  final List<TextInputFormatter> inputFormatters;

  /// Controls automatic capitalization of text.
  final TextCapitalization? textCapitalization;

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

  /// Horizontal backdrop blur intensity (defaults to 10.0).
  final double sigmaX;

  /// Vertical backdrop blur intensity (defaults to 10.0).
  final double sigmaY;

  /// Custom border color override.
  final Color? borderColor;

  /// Optional custom border decoration override.
  final BoxBorder? border;

  /// Optional list of box shadows applied to the input container.
  final List<BoxShadow>? boxShadow;

  /// Outer margin surrounding the input container.
  final EdgeInsetsGeometry? margin;

  /// Content clipping behavior (defaults to [Clip.antiAlias]).
  final Clip clipBehavior;

  /// Whether to build using glassmorphic [BlurredCard] backdrop (defaults to true).
  final bool useGlass;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late bool _obscured;

  @override
  void initState() {
    super.initState();
    _obscured = widget.obscureText ?? (widget.type == AppTextFieldType.password);
  }

  @override
  void didUpdateWidget(covariant AppTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.obscureText != oldWidget.obscureText) {
      _obscured = widget.obscureText ?? (widget.type == AppTextFieldType.password);
    }
  }

  TextInputType get _effectiveKeyboardType {
    if (widget.keyboardType != null) return widget.keyboardType!;
    switch (widget.type) {
      case AppTextFieldType.email:
        return TextInputType.emailAddress;
      case AppTextFieldType.password:
        return TextInputType.visiblePassword;
      case AppTextFieldType.phone:
        return TextInputType.phone;
      case AppTextFieldType.number:
        return TextInputType.number;
      case AppTextFieldType.multiline:
        return TextInputType.multiline;
      case AppTextFieldType.name:
      case AppTextFieldType.text:
        return TextInputType.text;
    }
  }

  TextCapitalization get _effectiveCapitalization {
    if (widget.textCapitalization != null) return widget.textCapitalization!;
    switch (widget.type) {
      case AppTextFieldType.name:
        return TextCapitalization.words;
      case AppTextFieldType.email:
      case AppTextFieldType.password:
      case AppTextFieldType.phone:
      case AppTextFieldType.number:
      case AppTextFieldType.multiline:
      case AppTextFieldType.text:
        return TextCapitalization.none;
    }
  }

  Widget? get _effectivePrefix {
    if (widget.prefix != null) return widget.prefix;
    switch (widget.type) {
      case AppTextFieldType.email:
        return const Icon(Icons.email_outlined, size: 20);
      case AppTextFieldType.password:
        return const Icon(Icons.lock_outline, size: 20);
      case AppTextFieldType.name:
        return const Icon(Icons.person_outline, size: 20);
      case AppTextFieldType.phone:
        return const Icon(Icons.phone_outlined, size: 20);
      case AppTextFieldType.text:
      case AppTextFieldType.multiline:
      case AppTextFieldType.number:
        return null;
    }
  }

  Widget? get _effectiveSuffix {
    if (widget.suffix != null) return widget.suffix;
    if (widget.type == AppTextFieldType.password) {
      return GestureDetector(
        onTap: () => setState(() => _obscured = !_obscured),
        child: Icon(
          _obscured ? Icons.visibility_off_outlined : Icons.visibility_outlined,
          size: 20,
        ),
      );
    }
    return null;
  }

  int? get _effectiveMaxLines {
    if (_obscured) return 1;
    if (widget.maxLines != null) return widget.maxLines;
    if (widget.type == AppTextFieldType.multiline) return null;
    return 1;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveBorderRadius = widget.borderRadius ?? BorderRadius.circular(16);
    final defaultFillColor = widget.fillColor ?? theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: widget.labelStyle ??
                theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
          ),
          const SizedBox(height: 8),
        ],
        FormField<String>(
          initialValue: widget.controller?.text ?? widget.initialValue,
          validator: widget.validator,
          builder: (FormFieldState<String> state) {
            final hasError = state.hasError || (widget.errorText != null && widget.errorText!.isNotEmpty);
            final displayError = state.errorText ?? widget.errorText;
            final activeBorderColor = hasError ? theme.colorScheme.error : (widget.borderColor ?? AppThemes.borderColor(context));

            final cupertinoField = CupertinoTextField(
              controller: widget.controller,
              placeholder: widget.placeholder,
              placeholderStyle: widget.placeholderStyle ??
                  theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                  ),
              style: widget.style ??
                  theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface),
              keyboardType: _effectiveKeyboardType,
              textInputAction: widget.textInputAction,
              obscureText: _obscured,
              obscuringCharacter: widget.obscuringCharacter,
              inputFormatters: widget.inputFormatters,
              prefix: _effectivePrefix != null
                  ? Padding(padding: const EdgeInsets.only(left: 12, right: 8), child: _effectivePrefix)
                  : null,
              suffix: _effectiveSuffix != null
                  ? Padding(padding: const EdgeInsets.only(left: 8, right: 12), child: _effectiveSuffix)
                  : null,
              minLines: widget.minLines,
              maxLines: _effectiveMaxLines,
              maxLength: widget.maxLength,
              readOnly: widget.readOnly,
              enabled: widget.enabled,
              autofocus: widget.autofocus,
              focusNode: widget.focusNode,
              textCapitalization: _effectiveCapitalization,
              onTap: widget.onTap,
              onSubmitted: widget.onSubmitted,
              onEditingComplete: widget.onEditingComplete,
              onChanged: (value) {
                state.didChange(value);
                if (widget.onChanged != null) widget.onChanged!(value);
              },
              padding: widget.contentPadding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: widget.useGlass
                  ? const BoxDecoration(color: Colors.transparent)
                  : BoxDecoration(
                      color: defaultFillColor,
                      borderRadius: effectiveBorderRadius,
                      border: widget.border ?? Border.all(color: activeBorderColor, width: 1),
                      boxShadow: widget.boxShadow,
                    ),
            );

            final inputContainer = widget.useGlass
                ? BlurredCard(
                    borderRadius: effectiveBorderRadius,
                    color: defaultFillColor,
                    sigmaX: widget.sigmaX,
                    sigmaY: widget.sigmaY,
                    border: widget.border ?? Border.all(color: activeBorderColor, width: 1),
                    boxShadow: widget.boxShadow,
                    margin: widget.margin,
                    clipBehavior: widget.clipBehavior,
                    padding: EdgeInsets.zero,
                    child: cupertinoField,
                  )
                : cupertinoField;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                inputContainer,
                if (hasError && displayError != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 6, left: 4),
                    child: Text(
                      displayError,
                      style: widget.errorStyle ??
                          theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.error),
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}

/// A mixin providing utility methods for constructing input text fields easily in UI screens.
mixin Inputs {
  /// Returns a configured [AppTextField] widget with explicit parameter configuration and glass options.
  Widget textField({
    required BuildContext context,
    AppTextFieldType type = AppTextFieldType.text,
    String? label,
    String? placeholder,
    TextEditingController? controller,
    String? initialValue,
    TextInputType? keyboardType,
    TextInputAction? textInputAction,
    bool? obscureText,
    String obscuringCharacter = '•',
    Widget? prefix,
    Widget? suffix,
    int? minLines,
    int? maxLines,
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
    TextCapitalization? textCapitalization,
    EdgeInsetsGeometry? contentPadding,
    BorderRadius? borderRadius,
    Color? fillColor,
    TextStyle? style,
    TextStyle? placeholderStyle,
    TextStyle? labelStyle,
    TextStyle? errorStyle,
    double sigmaX = 10.0,
    double sigmaY = 10.0,
    Color? borderColor,
    BoxBorder? border,
    List<BoxShadow>? boxShadow,
    EdgeInsetsGeometry? margin,
    Clip clipBehavior = Clip.antiAlias,
  }) {
    return AppTextField(
      type: type,
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
      sigmaX: sigmaX,
      sigmaY: sigmaY,
      borderColor: borderColor,
      border: border,
      boxShadow: boxShadow,
      margin: margin,
      clipBehavior: clipBehavior,
    );
  }

  /// Convenience shortcut for creating an Email input field.
  Widget emailField({
    required BuildContext context,
    String? label = 'Email',
    String? placeholder = 'name@example.com',
    TextEditingController? controller,
    FormFieldValidator<String>? validator,
    ValueChanged<String>? onChanged,
    double sigmaX = 10.0,
    double sigmaY = 10.0,
    Color? fillColor,
    Color? borderColor,
    BoxBorder? border,
    List<BoxShadow>? boxShadow,
    EdgeInsetsGeometry? margin,
    Clip clipBehavior = Clip.antiAlias,
  }) {
    return AppTextField.email(
      label: label,
      placeholder: placeholder,
      controller: controller,
      validator: validator,
      onChanged: onChanged,
      sigmaX: sigmaX,
      sigmaY: sigmaY,
      fillColor: fillColor,
      borderColor: borderColor,
      border: border,
      boxShadow: boxShadow,
      margin: margin,
      clipBehavior: clipBehavior,
    );
  }

  /// Convenience shortcut for creating a Password input field with toggle visibility.
  Widget passwordField({
    required BuildContext context,
    String? label = 'Password',
    String? placeholder = '••••••••',
    TextEditingController? controller,
    FormFieldValidator<String>? validator,
    ValueChanged<String>? onChanged,
    double sigmaX = 10.0,
    double sigmaY = 10.0,
    Color? fillColor,
    Color? borderColor,
    BoxBorder? border,
    List<BoxShadow>? boxShadow,
    EdgeInsetsGeometry? margin,
    Clip clipBehavior = Clip.antiAlias,
  }) {
    return AppTextField.password(
      label: label,
      placeholder: placeholder,
      controller: controller,
      validator: validator,
      onChanged: onChanged,
      sigmaX: sigmaX,
      sigmaY: sigmaY,
      fillColor: fillColor,
      borderColor: borderColor,
      border: border,
      boxShadow: boxShadow,
      margin: margin,
      clipBehavior: clipBehavior,
    );
  }

  /// Convenience shortcut for creating a Name input field.
  Widget nameField({
    required BuildContext context,
    String? label = 'Name',
    String? placeholder = 'John Doe',
    TextEditingController? controller,
    FormFieldValidator<String>? validator,
    ValueChanged<String>? onChanged,
    double sigmaX = 10.0,
    double sigmaY = 10.0,
    Color? fillColor,
    Color? borderColor,
    BoxBorder? border,
    List<BoxShadow>? boxShadow,
    EdgeInsetsGeometry? margin,
    Clip clipBehavior = Clip.antiAlias,
  }) {
    return AppTextField.name(
      label: label,
      placeholder: placeholder,
      controller: controller,
      validator: validator,
      onChanged: onChanged,
      sigmaX: sigmaX,
      sigmaY: sigmaY,
      fillColor: fillColor,
      borderColor: borderColor,
      border: border,
      boxShadow: boxShadow,
      margin: margin,
      clipBehavior: clipBehavior,
    );
  }
}
