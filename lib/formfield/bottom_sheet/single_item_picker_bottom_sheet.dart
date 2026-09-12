import 'package:flutter/material.dart';

import '../form_field_option.dart';

class SingleItemPickerBottomSheet<T> extends StatelessWidget {
  ///List options of picker
  final List<T> options;

  ///current option selected of picker
  final T? currentOption;

  final FlListBuilder<T>? listBuilder;

  static Future<T?> show<T>(BuildContext context, List<T> options, T? currentOption, FlListBuilder<T>? listBuilder) {
    return showModalBottomSheet<T>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return SingleItemPickerBottomSheet<T>(options: options, currentOption: currentOption, listBuilder: listBuilder);
      },
    );
  }

  const SingleItemPickerBottomSheet({super.key, required this.options, required this.currentOption, this.listBuilder});

  @override
  Widget build(BuildContext context) {
    if (options.isEmpty) {
      return const SizedBox(height: 200, child: Text('Empty Data'));
    }
    return ListView.builder(
      shrinkWrap: true,
      itemCount: options.length,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: options[index] == currentOption
              ? null
              : () {
                  Navigator.pop(context, options[index]);
                },
          child: listBuilder != null
              ? listBuilder!(context, options[index], options[index] == currentOption)
              : defaultFlListBuilder<T>(context, options[index], options[index] == currentOption),
        );
      },
    );
  }
}
