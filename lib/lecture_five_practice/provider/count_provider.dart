import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_expense_tracker/lecture_five_practice/provider/main_state_provider.dart';
import 'package:riverpod_expense_tracker/lecture_five_practice/transaction_model.dart';

/// -- transaction count provider -- ///
final transactionCountProvider = Provider<int>((ref) {
  final transactions = ref.watch(transactionListProvider);

  return transactions.length;
});

/// --- income transaction count provider -- ///
final incomeCountProvider = Provider<int>((ref) {
  final transactions = ref.watch(transactionListProvider);

  return transactions.where((transaction) {
    return transaction.type == TransactionType.income;
  }).length;
});

/// --- expense transaction count provider -- ///
final expenseCountProvider = Provider<int>((ref) {
  final transactions = ref.watch(transactionListProvider);

  return transactions.where((transaction) {
    return transaction.type == TransactionType.expense;
  }).length;
});
