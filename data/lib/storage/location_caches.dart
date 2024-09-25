import 'dart:collection';

import 'package:data/api/location/journey/journey.dart';
import 'package:data/api/location/location.dart';

class LocationCache {
  final Cache<String, ApiLocationJourney> _lastJourneyCache;
  final Cache<String, List<ApiLocation>> _lastFiveLocationCache;

  LocationCache({int cacheSize = 5})
      : _lastJourneyCache = Cache<String, ApiLocationJourney>(cacheSize),
        _lastFiveLocationCache = Cache<String, List<ApiLocation>>(cacheSize);

  void putLastJourney(ApiLocationJourney journey, String userId) {
    _lastJourneyCache.put(userId, journey);
  }

  ApiLocationJourney? getLastJourney(String userId) {
    return _lastJourneyCache.get(userId);
  }

  void putLastFiveLocations(List<ApiLocation> locations, String userId) {
    _lastFiveLocationCache.put(userId, locations);
  }

  List<ApiLocation>? getLastFiveLocations(String userId) {
    return _lastFiveLocationCache.get(userId);
  }

  void clear() {
    _lastJourneyCache.clear();
    _lastFiveLocationCache.clear();
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
}