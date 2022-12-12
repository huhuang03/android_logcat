typedef OnLogListener = Function(String log);

class Device {
  bool _hasStarted = false;
  bool _isStarting = false;
  bool _isPaused = false;

  OnLogListener? onLogListener;

  void setLogListener(OnLogListener onLogListener) {
    this.onLogListener = onLogListener;
  }

  void start() {
    if (isStarting() || hasStarted()) {
      return;
    }
    _hasStarted = true;
  }

  void pause() {
    _isPaused = true;
  }

  void stop() {
    _hasStarted = false;
  }

  bool hasStarted() {
    return _hasStarted;
  }

  bool isStarting() {
    return _isStarting;
  }

  bool isPaused() {
    return _isPaused;
  }

}