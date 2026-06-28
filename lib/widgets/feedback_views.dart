import 'package:flutter/material.dart';

import 'app_theme.dart';

class ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const ErrorView({super.key, required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.wifi_off_rounded,
            size: 48,
            color: AppTheme.textSecondary,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(color: AppTheme.textSecondary),
          ),
          const SizedBox(height: 20),
          FilledButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text('Tentar novamente'),
          ),
        ],
      ),
    ),
  );
}

class EmptyView extends StatelessWidget {
  final String message;
  final IconData icon;

  const EmptyView({
    super.key,
    required this.message,
    this.icon = Icons.inbox_rounded,
  });

  @override
  Widget build(BuildContext context) => Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 48, color: AppTheme.textSecondary),
        const SizedBox(height: 12),
        Text(
          message,
          style: TextStyle(color: AppTheme.textSecondary, fontSize: 15),
        ),
      ],
    ),
  );
}

class LoandingView extends StatelessWidget {
  const LoandingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: CircularProgressIndicator(color: AppTheme.primary));
  }
}
