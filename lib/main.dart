import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resturant_review/preview_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://jnxmzltgmwxgsuxlqusu.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImpueG16bHRnbXd4Z3N1eGxxdXN1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTk5Njk3NjcsImV4cCI6MjA3NTU0NTc2N30.6GxwiRbOiYbndb2Wnlej42bCY99rm5mR8nauf0-NQaM',
  );

  runApp(const MyApp());
}

final cloud = Supabase.instance.client;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Restaurant Review App',
      debugShowCheckedModeBanner: false,
      home: PreviewPage(),
    );
  }
}
