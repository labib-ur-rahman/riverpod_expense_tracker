import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_expense_tracker/lecture_five_practice/provider/main_state_provider.dart';
import 'package:riverpod_expense_tracker/lecture_five_practice/transaction_model.dart';

/// -- total expense provider -- ///
/// সব transaction নাও
/// শুধু expense type filter করো
/// সব expense amount যোগ করো
final totalExpenseProvider = Provider<double>((ref) {
  final transactions = ref.watch(transactionListProvider);

  final expenseTransactions = transactions.where((transaction) {
    return transaction.type == TransactionType.expense;
  });

  final totalExpense = expenseTransactions.fold<double>(0, (
    total,
    transaction,
  ) {
    return total + transaction.amount;
  });

  return totalExpense;
});
