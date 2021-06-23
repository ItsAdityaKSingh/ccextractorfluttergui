// Dart imports:
import 'dart:convert';
import 'dart:io';

// Package imports:
import 'package:file_selector/file_selector.dart';
import 'package:localstorage/localstorage.dart';

class CCExtractor {
  late Process process;
  final RegExp progressRegx = RegExp(r'###PROGRESS#(\d+)', multiLine: true);
  final RegExp summaryRegx = RegExp(r'\[(.*?)\]', multiLine: true);
  final RegExp logsRegx =
      RegExp(r'###SUBTITLE###(.+)|###TIME###(.+)', multiLine: true);
  final RegExp videoDetailsRegx = RegExp(r'###VIDEOINFO#(.+)', multiLine: true);
  late String outputFileName;
  late String outputformat;

  Future getData() async {
    LocalStorage storage = LocalStorage('config.json');
    await storage.ready;
    outputFileName = await storage.getItem('outputfilename');
    outputformat = await storage.getItem('outputformat');
  }

  String get ccextractor {
    return Platform.isWindows ? 'ccextractorwinfull.exe' : 'ccextractor';
  }

  Future<int> extractFile(
    XFile file, {
    required Function(String) listenProgress,
    required Function(String) listenOutput,
    required Function(List<String>) listenVideoDetails,
  }) async {
    await getData();
    process = await Process.start(
      ccextractor,
      [
        file.path,
        '--gui_mode_reports',
        // encoder
        '-latin1',
        // output file name
        outputFileName.isNotEmpty ? '-o' : '',
        outputFileName.isNotEmpty
            ? '${file.path.substring(0, file.path.lastIndexOf(RegExp(r'(\\|\/)')))}/$outputFileName.$outputformat'
            : '',
        // output format
        '-out=$outputformat',
      ],
    );

    process.stdout.transform(latin1.decoder).listen((update) {});

    process.stderr.transform(latin1.decoder).listen((update) {
      if (progressRegx.hasMatch(update)) {
        for (RegExpMatch i in progressRegx.allMatches(update)) {
          listenProgress(i[1]!);
        }
      }
      if (logsRegx.hasMatch(update)) {
        for (RegExpMatch i in logsRegx.allMatches(update)) {
          // 1,2 are here for regex groups, 1 corresponds to subtitle regex
          // match and 2 is time regex match. Later we can seperate this if
          // needed (no additonal benefit rn imo;td)
          if (i[1] != null) listenOutput(i[1]!);
          if (i[2] != null) listenOutput(i[2]!);
        }
      }
      if (videoDetailsRegx.hasMatch(update)) {
        for (RegExpMatch i in videoDetailsRegx.allMatches(update)) {
          listenVideoDetails(i[1]!.split('#'));
        }
      }
    });
    return process.exitCode;
  }

  /// Cancels the ongoing file process
  void cancelRun() {
    process.kill();
  }
}
