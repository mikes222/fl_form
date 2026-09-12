import 'package:fl_form/fl_form.dart';
import 'package:fl_form/formfield/widget/fl_readonly_field.dart';
import 'package:flutter/material.dart';

class FlRadioButtonFormField<T> extends FormField<T> {
  FlRadioButtonFormField({
    super.key,
    required String label,
    bool isRequired = false,
    super.validator,
    super.initialValue,
    required Iterable<T> options,
    FlContentBuilder<T>? contentBuilder,
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
           return FlReadonlyField(
             label: label,
             isRequired: isRequired,
             enabled: enabled,
             hasError: state.hasError,
             placeholderText: placeholderText,
             helperText: helperText,
             errorText: state.errorText,
             content: RadioGroup<T>(
               onChanged: (T? value) {
                 onChanged?.call(value);
                 state.didChange(value);
               },
               groupValue: state.value,
               child: vertical
                   ? _VerticalWidget(options: options, contentBuilder: contentBuilder ?? defaultFlContentBuilder<T>, enabled: enabled)
                   : _HorizontalWidget(options: options, contentBuilder: contentBuilder ?? defaultFlContentBuilder<T>, enabled: enabled),
             ),
           );
         },
       );

  static List<Widget> _buildChildren<T>(BuildContext context, Iterable<T> options, FlContentBuilder<T> contentBuilder, bool enabled) {
    return options.map((element) {
      final String optionKey;
      if (element is FormFieldOption) {
        final option = element as FormFieldOption;
        optionKey = option.label ?? option.value.toString();
      } else {
        optionKey = element.toString();
      }
      return InkWell(
        onTap: enabled
            ? () {
                RadioGroup.maybeOf<T>(context)?.onChanged(element);
              }
            : null,
        child: Row(
          children: [
            Radio<T>(key: Key(optionKey), value: element, enabled: enabled),
            contentBuilder(context, element),
          ],
        ),
      );
    }).toList();

    // // intrinsic width is necessary for horizontal elements
    // return IntrinsicWidth(
    //   child: RadioListTile(
    //     value: e.value,
    //     //dense: true,
    //     enabled: enabled,
    //     //visualDensity: VisualDensity.compact,
    //     title: builder.buildForContent(state.context, e),
    //   ),
    // );
    //}).toList();
  }
}

//////////////////////////////////////////////////////////////////////////////

class _VerticalWidget<T> extends StatelessWidget {
  final Iterable<T> options;
  final FlContentBuilder<T> contentBuilder;

  final bool enabled;

  const _VerticalWidget({super.key, required this.options, required this.contentBuilder, this.enabled = true});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: FlRadioButtonFormField._buildChildren(context, options, contentBuilder, enabled));
  }
}
//////////////////////////////////////////////////////////////////////////////

class _HorizontalWidget<T> extends StatelessWidget {
  final Iterable<T> options;
  final FlContentBuilder<T> contentBuilder;

  final bool enabled;

  const _HorizontalWidget({super.key, required this.options, required this.contentBuilder, this.enabled = true});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10,
        children: FlRadioButtonFormField._buildChildren(context, options, contentBuilder, enabled),
      ),
    );
  }
}
