// @dart=2.9
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
import 'package:url_launcher/url_launcher.dart';

class DownloadService {
  final BuildContext _context;
  bool _isOpen = true;

  DownloadService(this._context);
  Future<void> downloadDocumento(
      String idTurma, DocumentoModel documento) async {
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
          execute(idTurma, documento, urlFile);
        } else {
          openUrl(urlFile);
        }
      } else {
        execute(idTurma, documento, urlFile);
      }
    }
  }

  Future<void> openUrl(String urlFile) async {
    String url = Uri.encodeFull(urlFile);
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      ToastUtil.showShortToast("Não foi possível abrir o documento");
    }
  }

  Future<void> execute(
      String idTurma, DocumentoModel documento, String urlFile) async {
    try {
      _showMaterialDialog(_context);
      _isOpen = true;
      var _permissionReady = await _checkPermission();
      var _localPath = (await _findLocalPath());

      var _filename = 'documento_turma_$idTurma.pdf';
      if (_permissionReady) {
        if (_localPath.contains('/storage/emulated/0')) {
          _localPath = '/storage/emulated/0/e-Discente/' +
              Settings.usuario.nome.trim().replaceAll(' ', '_');
          Directory d = Directory(_localPath);
          if (!d.existsSync()) {
            Directory(d.path).createSync(recursive: true);
          }
        }
        print(_localPath);
        // var sessaoDownloadModel =
        //     await SessaoDownload().requestSessaoDownload(idTurma);
        var _dio = Dio();
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

        final response = await _dio.get(urlFile,
            options: (Options(
              contentType: Headers.formUrlEncodedContentType,
              headers: {'User-Agent': 'Mozilla/5.0'},
              followRedirects: false,
            )));
        print(response.headers);
        _filename = response.headers
            .value('content-disposition')
            .split('=')[1]
            .replaceAll('"', '');
        print(_filename);
        int _fileLength = 0;
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
        await _dio.download(urlFile, _localPath + '/' + _filename,
            options: Options(
                contentType: Headers.formUrlEncodedContentType,
                headers: {'User-Agent': 'Mozilla/5.0'},
                followRedirects: false,
                method: 'GET'), onReceiveProgress: (received, total) {
          print(formatBytes(received));
          int percentage = ((received / total) * 100).floor();
          print('${percentage.toDouble()} %');

          _fileLength = received;
        });

        print(_isOpen);
        if (_isOpen) {
          Navigator.of(_context).pop();
          _showCompleteDialog(
              _context, _filename, _localPath + '/' + _filename, _fileLength);
        } else {
          ToastUtil.showLongToast(
              'Download do arquivo \"$_filename\" foi concluido\nTamanho: ${formatBytes(_fileLength)}');
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
    final directory = Theme.of(this._context).platform == TargetPlatform.android
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<bool> _checkPermission() async {
    if (Theme.of(this._context).platform == TargetPlatform.android) {
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

  _showMaterialDialog(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
              title: Text("Fazendo Download"),
              content: LinearProgressIndicator(value: null),
            )).then((value) => _isOpen = false);
  }

  _showCompleteDialog(
      BuildContext context, String fileName, String filePath, int fileLength) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
              title: Text("Deseja abrir?"),
              content: Text(
                  'O arquivo \"$fileName\" foi salvo no seu dispositivo\nTamanho: ${formatBytes(fileLength)}'),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Não')),
                TextButton(
                    onPressed: () {
                      OpenFile.open(filePath);
                      Navigator.of(context).pop();
                    },
                    child: Text('Sim'))
              ],
            ));
  }

  static String formatBytes(int bytes, {int decimals = 2}) {
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
    var i = (log(bytes) / log(1024)).floor();
    return ((bytes / pow(1024, i)).toStringAsFixed(decimals)) +
        ' ' +
        suffixes[i];
  }
}
