import 'package:flutter/material.dart';
import 'package:aniyoka/app/app.bottomsheets.dart';
import 'package:aniyoka/app/app.dialogs.dart';
import 'package:aniyoka/app/app.locator.dart';
import 'package:aniyoka/app/app.router.dart';
import 'package:aniyoka/ui/common/app_theme.dart';
import 'package:stacked_services/stacked_services.dart';

// when contributing to the project, please use ui_helpers.dart when creating
// your views and Theme.of(context).colorScheme.color to handle color variables
// to make future adjustments to the project layout easier
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
      title: 'AniYoka',
      debugShowCheckedModeBanner: false,
      initialRoute: Routes.mainView,
      onGenerateRoute: StackedRouter().onGenerateRoute,
      navigatorKey: StackedService.navigatorKey,
      navigatorObservers: [StackedService.routeObserver],
      theme: getAppTheme(context),
    );
  }
}
