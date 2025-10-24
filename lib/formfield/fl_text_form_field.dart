import 'package:fl_form/formfield/widget/fl_textfield.dart';
import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';

import 'widget/default_error_builder.dart';

typedef ErrorBuilder = Widget Function(BuildContext context, String errorText);

class FlTextFormField extends FormField<String> {
  @Deprecated("Use FlPasswordFormField instead.")
  final bool isPassword;
  final TextEditingController? textEditingController;
  final ValueChanged<String?>? onChanged;

  FlTextFormField({
    super.key,
    required String label,
    String? placeholderText,
    bool isRequired = false,
    super.validator,
    this.onChanged,
    super.initialValue,
    super.autovalidateMode,
    super.onSaved,
    super.restorationId,
    super.enabled,
    @Deprecated("Use FlPasswordFormField instead.") this.isPassword = false,
    int minLines = 1,
    int maxLines = 1,
    Widget? prefixIcon,
    Widget? suffixIcon,
    bool autofocus = false,
    TextInputType? keyboardType,
    Brightness? keyboardAppearance,
    TextInputAction? textInputAction,
    int? maxLength,
    bool autocorrect = true,
    bool enableSuggestions = true,
    Iterable<String>? autofillHints,
    double? paddingLeftError,
    String? helperText,
    @Deprecated("Use FlPasswordFormField instead.") Tuple2<Widget, Widget>? iconObscureText,
    ErrorBuilder errorBuilder = defaultErrorBuilder,
    this.textEditingController,
  }) : super(
         builder: (field) {
           final state = field as FlTextFormFieldState;
           return FlTextfield(
             textEditingController: state.textEditingController,
             label: label,
             placeholderText: placeholderText,
             isRequired: isRequired,
             enabled: enabled,
             obscureText: state.obscureText,
             hasError: state.hasError,
             errorText: state.errorText,
             helperText: helperText,
             keyboardType: keyboardType,
             keyboardAppearance: keyboardAppearance,
             textInputAction: textInputAction,
             maxLength: maxLength,
             autocorrect: autocorrect,
             enableSuggestions: enableSuggestions,
             autofillHints: autofillHints,
             prefixIcon: prefixIcon,
             suffixIcon: isPassword
                 ? InkWell(
                     onTap: () {
                       state.toggleShowPass();
                     },
                     child: state.obscureText
                         ? (iconObscureText?.item1 ?? const Icon(Icons.visibility_outlined))
                         : (iconObscureText?.item2 ?? const Icon(Icons.visibility_off_outlined)),
                   )
                 : suffixIcon,

             autofocus: autofocus,
           );
         },
       );
  @override
  FormFieldState<String> createState() => FlTextFormFieldState();
}

//////////////////////////////////////////////////////////////////////////////

class FlTextFormFieldState extends FormFieldState<String> {
  late TextEditingController textEditingController;

  late bool obscureText;

  @override
  FlTextFormField get widget => super.widget as FlTextFormField;

  void toggleShowPass() {
    setState(() {
      obscureText = !obscureText;
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.isPassword) {
      obscureText = true;
    } else {
      obscureText = false;
    }

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
    widget.onChanged?.call(textEditingController.text);
    setValue(textEditingController.text);
  }

  @override
  void didUpdateWidget(FlTextFormField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != oldWidget.initialValue) {
      // when initialValue changed - maybe because you have an async call to retrieve the correct value and show the form field in the meantime with
      // a null-value, set the new initial value.
      setValue(widget.initialValue);
      textEditingController.text = widget.initialValue ?? '';
    }
  }
}
