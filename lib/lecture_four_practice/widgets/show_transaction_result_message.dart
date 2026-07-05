import 'package:flutter/material.dart';
import 'package:riverpod_expense_tracker/lecture_four_practice/transaction_logic.dart';

void showTransactionResultMessage(
  BuildContext context,
  TransactionActionResult result,
  String successMessage,
) {
  final String message;
  final Color backgroundColor;

  switch (result) {
    case TransactionActionResult.success:
      message = successMessage;
      backgroundColor = Colors.green;

    case TransactionActionResult.invalidTitle:
      message = 'Title cannot be empty';
      backgroundColor = Colors.orange;

    case TransactionActionResult.invalidAmount:
      message = 'Amount must be greater than zero';
      backgroundColor = Colors.orange;

    case TransactionActionResult.transactionNotFound:
      message = 'Transaction not found';
      backgroundColor = Colors.red;
  }

  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(content: Text(message), backgroundColor: backgroundColor),
    );
}
