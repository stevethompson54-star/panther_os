import 'package:flutter/material.dart';

class PantherScaffold extends StatelessWidget {
  const PantherScaffold({
    required this.title,
    required this.child,
    this.subtitle,
    this.actions = const [],
    this.showBackButton = false,
    this.maxContentWidth = 1200,
    this.padding = const EdgeInsets.all(24),
    super.key,
  });

  final String title;
  final String? subtitle;
  final Widget child;
  final List<Widget> actions;
  final bool showBackButton;
  final double maxContentWidth;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _PantherHeader(
              title: title,
              subtitle: subtitle,
              actions: actions,
              showBackButton: showBackButton,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: maxContentWidth,
                    ),
                    child: Padding(
                      padding: padding,
                      child: child,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PantherHeader extends StatelessWidget {
  const _PantherHeader({
    required this.title,
    required this.actions,
    required this.showBackButton,
    this.subtitle,
  });

  final String title;
  final String? subtitle;
  final List<Widget> actions;
  final bool showBackButton;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final canNavigateBack = Navigator.of(context).canPop();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 18,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: theme.dividerColor,
          ),
        ),
      ),
      child: Row(
        children: [
          if (showBackButton && canNavigateBack) ...[
            IconButton(
              tooltip: 'Go back',
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.arrow_back),
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle!,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (actions.isNotEmpty) ...[
            const SizedBox(width: 16),
            ...actions,
          ],
        ],
      ),
    );
  }
}