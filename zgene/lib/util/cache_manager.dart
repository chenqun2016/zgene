import 'dart:io';
import 'package:path_provider/path_provider.dart';

/// 缓存管理类
/// ./lib/utils/cache_util.dart
class CacheUtil {
  /// 获取缓存大小
  static Future<int> total() async {
    Directory tempDir = await getTemporaryDirectory();
    if (tempDir == null) return 0;
    int total = await _reduce(tempDir);
    return total;
  }

  static String formatSize(int value) {
    if (null == value) {
      return '0';
    }
    List<String> unitArr = []..add('B')..add('K')..add('M')..add('G');
    int index = 0;
    while (value > 1024) {
      index++;
      value = (value / 1024) as int;
    }
    String size = value.toStringAsFixed(2);
    return size + unitArr[index];
  }

  static Future<String> loadCache() async {
    Directory tempDir = await getTemporaryDirectory();
    double value = await _getTotalSizeOfFilesInDir(tempDir);

    print('临时目录大小: ' + value.toString());
    return _renderSize(value);
  }

// 循环计算文件的大小（递归）
  static Future<double> _getTotalSizeOfFilesInDir(
      final FileSystemEntity file) async {
    if (file is File) {
      int length = await file.length();
      return double.parse(length.toString());
    }
    if (file is Directory) {
      final List<FileSystemEntity> children = file.listSync();
      double total = 0;
      if (children != null)
        for (final FileSystemEntity child in children)
          total += await _getTotalSizeOfFilesInDir(child);
      return total;
    }
    return 0;
  }

  // 递归方式删除目录
  Future<Null> _delDir(FileSystemEntity file) async {
    if (file is Directory) {
      final List<FileSystemEntity> children = file.listSync();
      for (final FileSystemEntity child in children) {
        await _delDir(child);
      }
    }
    await file.delete();
  }

  static _renderSize(double value) {
    if (null == value) {
      return 0;
    }
    List<String> unitArr = []..add('B')..add('K')..add('M')..add('G');
    int index = 0;
    while (value > 1024) {
      index++;
      value = value / 1024;
    }
    String size = value.toStringAsFixed(2);
    if (size == '0.00') {
      return '0M';
    }
    // print('size:${size == 0}\n ==SIZE${size}');
    return size + unitArr[index];
  }

  /// 清除缓存
  static Future<void> clear() async {
    Directory tempDir = await getTemporaryDirectory();
    if (tempDir == null) return;
    await _delete(tempDir);
  }

  /// 递归缓存目录，计算缓存大小
  static Future<int> _reduce(final FileSystemEntity file) async {
    /// 如果是一个文件，则直接返回文件大小
    if (file is File) {
      int length = await file.length();
      return length;
    }

    /// 如果是目录，则遍历目录并累计大小
    if (file is Directory) {
      final List<FileSystemEntity> children = file.listSync();

      int total = 0;

      if (children != null && children.isNotEmpty)
        for (final FileSystemEntity child in children)
          total += await _reduce(child);

      return total;
    }

    return 0;
  }

  /// 递归删除缓存目录和文件
  static Future<void> _delete(FileSystemEntity file) async {
    if (file is Directory) {
      final List<FileSystemEntity> children = file.listSync();
      for (final FileSystemEntity child in children) {
        await _delete(child);
      }
    } else {
      await file.delete();
    }
  }
}
