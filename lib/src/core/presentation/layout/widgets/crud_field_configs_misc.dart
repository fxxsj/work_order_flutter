part of 'crud_form_field.dart';

final class CustomFieldConfig extends CrudFieldConfig {
  const CustomFieldConfig({
    this.fieldKey,
    required this.builder,
  });

  final Key? fieldKey;
  final Widget Function(BuildContext context) builder;

  @override
  Widget build(BuildContext context) => builder(context);
}
