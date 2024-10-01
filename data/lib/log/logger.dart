import 'dart:io';

import 'package:logger/logger.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'log_format.dart';

final logger = setupLogger();

const logFileName = 'app.log';

Future<void> logStart() async {
  final packageInfo = await PackageInfo.fromPlatform();
  logger.i('App Name: ${packageInfo.appName}'
      '\nApp Version: ${packageInfo.version} (${packageInfo.buildNumber})'
      '\nPackageName: ${packageInfo.packageName}'
      '\n--------------------------------------------------------------');
}

Logger setupLogger() {
  final logger = Logger(
    filter: null,
    printer: AppLogPrinter(),
    output: AppFileOutput(),
  );

  logStart();

  return logger;
}

class AppFileOutput extends LogOutput {
  @override
  void output(OutputEvent event) async {
    final directory = await getApplicationDocumentsDirectory();
    final logFile = File('${directory.path}/$logFileName');

    for (var line in event.lines) {
      await logFile.writeAsString('$line\n', mode: FileMode.append);
    }
  }
}
