import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Mutable monthly expense limit manage korbe
/// `MonthlyExpenseLimitNotifier` → State পরিবর্তনের logic রাখে
/// `double` → State-এর value কোন type-এর

final monthlyExpenseLimitProvider =
    NotifierProvider<MonthlyExpenseLimitNotifier, double>(
      MonthlyExpenseLimitNotifier.new,
    );

/// State → double
/// Modifier → increaseLimit(), decreaseLimit(), resetLimit()

class MonthlyExpenseLimitNotifier extends Notifier<double> {
  ///  Notifier তৈরি হলো
  ///     ↓
  ///  build() execute হলো
  ///     ↓
  ///  Initial state = 30000

  @override
  double build() {
    return 30000.00;
  }

  /// State পরিবর্তিত হলে Riverpod যারা provider-টি watch করছে তাদের notify করে।

  void increaseLimit() {
    state = state + 5000;
  }

  void decreaseLimit() {
    if (state <= 5000) return;

    state = state - 5000;
  }

  void resetLimit() {
    state = 30000.00;
  }
}

class ExpenseLimitScreen extends ConsumerWidget {
  const ExpenseLimitScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    debugPrint('ExpenseLimitScreen rebuilded -------------------');

    /// Watch:
    /// Limit change hole widget rebuild hobe
    /// এর অর্থ: Provider-এর বর্তমান value দাও এবং value পরিবর্তিত হলে এই widget আবার build করো।
    final expenseLimit = ref.watch(monthlyExpenseLimitProvider);

    /// Listen:
    /// Limit change hole callback execute hobe
    ref.listen<double>(monthlyExpenseLimitProvider, (previousLimit, newLimit) {
      debugPrint('----- Previous Limit: $previousLimit');
      debugPrint('----- New Limit: $newLimit');

      if (previousLimit == null) {
        return;
      }

      final difference = newLimit - previousLimit;

      final message = difference > 0
          ? 'Expense limit increased by '
                '৳${difference.toStringAsFixed(0)}'
          : 'Expense limit decreased by '
                '৳${difference.abs().toStringAsFixed(0)}';

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(message)));
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Expense Limit')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Read Value : ${ref.read(monthlyExpenseLimitProvider).toStringAsFixed(0)}',
                style: TextStyle(fontSize: 20, color: Colors.grey),
              ),
              const SizedBox(height: 12),

              const Text(
                'Monthly Expense Limit',
                style: TextStyle(fontSize: 20, color: Colors.grey),
              ),

              const SizedBox(height: 12),
              Text(
                '৳${expenseLimit.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                alignment: WrapAlignment.center,
                children: [
                  /// ref.read():
                  /// এর অর্থ: Provider-এর বর্তমান value শুধু নাও, কিন্তু value পরিবর্তিত হলে এই widget আবার build করো না।

                  /// এখানে, button press করলে provider-এর state change হবে।
                  ///
                  /// কিন্তু, Button-টি কিন্তু provider watch করছে না।
                  /// তাই, state পরিবর্তন হলেও Button নিজে rebuild হবে না।
                  ElevatedButton(
                    onPressed: () {
                      ref
                          .read(monthlyExpenseLimitProvider.notifier)
                          .decreaseLimit();
                      debugPrint('Decrease clicked');
                    },
                    child: Text(
                      'Decrease ৳5,000 (${ref.read(monthlyExpenseLimitProvider).toStringAsFixed(0)})',
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      /// `provider` → State পাওয়া যায়
                      /// `provider.notifier` → State পরিবর্তনের controller পাওয়া যায়

                      ref
                          .read(monthlyExpenseLimitProvider.notifier)
                          .increaseLimit();
                      debugPrint('Increase clicked');
                    },
                    child: Text(
                      'Increase ৳5,000 (${ref.read(monthlyExpenseLimitProvider).toStringAsFixed(0)})',
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),
              TextButton(
                onPressed: () {
                  ref.read(monthlyExpenseLimitProvider.notifier).resetLimit();
                  debugPrint('Reset clicked');
                },
                child: Text(
                  'Reset Limit (${ref.read(monthlyExpenseLimitProvider).toStringAsFixed(0)})',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
