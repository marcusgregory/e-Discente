import 'package:fluttertoast/fluttertoast.dart';

class ToastUtil {
  static showShortToast(String msg) {
    Fluttertoast.showToast(
      msg: '$msg',
      toastLength: Toast.LENGTH_SHORT,
    );
  }
}
