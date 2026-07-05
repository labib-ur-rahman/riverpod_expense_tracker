import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_expense_tracker/lecture_four_practice/transaction_logic.dart';

class TransactionSummaryCard extends ConsumerWidget {
  const TransactionSummaryCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    debugPrint('TransactionSummaryCard rebuilt');

    final income = ref.watch(totalIncomeProvider);
    final expense = ref.watch(totalExpenseProvider);
    final balance = ref.watch(currentBalanceProvider);

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text('Current Balance', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text(
              '৳${balance.toStringAsFixed(0)}',
              style: const TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
            ),
            const Divider(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total Income'),
                Text(
                  '+৳${income.toStringAsFixed(0)}',
                  style: const TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total Expense'),
                Text(
                  '-৳${expense.toStringAsFixed(0)}',
                  style: const TextStyle(
                    color: Colors.red,
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
