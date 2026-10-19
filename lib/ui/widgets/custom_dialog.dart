import 'package:flutter/material.dart';
import 'package:movies_app/l10n/app_localizations.dart';

enum AppButtonType { elevated, text, outlined }

class CustomDialog extends StatelessWidget {
  final String? title;
  final String? bodyText;
  final Widget? customBody;
  final IconData? icon;

  final String? confirmText;
  final VoidCallback? onConfirm;
  final AppButtonType confirmButtonType;

  final String? cancelText;
  final VoidCallback? onCancel;
  final AppButtonType cancelButtonType;

  final bool isLoading;
  final String loadingText;

  final bool autoDismiss;

  final Color? backgroundColor;
  final Color? titleColor;
  final Color? bodyColor;
  final Color? iconColor;
  final Color? confirmButtonColor;
  final Color? confirmTextColor;
  final Color? cancelButtonColor;
  final Color? cancelTextColor;
  final Color? progressIndicatorColor;
  final double borderRadius;

  const CustomDialog({
    super.key,
    this.title,
    this.bodyText,
    this.customBody,
    this.icon,
    this.confirmText,
    this.onConfirm,
    this.confirmButtonType = AppButtonType.elevated,
    this.cancelText,
    this.onCancel,
    this.cancelButtonType = AppButtonType.text,
    this.isLoading = false,
    this.loadingText = 'Loading...',
    this.autoDismiss = true,
    this.backgroundColor,
    this.titleColor,
    this.bodyColor,
    this.iconColor,
    this.confirmButtonColor,
    this.confirmTextColor,
    this.cancelButtonColor,
    this.cancelTextColor,
    this.progressIndicatorColor,
    this.borderRadius = 20.0,
  });


  static Future<T?> showLoading<T>(
    BuildContext context, {
        String? text,
    Color? progressColor,
    Color? backgroundColor,
    Color? textColor,
    bool barrierDismissible = false,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (_) => CustomDialog(
        isLoading: true,
        loadingText: text ?? AppLocalizations.of(context)!.loading,
        progressIndicatorColor: progressColor,
        backgroundColor: backgroundColor,
        bodyColor: textColor,
      ),
    );
  }

  static void hide(BuildContext context) {
    if (Navigator.of(context, rootNavigator: true).canPop()) {
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  static Future<T?> showTwoButtons<T>({
    required BuildContext context,
    String? title,
    required String body,
    IconData? icon,
    Color? iconColor,
    required String confirmText,
    VoidCallback? onConfirm,
    AppButtonType confirmType = AppButtonType.elevated,
    Color? confirmColor,
    Color? confirmTextColor,
    required String cancelText,
    VoidCallback? onCancel,
    AppButtonType cancelType = AppButtonType.text,
    Color? cancelColor,
    Color? cancelTextColor,
    Color? backgroundColor,
    Color? titleColor,
    Color? bodyColor,
    bool autoDismiss = true,
    bool barrierDismissible = true,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (_) => CustomDialog(
        title: title,
        bodyText: body,
        icon: icon,
        iconColor: iconColor,
        confirmText: confirmText,
        onConfirm: onConfirm,
        confirmButtonType: confirmType,
        confirmButtonColor: confirmColor,
        confirmTextColor: confirmTextColor,
        cancelText: cancelText,
        onCancel: onCancel,
        cancelButtonType: cancelType,
        cancelButtonColor: cancelColor,
        cancelTextColor: cancelTextColor,
        backgroundColor: backgroundColor,
        titleColor: titleColor,
        bodyColor: bodyColor,
        autoDismiss: autoDismiss,
      ),
    );
  }

  static Future<T?> showOneButton<T>({
    required BuildContext context,
    String? title,
    required String body,
    IconData? icon,
    Color? iconColor,
    required String buttonText,
    VoidCallback? onTap,
    AppButtonType buttonType = AppButtonType.elevated,
    Color? buttonColor,
    Color? buttonTextColor,
    Color? backgroundColor,
    Color? titleColor,
    Color? bodyColor,
    bool autoDismiss = true,
    bool barrierDismissible = true,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (_) => CustomDialog(
        title: title,
        bodyText: body,
        icon: icon,
        iconColor: iconColor,
        confirmText: buttonText,
        confirmButtonType: buttonType,
        confirmButtonColor: buttonColor,
        confirmTextColor: buttonTextColor,
        onConfirm: onTap,
        backgroundColor: backgroundColor,
        titleColor: titleColor,
        bodyColor: bodyColor,
        autoDismiss: autoDismiss,
      ),
    );
  }

  static Future<T?> showCustom<T>({
    required BuildContext context,
    String? title,
    required Widget body,
    String? confirmText,
    VoidCallback? onConfirm,
    AppButtonType confirmType = AppButtonType.elevated,
    Color? confirmColor,
    Color? confirmTextColor,
    String? cancelText,
    VoidCallback? onCancel,
    AppButtonType cancelType = AppButtonType.text,
    Color? cancelColor,
    Color? cancelTextColor,
    Color? backgroundColor,
    Color? titleColor,
    bool autoDismiss = true,
    bool barrierDismissible = true,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (_) => CustomDialog(
        title: title,
        customBody: body,
        confirmText: confirmText,
        onConfirm: onConfirm,
        confirmButtonType: confirmType,
        confirmButtonColor: confirmColor,
        confirmTextColor: confirmTextColor,
        cancelText: cancelText,
        onCancel: onCancel,
        cancelButtonType: cancelType,
        cancelButtonColor: cancelColor,
        cancelTextColor: cancelTextColor,
        backgroundColor: backgroundColor,
        titleColor: titleColor,
        autoDismiss: autoDismiss,
      ),
    );
  }

  static Future<T?> showError<T>({
    required BuildContext context,
    String? title,
    required String message,
    String? buttonText,
    VoidCallback? onTap,
    Color? iconColor,
    Color? buttonColor,
    bool barrierDismissible = true,
  }) {
    return showOneButton<T>(
      context: context,
      title: title,
      body: message,
      icon: Icons.error_outline_rounded,
      iconColor: iconColor ?? const Color(0xffE82626),
      buttonText: buttonText ?? AppLocalizations.of(context)!.ok,
      buttonColor: buttonColor ?? const Color(0xffE82626),
      buttonTextColor: Colors.white,
      onTap: onTap,
      barrierDismissible: barrierDismissible,
    );
  }

  static Future<T?> showSuccess<T>({
    required BuildContext context,
    String? title,
    required String message,
    String? buttonText,
    VoidCallback? onTap,
    Color? iconColor,
    Color? buttonColor,
    bool barrierDismissible = true,
  }) {
    return showOneButton<T>(
      context: context,
      title: title,
      body: message,
      icon: Icons.check_circle_outline_rounded,
      iconColor: iconColor ?? const Color(0xff57AA53),
      buttonText: buttonText ?? AppLocalizations.of(context)!.ok,
      buttonColor: buttonColor ?? const Color(0xff57AA53),
      buttonTextColor: Colors.white,
      onTap: onTap,
      barrierDismissible: barrierDismissible,
    );
  }


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveBgColor = backgroundColor ??
        theme.dialogTheme.backgroundColor ??
        theme.colorScheme.surface;

    return AlertDialog(
      backgroundColor: effectiveBgColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      contentPadding: const EdgeInsets.all(24),
      content: isLoading
          ? _buildLoadingContent(theme)
          : _buildStandardContent(context, theme),
    );
  }

  Widget _buildLoadingContent(ThemeData theme) {
    final effectiveTextColor =
        bodyColor ?? theme.textTheme.bodyMedium?.color ?? theme.colorScheme.onSurface;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircularProgressIndicator(
          valueColor: progressIndicatorColor != null
              ? AlwaysStoppedAnimation<Color>(progressIndicatorColor!)
              : AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
        ),
        const SizedBox(width: 20),
        Flexible(
          child: Text(
            loadingText,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: effectiveTextColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStandardContent(BuildContext context, ThemeData theme) {
    final hasCancelButton = cancelText != null;
    final effectiveTitleColor =
        titleColor ?? theme.textTheme.titleLarge?.color ?? theme.colorScheme.onSurface;
    final effectiveBodyColor =
        bodyColor ?? theme.textTheme.bodyMedium?.color ?? theme.colorScheme.onSurfaceVariant;
    final effectiveIconColor = iconColor ?? theme.colorScheme.primary;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (icon != null) ...[
          Align(
            alignment: Alignment.center,
            child: Icon(icon, size: 48, color: effectiveIconColor),
          ),
          const SizedBox(height: 16),
        ],
        if (title != null) ...[
          Text(
            title!,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: effectiveTitleColor,
            ),
          ),
          const SizedBox(height: 12),
        ],
        if (customBody != null)
          customBody!
        else if (bodyText != null)
          Text(
            bodyText!,
            style: TextStyle(
              fontSize: 14,
              color: effectiveBodyColor,
              height: 1.4,
            ),
          ),
        if (confirmText != null || cancelText != null) ...[
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (hasCancelButton) ...[
                Expanded(
                  child: _buildButton(
                    context: context,
                    type: cancelButtonType,
                    text: cancelText!,
                    onPressed: () {
                      if (autoDismiss) {
                        Navigator.of(context).pop();
                      }
                      onCancel?.call();
                    },
                    bgColor: cancelButtonColor,
                    textColor: cancelTextColor ??
                        (cancelButtonType == AppButtonType.elevated
                            ? theme.colorScheme.onSurface
                            : theme.colorScheme.onSurfaceVariant),
                    defaultBgColor:
                        theme.colorScheme.onSurface.withValues(alpha: 0.08),
                  ),
                ),
                const SizedBox(width: 12),
              ],
              if (confirmText != null)
                Expanded(
                  child: _buildButton(
                    context: context,
                    type: confirmButtonType,
                    text: confirmText!,
                    onPressed: () {
                      if (autoDismiss) {
                        Navigator.of(context).pop();
                      }
                      onConfirm?.call();
                    },
                    bgColor: confirmButtonColor,
                    textColor: confirmTextColor ??
                        (confirmButtonType == AppButtonType.elevated
                            ? theme.colorScheme.onPrimary
                            : theme.colorScheme.primary),
                    defaultBgColor: theme.colorScheme.primary,
                  ),
                ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildButton({
    required BuildContext context,
    required AppButtonType type,
    required String text,
    required VoidCallback onPressed,
    Color? bgColor,
    Color? textColor,
    Color? defaultBgColor,
  }) {
    final theme = Theme.of(context);
    final effectiveBgColor = bgColor ?? defaultBgColor;

    switch (type) {
      case AppButtonType.elevated:
        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: effectiveBgColor,
            foregroundColor: textColor ?? theme.colorScheme.onPrimary,
            elevation: 0,
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: onPressed,
          child: Text(text),
        );

      case AppButtonType.text:
        return TextButton(
          style: TextButton.styleFrom(
            backgroundColor: bgColor,
            foregroundColor: textColor ?? theme.colorScheme.primary,
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: onPressed,
          child: Text(text),
        );

      case AppButtonType.outlined:
        return OutlinedButton(
          style: OutlinedButton.styleFrom(
            foregroundColor: textColor ?? theme.colorScheme.primary,
            side: BorderSide(
              color: effectiveBgColor ?? theme.colorScheme.outline,
            ),
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: onPressed,
          child: Text(text),
        );
    }
  }
}
