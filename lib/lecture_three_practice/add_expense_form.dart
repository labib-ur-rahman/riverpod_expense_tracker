import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_expense_tracker/lecture_three_practice/lecture_three_practice_screen.dart';

class AddExpenseForm extends ConsumerStatefulWidget {
  const AddExpenseForm({super.key});

  @override
  ConsumerState<AddExpenseForm> createState() => _AddExpenseFormState();
}

class _AddExpenseFormState extends ConsumerState<AddExpenseForm> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _amountController;
  late final FocusNode _amountFocusNode;

  String _selectedCategory = 'Food';

  static const List<String> _categories = ['Food', 'Transport', 'Shopping'];

  @override
  void initState() {
    super.initState();

    debugPrint('AddExpenseForm initState called');

    _amountController = TextEditingController();
    _amountFocusNode = FocusNode();
  }

  @override
  void dispose() {
    debugPrint('AddExpenseForm dispose called');

    _amountController.dispose();
    _amountFocusNode.dispose();

    super.dispose();
  }

  void _submitExpense() {
    debugPrint(' ----- Submit button clicked');

    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }

    final amount = double.parse(_amountController.text.trim());

    ref.read(dailyExpenseProvider.notifier).addExpense(amount);

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            '৳${amount.toStringAsFixed(0)} '
            'added to $_selectedCategory',
          ),
        ),
      );

    _amountController.clear();
    _amountFocusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint(' ----- AddExpenseForm rebuilt');

    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _amountController,
            focusNode: _amountFocusNode,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            textInputAction: TextInputAction.done,
            decoration: const InputDecoration(
              labelText: 'Amount',
              prefixText: '৳ ',
              hintText: 'Enter amount (e.g., 120.5)',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              final amount = double.tryParse(value?.trim() ?? '');

              if (amount == null) {
                return 'Enter a valid amount';
              }

              if (amount <= 0) {
                return 'Amount must be greater than zero';
              }

              return null;
            },
            onChanged: (_) {
              debugPrint(' ----- TextField changes');
            },
            onTap: () {
              debugPrint(' ----- TextField tapped');
            },
            onFieldSubmitted: (_) {
              debugPrint(' ----- TextField submit');
              _submitExpense();
            },
          ),
          const SizedBox(height: 16),

          const Text(
            'Select Category',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),

          Wrap(
            spacing: 8,
            children: _categories.map((category) {
              debugPrint(' ----- ChoiceChip rebuilt');

              return ChoiceChip(
                label: Text(category),
                selected: _selectedCategory == category,
                onSelected: (_) {
                  setState(() {
                    _selectedCategory = category;
                  });
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 20),

          FilledButton(
            onPressed: _submitExpense,
            child: const Text('Add Expense'),
          ),
        ],
      ),
    );
  }
}
