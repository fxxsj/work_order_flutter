import 'package:flutter/material.dart';

/// Date field for [CrudFieldConfig.date].
class DateField extends FormField<String> {
  DateField({
    super.key,
    required String label,
    required TextEditingController controller,
    String? Function(String?)? validator,
    bool enabled = true,
    String? hintText,
    String? helperText,
    bool readOnly = true,
    VoidCallback? onTap,
  }) : super(
         initialValue: controller.text,
         validator: validator,
         builder: (state) {
           return Builder(
             builder: (ctx) {
               return TextFormField(
                 controller: controller,
                 validator: validator,
                 enabled: enabled,
                 readOnly: readOnly,
                 onTap: onTap,
                 keyboardType: TextInputType.datetime,
                 decoration: InputDecoration(
                   labelText: label,
                   hintText: hintText,
                   helperText: helperText,
                   prefixIcon: const Icon(
                     Icons.calendar_today_outlined,
                     size: 18,
                   ),
                   suffixIcon: enabled && controller.text.isNotEmpty
                       ? IconButton(
                           tooltip: '清空日期',
                           onPressed: () {
                             controller.clear();
                             state.didChange('');
                           },
                           icon: const Icon(Icons.close, size: 18),
                         )
                       : const Icon(Icons.keyboard_arrow_down_rounded),
                 ),
                 onChanged: state.didChange,
               );
             },
           );
         },
       );
}
