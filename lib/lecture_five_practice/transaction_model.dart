enum TransactionType { income, expense }

class ExpenseTransaction {
  const ExpenseTransaction({
    required this.id,
    required this.title,
    required this.amount,
    required this.category,
    required this.type,
    required this.createdAt,
  });

  final String id;
  final String title;
  final double amount;
  final String category;
  final TransactionType type;
  final DateTime createdAt;

  ExpenseTransaction copyWith({
    String? id,
    String? title,
    double? amount,
    String? category,
    TransactionType? type,
    DateTime? createdAt,
  }) {
    return ExpenseTransaction(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}