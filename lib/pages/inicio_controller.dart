import 'dart:async';

class InicioPageController {
  int pageIndex = 0;

  final _controller = StreamController.broadcast();

  Stream get stream => _controller.stream;

  void setPageIndex(int value) {
    pageIndex = value;
    _controller.sink.add(value);
  }

  void dispose() {
    _controller.close();
  }
}
