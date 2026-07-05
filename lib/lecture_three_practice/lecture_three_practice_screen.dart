import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_expense_tracker/lecture_three_practice/add_expense_form.dart';
import 'package:riverpod_expense_tracker/lecture_three_practice/expense_summary_card.dart';
import 'package:riverpod_expense_tracker/lecture_three_practice/reset_expense_section.dart';

/// Daily expense limit read-only value।
final dailyLimitProvider = Provider<double>((ref) {
  return 2000;
});

/// Daily expense mutable business state।
final dailyExpenseProvider = NotifierProvider<DailyExpenseNotifier, double>(
  DailyExpenseNotifier.new,
);

class DailyExpenseNotifier extends Notifier<double> {
  @override
  double build() {
    return 0;
  }

  void addExpense(double amount) {
    if (amount <= 0) {
      return;
    }

    state = state + amount;
  }

  void resetExpense() {
    state = 0;
  }
}

/// Limit এবং expense থেকে calculated state।
final dailyRemainingProvider = Provider<double>((ref) {
  final limit = ref.watch(dailyLimitProvider);
  final expense = ref.watch(dailyExpenseProvider);

  return limit - expense;
});

/// এই parent widget কোনো provider ব্যবহার করছে না।
class ExpenseTrackerScreen extends StatelessWidget {
  const ExpenseTrackerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Expense Tracker')),
      body: const SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              ExpenseSummaryCard(),
              SizedBox(height: 24),
              AddExpenseForm(),
              SizedBox(height: 24),
              ResetExpenseSection(),
            ],
          ),
        ),
      ),
    );
  }
}
