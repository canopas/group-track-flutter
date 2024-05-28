import 'package:logger/logger.dart';
import 'package:package_info_plus/package_info_plus.dart';
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
    output: null
  );

  logStart();

  return logger;
}
