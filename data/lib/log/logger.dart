import 'dart:io';

import 'package:logger/logger.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'log_format.dart';

final logger = setupLogger();

Logger setupLogger() {
  final logger = Logger(
    filter: ProductionFilter(),
  );

  return logger;
}