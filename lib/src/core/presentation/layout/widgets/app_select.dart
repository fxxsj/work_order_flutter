import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/constants/breakpoints.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/dialogs.dart';

/// 下拉选项配置
class AppDropdownOption<T> {
  const AppDropdownOption({
    required this.value,
    required this.label,
    this.enabled = true,
    this.groupLabel,
    this.secondaryLabel,
    this.icon,
    this.onSelected,
  });

  final T value;
  final String label;
  final bool enabled;
  final String? groupLabel;
  final String? secondaryLabel;
  final IconData? icon;
  final VoidCallback? onSelected;
}

/// 搜索配置
class AppDropdownSearchConfig {
  const AppDropdownSearchConfig({
    this.enabled = true,
    this.hintText,
    this.matcher,
    this.highlightMatches = false,
  });

  final bool enabled;
  final String? hintText;
  final bool Function(String query, AppDropdownOption<dynamic> option)? matcher;
  final bool highlightMatches;
}

class AppSelect<T> extends FormField<T> {
  AppSelect({
    super.key,
    required this.options,
    this.onChanged,
    this.decoration = const InputDecoration(),
    this.enabled = true,
    this.isMultiSelect = false,
    this.menuHeight,
    T? value,
    FormFieldValidator<T?>? validator,
    AutovalidateMode? autovalidateMode,
    this.searchConfig = const AppDropdownSearchConfig(),
    this.emptyText = '暂无可选项',
    this.noResultsText = '无匹配结果',
    this.selectHintText = '请选择',
    this.confirmText = '确定',
    this.cancelText = '取消',
    this.clearText = '清空',
    this.selectAllText = '全选',
    this.minOptionsForSearch = 1,
  }) : super(
          initialValue: value,
          validator: validator,
          autovalidateMode: autovalidateMode,
          builder: (state) {
            if (isMultiSelect) {
              return _MultiSelectDropdownField<T>(
                state: state,
                value: value,
                options: options,
                onChanged: onChanged,
                decoration: decoration,
                enabled: enabled,
                searchConfig: searchConfig,
                emptyText: emptyText,
                noResultsText: noResultsText,
                selectHintText: selectHintText,
                confirmText: confirmText,
                cancelText: cancelText,
                clearText: clearText,
                selectAllText: selectAllText,
                minOptionsForSearch: minOptionsForSearch,
              );
            }

            return _SingleSelectDropdownField<T>(
              state: state,
              value: value,
              options: options,
              onChanged: onChanged,
              decoration: decoration,
              enabled: enabled,
              searchConfig: searchConfig,
              emptyText: emptyText,
              noResultsText: noResultsText,
              selectHintText: selectHintText,
              minOptionsForSearch: minOptionsForSearch,
              menuHeight: menuHeight,
            );
          },
        );

  final List<AppDropdownOption<T>> options;
  final ValueChanged<T?>? onChanged;
  final InputDecoration decoration;
  final bool enabled;
  final bool isMultiSelect;
  final double? menuHeight;
  final AppDropdownSearchConfig searchConfig;
  final String emptyText;
  final String noResultsText;
  final String selectHintText;
  final String confirmText;
  final String cancelText;
  final String clearText;
  final String selectAllText;
  final int minOptionsForSearch;
}

// ==================== Single Select ====================

class _SingleSelectDropdownField<T> extends StatefulWidget {
  const _SingleSelectDropdownField({
    required this.state,
    required this.value,
    required this.options,
    required this.onChanged,
    required this.decoration,
    required this.enabled,
    required this.searchConfig,
    required this.emptyText,
    required this.noResultsText,
    required this.selectHintText,
    required this.minOptionsForSearch,
    this.menuHeight,
  });

  final FormFieldState<T?> state;
  final T? value;
  final List<AppDropdownOption<T>> options;
  final ValueChanged<T?>? onChanged;
  final InputDecoration decoration;
  final bool enabled;
  final AppDropdownSearchConfig searchConfig;
  final String emptyText;
  final String noResultsText;
  final String selectHintText;
  final int minOptionsForSearch;
  final double? menuHeight;

  @override
  State<_SingleSelectDropdownField<T>> createState() =>
      _SingleSelectDropdownFieldState<T>();
}

class _SingleSelectDropdownFieldState<T>
    extends State<_SingleSelectDropdownField<T>> {
  final FocusNode _focusNode = FocusNode();

  @override
  void didUpdateWidget(covariant _SingleSelectDropdownField<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value && widget.state.value != widget.value) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && widget.state.value != widget.value) {
          widget.state.didChange(widget.value);
        }
      });
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  List<AppDropdownOption<T>> get _effectiveOptions => widget.options;

  AppDropdownOption<T>? get _selectedOption {
    for (final option in _effectiveOptions) {
      if (option.onSelected == null && option.value == widget.state.value) {
        return option;
      }
    }
    return null;
  }

  Future<void> _openPicker(BuildContext context) async {
    if (!widget.enabled) return;

    final isMobile = MediaQuery.sizeOf(context).width < Breakpoints.sm;
    final maxHeight = widget.menuHeight ?? (isMobile ? 500.0 : 400.0);

    final result = isMobile
        ? await showModalBottomSheet<T>(
            context: context,
            isScrollControlled: true,
            useSafeArea: true,
            showDragHandle: true,
            backgroundColor: Theme.of(context).colorScheme.surface,
            shape:
                const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
            builder: (_) => SizedBox(
              height: maxHeight,
              child: _SingleSelectPicker<T>(
                title: widget.decoration.labelText,
                options: _effectiveOptions,
                initialValue: widget.state.value,
                searchConfig: widget.searchConfig,
                emptyText: widget.emptyText,
                noResultsText: widget.noResultsText,
                selectHintText: widget.selectHintText,
                minOptionsForSearch: widget.minOptionsForSearch,
              ),
            ),
          )
        : await showDialog<T>(
            context: context,
            builder: (_) => Dialog(
              insetPadding: const EdgeInsets.all(LayoutTokens.gapLg),
              clipBehavior: Clip.antiAlias,
              child: SizedBox(
                width: 400,
                height: maxHeight,
                child: _SingleSelectPicker<T>(
                  title: widget.decoration.labelText,
                  options: _effectiveOptions,
                  initialValue: widget.state.value,
                  searchConfig: widget.searchConfig,
                  emptyText: widget.emptyText,
                  noResultsText: widget.noResultsText,
                  selectHintText: widget.selectHintText,
                  minOptionsForSearch: widget.minOptionsForSearch,
                ),
              ),
            ),
          );

    if (result == null || result == widget.state.value) return;
    widget.state.didChange(result);
    widget.onChanged?.call(result);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final options = _effectiveOptions;
    if (options.isEmpty) {
      return InputDecorator(
        decoration: widget.decoration
            .applyDefaults(theme.inputDecorationTheme)
            .copyWith(
              enabled: false,
              errorText: widget.state.errorText,
            ),
        isEmpty: true,
        child: Text(
          widget.emptyText,
          style: theme.textTheme.bodyMedium?.copyWith(color: theme.hintColor),
        ),
      );
    }

    final selected = _selectedOption;
    final effectiveDecoration = widget.decoration
        .copyWith(
          hintText: widget.decoration.hintText ?? widget.selectHintText,
        )
        .applyDefaults(theme.inputDecorationTheme)
        .copyWith(
          enabled: widget.enabled,
          errorText: widget.state.errorText,
          suffixIcon: const Icon(Icons.arrow_drop_down),
        );

    return Semantics(
      label: widget.decoration.labelText,
      button: true,
      enabled: widget.enabled,
      child: InkWell(
        focusNode: _focusNode,
        onTap: () => _openPicker(context),
        borderRadius: BorderRadius.circular(LayoutTokens.radiusSm),
        child: InputDecorator(
          decoration: effectiveDecoration,
          isEmpty: selected == null,
          child:
              selected == null ? const SizedBox.shrink() : Text(selected.label),
        ),
      ),
    );
  }
}

class _SingleSelectPicker<T> extends StatefulWidget {
  const _SingleSelectPicker({
    required this.title,
    required this.options,
    required this.initialValue,
    required this.searchConfig,
    required this.emptyText,
    required this.noResultsText,
    required this.selectHintText,
    required this.minOptionsForSearch,
  });

  final String? title;
  final List<AppDropdownOption<T>> options;
  final T? initialValue;
  final AppDropdownSearchConfig searchConfig;
  final String emptyText;
  final String noResultsText;
  final String selectHintText;
  final int minOptionsForSearch;

  @override
  State<_SingleSelectPicker<T>> createState() => _SingleSelectPickerState<T>();
}

class _SingleSelectPickerState<T> extends State<_SingleSelectPicker<T>> {
  late final TextEditingController _searchController;
  String _query = '';

  bool get _showSearch =>
      widget.searchConfig.enabled &&
      widget.options.length >= widget.minOptionsForSearch;

  List<AppDropdownOption<T>> get _normalOptions =>
      widget.options.where((o) => o.onSelected == null).toList();

  List<AppDropdownOption<T>> get _actionOptions =>
      widget.options.where((o) => o.onSelected != null).toList();

  List<AppDropdownOption<T>> get _filteredNormalOptions {
    final normal = _normalOptions;
    if (_query.isEmpty) return normal;
    return _filterOptions<T>(normal, _query, widget.searchConfig);
  }

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final filtered = _filteredNormalOptions;
    final hasResults = filtered.isNotEmpty;
    final actionOptions = _actionOptions;

    return AppModalScaffold(
      title: widget.title ?? '请选择',
      showCloseButton: true,
      scrollable: false,
      bodyPadding: EdgeInsets.zero,
      leadingActions: actionOptions
          .map(
            (option) => TextButton.icon(
              onPressed: option.enabled
                  ? () {
                      Navigator.of(context).pop();
                      option.onSelected?.call();
                    }
                  : null,
              icon: Icon(option.icon ?? Icons.add, size: LayoutTokens.iconSm),
              label: Text(option.label),
            ),
          )
          .toList(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (_showSearch) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(
                LayoutTokens.gapLg,
                LayoutTokens.gapMd,
                LayoutTokens.gapLg,
                LayoutTokens.gapSm,
              ),
              child: TextField(
                controller: _searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: widget.searchConfig.hintText ?? '搜索',
                  prefixIcon: const Icon(Icons.search),
                  isDense: true,
                  border: const OutlineInputBorder(),
                ),
                onChanged: (value) => setState(() => _query = value.trim()),
              ),
            ),
            const Divider(height: 1),
          ],
          Expanded(
            child: hasResults
                ? ListView.separated(
                    padding: EdgeInsets.zero,
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final option = filtered[index];
                      final selected = option.value == widget.initialValue;

                      return ListTile(
                        title: _buildOptionLabel(theme, option),
                        dense: true,
                        enabled: option.enabled,
                        selected: selected,
                        trailing: selected
                            ? const Icon(Icons.check, size: LayoutTokens.iconLg)
                            : null,
                        onTap: option.enabled
                            ? () => Navigator.of(context).pop(option.value)
                            : null,
                      );
                    },
                  )
                : Center(
                    child: Padding(
                      padding: const EdgeInsets.all(LayoutTokens.gapLg),
                      child: Text(
                        widget.options.isEmpty
                            ? widget.emptyText
                            : widget.noResultsText,
                        style: theme.textTheme.bodyMedium
                            ?.copyWith(color: theme.hintColor),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionLabel(ThemeData theme, AppDropdownOption<T> option) {
    final label = _buildHighlightedText(
      text: option.label,
      query: _query,
      theme: theme,
      baseStyle: theme.textTheme.bodyLarge,
      highlightMatches: widget.searchConfig.highlightMatches,
    );

    if (option.secondaryLabel == null && option.icon == null) {
      return label;
    }

    return Row(
      children: [
        if (option.icon != null) ...[
          Icon(option.icon, size: 16),
          const SizedBox(width: LayoutTokens.gapSm),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              label,
              if (option.secondaryLabel != null)
                Text(
                  option.secondaryLabel!,
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: theme.hintColor),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

// ==================== Multi Select ====================

class _MultiSelectDropdownField<T> extends StatefulWidget {
  const _MultiSelectDropdownField({
    required this.state,
    required this.value,
    required this.options,
    required this.onChanged,
    required this.decoration,
    required this.enabled,
    required this.searchConfig,
    required this.emptyText,
    required this.noResultsText,
    required this.selectHintText,
    required this.confirmText,
    required this.cancelText,
    required this.clearText,
    required this.selectAllText,
    required this.minOptionsForSearch,
  });

  final FormFieldState<T?> state;
  final T? value;
  final List<dynamic> options;
  final ValueChanged<T?>? onChanged;
  final InputDecoration decoration;
  final bool enabled;
  final AppDropdownSearchConfig searchConfig;
  final String emptyText;
  final String noResultsText;
  final String selectHintText;
  final String confirmText;
  final String cancelText;
  final String clearText;
  final String selectAllText;
  final int minOptionsForSearch;

  @override
  State<_MultiSelectDropdownField<T>> createState() =>
      _MultiSelectDropdownFieldState<T>();
}

class _MultiSelectDropdownFieldState<T>
    extends State<_MultiSelectDropdownField<T>> {
  final FocusNode _focusNode = FocusNode();

  @override
  void didUpdateWidget(covariant _MultiSelectDropdownField<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_setEquals(oldWidget.value, widget.value) &&
        !_setEquals(widget.state.value, widget.value)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && !_setEquals(widget.state.value, widget.value)) {
          widget.state.didChange(widget.value);
        }
      });
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  List<AppDropdownOption<dynamic>> get _effectiveOptions {
    return widget.options
        .whereType<AppDropdownOption<dynamic>>()
        .cast<AppDropdownOption<dynamic>>()
        .toList();
  }

  Set<dynamic> get _selectedValues {
    final value = widget.state.value;
    if (value is Set<dynamic>) {
      return value;
    }
    return const {};
  }

  Future<void> _openPicker(BuildContext context) async {
    if (!widget.enabled) {
      return;
    }

    final initialSelection = Set<dynamic>.from(_selectedValues);
    final isMobile = MediaQuery.sizeOf(context).width < Breakpoints.sm;
    final result = isMobile
        ? await showModalBottomSheet<Set<dynamic>>(
            context: context,
            isScrollControlled: true,
            useSafeArea: true,
            showDragHandle: true,
            backgroundColor: Theme.of(context).colorScheme.surface,
            shape:
                const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
            builder: (sheetContext) => SizedBox(
              height: MediaQuery.sizeOf(sheetContext).height * 0.88,
              child: _MultiSelectPicker(
                title: widget.decoration.labelText,
                options: _effectiveOptions,
                initialSelection: initialSelection,
                searchConfig: widget.searchConfig,
                emptyText: widget.emptyText,
                noResultsText: widget.noResultsText,
                selectAllText: widget.selectAllText,
                clearText: widget.clearText,
                confirmText: widget.confirmText,
                cancelText: widget.cancelText,
                minOptionsForSearch: widget.minOptionsForSearch,
              ),
            ),
          )
        : await showDialog<Set<dynamic>>(
            context: context,
            builder: (dialogContext) => Dialog(
              insetPadding: const EdgeInsets.all(LayoutTokens.gapLg),
              clipBehavior: Clip.antiAlias,
              child: SizedBox(
                width: 520,
                height: 640,
                child: _MultiSelectPicker(
                  title: widget.decoration.labelText,
                  options: _effectiveOptions,
                  initialSelection: initialSelection,
                  searchConfig: widget.searchConfig,
                  emptyText: widget.emptyText,
                  noResultsText: widget.noResultsText,
                  selectAllText: widget.selectAllText,
                  clearText: widget.clearText,
                  confirmText: widget.confirmText,
                  cancelText: widget.cancelText,
                  minOptionsForSearch: widget.minOptionsForSearch,
                ),
              ),
            ),
          );

    if (result == null || _setEquals(_selectedValues, result)) {
      return;
    }

    widget.state.didChange(result as T?);
    widget.onChanged?.call(result as T?);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final selectedOptions = _effectiveOptions
        .where((option) => _selectedValues.contains(option.value))
        .toList();
    final effectiveDecoration = widget.decoration
        .copyWith(
          hintText: widget.decoration.hintText ?? widget.selectHintText,
        )
        .applyDefaults(theme.inputDecorationTheme)
        .copyWith(
          enabled: widget.enabled,
          errorText: widget.state.errorText,
          suffixIcon: const Icon(Icons.arrow_drop_down),
        );

    return Semantics(
      label: widget.decoration.labelText,
      button: true,
      enabled: widget.enabled,
      child: InkWell(
        focusNode: _focusNode,
        onTap: () => _openPicker(context),
        borderRadius: BorderRadius.circular(LayoutTokens.radiusSm),
        child: InputDecorator(
          decoration: effectiveDecoration,
          isEmpty: selectedOptions.isEmpty,
          child: selectedOptions.isEmpty
              ? const SizedBox.shrink()
              : Wrap(
                  spacing: LayoutTokens.gapXs,
                  runSpacing: LayoutTokens.gapXs,
                  children: selectedOptions
                      .map(
                        (option) => InputChip(
                          label: Text(option.label),
                          onDeleted: widget.enabled
                              ? () {
                                  final nextValues =
                                      Set<dynamic>.from(_selectedValues)
                                        ..remove(option.value);
                                  widget.state.didChange(nextValues as T?);
                                  widget.onChanged?.call(nextValues as T?);
                                }
                              : null,
                          visualDensity: VisualDensity.compact,
                        ),
                      )
                      .toList(),
                ),
        ),
      ),
    );
  }

  bool _setEquals(Object? left, Object? right) {
    if (left is Set && right is Set) {
      return setEquals<dynamic>(left.cast<dynamic>(), right.cast<dynamic>());
    }
    return left == right;
  }
}

class _MultiSelectPicker extends StatefulWidget {
  const _MultiSelectPicker({
    required this.title,
    required this.options,
    required this.initialSelection,
    required this.searchConfig,
    required this.emptyText,
    required this.noResultsText,
    required this.selectAllText,
    required this.clearText,
    required this.confirmText,
    required this.cancelText,
    required this.minOptionsForSearch,
  });

  final String? title;
  final List<AppDropdownOption<dynamic>> options;
  final Set<dynamic> initialSelection;
  final AppDropdownSearchConfig searchConfig;
  final String emptyText;
  final String noResultsText;
  final String selectAllText;
  final String clearText;
  final String confirmText;
  final String cancelText;
  final int minOptionsForSearch;

  @override
  State<_MultiSelectPicker> createState() => _MultiSelectPickerState();
}

class _MultiSelectPickerState extends State<_MultiSelectPicker> {
  late final TextEditingController _searchController;
  late Set<dynamic> _currentSelection;
  String _query = '';

  bool get _showSearch {
    return widget.searchConfig.enabled &&
        widget.options.length >= widget.minOptionsForSearch;
  }

  List<AppDropdownOption<dynamic>> get _filteredOptions {
    return _filterOptions(
      widget.options,
      _query,
      widget.searchConfig,
    );
  }

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _currentSelection = Set<dynamic>.from(widget.initialSelection);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final filtered = _filteredOptions;
    final hasResults = filtered.isNotEmpty;
    final selectableFiltered = filtered
        .where((option) => option.enabled)
        .map((option) => option.value);
    final allFilteredSelected = hasResults &&
        selectableFiltered.every((value) => _currentSelection.contains(value));

    return AppModalScaffold(
      title: widget.title ?? '请选择',
      showCloseButton: true,
      scrollable: false,
      bodyPadding: EdgeInsets.zero,
      leadingActions: [
        TextButton(
          onPressed: () => setState(() => _currentSelection = <dynamic>{}),
          child: Text(widget.clearText),
        ),
      ],
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(widget.cancelText),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(_currentSelection),
          child: Text(widget.confirmText),
        ),
      ],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (_showSearch)
            Padding(
              padding: const EdgeInsets.fromLTRB(
                LayoutTokens.gapLg,
                LayoutTokens.gapMd,
                LayoutTokens.gapLg,
                LayoutTokens.gapSm,
              ),
              child: TextField(
                controller: _searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: widget.searchConfig.hintText ?? '搜索',
                  prefixIcon: const Icon(Icons.search),
                  isDense: true,
                  border: const OutlineInputBorder(),
                ),
                onChanged: (value) => setState(() => _query = value.trim()),
              ),
            ),
          Padding(
            padding: EdgeInsets.fromLTRB(
              LayoutTokens.gapLg,
              _showSearch ? 0 : LayoutTokens.gapMd,
              LayoutTokens.gapLg,
              LayoutTokens.gapSm,
            ),
            child: Row(
              children: [
                Text(
                  '已选 ${_currentSelection.length} 项',
                  style: theme.textTheme.bodySmall,
                ),
                const Spacer(),
                TextButton(
                  onPressed: hasResults
                      ? () {
                          setState(() {
                            if (allFilteredSelected) {
                              for (final option in filtered) {
                                _currentSelection.remove(option.value);
                              }
                            } else {
                              for (final option in filtered) {
                                if (option.enabled) {
                                  _currentSelection.add(option.value);
                                }
                              }
                            }
                          });
                        }
                      : null,
                  child: Text(widget.selectAllText),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: hasResults
                ? ListView.separated(
                    padding: EdgeInsets.zero,
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final option = filtered[index];
                      final selected = _currentSelection.contains(option.value);

                      return CheckboxListTile(
                        value: selected,
                        dense: true,
                        enabled: option.enabled,
                        controlAffinity: ListTileControlAffinity.leading,
                        title: _buildOptionLabel(theme, option),
                        onChanged: option.enabled
                            ? (checked) {
                                setState(() {
                                  if (checked == true) {
                                    _currentSelection.add(option.value);
                                  } else {
                                    _currentSelection.remove(option.value);
                                  }
                                });
                              }
                            : null,
                      );
                    },
                  )
                : Center(
                    child: Padding(
                      padding: const EdgeInsets.all(LayoutTokens.gapLg),
                      child: Text(
                        widget.options.isEmpty
                            ? widget.emptyText
                            : widget.noResultsText,
                        style: theme.textTheme.bodyMedium
                            ?.copyWith(color: theme.hintColor),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionLabel(ThemeData theme, AppDropdownOption<dynamic> option) {
    final label = _buildHighlightedText(
      text: option.label,
      query: _query,
      theme: theme,
      baseStyle: theme.textTheme.bodyLarge,
      highlightMatches: widget.searchConfig.highlightMatches,
    );

    if (option.secondaryLabel == null && option.icon == null) {
      return label;
    }

    return Row(
      children: [
        if (option.icon != null) ...[
          Icon(option.icon, size: 16),
          const SizedBox(width: LayoutTokens.gapSm),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              label,
              if (option.secondaryLabel != null)
                Text(
                  option.secondaryLabel!,
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: theme.hintColor),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

List<AppDropdownOption<T>> _filterOptions<T>(
  List<AppDropdownOption<T>> options,
  String query,
  AppDropdownSearchConfig searchConfig,
) {
  if (query.trim().isEmpty) {
    return options;
  }

  return options
      .where((option) => _matchesQuery(query, option, searchConfig))
      .toList();
}

bool _matchesQuery(
  String query,
  AppDropdownOption<dynamic> option,
  AppDropdownSearchConfig searchConfig,
) {
  final trimmedQuery = query.trim();
  if (trimmedQuery.isEmpty) {
    return true;
  }
  if (option.onSelected != null) {
    return true;
  }

  final matcher = searchConfig.matcher;
  if (matcher != null) {
    return matcher(trimmedQuery, option);
  }

  final normalizedQuery = trimmedQuery.toLowerCase();
  final label = option.label.toLowerCase();
  final secondary = option.secondaryLabel?.toLowerCase() ?? '';
  return label.contains(normalizedQuery) || secondary.contains(normalizedQuery);
}

Widget _buildHighlightedText({
  required String text,
  required String query,
  required ThemeData theme,
  required TextStyle? baseStyle,
  required bool highlightMatches,
}) {
  if (query.isEmpty || !highlightMatches) {
    return Text(text, style: baseStyle);
  }

  final normalizedQuery = query.toLowerCase();
  final normalizedText = text.toLowerCase();
  final matches = <_HighlightRange>[];

  var start = 0;
  while (true) {
    final index = normalizedText.indexOf(normalizedQuery, start);
    if (index == -1) {
      break;
    }
    matches.add(_HighlightRange(index, index + normalizedQuery.length));
    start = index + normalizedQuery.length;
  }

  if (matches.isEmpty) {
    return Text(text, style: baseStyle);
  }

  final spans = <InlineSpan>[];
  var current = 0;
  for (final match in matches) {
    if (match.start > current) {
      spans.add(TextSpan(text: text.substring(current, match.start)));
    }
    spans.add(
      TextSpan(
        text: text.substring(match.start, match.end),
        style: TextStyle(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.w700,
          backgroundColor:
              theme.colorScheme.primary.withValues(alpha: OpacityTokens.mild),
        ),
      ),
    );
    current = match.end;
  }
  if (current < text.length) {
    spans.add(TextSpan(text: text.substring(current)));
  }

  return RichText(
    text: TextSpan(
      style: baseStyle ?? theme.textTheme.bodyLarge,
      children: spans,
    ),
  );
}

class _HighlightRange {
  _HighlightRange(this.start, this.end);

  final int start;
  final int end;
}
