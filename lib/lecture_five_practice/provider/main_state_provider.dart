import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_expense_tracker/lecture_five_practice/transaction_model.dart';

final transactionListProvider =
    NotifierProvider<TransactionListNotifier, List<ExpenseTransaction>>(
      TransactionListNotifier.new,
    );

class TransactionListNotifier extends Notifier<List<ExpenseTransaction>> {

  /// -- build state -- ///
  @override
  List<ExpenseTransaction> build() {
    return const [];
  }

  /// -- add transaction -- ///
  void addTransaction(ExpenseTransaction transaction) {
    state = List.unmodifiable([transaction, ...state]);
  }

  /// -- delete transaction -- ///
  void deleteTransaction(String id) {
    state = List.unmodifiable(
      state.where((transaction) => transaction.id != id),
    );
  }

  /// -- clear transactions -- ///
  void clearTransactions() {
    state = const [];
  }
}