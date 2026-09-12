import 'dart:async';

import 'package:fl_form/fl_form.dart';
import 'package:fl_form/formfield/widget/default_error_builder.dart';
import 'package:flutter/material.dart';
import 'package:stream_transform/stream_transform.dart';

import '../fl_form_field_theme.dart';

typedef OnSearch<T> = Future<List<T>> Function(String keyword);

class FlSearchDialog<T> extends StatefulWidget {
  final OnSearch<T> onSearch;
  final FlListBuilder<T>? listBuilder;
  final WidgetBuilder? loadingBuilder;
  final ErrorWidgetBuilder? errorWidgetBuilder;
  final String? searchPlaceholder;
  const FlSearchDialog({super.key, required this.onSearch, this.listBuilder, this.errorWidgetBuilder, this.loadingBuilder, this.searchPlaceholder});

  @override
  State<FlSearchDialog<T>> createState() => _FlSearchDialogState<T>();
}

//////////////////////////////////////////////////////////////////////////////

class _FlSearchDialogState<T> extends State<FlSearchDialog<T>> {
  final TextEditingController controller = TextEditingController();

  final StreamController<String> _searchStream = StreamController.broadcast();

  late final Stream<_SearchResult<T>> _searchResults;

  _SearchResult<T> _lastResult = _SearchResult();

  bool _initial = false;

  @override
  void initState() {
    super.initState();
    _searchResults = _searchStream.stream.debounce(const Duration(milliseconds: 700)).switchMap(_performSearch);
  }

  Stream<_SearchResult<T>> _performSearch(String keyword) async* {
    yield _SearchResult(loading: true);
    try {
      final List<T> results = await widget.onSearch(keyword);
      yield _SearchResult(result: results);
    } catch (error, stackTrace) {
      yield _SearchResult(error: error, stackTrace: stackTrace);
    }
  }

  @override
  void dispose() {
    _searchStream.close();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // let the background shine through
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Theme.of(context).scaffoldBackgroundColor, Colors.transparent],
        ),
      ),
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor.withAlpha(200),
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: SafeArea(
            child: Container(
              decoration: BoxDecoration(border: Border(bottom: Divider.createBorderSide(context))),
              child: Container(
                decoration: BoxDecoration(color: Theme.of(context).inputDecorationTheme.fillColor),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(top: 2),
                        child: TextField(
                          key: Key("search_field"),
                          cursorWidth: 1,
                          onChanged: (value) {
                            _searchStream.sink.add(value);
                          },
                          controller: controller,
                          autofocus: true,
                          style: Theme.of(context).extension<FlFormFieldTheme>()?.style,
                          decoration: InputDecoration(
                            hintStyle: Theme.of(context).extension<FlFormFieldTheme>()?.placeHolderStyle,
                            hintText: widget.searchPlaceholder ?? 'Type Something...',
                            contentPadding: const EdgeInsets.only(left: 8, top: 4),
                            border: InputBorder.none,
                            errorBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            focusedErrorBorder: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        controller.clear();
                        _searchStream.sink.add('');
                      },
                      icon: const Icon(Icons.clear_rounded),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        body: StreamBuilder<_SearchResult<T>>(
          stream: _searchResults,
          builder: (BuildContext context, AsyncSnapshot<_SearchResult<T>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              if (!_initial) {
                _searchStream.sink.add('');
                _initial = true;
              }
            }
            final result = snapshot.data;
            if (result != null && !result.loading) {
              _lastResult = result;
            }
            final items = _lastResult.result;
            final error = result?.error;
            return Stack(
              children: [
                if (items.isNotEmpty)
                  ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Navigator.pop(context, items[index]);
                        },
                        child: widget.listBuilder != null
                            ? widget.listBuilder!(context, items[index], false)
                            : defaultFlListBuilder(context, items[index], false),
                      );
                    },
                  ),
                if (widget.loadingBuilder != null && (result?.loading ?? false)) Center(child: widget.loadingBuilder!(context)),
                if (error != null)
                  widget.errorWidgetBuilder != null
                      ? widget.errorWidgetBuilder!(FlutterErrorDetails(exception: error, stack: result?.stackTrace))
                      : defaultErrorBuilder(context, error.toString()),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _SearchResult<T> {
  final List<T> result;

  final bool loading;

  final Object? error;

  final StackTrace? stackTrace;

  _SearchResult({this.result = const [], this.loading = false, this.error, this.stackTrace});
}
