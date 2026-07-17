import 'package:aniyoka/ui/common/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:aniyoka/app/app.bottomsheets.dart';
import 'package:aniyoka/app/app.dialogs.dart';
import 'package:aniyoka/app/app.locator.dart';
import 'package:aniyoka/app/app.router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked_services/stacked_services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupLocator();
  setupDialogUi();
  setupBottomSheetUi();
  await ThemeService.instance.init();
  
  final prefs = await SharedPreferences.getInstance();
  final bool isFirstRun = prefs.getBool('is_first_run') ?? true;
  
  runApp(MainApp(isFirstRun: isFirstRun));
}

class MainApp extends StatelessWidget {
  final bool isFirstRun;
  
  const MainApp({super.key, required this.isFirstRun});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: ThemeService.instance,
      builder: (context, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'AniYoka',
          initialRoute: isFirstRun ? Routes.welcomeView : Routes.mainView,
          onGenerateRoute: StackedRouter().onGenerateRoute,
          navigatorKey: StackedService.navigatorKey,
          navigatorObservers: [StackedService.routeObserver],
          theme: ThemeData(
            useMaterial3: true,
            textTheme: GoogleFonts.interTextTheme(),
            scaffoldBackgroundColor: kcBackgroundColor,
            canvasColor: kcBackgroundColor,
            // theme data to change navigation bar styling
            navigationBarTheme: NavigationBarThemeData(
              iconTheme: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return IconThemeData(color: kcPrimaryPink);
                }
                return const IconThemeData(color: kcLightGrey);
              }),
              labelTextStyle: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return GoogleFonts.nunito(
                    color: kcPrimaryPink,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  );
                }
                return GoogleFonts.nunito(
                  color: kcLightGrey,
                  fontSize: 12,
                );
              }),
            ),
          ),
        );
      },
    );
  }
}
