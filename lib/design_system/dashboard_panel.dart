import 'package:flutter/material.dart';

class DashboardPanel extends StatelessWidget {
  const DashboardPanel({
    super.key,
    required this.child,
    this.title,
    this.icon,
    this.trailing,
    this.padding = const EdgeInsets.all(22),
  });

  final Widget child;
  final String? title;
  final IconData? icon;
  final Widget? trailing;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final showHeader = title != null || icon != null || trailing != null;

    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: theme.colorScheme.outlineVariant,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showHeader) ...[
            Row(
              children: [
                if (icon != null) ...[
                  Icon(
                    icon,
                    size: 20,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 9),
                ],
                if (title != null)
                  Expanded(
                    child: Text(
                      title!,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: theme.colorScheme.primary,
                        letterSpacing: 1.2,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                else
                  const Spacer(),
                ?trailing,
              ],
            ),
            const SizedBox(height: 20),
          ],
          child,
        ],
      ),
    );
  }
}