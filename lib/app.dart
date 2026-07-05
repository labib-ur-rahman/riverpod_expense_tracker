import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_expense_tracker/lecture_four_practice/transaction_screen.dart';
import 'package:riverpod_expense_tracker/main.dart';

class ExpenseTrackerApp extends ConsumerWidget {
  const ExpenseTrackerApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appName = ref.watch(appNameProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: appName,
      home: const TransactionListScreen(),
    );
  }
}
