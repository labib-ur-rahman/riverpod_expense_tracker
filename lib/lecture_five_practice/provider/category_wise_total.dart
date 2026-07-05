import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_expense_tracker/lecture_five_practice/provider/main_state_provider.dart';
import 'package:riverpod_expense_tracker/lecture_five_practice/transaction_model.dart';

/// -- food expense total provider -- ///
final foodExpenseTotalProvider = Provider<double>((ref) {
  final transactions = ref.watch(transactionListProvider);

  final foodExpenses = transactions.where((transaction) {
    return transaction.type == TransactionType.expense &&
        transaction.category == 'Food';
  });

  return foodExpenses.fold<double>(
    0,
    (total, transaction) => total + transaction.amount,
  );
});

/// -- all category expense summary provider -- ///
final categoryExpenseSummaryProvider = Provider<Map<String, double>>((ref) {
  final transactions = ref.watch(transactionListProvider);

  final Map<String, double> summary = {};

  for (final transaction in transactions) {
    if (transaction.type != TransactionType.expense) {
      continue;
    }

    final oldTotal = summary[transaction.category] ?? 0;

    summary[transaction.category] = oldTotal + transaction.amount;
  }

  return Map.unmodifiable(summary);
});