import 'package:fl_form/formfield/widget/default_error_builder.dart';
import 'package:fl_form/formfield/widget/input_decoration_builder.dart';
import 'package:fl_form/formfield/widget/label_widget.dart';
import 'package:flutter/material.dart';

import 'fl_form_field_theme.dart';

class FlRadioButtonFormField<T> extends FormField<T> {
  FlRadioButtonFormField({
    super.key,
    required String label,
    bool isRequired = false,
    super.validator,
    super.initialValue,
    required List<T> options,
    super.autovalidateMode,
    super.onSaved,
    ValueChanged<T?>? onChanged,
    super.restorationId,
    super.enabled = true,
    String? helperText,
    String? placeholderText,
    bool vertical = true,
  }) : super(
         builder: (state) {
           return Column(
             crossAxisAlignment: CrossAxisAlignment.stretch,
             children: [
               LabelWidget(label: label, isRequired: isRequired),
               InputDecorator(
                 decoration: InputDecorationBuilder(
                   enabled: enabled,
                   hasError: state.hasError,
                   helperText: helperText,
                   placeholderText: placeholderText,
                 ).create(state.context),
                 child: RadioGroup(
                   onChanged: (T? value) {
                     state.didChange(value);
                     if (onChanged != null) onChanged(value);
                   },
                   groupValue: state.value,
                   child: vertical ? _VerticalWidget(children: _buildChildren(options, state)) : _HorizontalWidget(children: _buildChildren(options, state)),
                 ),
               ),

               if (state.hasError) defaultErrorBuilder(state.context, state.errorText!),
             ],
           );
         },
       );

  static List<Widget> _buildChildren<T>(List<T> options, FormFieldState<T> state) {
    return options.map((e) {
      //   return InkWell(
      //     onTap: () {
      //       RadioGroup.maybeOf<T>(state.context)?.onChanged(e);
      //     },
      //     child: Row(
      //       children: [
      //         Radio(value: e),
      //         Text(e.toString(), style: Theme.of(state.context).extension<FlFormFieldTheme>()?.style ?? Theme.of(state.context).textTheme.bodyMedium),
      //       ],
      //     ),
      //   );
      // }).toList();

      // intrinsic width is necessary for horizontal elements
      return IntrinsicWidth(
        child: RadioListTile(
          value: e,
          dense: true,
          visualDensity: VisualDensity.compact,
          title: Text(e.toString(), style: Theme.of(state.context).extension<FlFormFieldTheme>()?.style ?? Theme.of(state.context).textTheme.bodyMedium),
        ),
      );
    }).toList();
  }
}

//////////////////////////////////////////////////////////////////////////////

class _VerticalWidget extends StatelessWidget {
  final List<Widget> children;

  const _VerticalWidget({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: children);
  }
}
//////////////////////////////////////////////////////////////////////////////

class _HorizontalWidget extends StatelessWidget {
  final List<Widget> children;

  const _HorizontalWidget({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, spacing: 10, children: children),
    );
  }
}
