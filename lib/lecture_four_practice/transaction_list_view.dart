import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_expense_tracker/lecture_four_practice/show_transaction_result_message.dart';
import 'package:riverpod_expense_tracker/lecture_four_practice/transaction_form_sheet.dart';
import 'package:riverpod_expense_tracker/lecture_four_practice/transaction_logic.dart';

class TransactionListView extends ConsumerWidget {
  void _openEditForm(BuildContext context, ExpenseTransaction transaction) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return TransactionFormSheet(transaction: transaction);
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    debugPrint('TransactionListView rebuilt');

    final transactions = ref.watch(transactionListProvider);

    if (transactions.isEmpty) {
      return const Center(child: Text('No transactions yet'));
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
      itemCount: transactions.length,
      separatorBuilder: (_, _) {
        return const SizedBox(height: 8);
      },
      itemBuilder: (context, index) {
        final transaction = transactions[index];

        final isExpense = transaction.type == TransactionType.expense;

        return Card(
          child: ListTile(
            leading: CircleAvatar(
              child: Icon(
                isExpense ? Icons.arrow_upward : Icons.arrow_downward,
              ),
            ),
            title: Text(transaction.title),
            subtitle: Text(transaction.category),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${isExpense ? '-' : '+'}'
                  '৳${transaction.amount.toStringAsFixed(0)}',
                  style: TextStyle(
                    color: isExpense ? Colors.red : Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    _openEditForm(context, transaction);
                  },
                  icon: const Icon(Icons.edit),
                ),
                IconButton(
                  onPressed: () {
                    final result = ref
                        .read(transactionListProvider.notifier)
                        .deleteTransaction(transaction.id);

                    showTransactionResultMessage(
                      context,
                      result,
                      'Transaction deleted',
                    );
                  },
                  icon: const Icon(Icons.delete),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
