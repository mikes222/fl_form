import 'package:fl_form/fl_form.dart';
import 'package:fl_form/formfield/widget/fl_readonly_field.dart';
import 'package:flutter/material.dart';

class FlCheckboxGroupFormField<T> extends FormField<List<T>> {
  FlCheckboxGroupFormField({
    super.key,
    required String label,
    bool isRequired = false,
    super.validator,
    super.initialValue,
    required Iterable<T> options,
    FlContentBuilder<T>? contentBuilder,
    super.autovalidateMode,
    super.onSaved,
    super.restorationId,
    String? helperText,
    super.enabled,
  }) : super(
         builder: (state) {
           return FlReadonlyField(
             label: label,
             isRequired: isRequired,
             enabled: enabled,
             hasError: state.hasError,
             //placeholderText: placeholderText,
             helperText: helperText,
             errorText: state.errorText,
             content: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: options.map((element) {
                 return Row(
                   children: [
                     Checkbox(
                       key: Key(element.toString()),
                       value: state.value?.contains(element) == true,
                       onChanged: (value) {
                         if (value == true) {
                           state.didChange([...state.value ?? [], element]);
                         } else {
                           state.didChange([...state.value!]..remove(element));
                         }
                       },
                     ),
                     const SizedBox(width: 4),
                     Expanded(
                       child: InkWell(
                         onTap: () {
                           if (state.value?.contains(element) == true) {
                             state.didChange([...state.value!]..remove(element));
                           } else {
                             state.didChange([...state.value ?? [], element]);
                           }
                         },
                         child: contentBuilder != null ? contentBuilder(state.context, element) : defaultFlContentBuilder<T>(state.context, element),
                       ),
                     ),
                   ],
                 );
               }).toList(),
             ),
           );
         },
       );
}
