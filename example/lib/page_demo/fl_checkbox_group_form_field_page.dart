import 'package:fl_form/fl_form.dart';
import 'package:flutter/material.dart';

class FlCheckBoxGroupFormFieldPage extends StatefulWidget {
  const FlCheckBoxGroupFormFieldPage({super.key});

  @override
  State<FlCheckBoxGroupFormFieldPage> createState() => _FlCheckBoxGroupFormFieldPageState();
}

class _FlCheckBoxGroupFormFieldPageState extends State<FlCheckBoxGroupFormFieldPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Column(
          children: [
            FlCheckboxGroupFormField(
              label: 'Select Item',
              //builder: AvatarNameFormFieldWidgetBuilder(small: true),
              options: ['Item 1', 'Item 2', 'Item 3'],
            ),
            const SizedBox(height: 24),
            FlCheckboxGroupFormField(
              isRequired: true,
              autovalidateMode: AutovalidateMode.always,
              validator: (value) {
                if (value == null || value.isEmpty) return 'Data invalid';
                return null;
              },
              //builder: AvatarNameFormFieldWidgetBuilder(),
              label: 'Select Item',
              options: ['Dang Ngoc Duc', 'Vu Manh Quang', 'Hoang Van Thai', 'Nguyẽn Quang Sang', 'Chu Ngoc Mai', 'Do Thu Giang'],
            ),
          ],
        ),
      ),
    );
  }
}

//////////////////////////////////////////////////////////////////////////////

// class AvatarNameFormFieldWidgetBuilder implements FormFieldWidgetBuilder {
//   final bool small;
//
//   AvatarNameFormFieldWidgetBuilder({this.small = false});
//
//   @override
//   Widget buildForContent(BuildContext context, FormFieldOption formFieldOption) {
//     if (small) {
//       return Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           AvatarNameWidget(radius: 12, name: formFieldOption.value.toString()),
//           const SizedBox(width: 4),
//           Text(formFieldOption.value.toString()),
//         ],
//       );
//     }
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           AvatarNameWidget(radius: 24, name: formFieldOption.value.toString()),
//           const SizedBox(width: 12),
//           Column(
//             children: [
//               Text(formFieldOption.value.toString(), style: Theme.of(context).textTheme.titleMedium),
//               Text('dangngocduc.bk@gmail.com', style: Theme.of(context).textTheme.labelMedium),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   @override
//   Widget buildForList(BuildContext context, FormFieldOption formFieldOption, bool isSelected) {
//     if (small) {
//       return Row(
//         children: [
//           AvatarNameWidget(radius: 12, name: formFieldOption.value.toString()),
//           const SizedBox(width: 4),
//           Text(formFieldOption.value.toString()),
//           Spacer(),
//           if (isSelected) const Icon(Icons.done),
//         ],
//       );
//     }
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       child: Row(
//         children: [
//           AvatarNameWidget(radius: 24, name: formFieldOption.value.toString()),
//           const SizedBox(width: 12),
//           Column(
//             children: [
//               Text(formFieldOption.value.toString(), style: Theme.of(context).textTheme.titleMedium),
//               Text('dangngocduc.bk@gmail.com', style: Theme.of(context).textTheme.labelMedium),
//             ],
//           ),
//           Spacer(),
//           if (isSelected) const Icon(Icons.done),
//         ],
//       ),
//     );
//   }
// }
