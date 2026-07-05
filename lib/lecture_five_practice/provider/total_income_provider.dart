import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_expense_tracker/lecture_five_practice/provider/main_state_provider.dart';
import 'package:riverpod_expense_tracker/lecture_five_practice/transaction_model.dart';

/// -- total income provider -- ///
/// সব transaction নাও
/// শুধু income type filter করো
/// সব income amount যোগ করো

final totalIncomeProvider = Provider<double>((ref) {
  final transactions = ref.watch(transactionListProvider);

  final incomeTransactions = transactions.where((transaction) {
    return transaction.type == TransactionType.income;
  });

  final totalIncome = incomeTransactions.fold<double>(0, (total, transaction) {
    return total + transaction.amount;
  });

  return totalIncome;
});
