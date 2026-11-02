import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

// Screens
import 'package:gym/screens/browse_coaches_screen.dart';
import 'package:gym/screens/coach_home_screen.dart';
import 'package:gym/screens/coach_profile_screen.dart';
import 'package:gym/screens/conversations_screen.dart';
import 'package:gym/screens/goals_screen.dart';
import 'package:gym/screens/my_programs_screen.dart';
import 'package:gym/screens/profile_screen.dart';
import 'package:gym/screens/edit_profile_screen.dart';
import 'package:gym/screens/settings_screen.dart';
import 'package:gym/screens/history_screen.dart';
import 'package:gym/screens/my_courses_screen.dart';
import 'package:gym/screens/formations_screen.dart';
import 'package:gym/screens/client_store_screen.dart';
import 'package:gym/screens/coach_orders_screen.dart';
import 'package:gym/screens/statistics_screen.dart';

// Pages
import 'pages/welcome.dart';
import 'pages/simple_welcome.dart';
import 'pages/login.dart';
import 'pages/signup.dart';
import 'pages/home.dart';

// Providers
import 'providers/goals_provider.dart';
import 'providers/LanguageProvider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(); // 🔥 Firebase

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GoalsProvider()),
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
      ],
      child: Consumer<LanguageProvider>(
        builder: (context, langProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'CoachLink',

            // 🌍 RTL / LTR
            builder: (context, child) {
              return Directionality(
                textDirection: langProvider.selectedLanguage == 'AR'
                    ? TextDirection.rtl
                    : TextDirection.ltr,
                child: child!,
              );
            },

            // 🎨 Theme (important)
            theme: ThemeData(
              primarySwatch: Colors.blue,
              scaffoldBackgroundColor: Colors.white,
              appBarTheme: const AppBarTheme(
                elevation: 0,
                centerTitle: true,
              ),
            ),

            initialRoute: '/welcome',

            routes: {
              // 🔵 Welcome
              '/welcome': (_) => const Welcome(),
              '/simple_welcome': (_) => const SimpleWelcome(),

              // 🔐 Auth
              '/login': (_) => const LoginScreen(),
              '/signup': (_) => const SignupScreen(),

              // 👤 Client
              '/home': (_) => const HomeScreen(),
              '/goals': (_) => const GoalsScreen(),
              '/profile': (_) => const ProfileScreen(),
              '/edit_profile': (_) => const EditProfileScreen(),
              '/settings': (_) => const SettingsScreen(),
              '/history': (_) => const HistoryScreen(),
              '/my_courses': (_) => const MyCoursesScreen(),
              '/formations': (_) => const FormationsScreen(),
              '/browse_coaches': (_) => const BrowseCoachesScreen(),
              '/client_store': (_) => const ClientStoreScreen(),

              // 🧑‍🏫 Coach
              '/coach_home': (_) => const CoachHomeMain(),
              '/chat': (_) => const CoachChatScreen(),
              '/my_programs': (_) => const MyProgramsScreen(),
              '/coach_orders': (_) => const CoachOrdersScreen(),

              // ⚠️ مهم: profile dynamic
              '/coach_profile': (context) {
                final args = ModalRoute.of(context)!.settings.arguments
                    as Map<String, dynamic>;

                return CoachProfileScreen(
                  coachId: args['coachId'],
                  coachName: args['coachName'],
                  coachPhoto: args['coachPhoto'],
                  specialization: args['specialization'],
                );
              },

              // 📊 Statistics
              '/statistics': (_) => const StatisticsScreen(),
            },
          );
        },
      ),
    );
  }
}
