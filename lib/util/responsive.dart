import 'package:flutter/widgets.dart';

class Responsive {
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 730;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width < 1190 &&
      MediaQuery.of(context).size.width >= 730;

  static bool isWeb(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1190;
}
