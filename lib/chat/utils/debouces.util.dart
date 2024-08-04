import 'dart:async';

class DeboucesUtil {
  Timer? _timer;
  Timer? _timer2;
  Timer? _timer3;

  void debouceEvery(Function function) {
    const duration = Duration(milliseconds: 700);
    if (_timer == null) {
      function();
      _timer = Timer.periodic(duration, (Timer t) => function());
    }
    if (_timer2 != null) {
      _timer2!.cancel();
      //clear timer
    }
    _timer2 = Timer(duration, () {
      _timer!.cancel();
      _timer = null;
    });
  }

  void debouce(Function functionInit, Function functionFinal,
      {Duration duration = const Duration(milliseconds: 800)}) {
    //set the duration that you want call stopTyping() after that.
    if (_timer3 != null) {
      _timer3!.cancel();
      //clear timer
      functionInit();
    }
    _timer3 = Timer(duration, () => functionFinal());
  }
}
