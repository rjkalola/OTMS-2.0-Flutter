import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class CustomCacheManager extends CacheManager {
  static const key = "customCache";

  CustomCacheManager()
      : super(
    Config(
      key,
      stalePeriod: const Duration(days: 30), // store cache for 30 days
      maxNrOfCacheObjects: 200,
    ),
  );
}
