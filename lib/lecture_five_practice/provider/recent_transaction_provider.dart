import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_expense_tracker/lecture_five_practice/provider/main_state_provider.dart';
import 'package:riverpod_expense_tracker/lecture_five_practice/transaction_model.dart';

/// -- recent transactions provider -- ///
final recentTransactionsProvider = Provider<List<ExpenseTransaction>>((ref) {
  final transactions = ref.watch(transactionListProvider);

  // first 5 transactions
  return transactions.take(5).toList(growable: false);
});

/// -- recent income transactions provider -- ///
final recentIncomeTransactionsProvider = Provider<List<ExpenseTransaction>>((ref) {
  final transactions = ref.watch(transactionListProvider);

  // first 5 income transactions
  return transactions.where((transaction) {
    return transaction.type == TransactionType.income;
  }).take(5).toList(growable: false);
});

/// -- recent expense transactions provider -- ///
final recentExpenseTransactionsProvider = Provider<List<ExpenseTransaction>>((ref) {
  final transactions = ref.watch(transactionListProvider);

  // first 5 expense transactions
  return transactions.where((transaction) {
    return transaction.type == TransactionType.expense;
  }).take(5).toList(growable: false);
});
