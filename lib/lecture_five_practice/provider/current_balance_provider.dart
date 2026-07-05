import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_expense_tracker/lecture_five_practice/provider/total_expense_provider.dart';
import 'package:riverpod_expense_tracker/lecture_five_practice/provider/total_income_provider.dart';

/// -- current balance provider -- ///

final currentBalanceProvider = Provider<double>((ref) {
  final income = ref.watch(totalIncomeProvider);
  final expense = ref.watch(totalExpenseProvider);

  return income - expense;
});
