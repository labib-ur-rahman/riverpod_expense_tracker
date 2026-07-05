import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Application Name provide kore
final appNameProvider = Provider<String>((ref) {
  return 'Expense Tracker';
});

/// Money Symbol Provide kore
final currencyProvider = Provider<String>((ref) {
  return '৳';
});

/// Default monthly budget provide kore
final monthlyBudgetProvider = Provider<double>((ref) {
  return 30000.00;
});

/// Monthly Budget and currency use kore formatted monthly budget provide kore
final formattedBudgetProvider = Provider<String>((ref) {
  final currency = ref.watch(currencyProvider);
  final budget = ref.watch(monthlyBudgetProvider);
  return '$currency${budget.toStringAsFixed(0)}';
});

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appName = ref.watch(appNameProvider);
    final formattedBudget = ref.watch(formattedBudgetProvider);

    return Scaffold(
      appBar: AppBar(title: Text(appName)),
      body: Center(
        child: Text(
          'Monthly Budget: $formattedBudget',
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
