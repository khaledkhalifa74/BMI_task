import 'package:bmi_task/core/utils/colors.dart';
import 'package:bmi_task/features/Authentication/manager/auth_cubit/auth_cubit.dart';
import 'package:bmi_task/features/Authentication/presentation/views/login_view.dart';
import 'package:bmi_task/features/Authentication/presentation/views/register_view.dart';
import 'package:bmi_task/features/BMICalculation/presentation/views/calculate_bmi_view.dart';
import 'package:bmi_task/features/BMICalculation/presentation/views/show_bmi_view.dart';
import 'package:bmi_task/features/Entries/manager/entries_cubit/entries_cubit.dart';
import 'package:bmi_task/features/Entries/presentation/views/entries_view.dart';
import 'package:bmi_task/firebase_options.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  if(!kDebugMode) {
    await FirebaseAppCheck.instance.activate(
      androidProvider: AndroidProvider.playIntegrity,
      appleProvider: AppleProvider.appAttest,
      webProvider: ReCaptchaV3Provider('recaptcha-v3-site-key'),
    );
  } else {
    await FirebaseAppCheck.instance.activate(
      androidProvider: AndroidProvider.debug,
      appleProvider: AppleProvider.debug,
    );
  }
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
      builder: (context, child){
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => AuthCubit()),
            BlocProvider(create: (context) => EntriesCubit()),
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'BMI',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: kPrimaryColor),
              useMaterial3: true,
              textTheme: GoogleFonts.poppinsTextTheme(),
              primaryColor: kPrimaryColor,
            ),
            initialRoute: LoginView.id,
            routes: {
              LoginView.id: (context) => const LoginView(),
              RegisterView.id: (context) => const RegisterView(),
              CalculateBMIView.id: (context) => const CalculateBMIView(),
              ShowBMIView.id: (context) => const ShowBMIView(),
              EntriesView.id: (context) => const EntriesView(),
            },
          ),
        );
      }
    );
  }
}