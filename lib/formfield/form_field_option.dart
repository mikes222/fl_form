import 'package:flutter/material.dart';

typedef FlContentBuilder<T> = Widget Function(BuildContext context, T? value);

typedef FlListBuilder<T> = Widget Function(BuildContext context, T value, bool isSelected);

Widget defaultFlContentBuilder<T>(BuildContext context, T? value) {
  return Text(value?.toString() ?? "");
}

Widget defaultFlListBuilder<T>(BuildContext context, T? value, bool isSelected) {
  return Row(children: [Text(value?.toString() ?? ""), const Spacer(), if (isSelected) const Icon(Icons.done)]);
}

//////////////////////////////////////////////////////////////////////////////

/// Helper class in case you want to render not only value.toString() but also separate labels and icons. Use it like so:
///
/// <code>
///     final options = [
//       const FormFieldOption(
//         value: "Auto",
//         label: "Auto",
//         icon: HugeIcon(icon: HugeIcons.strokeRoundedRotate01),
//       ),
//     ...
// ];
//
//           SegmentedButtonFormFieldCustom<FormFieldOption<String>>(
//             label: AppLocalization.of(context).lblOrientationInCockpit,
//             options: options,
//             initialValue: {options.firstWhere((test) => test.value == item.getOrientation())},
//             required: false,
//             enabled: editmode,
//             contentBuilder: defaultFlFormFieldOptionContentBuilder,
//             onChanged: (Set<FormFieldOption<String>>? val) {
//               OrientationMgr().setSetting(val?.firstOrNull?.value ?? "Auto");
//             },
//             onSaved: (Set<FormFieldOption<String>>? val) {
//               item.setOrientation(val?.firstOrNull?.value ?? "Auto");
//             },
//           ),
/// </code>
class FormFieldOption<T> {
  final T value;

  final String? label;

  final Widget? icon;

  final Object? additionalData;

  const FormFieldOption({required this.value, this.label, this.icon, this.additionalData});
}

//////////////////////////////////////////////////////////////////////////////

Widget defaultFlFormFieldOptionContentBuilder<T>(BuildContext context, FormFieldOption<T>? formFieldOption) {
  if (formFieldOption == null) return Text("");
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      if (formFieldOption.icon != null) formFieldOption.icon!,
      if (formFieldOption.icon != null) SizedBox(width: (Theme.of(context).textTheme.bodyLarge?.fontSize ?? 0) / 2),
      Text(formFieldOption.label ?? formFieldOption.value.toString()),
    ],
  );
}

Widget defaultFlFormFieldOptionListBuilder<T>(BuildContext context, FormFieldOption<T>? formFieldOption, bool isSelected) {
  if (formFieldOption == null) return Text("");
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      if (formFieldOption.icon != null) formFieldOption.icon!,
      if (formFieldOption.icon != null) SizedBox(width: (Theme.of(context).textTheme.bodyLarge?.fontSize ?? 0) / 2),
      Text(formFieldOption.label ?? formFieldOption.value.toString()),
      const Spacer(),
      if (isSelected) const Icon(Icons.done),
    ],
  );
}
