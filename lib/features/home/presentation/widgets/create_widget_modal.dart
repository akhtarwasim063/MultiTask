import 'package:flutter/material.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../domain/entities/custom_widget_entity.dart';

class CreateWidgetModal extends StatefulWidget {
  final Function(CustomWidgetEntity) onCreated;

  const CreateWidgetModal({super.key, required this.onCreated});

  static void show(BuildContext context, Function(CustomWidgetEntity) onCreated) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CreateWidgetModal(onCreated: onCreated),
    );
  }

  @override
  State<CreateWidgetModal> createState() => _CreateWidgetModalState();
}

class _CreateWidgetModalState extends State<CreateWidgetModal> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController(text: 'My Custom Widget');
  final _detailController = TextEditingController(text: 'https://api.github.com/zen');
  CustomWidgetType _selectedType = CustomWidgetType.customApiCard;

  @override
  void dispose() {
    _titleController.dispose();
    _detailController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      final id = 'widget_${DateTime.now().millisecondsSinceEpoch}';
      final Map<String, dynamic> config = {};

      if (_selectedType == CustomWidgetType.customApiCard) {
        config['url'] = _detailController.text.trim();
        config['note'] = 'Custom REST API integration card.';
      } else if (_selectedType == CustomWidgetType.quickNote) {
        config['content'] = _detailController.text.trim();
      }

      final entity = CustomWidgetEntity(
        id: id,
        title: _titleController.text.trim(),
        type: _selectedType,
        config: config,
        isVisible: true,
      );

      widget.onCreated(entity);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.only(
        top: 24,
        left: 24,
        right: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF131722) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.dashboard_customize_rounded, color: colorScheme.primary, size: 22),
                      const SizedBox(width: 8),
                      Text(
                        context.tr('create_widget_btn'),
                        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Widget Type Picker
              const Text('Select Widget Type', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ChoiceChip(
                    label: const Text('REST API Card'),
                    selected: _selectedType == CustomWidgetType.customApiCard,
                    onSelected: (_) {
                      setState(() {
                        _selectedType = CustomWidgetType.customApiCard;
                        _detailController.text = 'https://api.github.com/zen';
                      });
                    },
                  ),
                  ChoiceChip(
                    label: const Text('Quick Note / Objective'),
                    selected: _selectedType == CustomWidgetType.quickNote,
                    onSelected: (_) {
                      setState(() {
                        _selectedType = CustomWidgetType.quickNote;
                        _detailController.text = 'Sprint 42: Deploy multi-API resilience policies.';
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Title input
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Widget Title',
                  prefixIcon: Icon(Icons.title_rounded),
                ),
                validator: (val) => (val == null || val.trim().isEmpty) ? 'Please enter a title' : null,
              ),
              const SizedBox(height: 14),

              // Details input
              TextFormField(
                controller: _detailController,
                maxLines: _selectedType == CustomWidgetType.quickNote ? 3 : 1,
                decoration: InputDecoration(
                  labelText: _selectedType == CustomWidgetType.customApiCard
                      ? 'Endpoint URL'
                      : 'Note / Objective Body',
                  prefixIcon: Icon(_selectedType == CustomWidgetType.customApiCard
                      ? Icons.link_rounded
                      : Icons.notes_rounded),
                ),
                validator: (val) => (val == null || val.trim().isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 24),

              ElevatedButton.icon(
                onPressed: _submit,
                icon: const Icon(Icons.add_rounded),
                label: Text(context.tr('create')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
