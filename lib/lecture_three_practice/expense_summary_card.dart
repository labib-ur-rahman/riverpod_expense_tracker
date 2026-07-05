import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_expense_tracker/lecture_three_practice/lecture_three_practice_screen.dart';

class ExpenseSummaryCard extends ConsumerWidget {
  const ExpenseSummaryCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    debugPrint('ExpenseSummaryCard rebuilt');

    final expense = ref.watch(dailyExpenseProvider);
    final limit = ref.watch(dailyLimitProvider);
    final remaining = ref.watch(dailyRemainingProvider);

    final hasExceededLimit = remaining < 0;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [const Text('Daily limit'), Text(limit.toString())],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [const Text('Total expense'), Text(expense.toString())],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(hasExceededLimit ? 'Exceeded by' : 'Remaining'),
                Text(
                  '৳${remaining.abs().toStringAsFixed(0)}',
                  style: TextStyle(
                    color: hasExceededLimit ? Colors.red : Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
