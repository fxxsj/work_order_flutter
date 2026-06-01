import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/page_header_bar.dart';

class PageModeOption<T> {
  const PageModeOption({required this.value, required this.label});

  final T value;
  final String label;
}

class PageModeToggle<T> extends StatelessWidget {
  const PageModeToggle({
    super.key,
    required this.value,
    required this.options,
    required this.onChanged,
    this.minWidth = 88,
  });

  final T value;
  final List<PageModeOption<T>> options;
  final ValueChanged<T> onChanged;
  final double minWidth;

  @override
  Widget build(BuildContext context) {
    return ToggleButtons(
      isSelected: options.map((option) => option.value == value).toList(),
      onPressed: (index) => onChanged(options[index].value),
      constraints: BoxConstraints(
        minHeight: PageActionStyle.height,
        minWidth: minWidth,
      ),
      children: options
          .map(
            (option) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: SpacingTokens.md),
              child: Text(option.label),
            ),
          )
          .toList(),
    );
  }
}
