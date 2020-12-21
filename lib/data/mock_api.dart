import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'base_http.dart';

//v1 正式 'https://nestciao.zc0901.com/api/app/v1/'

bool isTest = true;

// 后台测试
final http = isTest
    ? Http('http://nestciao.ngrok.zc0901.com/api/app/v2/')
    : Http('http://nestciao.zc0901.com/api/app/v2/');

// v2 中台测试接口
final httpMiddle = isTest
    ? Http('http://nestciao.ngrok.zc0901.com/api/public/v2/')
    : Http('http://nestciao.zc0901.com/api/public/v2/');

final testYapi = Http('http://yapi.zc0901.com/mock/69/api/app/v2/');

/// 案例工具
class Http extends BaseHttp {
  Http(String baseUrl) : super(baseUrl);

  @override
  void init() {
    interceptors.add(ApiInterceptor());
  }
}

class ApiInterceptor extends InterceptorsWrapper {
  @override
  onRequest(RequestOptions options) async {

    if (options.queryParameters.length != 0) {
      debugPrint("GET参数：${options.queryParameters}");
    }
    if (options.data != null) {
      debugPrint("POST参数：${options.data}");
    }
  }

  @override
  onResponse(Response response) async {
    ResponseData responseData = ResponseData.fromJson(response.data);
    debugPrint("请求返回数据 ：${response.data}\n");
    if (responseData.success) {
      response.data = responseData.data;
      http.resolve(response);
    } else if (responseData.code == -1) {
      response.statusCode = responseData.code;
      http.resolve(responseData);
    } else {
      throw NotSuccessException(responseData);
    }
  }
}

class ResponseData extends BaseResponseData {
  @override
  bool get success => (code == 200 || code == 0);

  ResponseData.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    data = json['data'];
  }
}
