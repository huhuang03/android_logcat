import 'dart:convert';
import 'dart:io';

typedef OnLogListener = Function(String log);

class Device {
  bool _hasStarted = false;
  bool _isStarting = false;
  bool _isPaused = false;
  Process? _process;

  OnLogListener? onLogListener;

  void setLogListener(OnLogListener onLogListener) {
    this.onLogListener = onLogListener;
  }

  void start({List<String>? tags}) {
    if (isStarting() || hasStarted()) {
      return;
    }

    stop();
    _isStarting = true;
    List<String> params = List.empty(growable: true);
    params.add("logcat");
    tags?.forEach((element) {
      params.add("-s");
      params.add(element);
    });

    Process.start("adb", params).then((value) {
      _process = value;
      _process!.stdout.transform(utf8.decoder)
      .forEach((element) {
        if (!_isPaused) {
          onLogListener?.call(element);
        }
      });
      _isStarting = false;
      _hasStarted = true;
    }).catchError((err) {
      print("start process trigger error: $err");
      _isStarting= false;
    });
  }

  void pause() {
    _isPaused = true;
  }

  void stop() {
    _hasStarted = false;
    _process?.kill(ProcessSignal.sigstop);
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