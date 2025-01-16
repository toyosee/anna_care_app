import 'package:anna_care/base_screen.dart';
import 'package:anna_care/dashboard_screen.dart';
import 'package:anna_care/providers/first_aid_and_emergency_provider.dart';
import 'package:anna_care/providers/timeout_provider.dart';
import 'package:anna_care/screens/emergency_response_screen.dart';
import 'package:anna_care/screens/fitness_screen.dart';
import 'package:anna_care/screens/health_advisor_screen.dart';
import 'package:anna_care/screens/health_tips_screen.dart';
import 'package:anna_care/screens/home_screen.dart';
import 'package:anna_care/screens/time_out_screen.dart';
import 'package:anna_care/screens/workout_scheduller_screen.dart';
import 'package:anna_care/screens/disease_outbreak_screen.dart';
import 'package:anna_care/providers/disease_outbreak_provider.dart';
import 'package:anna_care/providers/health_advisor_provider.dart';
import 'package:anna_care/providers/health_tips_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart'; // Import provider package
import 'package:permission_handler/permission_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Request notification permission
  await requestNotificationPermission();
  
  runApp(const AnnaCareApp());
}

Future<void> requestNotificationPermission() async {
  if (await Permission.notification.isDenied) {
    await Permission.notification.request();
  }
}

class AnnaCareApp extends StatelessWidget {
  const AnnaCareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MedicalFormProvider()),
        ChangeNotifierProvider(create: (_) => HealthTipsProvider()),
        ChangeNotifierProvider(create: (_) => DiseaseOutbreakProvider()),
        ChangeNotifierProvider(create: (_) => TimerProvider()),
        ChangeNotifierProvider(create: (_) => FirstAidTipsProvider())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'BMI Calculator',
        theme: ThemeData(
          primaryColor: const Color.fromARGB(255, 3, 72, 130),
          primaryColorLight: Colors.white,
          primaryColorDark: Colors.black,
          textTheme: GoogleFonts.latoTextTheme(),
          useMaterial3: true,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => HomePage(),
          '/dashboard': (context) => Dashboard(),
          '/bmi': (context) => BMICalculator(),
          '/fitness': (context) => FitnessPage(),
          '/healthTips': (context) => HealthTipsScreen(),
          '/timeOut': (context) => TimeOutWidget(),
          '/workoutScheduler': (context) => WorkoutSchedulerPage(),
          '/healthAdvisor': (context) => MedicalFormScreen(),
          '/outbreakTracker': (context) => OutbreakTracker(),
          '/firstAidAndEmergency': (context) => EmergencyResponseScreen(),
        },
      ),
    );
  }
}
