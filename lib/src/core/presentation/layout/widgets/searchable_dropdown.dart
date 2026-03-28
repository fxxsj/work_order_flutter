import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/constants/breakpoints.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';

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

class _SearchableDropdownFieldBody<T> extends StatefulWidget {
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
  State<_SearchableDropdownFieldBody<T>> createState() =>
      _SearchableDropdownFieldBodyState<T>();
}

class _SearchableDropdownFieldBodyState<T>
    extends State<_SearchableDropdownFieldBody<T>> {
  static const double _desktopMaxHeight = 420;
  static const double _desktopViewportMargin = LayoutTokens.gapLg;
  static const double _desktopPopoverGap = 0;

  final GlobalKey _fieldKey = GlobalKey();
  OverlayEntry? _overlayEntry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final useDesktopPopover =
        MediaQuery.sizeOf(context).width >= Breakpoints.sm;
    final effectiveDecoration = widget.decoration
        .applyDefaults(theme.inputDecorationTheme)
        .copyWith(errorText: widget.state.errorText);
    final selectedItem = _findSelectedItem(widget.state.value, widget.items);
    final label = selectedItem == null
        ? null
        : _labelForItem(selectedItem, widget.itemLabelBuilder);
    final displayChild =
        selectedItem?.child ?? widget.hint ?? const SizedBox.shrink();

    return InkWell(
      key: _fieldKey,
      onTap: widget.enabled ? () => _openPicker(context) : null,
      borderRadius: BorderRadius.circular(LayoutTokens.radiusSm),
      child: InputDecorator(
        decoration: effectiveDecoration.copyWith(
          enabled: widget.enabled,
          suffixIcon: effectiveDecoration.suffixIcon ??
              Icon(
                useDesktopPopover && _overlayEntry != null
                    ? Icons.arrow_drop_up
                    : Icons.arrow_drop_down,
              ),
        ),
        isEmpty: label == null || label.isEmpty,
        child: DefaultTextStyle.merge(
          style: theme.textTheme.bodyMedium,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.isExpanded)
                Expanded(child: displayChild)
              else
                displayChild,
            ],
          ),
        ),
      ),
    );
  }

  @override
  void didUpdateWidget(covariant _SearchableDropdownFieldBody<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!widget.enabled) {
      _removeOverlay();
    }
  }

  @override
  void dispose() {
    _removeOverlay();
    super.dispose();
  }

  Future<void> _openPicker(BuildContext context) async {
    if (MediaQuery.sizeOf(context).width < Breakpoints.sm) {
      final result = await _showMobileSheet(context);
      if (result is _DropdownSelection<T>) {
        _applySelection(result.value);
      }
      return;
    }

    if (_overlayEntry != null) {
      _removeOverlay();
      return;
    }

    _showDesktopPopover(context);
  }

  Future<Object?> _showMobileSheet(BuildContext context) {
    return showModalBottomSheet<Object?>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      builder: (sheetContext) => _PickerSheet<T>(
        items: widget.items,
        selectedValue: widget.state.value,
        title: widget.decoration.labelText,
        searchHintText: widget.searchHintText,
        noResultsText: widget.noResultsText,
        itemLabelBuilder: widget.itemLabelBuilder,
      ),
    );
  }

  void _showDesktopPopover(BuildContext context) {
    final overlayState = Overlay.of(context, rootOverlay: true);
    final fieldContext = _fieldKey.currentContext;
    final fieldBox = fieldContext?.findRenderObject() as RenderBox?;
    if (fieldBox == null || !fieldBox.hasSize) {
      return;
    }

    final mediaQuery = MediaQuery.of(context);
    final origin = fieldBox.localToGlobal(Offset.zero);
    final fieldRect = Rect.fromLTWH(
      origin.dx,
      origin.dy,
      fieldBox.size.width,
      fieldBox.size.height,
    );

    final availableWidth = mediaQuery.size.width - (_desktopViewportMargin * 2);
    final popoverWidth = math.min(fieldRect.width, availableWidth);
    final safeTop = mediaQuery.padding.top + _desktopViewportMargin;
    final safeBottom = mediaQuery.size.height -
        mediaQuery.padding.bottom -
        _desktopViewportMargin;
    final spaceBelow = safeBottom - fieldRect.bottom - _desktopPopoverGap;
    final spaceAbove = fieldRect.top - safeTop - _desktopPopoverGap;
    final openAbove = spaceBelow < 220 && spaceAbove > spaceBelow;
    final popoverMaxHeight = math.min(
      _desktopMaxHeight,
      math.max(200.0, openAbove ? spaceAbove : spaceBelow),
    );
    final popoverLeft = fieldRect.left.clamp(
      _desktopViewportMargin,
      mediaQuery.size.width - _desktopViewportMargin - popoverWidth,
    );
    final popoverTop = openAbove
        ? fieldRect.top - popoverMaxHeight - _desktopPopoverGap
        : fieldRect.bottom + _desktopPopoverGap;

    _overlayEntry = OverlayEntry(
      builder: (overlayContext) {
        return Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: _removeOverlay,
                child: const SizedBox.expand(),
              ),
            ),
            Positioned(
              left: popoverLeft.toDouble(),
              top: popoverTop,
              width: popoverWidth,
              child: Material(
                color: Colors.transparent,
                child: _PickerPopover<T>(
                  items: widget.items,
                  selectedValue: widget.state.value,
                  searchHintText: widget.searchHintText,
                  noResultsText: widget.noResultsText,
                  itemLabelBuilder: widget.itemLabelBuilder,
                  maxListHeight: popoverMaxHeight,
                  onSelected: _applySelection,
                ),
              ),
            ),
          ],
        );
      },
    );

    overlayState.insert(_overlayEntry!);
    if (mounted) {
      setState(() {});
    }
  }

  void _applySelection(T? value) {
    widget.state.didChange(value);
    widget.onChanged?.call(value);
    _removeOverlay();
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    if (mounted) {
      setState(() {});
    }
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
    final filtered = _filterItems(
      widget.items,
      _query,
      widget.itemLabelBuilder,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(
            LayoutTokens.gapLg,
            LayoutTokens.gapMd,
            LayoutTokens.gapSm,
            LayoutTokens.gapSm,
          ),
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
          padding: EdgeInsets.fromLTRB(
            LayoutTokens.gapLg,
            0,
            LayoutTokens.gapLg,
            LayoutTokens.gapMd,
          ),
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
          child: _PickerResultsList<T>(
            items: filtered,
            selectedValue: widget.selectedValue,
            noResultsText: widget.noResultsText,
            onSelected: (value) =>
                Navigator.of(context).pop(_DropdownSelection<T>(value)),
          ),
        ),
      ],
    );
  }
}

class _PickerPopover<T> extends StatefulWidget {
  const _PickerPopover({
    required this.items,
    required this.selectedValue,
    required this.searchHintText,
    required this.noResultsText,
    required this.itemLabelBuilder,
    required this.maxListHeight,
    required this.onSelected,
  });

  final List<DropdownMenuItem<T>> items;
  final T? selectedValue;
  final String? searchHintText;
  final String? noResultsText;
  final String Function(DropdownMenuItem<T> item)? itemLabelBuilder;
  final double maxListHeight;
  final ValueChanged<T?> onSelected;

  @override
  State<_PickerPopover<T>> createState() => _PickerPopoverState<T>();
}

class _PickerPopoverState<T> extends State<_PickerPopover<T>> {
  static const double _resultRowHeight = 48;
  static const double _emptyStateHeight = 88;

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
    final filtered = _filterItems(
      widget.items,
      _query,
      widget.itemLabelBuilder,
    );
    final estimatedListHeight = filtered.isEmpty
        ? _emptyStateHeight
        : math.min(
            widget.maxListHeight, filtered.length * _resultRowHeight + 1);

    return Material(
      color: theme.colorScheme.surface,
      elevation: 12,
      shadowColor: theme.shadowColor.withValues(alpha: 0.14),
      borderRadius: BorderRadius.circular(LayoutTokens.radiusSm),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(LayoutTokens.radiusSm),
          border: Border.all(color: theme.dividerColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                LayoutTokens.gapMd,
                LayoutTokens.gapMd,
                LayoutTokens.gapMd,
                LayoutTokens.gapSm,
              ),
              child: TextField(
                controller: _controller,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: widget.searchHintText ?? '搜索',
                  prefixIcon: const Icon(Icons.search),
                  isDense: true,
                  border: const OutlineInputBorder(),
                ),
                onChanged: (value) => setState(() => _query = value.trim()),
              ),
            ),
            ConstrainedBox(
              constraints: BoxConstraints(maxHeight: estimatedListHeight),
              child: _PickerResultsList<T>(
                items: filtered,
                selectedValue: widget.selectedValue,
                noResultsText: widget.noResultsText,
                onSelected: widget.onSelected,
                dense: false,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PickerResultsList<T> extends StatelessWidget {
  const _PickerResultsList({
    required this.items,
    required this.selectedValue,
    required this.noResultsText,
    required this.onSelected,
    this.dense = true,
  });

  final List<DropdownMenuItem<T>> items;
  final T? selectedValue;
  final String? noResultsText;
  final ValueChanged<T?> onSelected;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (items.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(LayoutTokens.gapLg),
          child: Text(
            noResultsText ?? '无匹配结果',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.hintColor,
            ),
          ),
        ),
      );
    }

    return ListView.separated(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      itemCount: items.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final item = items[index];
        final isSelected = item.value == selectedValue;
        final isEnabled = item.enabled;
        return ListTile(
          dense: dense,
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
          onTap: isEnabled ? () => onSelected(item.value) : null,
        );
      },
    );
  }
}

class _DropdownSelection<T> {
  const _DropdownSelection(this.value);

  final T? value;
}

List<DropdownMenuItem<T>> _filterItems<T>(
  List<DropdownMenuItem<T>> items,
  String query,
  String Function(DropdownMenuItem<T> item)? itemLabelBuilder,
) {
  if (query.isEmpty) {
    return items;
  }
  final normalizedQuery = query.toLowerCase();
  return items.where((item) {
    final label = _labelForItem(item, itemLabelBuilder);
    return label.toLowerCase().contains(normalizedQuery);
  }).toList();
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
