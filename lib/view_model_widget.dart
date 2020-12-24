import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// 视图模型部件
class ViewModelWidget<M extends ChangeNotifier> extends StatefulWidget {
  final ValueWidgetBuilder<M> builder;
  final M model;
  final Widget child;
  final Function(M model) onModelReady;
  // final bool autoDispose;

  const ViewModelWidget({
    Key key,
    @required this.builder,
    @required this.model,
    this.child,
    this.onModelReady,
    // this.autoDispose: true,
  }) : super(key: key);

  @override
  _ViewModelWidgetState<M> createState() => _ViewModelWidgetState<M>();
}

class _ViewModelWidgetState<T extends ChangeNotifier>
    extends State<ViewModelWidget<T>> {
  T model;

  @override
  void initState() {
    super.initState();
    model = widget.model;
    widget.onModelReady?.call(model);
  }

  // @override
  // void dispose() {
  //   if (widget.autoDispose) model.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<T>(
      create: (_) => model,
      child: Consumer<T>(
        builder: widget.builder,
        child: widget.child,
      ),
    );
  }
}

class ViewModelWidget2<M1 extends ChangeNotifier, M2 extends ChangeNotifier>
    extends StatefulWidget {
  final Widget Function(
      BuildContext context, M1 model1, M2 model2, Widget child) builder;
  final M1 model1;
  final M2 model2;
  final Widget child;
  final Function(M1 model1, M2 model2) onModelReady;
  final bool autoDispose;

  const ViewModelWidget2({
    Key key,
    @required this.builder,
    @required this.model1,
    @required this.model2,
    this.child,
    this.onModelReady,
    this.autoDispose: true,
  }) : super(key: key);

  @override
  _ViewModelWidget2<M1, M2> createState() => _ViewModelWidget2<M1, M2>();
}

class _ViewModelWidget2<M1 extends ChangeNotifier, M2 extends ChangeNotifier>
    extends State<ViewModelWidget2<M1, M2>> {
  M1 model1;
  M2 model2;

  @override
  void initState() {
    model1 = widget.model1;
    model2 = widget.model2;
    widget.onModelReady?.call(model1, model2);
    super.initState();
  }

  @override
  void dispose() {
    if (widget.autoDispose) {
      model1.dispose();
      model2.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<M1>.value(value: model1),
        ChangeNotifierProvider<M2>.value(value: model2),
      ],
      child: Consumer2<M1, M2>(
        builder: widget.builder,
        child: widget.child,
      ),
    );
  }
}
// 三模型视图
class ViewModelWidget3<M1 extends ChangeNotifier, M2 extends ChangeNotifier, M3 extends ChangeNotifier>
    extends StatefulWidget {
  final Widget Function(
      BuildContext context, M1 model1, M2 model2, M3 model3, Widget child) builder;
  final M1 model1;
  final M2 model2;
  final M3 model3;
  final Widget child;
  final Function(M1 model1, M2 model2, M3 model3) onModelReady;
  final bool autoDispose;

  const ViewModelWidget3({
    Key key,
    @required this.builder,
    @required this.model1,
    @required this.model2,
    @required this.model3,
    this.child,
    this.onModelReady,
    this.autoDispose: true,
  }) : super(key: key);

  @override
  _ViewModelWidget3<M1, M2, M3> createState() => _ViewModelWidget3<M1, M2, M3>();
}

class _ViewModelWidget3<M1 extends ChangeNotifier, M2 extends ChangeNotifier, M3 extends ChangeNotifier>
    extends State<ViewModelWidget3<M1, M2, M3>> {
  M1 model1;
  M2 model2;
  M3 model3;

  @override
  void initState() {
    model1 = widget.model1;
    model2 = widget.model2;
    model3 = widget.model3;
    widget.onModelReady?.call(model1, model2, model3);
    super.initState();
  }

  @override
  void dispose() {
    if (widget.autoDispose) {
      model1.dispose();
      model2.dispose();
      model3.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<M1>.value(value: model1),
        ChangeNotifierProvider<M2>.value(value: model2),
        ChangeNotifierProvider<M3>.value(value: model3),
      ],
      child: Consumer3<M1, M2, M3>(
        builder: widget.builder,
        child: widget.child,
      ),
    );
  }
}
