import 'package:fl_form/formfield/widget/fl_readonly_field.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// todo pattern for date field (dd/mm/yyyy versus yyyy-mm-dd)
class FlDateFormField extends FormField<DateTime> {
  FlDateFormField({
    DateFormat? dateFormat,
    DateTime? firstDate,
    DateTime? lastDate,
    super.validator,
    super.onSaved,
    ValueChanged<DateTime?>? onChanged,
    super.autovalidateMode,
    super.initialValue,
    required String label,
    required String? placeholderText,
    bool isRequired = false,
    Widget? prefixIcon,
    Widget? suffixIcon,
    String? helperText,
    bool enabled = true,
    super.key,
  }) : super(
         builder: (field) {
           final state = field as FlDateFormFieldState;
           return FlReadonlyField(
             label: label,
             isRequired: isRequired,
             enabled: enabled,
             hasError: state.hasError,
             errorText: state.errorText,
             helperText: helperText,
             //             autofocus: autofocus,
             content: InkWell(
               onTap: enabled
                   ? () {
                       showDatePicker(
                         context: state.context,
                         initialDate: state.value ?? DateTime.now(),
                         firstDate: firstDate ?? DateTime.now().add(Duration(days: -3650)),
                         lastDate: lastDate ?? DateTime.now().add(Duration(days: 3650)),
                       ).then((value) {
                         if (value != null) {
                           state.didChange(value);
                           if (onChanged != null) {
                             onChanged(value);
                           }
                         }
                       });
                     }
                   : null,
               child: Text(state.value == null ? dateFormat?.pattern ?? 'YYYY/MM/DD' : dateFormat!.format(state.value!)),
             ),
           );
         },
       );
  @override
  FlDateFormFieldState createState() => FlDateFormFieldState();
}

class FlDateFormFieldState extends FormFieldState<DateTime> {
  bool isFocused = false;

  void setIsFocused(bool newValue) {
    setState(() {
      isFocused = newValue;
    });
  }
}
