import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trainhero/src/constants/app_sizes.dart';
import 'package:trainhero/src/routing/app_router.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return LayoutBuilder(
            builder: (context, constraints) {
              return SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildTitle(constraints),
                    _buildLogo(),
                    _buildButton(),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  SlideTransition _buildButton() {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 0.1),
        end: const Offset(0, 0),
      ).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: const Interval(
            0.6,
            1,
            curve: Curves.easeOutCubic,
          ),
        ),
      ),
      child: FadeTransition(
        opacity: Tween<double>(begin: 0, end: 1.0).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: const Interval(
              0.6,
              1,
              curve: Curves.easeOutCubic,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Sizes.p20),
          child: Column(
            children: [
              TextButton(
                onPressed: () =>
                    GoRouter.of(context).pushNamed(AppRoute.mail.name),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xffEADCFF),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Center(
                    child: Text(
                      "Get Started",
                      style: GoogleFonts.nunito(
                        color: const Color(0xff3B3949),
                        fontSize: Sizes.p16,
                      ),
                    ),
                  ),
                ),
              ),
              gapH32,
              Text(
                "Any queries? Contact us at\n"
                "help@trainhero.uk",
                textAlign: TextAlign.center,
                style: GoogleFonts.nunito(
                  color: Colors.white,
                  fontSize: Sizes.p14,
                ),
              ),
              gapH20,
            ],
          ),
        ),
      ),
    );
  }

  SlideTransition _buildLogo() {
    return SlideTransition(
      position:
          Tween<Offset>(begin: const Offset(0, 0.3), end: const Offset(0, 0))
              .animate(
        CurvedAnimation(
          parent: _animationController,
          curve: const Interval(
            0.5,
            0.9,
            curve: Curves.easeOutCubic,
          ),
        ),
      ),
      child: FadeTransition(
        opacity: Tween<double>(begin: 0, end: 1).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: const Interval(
              0.5,
              0.9,
              curve: Curves.easeOutCubic,
            ),
          ),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: Sizes.p32),
          child: Center(
            child: Image.asset(
              "assets/trainHeroLogo.png",
              width: Sizes.p80,
            ),
          ),
        ),
      ),
    );
  }

  FadeTransition _buildTitle(BoxConstraints constraints) {
    return FadeTransition(
      opacity: Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          curve: const Interval(
            0.2,
            0.7,
            curve: Curves.easeInOut,
          ),
          parent: _animationController,
        ),
      ),
      child: Column(
        children: [
          gapH80,
          AnimatedContainer(
            curve: Curves.fastLinearToSlowEaseIn,
            duration: const Duration(milliseconds: 1000),
            child: Text(
              "Claim in seconds",
              style: GoogleFonts.nunito(
                color: Colors.white,
                fontSize: Sizes.p24,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(Sizes.p32),
            padding: const EdgeInsets.symmetric(horizontal: Sizes.p32),
            child: Text(
              "Complete your claim in seconds with trainhero.",
              textAlign: TextAlign.center,
              style: GoogleFonts.nunito(
                color: Colors.white,
                fontSize: Sizes.p16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
