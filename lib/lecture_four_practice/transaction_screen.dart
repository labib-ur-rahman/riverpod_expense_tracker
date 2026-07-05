import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_expense_tracker/lecture_four_practice/transaction_form_sheet.dart';
import 'package:riverpod_expense_tracker/lecture_four_practice/transaction_list_view.dart';
import 'package:riverpod_expense_tracker/lecture_four_practice/transaction_summary_card.dart';
import 'package:riverpod_expense_tracker/lecture_four_practice/transaction_logic.dart';

class TransactionListScreen extends ConsumerWidget {
  const TransactionListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    debugPrint('Transaction Screen rebuild');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Tracker'),
        actions: [
          /// clear button (only visible when transactions are not empty)
          Consumer(
            builder: (context, ref, child) {
              debugPrint('Clear button rebuild');

              final transactions = ref.watch(transactionListProvider);

              return IconButton(
                onPressed: transactions.isEmpty
                    ? null
                    : () {
                        ref
                            .read(transactionListProvider.notifier)
                            .clearTransactions();
                      },
                icon: const Icon(Icons.delete_sweep),
              );
            },
          ),
        ],
      ),

      body: Column(
        children: [
          const TransactionSummaryCard(),
          Expanded(child: TransactionListView()),
        ],
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          debugPrint('Transaction button pressed');

          _openAddForm(context);
        },
        label: const Text('Add Transaction'),
      ),
    );
  }

  void _openAddForm(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return const TransactionFormSheet();
      },
    );
  }
}
