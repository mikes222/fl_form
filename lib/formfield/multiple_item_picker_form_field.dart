import 'package:fl_form/fl_form.dart';
import 'package:fl_form/formfield/widget/fl_readonly_field.dart';
import 'package:flutter/material.dart';

import 'bottom_sheet/multiple_item_picker_bottom_sheet.dart';

class MultipleItemPickerFormField<T> extends FormField<List<T>> {
  MultipleItemPickerFormField({
    super.key,
    required String label,
    String? placeholderText,
    Widget? prefixIcon,
    super.validator,
    super.onSaved,
    ValueChanged<List<T>>? onChanged,
    ValueChanged<T>? onDelete,
    super.autovalidateMode,
    super.enabled,
    super.initialValue,
    bool isRequired = false,
    required Iterable<T> options,
    FlContentBuilder<T>? contentBuilder,
    FlListBuilder<T>? listBuilder,
    String? helperText,
  }) : super(
         builder: (field) {
           final state = field as MultipleItemPickerFormFieldState<T>;
           return FlReadonlyField(
             label: label,
             isRequired: isRequired,
             enabled: enabled,
             hasError: state.hasError,
             placeholderText: placeholderText,
             onTap: enabled
                 ? () {
                     MultipleItemPickerBottomSheet.show<T>(state.context, options.toList(), state.value, listBuilder).then((value) {
                       if (value != null) {
                         state.didChange(value);
                       }
                     });
                   }
                 : null,
             helperText: helperText,
             errorText: state.errorText,
             content: state.value == null || state.value!.isEmpty
                 ? null
                 : Wrap(
                     spacing: 4,
                     runSpacing: 4,
                     children: state.value!
                         .map(
                           (v) => Chip(
                             onDeleted: onDelete != null
                                 ? () {
                                     onDelete(v);
                                   }
                                 : null,
                             label: contentBuilder != null ? contentBuilder(state.context, v) : defaultFlContentBuilder<T>(state.context, v),
                           ),
                         )
                         .toList(),
                   ),
             suffixIcon: const Icon(Icons.keyboard_arrow_down),
           );
         },
       );

  @override
  FormFieldState<List<T>> createState() {
    return MultipleItemPickerFormFieldState<T>();
  }
}

//////////////////////////////////////////////////////////////////////////////

class MultipleItemPickerFormFieldState<T> extends FormFieldState<List<T>> {
  @override
  MultipleItemPickerFormField<T> get widget => super.widget as MultipleItemPickerFormField<T>;
}
