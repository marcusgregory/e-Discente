class DateUtil {
  static String getTimeElapsedByDate(String date) {
    Duration dateDuration = DateTime.now().difference(DateTime.parse(date));

    if (dateDuration.inDays >= 1) {
      return "${dateDuration.inDays} dias atrás";
    } else if (dateDuration.inHours >= 1) {
      return "${dateDuration.inHours} horas atrás";
    } else if (dateDuration.inMinutes >= 1) {
      return "${dateDuration.inMinutes} minutos atrás";
    } else if (dateDuration.inSeconds >= 1) {
      return "${dateDuration.inSeconds} segundos atrás";
    } else {
      return "Agora";
    }
  }
}
