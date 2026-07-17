import 'package:aniyoka/ui/common/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:aniyoka/app/app.bottomsheets.dart';
import 'package:aniyoka/app/app.dialogs.dart';
import 'package:aniyoka/app/app.locator.dart';
import 'package:aniyoka/app/app.router.dart';
import 'package:stacked_services/stacked_services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupLocator();
  setupDialogUi();
  setupBottomSheetUi();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: Routes.mainView,
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
              return const IconThemeData(color: kcPrimaryPink);
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
  }
}
