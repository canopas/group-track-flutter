import 'dart:collection';

import 'package:data/api/location/journey/journey.dart';
import 'package:data/api/location/location.dart';

class LocationCache {
  final Cache<String, ApiLocationJourney> _lastJourneyCache;
  final Cache<String, List<LocationData>> _lastFiveLocationCache;
  final Cache<String, List<LocationData>> _locationCache;

  static LocationCache? _instance;

  static LocationCache get instance {
    _instance ??= LocationCache();
    return _instance!;
  }

  LocationCache({int cacheSize = 5, int locationCacheSize = 200})
      : _lastJourneyCache = Cache<String, ApiLocationJourney>(cacheSize),
        _lastFiveLocationCache = Cache<String, List<LocationData>>(cacheSize),
        _locationCache = Cache<String, List<LocationData>>(locationCacheSize);

  void putLastJourney(ApiLocationJourney journey, String userId) {
    _lastJourneyCache.put(userId, journey);
  }

  ApiLocationJourney? getLastJourney(String userId) {
    return _lastJourneyCache.get(userId);
  }

  void putLastFiveLocations(List<LocationData> locations, String userId) {
    _lastFiveLocationCache.put(userId, locations);
  }

  List<LocationData> getLastFiveLocations(String userId) {
    return _lastFiveLocationCache.get(userId) ?? [];
  }

  void clearLocationCache() {
    _locationCache.clear();
  }

  void addLocation(LocationData location, String userId) {
    var locations = getLocations(userId);
    locations.add(location);
    _locationCache.put(userId, locations);
  }

  List<LocationData> getLocations(String userId) {
    return _locationCache.get(userId) ?? [];
  }

  void clear() {
    _lastJourneyCache.clear();
    _lastFiveLocationCache.clear();
    _locationCache.clear();
  }
}

class Cache<K, V> {
  final int capacity;
  final LinkedHashMap<K, V> _cache = LinkedHashMap<K, V>();

  Cache(this.capacity);

  void put(K key, V value) {
    if (_cache.length >= capacity) {
      _cache.remove(_cache.keys.first);
    }
    _cache[key] = value;
  }

  V? get(K key) {
    if (!_cache.containsKey(key)) return null;

    final value = _cache.remove(key);
    _cache[key] = value as V;
    return value;
  }

  void clear() {
    _cache.clear();
  }

  Iterable<MapEntry<K, V>> get entries => _cache.entries;
}