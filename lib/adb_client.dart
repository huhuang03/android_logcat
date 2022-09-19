import 'dart:io';

class AdbClient {
  void start() {
    Socket.connect("127.0.0.1", 5937)
        .then((socket) {
          print("socket: $socket");
    }, onError: (err) {
          print("onError: $err");
    }).catchError((err) {
      print("catchError: $err");
    });
  }
}