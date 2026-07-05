import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Application name
final appNameProvider = Provider<String>((ref) {
  return 'Expense Tracker';
});

/// Currency symbol
final currencyProvider = Provider<String>((ref) {
  return '৳';
});

/// Monthly income goal
final monthlyIncomeGoalProvider = Provider<double>((ref) {
  return 50000;
});

/// Maximum monthly expense
final monthlyExpenseLimitProvider = Provider<double>((ref) {
  return 30000;
});

/// Derived/computed value
final remainingTargetProvider = Provider<double>((ref) {
  final incomeGoal = ref.watch(monthlyIncomeGoalProvider);
  final expenseLimit = ref.watch(monthlyExpenseLimitProvider);

  return incomeGoal - expenseLimit;
});

class LectureOnePractice extends ConsumerWidget {
  const LectureOnePractice({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appName = ref.watch(appNameProvider);
    final currency = ref.watch(currencyProvider);
    final incomeGoal = ref.watch(monthlyIncomeGoalProvider);
    final expenseLimit = ref.watch(monthlyExpenseLimitProvider);
    final remainingTarget = ref.watch(remainingTargetProvider);

    return Scaffold(
      appBar: AppBar(title: Text(appName)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Monthly Income Goal:',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Text(
                '$currency${incomeGoal.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 24),

              const Text(
                'Monthly Expense Limit:',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Text(
                '$currency${expenseLimit.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 24),

              const Text(
                'Remaining Target:',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Text(
                '$currency${remainingTarget.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}