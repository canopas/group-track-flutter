import 'package:logger/logger.dart';

final logger = setupLogger();

Logger setupLogger() {
  final logger = Logger(
    filter: ProductionFilter(),
  );

  return logger;
}