import 'package:flutter/widgets.dart';
import 'package:mazenki/core/vendors/get.it.dart';
import 'package:provider/provider.dart';

import 'base.controller.dart';

class BaseView<T extends BaseController> extends StatefulWidget {
  final Widget Function(BuildContext context, T viewController, Widget? child)
      builder;

  final Function(T)? onModelReady;
  final Function(T)? postInitState;
  const BaseView(
      {Key? key, required this.builder, this.onModelReady, this.postInitState})
      : super(key: key);

  @override
  _BaseViewState<T> createState() => _BaseViewState<T>();
}

class _BaseViewState<T extends BaseController> extends State<BaseView<T>> {
  T model = locator<T>();
  @override
  void initState() {
    final function = widget.onModelReady;
    if (function != null) {
      function(model);
    }
    super.initState();
    // final functionPost = widget.postInitState;
    // if (functionPost != null) {
    //   functionPost(model);
    // }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<T>(
      create: (_) => locator<T>(),
      child: Consumer<T>(builder: widget.builder),
    );
  }
}
