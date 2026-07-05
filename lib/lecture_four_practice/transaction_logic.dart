import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// -- Enum
enum TransactionType { income, expense }

enum TransactionActionResult {
  success,
  invalidTitle,
  invalidAmount,
  transactionNotFound,
}

/// -- Model
@immutable
class ExpenseTransaction {
  final String id;
  final String title;
  final double amount;
  final String category;
  final TransactionType type;
  final DateTime createdAt;

  const ExpenseTransaction({
    required this.id,
    required this.title,
    required this.amount,
    required this.category,
    required this.type,
    required this.createdAt,
  });

  ExpenseTransaction copyWith({
    String? id,
    String? title,
    double? amount,
    String? category,
    TransactionType? type,
    DateTime? date,
  }) {
    return ExpenseTransaction(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      type: type ?? this.type,
      createdAt: date ?? this.createdAt,
    );
  }
}

/// -- Transaction Provider
final transactionListProvider =
    NotifierProvider<TransactionListNotifier, List<ExpenseTransaction>>(
      TransactionListNotifier.new,
    );

class TransactionListNotifier extends Notifier<List<ExpenseTransaction>> {
  /// -- Build
  @override
  List<ExpenseTransaction> build() {
    return const [];
  }

  /// --  add transaction
  TransactionActionResult addTransaction({
    required String title,
    required double amount,
    required String category,
    required TransactionType type,
  }) {
    final cleanTitle = title.trim();

    if (cleanTitle.isEmpty) {
      return TransactionActionResult.invalidTitle;
    }

    if (amount <= 0) {
      return TransactionActionResult.invalidAmount;
    }

    final now = DateTime.now();

    final transaction = ExpenseTransaction(
      id: now.microsecondsSinceEpoch.toString(),
      title: cleanTitle,
      amount: amount,
      category: category,
      type: type,
      createdAt: now,
    );

    /// পুরোনো list থেকে নতুন list বানাও
    /// → তার শেষে নতুন transaction বসাও
    /// → তারপর state replace করো
    state = List.unmodifiable([...state, transaction]);

    return TransactionActionResult.success;
  }

  /// -- update transaction
  TransactionActionResult updateTransaction({
    required String id,
    required String title,
    required double amount,
    required String category,
    required TransactionType type,
  }) {
    final cleanTitle = title.trim();

    if (cleanTitle.isEmpty) {
      return TransactionActionResult.invalidTitle;
    }

    if (amount <= 0) {
      return TransactionActionResult.invalidAmount;
    }

    // Check if transaction exists, then take that transaction and update it
    final transactionExists = state.any((transaction) => transaction.id == id);

    if (!transactionExists) {
      return TransactionActionResult.transactionNotFound;
    }

    /// update existing transaction
    /// সব transaction loop করো
    /// যার ID match করে → তার updated copy রাখো
    /// যার ID match করে না → আগের transaction রাখো
    state = List.unmodifiable([
      for (final transaction in state)
        if (transaction.id == id)
          transaction.copyWith(
            title: cleanTitle,
            amount: amount,
            category: category,
            type: type,
          )
        else
          transaction,
    ]);

    return TransactionActionResult.success;
  }

  /// -- delete transaction
  TransactionActionResult deleteTransaction(String id) {
    /// check transaction is exist or not
    final transactionExists = state.any((transaction) => transaction.id == id);

    if (!transactionExists) {
      return TransactionActionResult.transactionNotFound;
    }

    /// update the state without the given id
    /// যে transaction-এর ID delete করতে চাই
    /// → সেটা বাদ দিয়ে নতুন list বানাও
    state = List.unmodifiable(
      state.where((transaction) => transaction.id != id),
    );

    return TransactionActionResult.success;
  }

  void clearTransactions() {
    state = const [];
  }
}

/// -- Total Income Provider
final totalIncomeProvider = Provider<double>((ref) {
  final transactions = ref.watch(transactionListProvider);

  return transactions
      .where((transaction) {
        return transaction.type == TransactionType.income;
      })
      .fold<double>(0, (total, transaction) {
        return total + transaction.amount;
      });
});

/// -- Total Expense Provider
final totalExpenseProvider = Provider<double>((ref) {
  final transactions = ref.watch(transactionListProvider);

  return transactions
      .where((transaction) {
        return transaction.type == TransactionType.expense;
      })
      .fold<double>(0, (total, transaction) {
        return total + transaction.amount;
      });
});

/// -- Current Balance Provider
final currentBalanceProvider = Provider<double>((ref) {
  final income = ref.watch(totalIncomeProvider);
  final expense = ref.watch(totalExpenseProvider);

  return income - expense;
});