import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_expense_tracker/lecture_four_practice/widgets/show_transaction_result_message.dart';
import 'package:riverpod_expense_tracker/lecture_four_practice/transaction_logic.dart';

class TransactionFormSheet extends ConsumerStatefulWidget {
  const TransactionFormSheet({super.key, this.transaction});

  final ExpenseTransaction? transaction;

  bool get isEditing => transaction != null;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _TransactionFormSheetState();
}

class _TransactionFormSheetState extends ConsumerState<TransactionFormSheet> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _titleController;
  late final TextEditingController _amountController;
  late final FocusNode _titleFocusNode;

  TransactionType _selectedType = TransactionType.expense;
  String _selectedCategory = 'Food';

  static const List<String> _categories = [
    'Food',
    'Transport',
    'Shopping',
    'Salary',
    'Other',
  ];

  /// -- Initialize all the state variables here -- ///
  @override
  void initState() {
    super.initState();

    final transaction = widget.transaction;

    _titleController = TextEditingController(text: transaction?.title ?? '');

    _amountController = TextEditingController(
      text: transaction?.amount.toStringAsFixed(0) ?? '',
    );

    _titleFocusNode = FocusNode();

    final transactionCategory = transaction?.category;

    if (transactionCategory != null &&
        _categories.contains(transactionCategory)) {
      _selectedCategory = transactionCategory;
    }
  }

  /// -- Dispose all the state variables here -- ///
  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _titleFocusNode.dispose();

    super.dispose();
  }

  /// -- Submit handler -- ///
  void _submit() {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }

    final title = _titleController.text.trim();
    final amount = double.parse(_amountController.text.trim());
    final notifier = ref.read(transactionListProvider.notifier);

    final TransactionActionResult result;

    if (widget.isEditing) {
      result = notifier.updateTransaction(
        id: widget.transaction!.id,
        title: title,
        amount: amount,
        category: _selectedCategory,
        type: _selectedType,
      );
    } else {
      result = notifier.addTransaction(
        title: title,
        amount: amount,
        category: _selectedCategory,
        type: _selectedType,
      );
    }

    final successMessage = widget.isEditing
        ? 'Transaction updated'
        : 'Transaction added';

    showTransactionResultMessage(context, result, successMessage);

    if (result == TransactionActionResult.success) {
      Navigator.of(context).pop();
    }
  }

  /// -- Build UI here -- ///
  @override
  Widget build(BuildContext context) {
    debugPrint('TransactionFormSheet rebuilt');

    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                widget.isEditing ? 'Edit Transaction' : 'Add Transaction',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              TextFormField(
                controller: _titleController,
                focusNode: _titleFocusNode,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  final title = value?.trim() ?? '';

                  if (title.isEmpty) {
                    return 'Title is required';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _amountController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Amount',
                  prefixText: '৳ ',
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
              ),

              const SizedBox(height: 20),

              const Text(
                'Transaction Type',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 8),

              Wrap(
                spacing: 8,
                children: [
                  ChoiceChip(
                    label: const Text('Expense'),
                    selected: _selectedType == TransactionType.expense,
                    onSelected: (_) {
                      setState(() {
                        _selectedType = TransactionType.expense;
                      });
                    },
                  ),
                  ChoiceChip(
                    label: const Text('Income'),
                    selected: _selectedType == TransactionType.income,
                    onSelected: (_) {
                      setState(() {
                        _selectedType = TransactionType.income;
                      });
                    },
                  ),
                ],
              ),

              const SizedBox(height: 20),

              const Text(
                'Category',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 8),

              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _categories.map((category) {
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

              const SizedBox(height: 24),

              FilledButton(
                onPressed: _submit,
                child: Text(
                  widget.isEditing ? 'Update Transaction' : 'Add Transaction',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
