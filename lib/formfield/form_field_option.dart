import 'package:flutter/material.dart';

class FormFieldOption<T> {
  final T value;

  final String? label;

  final IconData? icon;

  final Object? additionalData;

  const FormFieldOption({required this.value, this.label, this.icon, this.additionalData});
}

//////////////////////////////////////////////////////////////////////////////

abstract class FormFieldWidgetBuilder {
  Widget buildForContent(BuildContext context, FormFieldOption formFieldOption);

  Widget buildForList(BuildContext context, FormFieldOption formFieldOption, bool isSelected);
}

//////////////////////////////////////////////////////////////////////////////

class DefaultFormFieldWidgetBuilder implements FormFieldWidgetBuilder {
  const DefaultFormFieldWidgetBuilder();

  @override
  Widget buildForContent(BuildContext context, FormFieldOption formFieldOption) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (formFieldOption.icon != null) Icon(formFieldOption.icon),
        if (formFieldOption.icon != null) SizedBox(width: (Theme.of(context).textTheme.bodyLarge?.fontSize ?? 0) / 2),
        Text(formFieldOption.label ?? formFieldOption.value.toString()),
      ],
    );
  }

  @override
  Widget buildForList(BuildContext context, FormFieldOption formFieldOption, bool isSelected) {
    return Row(
      children: [
        if (formFieldOption.icon != null) Icon(formFieldOption.icon, color: Theme.of(context).iconTheme.color),
        if (formFieldOption.icon != null) SizedBox(width: Theme.of(context).textTheme.bodyLarge?.fontSize),
        Text(formFieldOption.label ?? formFieldOption.value.toString(), style: Theme.of(context).textTheme.bodyLarge),
        const Spacer(),
        if (isSelected) const Icon(Icons.done),
      ],
    );
  }
}
