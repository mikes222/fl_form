import 'package:fl_form/formfield/fl_text_form_field.dart';
import 'package:fl_form/formfield/widget/input_decoration_builder.dart';
import 'package:fl_form/formfield/widget/label_widget.dart';
import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';

import 'fl_form_field_theme.dart';
import 'widget/default_error_builder.dart';

class FlPasswordFormField extends FormField<String> {
  final TextEditingController? textEditingController;

  final bool obscureText;

  FlPasswordFormField({
    super.key,
    required String label,
    bool isRequired = false,
    super.validator,
    ValueChanged<String>? onChanged,
    super.initialValue,
    super.autovalidateMode,
    super.onSaved,
    super.restorationId,
    super.enabled,
    Widget? prefixIcon,
    bool autofocus = false,
    Brightness? keyboardAppearance,
    TextInputAction? textInputAction,
    double? paddingLeftError,
    Tuple2<Widget, Widget>? iconObscureText,
    ErrorBuilder errorBuilder = defaultErrorBuilder,
    this.textEditingController,
    this.obscureText = true,
    String? helperText,
    String? placeholderText,
  }) : super(
         builder: (field) {
           final state = field as FlPasswordFormFieldState;

           return Column(
             crossAxisAlignment: CrossAxisAlignment.stretch,
             children: [
               LabelWidget(label: label, isRequired: isRequired),
               TextField(
                 controller: state.textEditingController,
                 cursorWidth: 1,
                 obscureText: state.obscureText,
                 enabled: enabled,
                 autofocus: autofocus,
                 keyboardAppearance: keyboardAppearance,
                 textInputAction: textInputAction,
                 autocorrect: false,
                 enableSuggestions: false,
                 onChanged: (value) {
                   onChanged?.call(value);
                   state.didChange(value);
                 },
                 style: enabled
                     ? Theme.of(field.context).extension<FlFormFieldTheme>()?.style
                     : Theme.of(field.context).extension<FlFormFieldTheme>()?.disableStyle,
                 decoration: InputDecorationBuilder(
                   enabled: enabled,
                   hasError: state.hasError,
                   helperText: helperText,
                   placeholderText: placeholderText,
                   prefixIcon: prefixIcon,
                   suffixIcon: GestureDetector(
                     onTap: () {
                       state.toggleShowPass();
                     },
                     child: state.obscureText
                         ? (iconObscureText?.item1 ?? const Icon(Icons.visibility_outlined))
                         : (iconObscureText?.item2 ?? const Icon(Icons.visibility_off_outlined)),
                   ),
                 ).create(field.context),
               ),
               if (state.hasError) errorBuilder(state.context, state.errorText!),
             ],
           );
         },
       );
  @override
  FormFieldState<String> createState() => FlPasswordFormFieldState();
}

class FlPasswordFormFieldState extends FormFieldState<String> {
  late TextEditingController textEditingController;

  late bool obscureText;

  @override
  FlPasswordFormField get widget => super.widget as FlPasswordFormField;

  void toggleShowPass() {
    setState(() {
      obscureText = !obscureText;
    });
  }

  @override
  void didUpdateWidget(FlPasswordFormField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.obscureText != oldWidget.obscureText) obscureText = widget.obscureText;
    if (widget.initialValue != oldWidget.initialValue) {
      // when initialValue changed - maybe because you have an async call to retrieve the correct value and show the form field in the meantime with
      // a null-value, set the new initial value.
      setValue(widget.initialValue);
      textEditingController.text = widget.initialValue ?? '';
    }
  }

  @override
  void initState() {
    super.initState();
    obscureText = widget.obscureText;

    textEditingController = widget.textEditingController ?? TextEditingController(text: widget.initialValue);
    textEditingController.addListener(listen);
    setValue(widget.initialValue);
  }

  @override
  void dispose() {
    textEditingController.removeListener(listen);
    super.dispose();
  }

  void listen() {
    setValue(textEditingController.text);
  }
}
