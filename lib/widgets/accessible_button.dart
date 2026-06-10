import 'package:flutter/material.dart';

/// Reusable button that always meets the WCAG 2.1 AA 48×48 dp
/// touch-target minimum and carries a screen-reader [semanticLabel].
class AccessibleButton extends StatelessWidget {
  final String label;
  final String? semanticLabel;
  final String? tooltip;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool fullWidth;
  final ButtonVariant variant;
  final IconData? icon;

  const AccessibleButton({
    super.key,
    required this.label,
    this.semanticLabel,
    this.tooltip,
    this.onPressed,
    this.isLoading = false,
    this.fullWidth = false,
    this.variant = ButtonVariant.filled,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveLabel = isLoading ? 'Loading, please wait' : label;

    Widget content = isLoading
        ? const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
                strokeWidth: 2.5, color: Colors.white),
          )
        : (icon != null
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, size: 20),
                  const SizedBox(width: 8),
                  Text(label),
                ],
              )
            : Text(label));

    Widget button;
    switch (variant) {
      case ButtonVariant.filled:
        button = ElevatedButton(
            onPressed: isLoading ? null : onPressed, child: content);
      case ButtonVariant.outlined:
        button = OutlinedButton(
            onPressed: isLoading ? null : onPressed, child: content);
      case ButtonVariant.text:
        button = TextButton(
            onPressed: isLoading ? null : onPressed, child: content);
    }

    // Guarantee the minimum touch-target even for text buttons.
    button = ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
      child: button,
    );

    if (fullWidth) {
      button = SizedBox(width: double.infinity, child: button);
    }

    if (tooltip != null) {
      button = Tooltip(message: tooltip!, child: button);
    }

    return Semantics(
      label: semanticLabel ?? effectiveLabel,
      button: true,
      enabled: onPressed != null && !isLoading,
      child: button,
    );
  }
}

enum ButtonVariant { filled, outlined, text }
