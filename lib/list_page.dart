import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:referesh_model/sample_list_item.dart';
import 'package:referesh_model/viewModel/read_model.dart';
import 'package:referesh_model/view_model_widget.dart';

class ListPage extends StatefulWidget {
  ListPage({Key key}) : super(key: key);

  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  // 列表
  int _listCount = 20;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('EasyRefresh'),
      ),
      body: ViewModelWidget<ReadModel>(
        model: ReadModel(),
        onModelReady: (model) {
          model.initData();
        },
        builder: (_, ReadModel model, child) {
          return EasyRefresh(
            child: ListView.builder(
                padding: EdgeInsets.all(0.0),
                itemBuilder: (context, index) {
                  return SampleListItem(index: index);
                },
                itemCount: model.list.length),
            onRefresh: model.refresh,
            onLoad: model.loadMore,
          );
        },
      ),
    );
  }
}


class _Example extends StatefulWidget {
  @override
  _ExampleState createState() {
    return _ExampleState();
  }
}

class _ExampleState extends State<_Example> {
  EasyRefreshController _controller;

  // 条目总数
  int _count = 20;

  @override
  void initState() {
    super.initState();
    _controller = EasyRefreshController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("EasyRefresh"),
        ),
        body: EasyRefresh(
          // enableControlFinishRefresh: false,
          // enableControlFinishLoad: true,
          controller: _controller,
          header: ClassicalHeader(),
          footer: ClassicalFooter(),
          onRefresh: () async {
            await Future.delayed(Duration(seconds: 2), () {
              print('onRefresh');
              setState(() {
                _count = 20;
              });
              _controller.resetLoadState();
            });
          },
          onLoad: () async {
            await Future.delayed(Duration(seconds: 2), () {
              print('onLoad');
              setState(() {
                _count += 10;
              });
              _controller.finishLoad(success: true, noMore: _count >= 40);
            });
          },
          child: ListView.builder(
            itemCount: _count,
            itemBuilder: (_, index) {
              return Container(
                width: 60.0,
                height: 60.0,
                child: Center(
                  child: Text('$index'),
                ),
                color: index % 2 == 0 ? Colors.grey[300] : Colors.transparent,
              );
            },
          ),
        ),
        persistentFooterButtons: <Widget>[
          FlatButton(
              onPressed: () {
                _controller.callRefresh();
              },
              child: Text("Refresh", style: TextStyle(color: Colors.black))),
          FlatButton(
              onPressed: () {
                _controller.callLoad();
              },
              child: Text("Load more", style: TextStyle(color: Colors.black))),
        ]);
  }
}
