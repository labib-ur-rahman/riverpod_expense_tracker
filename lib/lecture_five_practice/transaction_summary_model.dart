class TransactionSummary {
  const TransactionSummary({
    required this.totalIncome,
    required this.totalExpense,
    required this.currentBalance,
    required this.transactionCount,
  });

  final double totalIncome;
  final double totalExpense;
  final double currentBalance;
  final int transactionCount;
}