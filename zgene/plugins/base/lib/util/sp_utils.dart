import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

///sp工具类
class SpUtils {
  /// 静态私有实例对象
  static final _instance = SpUtils._init();

  /// 工厂构造函数 返回实例对象
  factory SpUtils() => _instance;

  /// SharedPreferences对象
  static SharedPreferences? _storage;

  /// 命名构造函数 用于初始化SharedPreferences实例对象
  SpUtils._init() {
    // _initStorage();
  }

  /// 初始化
  initStorage() async {
    // 若_不存在 则创建SharedPreferences实例
    if (_storage == null) _storage = await SharedPreferences.getInstance();
  }

  /// 设置存储
  setStorage(String key, dynamic value) {
    String type;
    // 监测value的类型 如果是Map和List,则转换成JSON，以字符串进行存储
    if (value is Map || value is List) {
      type = 'String';
      value = JsonEncoder().convert(value);
    }
    // 否则 获取value的类型的字符串形式
    else {
      type = value.runtimeType.toString();
    }
    // 根据value不同的类型 用不同的方法进行存储
    switch (type) {
      case 'String':
        _storage!.setString(key, value);
        break;
      case 'int':
        _storage!.setInt(key, value);
        break;
      case 'double':
        _storage!.setDouble(key, value);
        break;
      case 'bool':
        _storage!.setBool(key, value);
        break;
    }
  }

  /// 获取存储 注意：返回的是一个Future对象 要么用await接收 要么在.then中接收
  dynamic getStorage(String key) {
    // 获取key对应的value
    dynamic value = _storage!.get(key);
    // 判断value是不是一个json的字符串 是 则解码
    if (_isJson(value)) {
      return JsonDecoder().convert(value);
    } else {
      // 不是 则直接返回
      return value;
    }
  }

  /// 获取存储 defaultValue 需要的默认值
  dynamic getStorageDefault(String key, dynamic defaultValue) {
    // 获取key对应的value
    dynamic value = _storage!.get(key);
    if (value != null) {
      // 判断value是不是一个json的字符串 是 则解码
      if (_isJson(value)) {
        return JsonDecoder().convert(value);
      } else {
        // 不是 则直接返回
        return value;
      }
    } else {
      return defaultValue;
    }
  }

  /// 是否包含某个key
  bool hasKey(String key) {
    return _storage!.containsKey(key);
  }

  /// 删除key指向的存储 如果key存在则删除并返回true，否则返回false
  bool removeStorage(String key) {
    if (hasKey(key)) {
      _storage!.remove(key);
      return true;
    } else {
      return false;
    }
    // return  _storage.remove(key);
  }

  /// 清空存储 并总是返回true
  bool clear() {
    _storage!.clear();
    return true;
  }

  /// 获取所有的key 类型为Set<String>
  Set<String> getKeys() {
    return _storage!.getKeys();
  }

  // 判断是否是JSON字符串
  _isJson(dynamic value) {
    try {
      // 如果value是一个json的字符串 则不会报错 返回true
      JsonDecoder().convert(value);
      return true;
    } catch (e) {
      // 如果value不是json的字符串 则报错 进入catch 返回false
      return false;
    }
  }
}
