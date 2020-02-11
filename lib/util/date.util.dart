class DateUtil {
  static String getTimeElapsedByDate(String date) {
    Duration dateDuration = DateTime.now().difference(DateTime.parse(date));
    if (dateDuration.inDays >= 30) {
      return "${(dateDuration.inDays / 30).floor()} ${(dateDuration.inDays / 30).floor() == 1 ? "mês" : "meses"} atrás";
    } else if (dateDuration.inDays >= 1) {
      return "${dateDuration.inDays} ${(dateDuration.inDays == 1 ? "dia" : "dias")} atrás";
    } else if (dateDuration.inHours >= 1) {
      return "${dateDuration.inHours} ${(dateDuration.inHours == 1 ? "hora" : "horas")} atrás";
    } else if (dateDuration.inMinutes >= 1) {
      return "${dateDuration.inMinutes} ${(dateDuration.inMinutes == 1 ? "minuto" : "minutos")} atrás";
    } else if (dateDuration.inSeconds >= 1) {
      return "${dateDuration.inSeconds} ${(dateDuration.inSeconds == 1 ? "segundo" : "segundos")} atrás";
    } else {
      return "Agora";
    }
  }
}
