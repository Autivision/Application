import 'package:autivision/screens/detail_history.dart';
import 'package:autivision/screens/forgotPassword_screen.dart';
import 'package:autivision/services/history_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'screens/login_screen.dart';
import 'screens/loading_screen.dart';
import 'screens/main_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/onBoarding_screen.dart';
import 'screens/example_screen.dart';
import 'screens/history_screen.dart';
import 'screens/profile_screen.dart';
import 'providers/auth_provider.dart' as MyAuthProvider;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Inisialisasi data lokal
  await initializeDateFormatting('id', null);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MyAuthProvider.AuthProvider()),
        Provider<HistoryService>(create: (_) => HistoryService()),
        // Add other providers if necessary
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AutiVision',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Poppins',
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoadingScreen(),
        '/login': (context) => LoginScreen(),
        '/main': (context) =>
            MainScreen(user: FirebaseAuth.instance.currentUser),
        '/signup': (context) => SignupScreen(),
        '/onBoarding': (context) => OnBoardingScreen(),
        '/example': (context) => ExampleScreen(),
        '/detail': (context) => DetailHistoryScreen(
              historyItem: {},
            ),
        '/history': (context) {
          User? user = FirebaseAuth.instance.currentUser;
          if (user != null) {
            return HistoryScreen();
          } else {
            return LoginScreen();
          }
        },
        '/profile': (context) => ProfileScreen(),
        '/forgotPassword': (context) => ForgotPasswordScreen(),
      },
    );
  }
}
