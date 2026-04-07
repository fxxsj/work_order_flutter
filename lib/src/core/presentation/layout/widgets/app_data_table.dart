import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/common/theme_ext.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/app_card.dart';

class AppDataTable extends StatelessWidget {
  const AppDataTable({
    super.key,
    required this.columns,
    required this.rows,
    this.columnSpacing = 18,
    this.horizontalMargin = 16,
    this.minWidth,
    this.headingRowHeight = 44,
    this.dataRowMinHeight = 44,
    this.dataRowMaxHeight = 56,
  });

  final List<DataColumn> columns;
  final List<DataRow> rows;
  final double columnSpacing;
  final double horizontalMargin;
  final double? minWidth;
  final double headingRowHeight;
  final double dataRowMinHeight;
  final double dataRowMaxHeight;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>();
    final semantic = theme.extension<AppSemanticColors>();
    final headingStyle = theme.textTheme.labelLarge?.copyWith(
      color: colors?.subtleText ?? theme.hintColor,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.2,
      fontSize: TextTokens.fontSizeBodyMedium,
    );
    final dataStyle = theme.textTheme.bodyMedium?.copyWith(
      fontSize: TextTokens.fontSizeBodyMedium,
      height: 1.4,
    );

    return AppCard(
      padding: EdgeInsets.zero,
      showShadow: false,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: minWidth ?? constraints.maxWidth,
                ),
                child: DataTable(
                  columns: columns,
                  rows: rows,
                  headingTextStyle: headingStyle,
                  headingRowColor: WidgetStateProperty.all(
                    semantic?.surfaceAlt ??
                        theme.colorScheme.surfaceContainerHighest,
                  ),
                  columnSpacing: columnSpacing,
                  horizontalMargin: horizontalMargin,
                  headingRowHeight: headingRowHeight,
                  dataRowMinHeight: dataRowMinHeight,
                  dataRowMaxHeight: dataRowMaxHeight,
                  dividerThickness: 0.8,
                  showBottomBorder: true,
                  dataTextStyle: dataStyle,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
