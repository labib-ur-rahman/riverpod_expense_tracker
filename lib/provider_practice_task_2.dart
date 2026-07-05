import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// দৈনিক সর্বোচ্চ expense limit।
final dailyLimitProvider = Provider<double>((ref) {
  return 2000;
});

/// দৈনিক expense state manage করবে।
final dailyExpenseProvider = NotifierProvider<DailyExpenseNotifier, double>(
  DailyExpenseNotifier.new,
);

class DailyExpenseNotifier extends Notifier<double> {
  @override
  double build() {
    return 0;
  }

  void addExpense(double amount) {
    if (amount <= 0) {
      return;
    }

    state = state + amount;
  }

  void resetExpense() {
    state = 0;
  }
}

/// Daily limit এবং expense থেকে remaining amount calculate করবে।
final dailyRemainingProvider = Provider<double>((ref) {
  final limit = ref.watch(dailyLimitProvider);
  final expense = ref.watch(dailyExpenseProvider);

  return limit - expense;
});

class LectureTwoPractice extends ConsumerWidget {
  const LectureTwoPractice({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    debugPrint('LectureTwoPractice rebuilt -------------------');

    final expense = ref.watch(dailyExpenseProvider);
    final limit = ref.watch(dailyLimitProvider);
    final remainingAmount = ref.watch(dailyRemainingProvider);

    ref.listen<double>(dailyExpenseProvider, (previousExpense, nextExpense) {
      debugPrint('Previous Expense: $previousExpense');
      debugPrint('New Expense: $nextExpense');

      if (nextExpense == limit) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            const SnackBar(
              content: Text('You have reached today\'s limit'),
              backgroundColor: Colors.orangeAccent,
            ),
          );
      } else if (nextExpense > limit) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            const SnackBar(
              content: Text('Warning! You exceeded today\'s limit'),
              backgroundColor: Colors.red,
            ),
          );
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Daily Expense Counter')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Today\'s Expense: '
                '৳${expense.toStringAsFixed(0)}',
                style: const TextStyle(fontSize: 20, color: Colors.grey),
              ),
              const SizedBox(height: 12),
              Text(
                'Daily Limit: '
                '৳${limit.toStringAsFixed(0)}',
                style: const TextStyle(fontSize: 20, color: Colors.grey),
              ),
              const SizedBox(height: 12),
              Text(
                'Remaining Amount: '
                '৳${remainingAmount.toStringAsFixed(0)}',
                style: TextStyle(
                  fontSize: 20,
                  color: remainingAmount < 0 ? Colors.red : Colors.grey,
                ),
              ),
              const SizedBox(height: 24),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                alignment: WrapAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      ref.read(dailyExpenseProvider.notifier).addExpense(100);
                    },
                    child: const Text('Add ৳100'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      ref.read(dailyExpenseProvider.notifier).addExpense(500);
                    },
                    child: const Text('Add ৳500'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      ref.read(dailyExpenseProvider.notifier).resetExpense();
                    },
                    child: const Text('Reset'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
