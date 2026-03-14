import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/constants/breakpoints.dart';

class SearchableDropdownFormField<T> extends FormField<T> {
  SearchableDropdownFormField({
    super.key,
    required this.items,
    this.onChanged,
    this.decoration = const InputDecoration(),
    this.hint,
    this.enabled = true,
    this.isExpanded = false,
    this.value,
    T? initialValue,
    this.validator,
    AutovalidateMode? autovalidateMode,
    this.searchHintText,
    this.noResultsText,
    this.itemLabelBuilder,
  }) : super(
          initialValue: value ?? initialValue,
          validator: validator,
          autovalidateMode: autovalidateMode,
          builder: (state) {
            return _SearchableDropdownFieldBody<T>(
              state: state,
              items: items,
              onChanged: onChanged,
              decoration: decoration,
              hint: hint,
              enabled: enabled,
              isExpanded: isExpanded,
              searchHintText: searchHintText,
              noResultsText: noResultsText,
              itemLabelBuilder: itemLabelBuilder,
            );
          },
        );

  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?>? onChanged;
  final InputDecoration decoration;
  final Widget? hint;
  final bool enabled;
  final bool isExpanded;
  final T? value;
  final FormFieldValidator<T>? validator;
  final String? searchHintText;
  final String? noResultsText;
  final String Function(DropdownMenuItem<T> item)? itemLabelBuilder;
}

class _SearchableDropdownFieldBody<T> extends StatelessWidget {
  const _SearchableDropdownFieldBody({
    required this.state,
    required this.items,
    required this.onChanged,
    required this.decoration,
    required this.hint,
    required this.enabled,
    required this.isExpanded,
    required this.searchHintText,
    required this.noResultsText,
    required this.itemLabelBuilder,
  });

  final FormFieldState<T> state;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?>? onChanged;
  final InputDecoration decoration;
  final Widget? hint;
  final bool enabled;
  final bool isExpanded;
  final String? searchHintText;
  final String? noResultsText;
  final String Function(DropdownMenuItem<T> item)? itemLabelBuilder;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveDecoration = decoration
        .applyDefaults(theme.inputDecorationTheme)
        .copyWith(errorText: state.errorText);
    final selectedItem = _findSelectedItem(state.value, items);
    final label = selectedItem == null
        ? null
        : _labelForItem(selectedItem, itemLabelBuilder);

    final displayChild = selectedItem?.child ?? hint ?? const SizedBox.shrink();

    return InkWell(
      onTap: enabled ? () => _openPicker(context) : null,
      borderRadius: BorderRadius.circular(12),
      child: InputDecorator(
        decoration: effectiveDecoration.copyWith(
          enabled: enabled,
          suffixIcon: effectiveDecoration.suffixIcon ??
              const Icon(Icons.arrow_drop_down),
        ),
        isEmpty: label == null || label.isEmpty,
        child: DefaultTextStyle.merge(
          style: theme.textTheme.bodyMedium,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isExpanded) Expanded(child: displayChild) else displayChild,
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _openPicker(BuildContext context) async {
    final result = await _showPicker(context);
    if (result is _DropdownSelection<T>) {
      state.didChange(result.value);
      onChanged?.call(result.value);
    }
  }

  Future<Object?> _showPicker(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final useBottomSheet = width < Breakpoints.sm;
    if (useBottomSheet) {
      return showModalBottomSheet<Object?>(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        showDragHandle: true,
        backgroundColor: Theme.of(context).colorScheme.surface,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        builder: (sheetContext) => _PickerSheet<T>(
          items: items,
          selectedValue: state.value,
          title: decoration.labelText,
          searchHintText: searchHintText,
          noResultsText: noResultsText,
          itemLabelBuilder: itemLabelBuilder,
        ),
      );
    }

    return showDialog<Object?>(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          insetPadding:
              const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520, maxHeight: 560),
            child: _PickerSheet<T>(
              items: items,
              selectedValue: state.value,
              title: decoration.labelText,
              searchHintText: searchHintText,
              noResultsText: noResultsText,
              itemLabelBuilder: itemLabelBuilder,
            ),
          ),
        );
      },
    );
  }
}

class _PickerSheet<T> extends StatefulWidget {
  const _PickerSheet({
    required this.items,
    required this.selectedValue,
    required this.title,
    required this.searchHintText,
    required this.noResultsText,
    required this.itemLabelBuilder,
  });

  final List<DropdownMenuItem<T>> items;
  final T? selectedValue;
  final String? title;
  final String? searchHintText;
  final String? noResultsText;
  final String Function(DropdownMenuItem<T> item)? itemLabelBuilder;

  @override
  State<_PickerSheet<T>> createState() => _PickerSheetState<T>();
}

class _PickerSheetState<T> extends State<_PickerSheet<T>> {
  final TextEditingController _controller = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final filtered = widget.items.where((item) {
      final label = _labelForItem(item, widget.itemLabelBuilder);
      if (_query.isEmpty) return true;
      return label.toLowerCase().contains(_query.toLowerCase());
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 8, 8),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  widget.title ?? '请选择',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              IconButton(
                tooltip: '关闭',
                onPressed: () => Navigator.of(context).maybePop(),
                icon: const Icon(Icons.close),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          child: TextField(
            controller: _controller,
            decoration: InputDecoration(
              hintText: widget.searchHintText ?? '搜索',
              prefixIcon: const Icon(Icons.search),
              isDense: true,
              border: const OutlineInputBorder(),
            ),
            onChanged: (value) => setState(() => _query = value.trim()),
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: filtered.isEmpty
              ? Center(
                  child: Text(
                    widget.noResultsText ?? '无匹配结果',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.hintColor,
                    ),
                  ),
                )
              : ListView.separated(
                  itemCount: filtered.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final item = filtered[index];
                    final isSelected = item.value == widget.selectedValue;
                    final isEnabled = item.enabled;
                    return ListTile(
                      dense: true,
                      enabled: isEnabled,
                      title: DefaultTextStyle.merge(
                        style: theme.textTheme.bodyMedium,
                        child: item.child,
                      ),
                      trailing: isSelected
                          ? Icon(
                              Icons.check,
                              size: 18,
                              color: theme.colorScheme.primary,
                            )
                          : null,
                      onTap: isEnabled
                          ? () => Navigator.of(context)
                              .pop(_DropdownSelection<T>(item.value))
                          : null,
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class _DropdownSelection<T> {
  const _DropdownSelection(this.value);

  final T? value;
}

DropdownMenuItem<T>? _findSelectedItem<T>(
  T? value,
  List<DropdownMenuItem<T>> items,
) {
  for (final item in items) {
    if (item.value == value) return item;
  }
  return null;
}

String _labelForItem<T>(
  DropdownMenuItem<T> item,
  String Function(DropdownMenuItem<T> item)? itemLabelBuilder,
) {
  if (itemLabelBuilder != null) {
    return itemLabelBuilder(item);
  }
  final child = item.child;
  if (child is Text) {
    final data = child.data;
    if (data != null && data.trim().isNotEmpty) return data;
    final span = child.textSpan?.toPlainText();
    if (span != null && span.trim().isNotEmpty) return span;
  }
  final valueText = item.value?.toString() ?? '';
  return valueText.trim().isNotEmpty ? valueText : '';
}
