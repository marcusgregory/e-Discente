import 'package:e_discente/util/toast.util.dart';
import 'package:url_launcher/url_launcher_string.dart';

Future<void> openUrl(String urlFile) async {
  String url = Uri.encodeFull(urlFile);
  if (await launchUrlString(url, mode: LaunchMode.externalApplication)) {
  } else {
    ToastUtil.showShortToast("Não foi possível abrir a url");
  }
}
