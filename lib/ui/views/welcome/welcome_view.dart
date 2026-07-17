import 'package:aniyoka/app/app.router.dart';
import 'package:aniyoka/ui/common/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WelcomeView extends StatelessWidget {
  const WelcomeView({super.key});

  Future<void> _completeOnboarding(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_first_run', false);
    
    if (context.mounted) {
      Navigator.pushReplacementNamed(context, Routes.mainView);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kcPrimaryPink, 
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 40),
            
            Center(
              child: Image.asset(
                'assets/images/logo.png',
                height: 60,
              ),
            ),
            
            const Spacer(),

            SizedBox(
              height: MediaQuery.of(context).size.height * 0.35,
              width: double.infinity,
              child: OverflowBox(
                maxWidth: MediaQuery.of(context).size.width * 1.6,
                maxHeight: MediaQuery.of(context).size.height * 0.40,
                alignment: Alignment.center, 
                child: Transform.translate(
                  offset: const Offset(25, 40), 
                  child: Image.asset(
                    'assets/images/posters.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),

            const Spacer(),

            Text(
              'Welcome to',
              style: GoogleFonts.inter(
                color: kcTertiaryPink,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 15),
            Text(
              'AniYoka',
              style: GoogleFonts.nunito(
                color: kcTertiaryPink,
                fontSize: 54,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.5,
                height: 0.85,
              ),
            ),
            Text(
              'あによめ',
              style: GoogleFonts.notoSansJp(
                color: kcTertiaryPink,
                fontSize: 22,
                fontWeight: FontWeight.w900,
                letterSpacing: 2.0,
              ),
            ),

            const Spacer(flex: 2),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () => _completeOnboarding(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kcSurfaceColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    "Let’s Go!",
                    style: GoogleFonts.nunito(
                      color: kcOffWhite,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}