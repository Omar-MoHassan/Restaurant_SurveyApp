import 'package:flutter/material.dart';
import 'main.dart';

class RestaurantService {
  Future<List<String>> loadMeals() async {
    try {
      final response = await cloud.from('meals').select('name_en');

      final List<dynamic> data = response as List<dynamic>;
      final List<String> result = <String>[];

      for (var i = 0; i < data.length; i++) {
        final row = data[i];
        final value = row['name_en'];
        result.add(value.toString());
      }

      return result;
    } catch (e) {
      debugPrint('Error loading meals: $e');
      return <String>[];
    }
  }

  Future<List<String>> loadMealPhoto() async {
    try {
      final response = await cloud.from('meals').select('image_url');

      final List<dynamic> data = response as List<dynamic>;
      final List<String> result = <String>[];

      for (var i = 0; i < data.length; i++) {
        final row = data[i];
        final value = row['image_url'];
        result.add(value.toString());
      }

      return result;
    } catch (e) {
      debugPrint('Error loading meal photos: $e');
      return <String>[];
    }
  }

  Future<List<String>> loadDescription() async {
    try {
      final response = await cloud.from('meals').select('description_en');

      final List<dynamic> data = response as List<dynamic>;
      final List<String> result = <String>[];

      for (var i = 0; i < data.length; i++) {
        final row = data[i];
        final value = row['description_en'];
        result.add(value.toString());
      }

      return result;
    } catch (e) {
      debugPrint('Error loading descriptions: $e');
      return <String>[];
    }
  }

  /// Insert one review row into Supabase `reviews` table.
  ///
  /// Table columns used (must exist in Supabase):
  /// - dish_rate (bigint)
  /// - service_rate (int4)
  /// - overall_experience_rate (int4)
  /// - comment (text)
  /// - recommend us (text or varchar)
  /// - created_at (timestamptz)
  Future<bool> sendReview({
    required String mealName, // kept for future use if you add a column
    required double serviceRating,
    required double foodRating,
    required double overallRating,
    required String comments,
    required String recommend,
  }) async {
    try {
      await cloud.from('reviews').insert({
        // numeric ratings as integers 1–5
        'dish_rate': foodRating.toInt(),
        'service_rate': serviceRating.toInt(),
        'overall_experience_rate': overallRating.toInt(),
        'comment': comments,
        // if your column name is `recommend_us`, change the key below
        'recommend us': recommend,
        'created_at': DateTime.now().toIso8601String(),
      });

      return true;
    } catch (e) {
      debugPrint('Error sending review: $e');
      return false;
    }
  }
}
