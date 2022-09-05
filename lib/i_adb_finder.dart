class IAdbFinder {
  String findAdb() => throw UnimplementedError();
}

class DefaultAdbFinder implements IAdbFinder {
  @override
  String findAdb() {
    // 在path中寻找adb?
    throw UnimplementedError();
  }
}