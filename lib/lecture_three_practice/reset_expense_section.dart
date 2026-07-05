import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_expense_tracker/lecture_three_practice/lecture_three_practice_screen.dart';

class ResetExpenseSection extends StatelessWidget {
  const ResetExpenseSection({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint('ResetExpenseSection parent built');

    return Consumer(
      child: const Icon(Icons.restart_alt),
      builder: (context, ref, child) {
        debugPrint('Reset button Consumer rebuilt');

        final expense = ref.watch(dailyExpenseProvider);

        return OutlinedButton.icon(
          onPressed: expense == 0
              ? null
              : () {
                  ref.read(dailyExpenseProvider.notifier).resetExpense();
                },
          icon: child!,
          label: const Text('Reset Expense'),
        );
      },
    );
  }
}
