import 'package:fl_form/fl_form.dart';
import 'package:flutter/material.dart';

class MultipleItemPickerBottomSheet<T> extends StatefulWidget {
  ///List options of picker
  final List<T> options;

  ///current option selected of picker
  final List<T>? currentOption;

  final FlListBuilder<T>? listBuilder;

  static Future<List<T>?> show<T>(BuildContext context, List<T> options, List<T>? currentOption, FlListBuilder<T>? listBuilder) {
    return showModalBottomSheet<List<T>>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return MultipleItemPickerBottomSheet<T>(options: options, currentOption: currentOption, listBuilder: listBuilder);
      },
    );
  }

  const MultipleItemPickerBottomSheet({super.key, required this.options, required this.currentOption, this.listBuilder});

  @override
  State<MultipleItemPickerBottomSheet<T>> createState() => _State<T>();
}

//////////////////////////////////////////////////////////////////////////////

class _State<T> extends State<MultipleItemPickerBottomSheet<T>> {
  late List<T> currentOption;

  @override
  void initState() {
    super.initState();
    currentOption = [...widget.currentOption ?? []];
  }

  @override
  Widget build(BuildContext context) {
    if (widget.options.isEmpty) {
      return const SizedBox(height: 200, child: Text('Empty Data'));
    }
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: widget.options.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  if (currentOption.contains(widget.options[index])) {
                    setState(() {
                      currentOption.remove(widget.options[index]);
                    });
                  } else {
                    setState(() {
                      currentOption.add(widget.options[index]);
                    });
                  }
                },
                child: widget.listBuilder != null
                    ? widget.listBuilder!(context, widget.options[index], currentOption.contains(widget.options[index]))
                    : defaultFlListBuilder(context, widget.options[index], currentOption.contains(widget.options[index])),
              );
            },
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: ElevatedButton(
            onPressed: () {
              Navigator.pop(context, currentOption.isEmpty ? null : currentOption);
            },
            child: const Text('Submit'),
          ),
        ),
      ],
    );
  }
}
