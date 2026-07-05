import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_expense_tracker/lecture_five_practice/provider/category_wise_total.dart';
import 'package:riverpod_expense_tracker/lecture_five_practice/provider/main_state_provider.dart';
import 'package:riverpod_expense_tracker/lecture_five_practice/provider/recent_transaction_provider.dart';
import 'package:riverpod_expense_tracker/lecture_five_practice/provider/transaction_summary_provider.dart';
import 'package:riverpod_expense_tracker/lecture_five_practice/transaction_model.dart';

class DerivedStateDashboard extends ConsumerWidget {
  const DerivedStateDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary = ref.watch(transactionSummaryProvider);
    final recentTransactions = ref.watch(recentTransactionsProvider);
    final categorySummary = ref.watch(categoryExpenseSummaryProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Derived State Dashboard')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Text('Current Balance'),
                  const SizedBox(height: 8),
                  Text(
                    '৳${summary.currentBalance.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Divider(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Income'),
                      Text('+৳${summary.totalIncome.toStringAsFixed(0)}'),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Expense'),
                      Text('-৳${summary.totalExpense.toStringAsFixed(0)}'),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Transactions'),
                      Text('${summary.transactionCount}'),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            'Category Expense Summary',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 8),

          if (categorySummary.isEmpty)
            const Text('No expense category yet')
          else
            ...categorySummary.entries.map((entry) {
              return ListTile(
                title: Text(entry.key),
                trailing: Text('৳${entry.value.toStringAsFixed(0)}'),
              );
            }),

          const SizedBox(height: 20),

          const Text(
            'Recent Transactions',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 8),

          if (recentTransactions.isEmpty)
            const Text('No recent transactions')
          else
            ...recentTransactions.map((transaction) {
              final isExpense = transaction.type == TransactionType.expense;

              return ListTile(
                title: Text(transaction.title),
                subtitle: Text(transaction.category),
                trailing: Text(
                  '${isExpense ? '-' : '+'}'
                  '৳${transaction.amount.toStringAsFixed(0)}',
                ),
              );
            }),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          ref
              .read(transactionListProvider.notifier)
              .addTransaction(
                ExpenseTransaction(
                  id: DateTime.now().microsecondsSinceEpoch.toString(),
                  title: 'Lunch',
                  amount: 500,
                  category: 'Food',
                  type: TransactionType.expense,
                  createdAt: DateTime.now(),
                ),
              );
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Lunch'),
      ),
    );
  }
}