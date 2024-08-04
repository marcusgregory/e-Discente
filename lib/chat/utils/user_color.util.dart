import 'package:e_discente/util/color_utils/randomcolor.dart';
import 'package:flutter/material.dart';

import '../../util/color_utils/colortype.dart';
import '../../util/color_utils/luminos.dart';
import '../../util/color_utils/options.dart';

class UserColorUtil {
  static Map<String, UserColors> users = <String, UserColors>{};
  static UserColors getRandomColorsByUserName(String username) {
    username = username.toLowerCase().trim();
    if (users.containsKey(username)) {
      UserColors userColors = users[username] ??
          UserColors(light: Colors.black, dark: Colors.white);
      return userColors;
    } else {
      Options optionsLight = Options(
          format: Format.hex,
          colorType: ColorType.random,
          luminosity: Luminosity.light);
      Options optionsDark = Options(
          format: Format.hex,
          colorType: [
            ColorType.green,
            ColorType.blue,
            ColorType.orange,
            ColorType.red
          ],
          luminosity: Luminosity.dark);
      Color colorLight =
          Color(_getColorFromHex(RandomColor.getColor(optionsDark)));
      Color colorDark =
          Color(_getColorFromHex(RandomColor.getColor(optionsLight)));
      var userColors = UserColors(dark: colorDark, light: colorLight);
      users[username] = userColors;
      return userColors;
    }
  }

  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }
}

class UserColors {
  final Color light;
  final Color dark;

  UserColors({required this.light, required this.dark});
}
