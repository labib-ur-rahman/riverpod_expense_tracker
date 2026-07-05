import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_expense_tracker/lecture_five_practice/provider/count_provider.dart';
import 'package:riverpod_expense_tracker/lecture_five_practice/provider/current_balance_provider.dart';
import 'package:riverpod_expense_tracker/lecture_five_practice/provider/total_expense_provider.dart';
import 'package:riverpod_expense_tracker/lecture_five_practice/provider/total_income_provider.dart';

import '../transaction_summary_model.dart';

/// -- transaction summary provider -- ///
final transactionSummaryProvider = Provider<TransactionSummary>((ref) {
  final income = ref.watch(totalIncomeProvider);
  final expense = ref.watch(totalExpenseProvider);
  final balance = ref.watch(currentBalanceProvider);
  final count = ref.watch(transactionCountProvider);

  return TransactionSummary(
    totalIncome: income,
    totalExpense: expense,
    currentBalance: balance,
    transactionCount: count,
  );
});
