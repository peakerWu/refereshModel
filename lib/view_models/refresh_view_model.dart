part of view_models;

/// 多页列表视图模型
///
/// 用于维护多页列表数据及状态，并提供下拉刷新、上拉加载方法
abstract class RefreshViewModel<T> extends ListViewModel<T> {
  bool userSuccess;

  RefreshViewModel({ViewState viewState, bool success: false})
      : super(viewState: viewState) {
    userSuccess = success;
  }

  /// 首页页码
  static const int firstPage = 1;

  /// 单页条数
  int pageSize = 20;

  /// 当前页码
  int currentPage = 1;

  ///该标记用来控制是否能上啦加载更改，目前只是定义、赋值，暂未使用。
  bool canLoadMore = false;

  /// 刷新控制器
  EasyRefreshController _controller = EasyRefreshController();

  EasyRefreshController get controller => _controller;

  /// 下拉刷新
  ///
  /// [init] 是否第一次加载
  /// true: Error 时跳转页码
  /// false: Error 时直接出提示
  @override
  Future<List<T>> refresh({bool init = false}) async {
    try {
      /* if (init) {
        setBusy();
      }*/
      currentPage = firstPage;
      var data = await loadData(page: firstPage);
      if (data.isEmpty) {
        canLoadMore = false;
        if (!init) {
          controller.finishRefresh(success: true);
        }
        list.clear();
        setEmpty();
      } else {
        onDataLoaded(data);
        list.clear();
        list.addAll(data);
        if (!init) {
          controller.finishRefresh(success: true, noMore: false);
          controller.resetLoadState();
        }

        canLoadMore = data.length > pageSize;
        if (userSuccess) {
          setSuccess();
        } else {
          setIdle();
        }

        if (pageSize > list.length) {
          await Future.delayed(Duration(milliseconds: 300), () {
            controller.finishLoad(success: true, noMore: true);
          });
        }
      }   
      return data;
    } catch (e, s) {
      if (init) list.clear();
      controller.finishRefresh(success: false, noMore: true);
      canLoadMore = false;
      setError(e, s);
      return null;
    }
  }

  /// 加载更多
  Future<List<T>> loadMore() async {
    try {
      var data = await loadData(page: ++currentPage);
      if (data.isEmpty) {
        currentPage--;
        // refreshController.loadNoData();
        controller.finishLoad(success: true, noMore: true);
        canLoadMore = false;
      } else {
        onDataLoaded(data);
        list.addAll(data);
        controller.finishLoad(success: true, noMore: data.length < pageSize);
        canLoadMore = data.length > pageSize;
        notifyListeners();
      }
      return data;
    } catch (e, s) {
      currentPage--;
      // refreshController.loadFailed();
      controller.finishLoad(success: false);
      canLoadMore = false;
      setError(e, s);
      return null;
    }
  }

  /// 加载数据
  Future<List<T>> loadData({int page});

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
