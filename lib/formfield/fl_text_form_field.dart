import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';

import 'fl_form_field_theme.dart';

typedef ErrorBuilder = Widget Function(BuildContext context, String errorText, FormFieldState state);

class FlTextFormField extends FormField<String> {
  final bool isPassword;
  final TextEditingController? textEditingController;

  FlTextFormField({
    super.key,
    required String label,
    String? placeholderText,
    bool isRequired = false,
    FormFieldValidator<String>? validator,
    ValueChanged<String>? onChanged,
    String? initialValue,
    AutovalidateMode? autovalidateMode,
    FormFieldSetter<String>? onSaved,
    String? restorationId,
    bool enabled = true,
    @Deprecated("Use FlPasswordFormField instead.") this.isPassword = false,
    int maxLines = 1,
    Widget? prefixIcon,
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
    ErrorBuilder? errorBuilder,
    this.textEditingController,
  }) : super(
         validator: validator,
         onSaved: onSaved,
         initialValue: initialValue,
         autovalidateMode: autovalidateMode,
         restorationId: restorationId,
         enabled: enabled,
         builder: (field) {
           final state = field as FlTextFormFieldState;

           return Column(
             crossAxisAlignment: CrossAxisAlignment.stretch,
             children: [
               Padding(
                 padding: const EdgeInsets.only(bottom: 4),
                 child: RichText(
                   text: TextSpan(
                     style: Theme.of(field.context).extension<FlFormFieldTheme>()?.labelStyle,
                     children: [
                       TextSpan(text: label),
                       if (isRequired)
                         TextSpan(
                           text: ' *',
                           style: Theme.of(field.context).extension<FlFormFieldTheme>()?.labelStyle.copyWith(color: Colors.red),
                         ),
                     ],
                   ),
                 ),
               ),
               TextField(
                 controller: state.textEditingController,
                 cursorWidth: 1,
                 obscureText: state.obscureText,
                 enabled: enabled,
                 maxLines: maxLines,
                 minLines: maxLines,
                 autofocus: autofocus,
                 keyboardAppearance: keyboardAppearance,
                 keyboardType: keyboardType,
                 maxLength: maxLength,
                 textInputAction: textInputAction,
                 autocorrect: autocorrect,
                 enableSuggestions: enableSuggestions,
                 autofillHints: autofillHints,
                 onChanged: (value) {
                   onChanged?.call(value);
                   state.didChange(value);
                 },
                 style: enabled
                     ? Theme.of(field.context).extension<FlFormFieldTheme>()?.style
                     : Theme.of(field.context).extension<FlFormFieldTheme>()?.disableStyle,
                 decoration: InputDecoration(
                   hintText: placeholderText,
                   prefixIcon: prefixIcon,
                   fillColor: enabled
                       ? Theme.of(field.context).extension<FlFormFieldTheme>()?.inputDecorationTheme.fillColor
                       : Theme.of(field.context).extension<FlFormFieldTheme>()?.fillColorDisable,
                   suffixIcon: isPassword
                       ? GestureDetector(
                           onTap: () {
                             state.toglgleShowPass();
                           },
                           child: state.obscureText
                               ? (iconObscureText?.item1 ?? const Icon(Icons.visibility_outlined))
                               : (iconObscureText?.item2 ?? const Icon(Icons.visibility_off_outlined)),
                         )
                       : null,
                   enabledBorder: state.hasError ? Theme.of(field.context).extension<FlFormFieldTheme>()?.inputDecorationTheme.errorBorder : null,
                   focusedBorder: state.hasError ? Theme.of(field.context).extension<FlFormFieldTheme>()?.inputDecorationTheme.focusedErrorBorder : null,
                   disabledBorder: Theme.of(field.context).extension<FlFormFieldTheme>()?.inputDecorationTheme.disabledBorder,
                   border: state.hasError ? Theme.of(field.context).extension<FlFormFieldTheme>()?.inputDecorationTheme.errorBorder : null,
                   helperText: helperText,
                 ).applyDefaults(Theme.of(field.context).extension<FlFormFieldTheme>()?.inputDecorationTheme ?? Theme.of(field.context).inputDecorationTheme),
               ),
               if (state.hasError)
                 errorBuilder != null
                     ? errorBuilder(field.context, state.errorText!, state)
                     : Padding(
                         // todo: use Theme.of(field.context).extension<FlFormFieldTheme>()?.inputDecorationTheme.contentPadding completely instead of just the left-property
                         padding: EdgeInsets.only(
                           top: 4,
                           left:
                               paddingLeftError ??
                               (Theme.of(field.context).extension<FlFormFieldTheme>()?.inputDecorationTheme.contentPadding != null
                                       ? Theme.of(field.context).extension<FlFormFieldTheme>()?.inputDecorationTheme.contentPadding as EdgeInsets
                                       : null)
                                   ?.left ??
                               4,
                         ),
                         child: RichText(
                           text: TextSpan(
                             style: Theme.of(field.context).extension<FlFormFieldTheme>()?.errorStyle,
                             children: [TextSpan(text: state.errorText)],
                           ),
                         ),
                       ),
             ],
           );
         },
       );
  @override
  FormFieldState<String> createState() => FlTextFormFieldState();
}

class FlTextFormFieldState extends FormFieldState<String> {
  late TextEditingController textEditingController;

  late bool obscureText;

  @override
  FlTextFormField get widget => super.widget as FlTextFormField;

  void toglgleShowPass() {
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
  }
}
