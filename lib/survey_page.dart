// --- ONLY UI IMPROVEMENTS APPLIED – NO LOGIC CHANGED ---

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:resturant_review/restaurant_service.dart';

class SurveyPage extends StatefulWidget {
  SurveyPage({super.key});

  @override
  State<SurveyPage> createState() => _SurveyPageState();
}

class _SurveyPageState extends State<SurveyPage> {
  final TextEditingController commentsController = TextEditingController();
  final TextEditingController recommendController = TextEditingController();

  final List<String> choices = <String>['Yes', 'No'];

  final RxDouble serviceRating = 0.0.obs;
  final RxDouble foodRating = 0.0.obs;
  final RxDouble overallRating = 0.0.obs;

  final SpeechToText speechToText = SpeechToText();

  final RxBool speechEnabled = false.obs;
  final RxBool isListening = false.obs;
  final RxString wordsSpoken = ''.obs;

  final RestaurantService _restaurantService = RestaurantService();

  @override
  void dispose() {
    commentsController.dispose();
    recommendController.dispose();
    speechToText.stop();
    super.dispose();
  }

  void _startListening() async {
    isListening.value = true;

    await speechToText.listen(
      onResult: (result) {
        wordsSpoken.value = result.recognizedWords;
      },
    );
  }

  void _stopListening() async {
    isListening.value = false;
    await speechToText.stop();
  }

  Future<void> _submitReview(String mealName) async {
    if (serviceRating.value == 0 ||
        foodRating.value == 0 ||
        overallRating.value == 0) {
      Get.snackbar(
        'Missing Ratings',
        'Please rate service, food, and overall experience.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (recommendController.text.isEmpty) {
      Get.snackbar(
        'Missing Answer',
        'Please choose if you would recommend us.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final String comments = commentsController.text;
    final String recommendValue = recommendController.text;

    final bool success = await _restaurantService.sendReview(
      mealName: mealName,
      serviceRating: serviceRating.value,
      foodRating: foodRating.value,
      overallRating: overallRating.value,
      comments: comments,
      recommend: recommendValue,
    );

    if (success) {
      Get.snackbar(
        'Thank you!',
        'Your review has been submitted successfully.',
        snackPosition: SnackPosition.BOTTOM,
      );
      commentsController.clear();
      recommendController.clear();
      setState(() {
        serviceRating.value = 0;
        foodRating.value = 0;
        overallRating.value = 0;
      });
      Get.back();
    } else {
      Get.snackbar(
        'Error',
        'Something went wrong while sending your review.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final String name = Get.arguments['name'];
    final String photo = Get.arguments['photo'];
    final String description = Get.arguments['description'];

    return Scaffold(
      backgroundColor: const Color(0xfffafafa),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
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

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        photo,
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            description,

                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 14,
                              height: 1.4,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 22),

            const Text(
              'Survey',
              style: TextStyle(
                fontSize: 24,
                color: Colors.black87,
                fontWeight: FontWeight.w800,
              ),
            ),

            const SizedBox(height: 16),

            Card(
              elevation: 3,
              shadowColor: Colors.black12,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    buildRatingRow(
                      label: "Service",
                      onChanged: (value) {
                        setState(() => serviceRating.value = value);
                      },
                    ),
                    const Divider(height: 32),

                    buildRatingRow(
                      label: 'Food Quality',
                      onChanged: (value) {
                        setState(() => foodRating.value = value);
                      },
                    ),
                    const Divider(height: 32),

                    buildRatingRow(
                      label: 'Overall Experience',
                      onChanged: (value) {
                        setState(() => overallRating.value = value);
                      },
                    ),

                    const SizedBox(height: 28),

                    Obx(() {
                      return TextField(
                        controller: commentsController,
                        maxLines: null,
                        minLines: 3,
                        style: const TextStyle(fontSize: 16),
                        decoration: InputDecoration(
                          labelText: "Comments",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              Icons.mic,
                              color: isListening.value
                                  ? Colors.red
                                  : Colors.grey,
                            ),
                            onPressed: () async {
                              speechEnabled.value = await speechToText
                                  .initialize();
                              PermissionStatus status = await Permission
                                  .microphone
                                  .request();

                              if (status.isGranted) {
                                if (isListening.value) {
                                  _stopListening();
                                  commentsController.text = wordsSpoken.value;
                                } else {
                                  _startListening();
                                }
                              } else if (status.isPermanentlyDenied) {
                                openAppSettings();
                              }
                            },
                          ),
                        ),
                      );
                    }),

                    const SizedBox(height: 24),

                    DropdownMenu(
                      controller: recommendController,
                      label: const Text("Would you Recommend us?"),
                      dropdownMenuEntries: [
                        for (final e in choices)
                          DropdownMenuEntry(value: e, label: e),
                      ],
                      width: double.infinity,
                      inputDecorationTheme: InputDecorationTheme(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () => _submitReview(name),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orangeAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                        ),
                        child: const Text(
                          'Submit',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildRatingRow({
    required String label,
    required Function(double) onChanged,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
        ),
        RatingBar.builder(
          initialRating: 0,
          minRating: 1,
          itemCount: 5,
          itemSize: 28,
          itemBuilder: (ctx, _) =>
              const Icon(Icons.star, color: Colors.orangeAccent),
          onRatingUpdate: onChanged,
        ),
      ],
    );
  }
}
