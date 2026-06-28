import 'package:aniyoka/ui/common/app_colors.dart';
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
      initialRoute: Routes.startupView,
      onGenerateRoute: StackedRouter().onGenerateRoute,
      navigatorKey: StackedService.navigatorKey,
      navigatorObservers: [StackedService.routeObserver],
      theme: ThemeData(
        useMaterial3: true,
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
              return const TextStyle(color: kcPrimaryPink, fontSize: 12, fontWeight: FontWeight(600));
            }
            return const TextStyle(color: kcLightGrey, fontSize: 12);
          }),
        ),
      ),
    );
  }
}
