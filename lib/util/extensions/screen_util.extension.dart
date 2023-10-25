import 'package:flutter/widgets.dart';

extension ScreenUtilExtension on BuildContext {
  double get screenHeight => MediaQuery.of(this).size.height;
  double get screenWidth => MediaQuery.of(this).size.width;

  double screenHeightPercentage(double percentage) {
    return screenHeight * percentage;
  }

  double screenWidthPercentage(double percentage) {
    return screenWidth * percentage;
  }

  double blockSizeHorizontal(double percentage) {
    return screenWidth * percentage / 100;
  }

  double blockSizeVertical(double percentage) {
    return screenHeight * percentage / 100;
  }

  double textSize(double size) {
    // Ajusta o tamanho do texto com base no tamanho da tela.
    if (isSmartphone) {
      return size * 0.8;
    } else if (isTablet) {
      return size * 1.0;
    } else {
      return size * 1.2;
    }
  }

  bool get isSmartphone => screenWidth < 600;
  bool get isTablet => screenWidth >= 600 && screenWidth < 1024;
  bool get isDesktop => screenWidth >= 1024;
}
