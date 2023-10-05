import 'dart:io';
import 'dart:math';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:e_discente/models/documento.model.dart';
//import 'package:e_discente/repositories/sessao_download.repository.dart';
import 'package:e_discente/settings.dart';
import 'package:e_discente/util/toast.util.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:url_launcher/url_launcher_string.dart';

class DownloadService {
  final BuildContext _context;
  bool _isOpen = true;

  DownloadService(this._context);
  Future<void> downloadDocumento(
      String? idTurma, DocumentoModel documento) async {
    String urlFile =
        'https://sig.unilab.edu.br/sigaa/verArquivo?idArquivo=${documento.id}&key=${documento.key}&salvar=false';
    if (kIsWeb) {
      openUrl(urlFile);
    } else {
      if (Platform.isAndroid) {
        DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        int sdk = androidInfo.version.sdkInt;
        if (sdk <= 28) {
          _showDialogOpenExternalLinkOrDownload(_context, () {
            openUrl(urlFile);
          }, () {
            _executeDownload(_context, idTurma, documento, urlFile);
          });
        } else {
          _showDialogOpenExternalLink(
            _context,
            () {
              openUrl(urlFile);
            },
          );
        }
      } else {
        _showDialogOpenExternalLink(
          _context,
          () {
            openUrl(urlFile);
          },
        );
      }
    }
  }

  Future<void> openUrl(String urlFile) async {
    String url = Uri.encodeFull(urlFile);
    if (await launchUrlString(url, mode: LaunchMode.externalApplication)) {
    } else {
      ToastUtil.showShortToast("Não foi possível abrir o documento");
    }
  }

  Future<void> execute(String? idTurma, DocumentoModel documento,
      String urlFile, Function(double) percent) async {
    try {
      _isOpen = true;
      var permissionReady = await _checkPermission();
      var localPath = (await _findLocalPath());

      var filename = 'documento_turma_$idTurma.pdf';
      if (permissionReady) {
        if (localPath.contains('/storage/emulated/0')) {
          localPath =
              '/storage/emulated/0/e-Discente/${Settings.usuario!.nome.trim().replaceAll(' ', '_')}';
          Directory d = Directory(localPath);
          if (!d.existsSync()) {
            Directory(d.path).createSync(recursive: true);
          }
        }
        print(localPath);
        // var sessaoDownloadModel =
        //     await SessaoDownload().requestSessaoDownload(idTurma);
        var dio = Dio();
        // final response =
        //     await _dio.post('https://sig.unilab.edu.br/sigaa/ava/index.jsf',
        //         data: {
        //           'javax.faces.ViewState': sessaoDownloadModel.sessao,
        //           'formAva': 'formAva',
        //           'formAva:idTopicoSelecionado': '0',
        //           'id': documento.id.trim(),
        //           documento.formAva.trim(): documento.formAva.trim(),
        //         },
        //         options: (Options(
        //           contentType: Headers.formUrlEncodedContentType,
        //           headers: {
        //             'Cookie':
        //                 'JSESSIONID=' + sessaoDownloadModel.cookieSessao.trim(),
        //             'User-Agent': 'Mozilla/5.0'
        //           },
        //           followRedirects: false,
        //         )));
        // print(response.headers);
        // _filename = response.headers
        //     .value('content-disposition')
        //     .split('=')[1]
        //     .replaceAll('"', '');

        final response = await dio.get(urlFile,
            options: (Options(
              contentType: Headers.formUrlEncodedContentType,
              headers: {'User-Agent': 'Mozilla/5.0'},
              followRedirects: false,
            )));
        print(response.headers);
        filename = response.headers
            .value('content-disposition')!
            .split('=')[1]
            .replaceAll('"', '');
        print(filename);
        int fileLength = 0;
        // await _dio.download('https://sig.unilab.edu.br/sigaa/ava/index.jsf',
        //     _localPath + '/' + _filename,
        //     data: {
        //       'javax.faces.ViewState': sessaoDownloadModel.sessao,
        //       'formAva': 'formAva',
        //       'formAva:idTopicoSelecionado': '0',
        //       'id': documento.id.trim(),
        //       documento.formAva.trim(): documento.formAva.trim(),
        //     },
        //     options: Options(
        //         contentType: Headers.formUrlEncodedContentType,
        //         headers: {
        //           'Cookie':
        //               'JSESSIONID=' + sessaoDownloadModel.cookieSessao.trim(),
        //           'User-Agent': 'Mozilla/5.0'
        //         },
        //         followRedirects: false,
        //         method: 'POST'), onReceiveProgress: (rec, res) {
        //   print(formatBytes(rec));
        //   _fileLength = rec;
        // });
        await dio.download(urlFile, '$localPath/$filename',
            options: Options(
                contentType: Headers.formUrlEncodedContentType,
                headers: {'User-Agent': 'Mozilla/5.0'},
                followRedirects: false,
                method: 'GET'), onReceiveProgress: (received, total) {
          print(formatBytes(received));
          int percentage = ((received / total) * 100).floor();
          print('${percentage.toDouble()} %');
          percent(percentage.toDouble() / 100.0);

          fileLength = received;
        });

        print(_isOpen);
        if (_isOpen) {
          Navigator.of(_context).pop();
          _showCompleteDialog(
              _context, filename, '$localPath/$filename', fileLength);
        } else {
          ToastUtil.showLongToast(
              'Download do arquivo "$filename" foi concluido\nTamanho: ${formatBytes(fileLength)}');
        }
      }
    } catch (e) {
      print(_isOpen);
      if (_isOpen) {
        Navigator.of(_context).pop();
      }
      ToastUtil.showLongToast('Ocorreu um erro ao baixar o Documento');
    } finally {}
  }

  Future<String> _findLocalPath() async {
    final directory = Theme.of(_context).platform == TargetPlatform.android
        ? await (getExternalStorageDirectory())
        : await getApplicationDocumentsDirectory();
    return directory!.path;
  }

  Future<bool> _checkPermission() async {
    if (Theme.of(_context).platform == TargetPlatform.android) {
      final status = await Permission.storage.status;
      if (status != PermissionStatus.granted) {
        final result = await Permission.storage.request();
        if (result == PermissionStatus.granted) {
          return true;
        }
      } else {
        return true;
      }
    } else {
      return true;
    }
    return false;
  }

  _executeDownload(BuildContext context, String? idTurma,
      DocumentoModel documento, String urlFile) {
    double? percent;
    StateSetter? setState;
    execute(idTurma, documento, urlFile, (percent) {
      if (setState != null) {
        setState(() {
          percent = percent;
        });
      }
    });
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => StatefulBuilder(builder: (context, setState) {
              setState = setState;

              return AlertDialog(
                title: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text('Fazendo Download'),
                    Visibility(
                        visible: percent != null,
                        child: Text(percent != null
                            ? ' (${(percent * 100).floor()}%)'
                            : '')),
                  ],
                ),
                content: LinearProgressIndicator(value: percent),
              );
            })).then((value) => _isOpen = false);
  }

  _showCompleteDialog(
      BuildContext context, String fileName, String filePath, int fileLength) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
              title: const Text("Deseja abrir?"),
              content: Text(
                  'O arquivo "$fileName" foi salvo no seu dispositivo\nTamanho: ${formatBytes(fileLength)}'),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Não')),
                TextButton(
                    onPressed: () {
                      OpenFile.open(filePath);
                      Navigator.of(context).pop();
                    },
                    child: const Text('Sim'))
              ],
            ));
  }

  _showDialogOpenExternalLinkOrDownload(
      BuildContext context, Function open, Function download) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
              title: const Text("Deseja baixar ou abrir?"),
              content: const Text(
                  'Você deseja baixar o arquivo em seu dispositivo ou abrir em seu navegador?'),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      download();
                    },
                    child: const Text('Baixar')),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      open();
                    },
                    child: const Text('Abrir'))
              ],
            ));
  }

  _showDialogOpenExternalLink(BuildContext context, Function open) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
              title: const Text("Deseja abrir?"),
              content:
                  const Text('Você deseja abrir o arquivo em seu navegador?'),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancelar')),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      open();
                    },
                    child: const Text('Abrir'))
              ],
            ));
  }

  static String formatBytes(int bytes, {int decimals = 2}) {
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
    var i = (log(bytes) / log(1024)).floor();
    return '${(bytes / pow(1024, i)).toStringAsFixed(decimals)} ${suffixes[i]}';
  }
}
