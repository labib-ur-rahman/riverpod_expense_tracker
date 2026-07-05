import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_expense_tracker/app.dart';

void main() {
  runApp(ProviderScope(child: const ExpenseTrackerApp()));
}

/// Application Name provide kore
final appNameProvider = Provider<String>((ref) {
  return 'Expense Tracker';
});
