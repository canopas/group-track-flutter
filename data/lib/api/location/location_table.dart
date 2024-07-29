import 'package:freezed_annotation/freezed_annotation.dart';

part 'location_table.freezed.dart';
part 'location_table.g.dart';

@freezed
class LocationTable with _$LocationTable {
  const LocationTable._();
  const factory LocationTable({
    required String userId,
    String? lastFiveMinutesLocations,
    String? lastLocationJourney,
  }) = _LocationTable;

  factory LocationTable.fromJson(Map<String, dynamic> json) =>
      _$LocationTableFromJson(json);

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'lastFiveMinutesLocations': lastFiveMinutesLocations,
      'lastLocationJourney': lastLocationJourney,
    };
  }

  factory LocationTable.fromMap(Map<String, dynamic> map) {
    return LocationTable(
      userId: map['userId'],
      lastFiveMinutesLocations: map['lastFiveMinutesLocations'],
      lastLocationJourney: map['lastLocationJourney'],
    );
  }
}
