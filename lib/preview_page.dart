import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resturant_review/restaurant_service.dart';
import 'package:resturant_review/survey_page.dart';

class PreviewPage extends StatefulWidget {
  PreviewPage({super.key});

  @override
  State<PreviewPage> createState() => _PreviewPageState();
}

class _PreviewPageState extends State<PreviewPage> {
  final meals = <String>[].obs;
  final description = <String>[].obs;
  final photos = <String>[].obs;

  @override
  void initState() {
    super.initState();
    loadMeals();
    loadMealsPhotos();
    loadDescription();
  }

  Future<void> loadMeals() async {
    meals.value = await RestaurantService().loadMeals();
  }

  Future<void> loadDescription() async {
    description.value = await RestaurantService().loadDescription();
  }

  loadMealsPhotos() async {
    photos.value = await RestaurantService().loadMealPhoto();
  }

  @override
  void dispose() {
    meals.close();
    description.close();
    photos.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfffafafa),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 3,
        centerTitle: true,
        title: const Text(
          "Meals",
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      body: SafeArea(
        child: Column(
          children: [
            Obx(() {
              if (meals.isEmpty || photos.isEmpty || description.isEmpty) {
                return const Expanded(
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: ListView.separated(
                    itemCount: meals.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 16),

                    itemBuilder: (ctx, index) => InkWell(
                      onTap: () {
                        Get.to(
                          () => SurveyPage(),
                          arguments: {
                            'photo': photos[index],
                            'name': meals[index],
                            'description': description[index],
                          },
                        );
                      },
                      borderRadius: BorderRadius.circular(16),

                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(12),

                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      meals[index],
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      description[index],
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                width: 120,
                                height: 120,
                                color: Colors.grey[200],
                                child: Image.network(
                                  photos[index],
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
