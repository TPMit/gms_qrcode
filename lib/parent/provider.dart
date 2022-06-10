// ignore_for_file: use_key_in_widget_constructors, prefer_typing_uninitialized_variables, overridden_fields

import 'package:flutter/widgets.dart';

class Provider extends StatefulWidget {
  const Provider({this.data, this.child});

  static of(BuildContext context) {
    _InheritedProvider? p =
        // ignore: deprecated_member_use
        context.dependOnInheritedWidgetOfExactType<_InheritedProvider>();
    return p?.data;
  }

  final data;
  final child;

  @override
  State<StatefulWidget> createState() => _ProviderState();
}

class _ProviderState extends State<Provider> {
  @override
  initState() {
    super.initState();
    widget.data.addListener(didValueChange);
  }

  didValueChange() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return _InheritedProvider(
      data: widget.data,
      child: widget.child,
    );
  }

  @override
  dispose() {
    widget.data.removeListener(didValueChange);
    super.dispose();
  }
}

class _InheritedProvider extends InheritedWidget {
  _InheritedProvider({this.data, required this.child})
      : _dataValue = data.value,
        super(child: child);
  final data;
  @override
  final child;
  final _dataValue;

  @override
  bool updateShouldNotify(_InheritedProvider oldWidget) {
    return _dataValue != oldWidget._dataValue;
  }
}
