import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:open_mail_app/open_mail_app.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'dart:io' show Platform;
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:trainhero/src/constants/app_sizes.dart';
import 'package:trainhero/src/features/mail/domain/onboarding_data.dart';
import 'package:trainhero/src/features/mail/presentation/mail_page.dart';

class MailScreen extends StatefulWidget {
  const MailScreen({super.key});

  @override
  State<MailScreen> createState() => _MailScreenState();
}

class _MailScreenState extends State<MailScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _buttonController;
  final PageController _pageController = PageController();
  int currentPage = 0;

  List<OnboardingData> pageData = [
    const OnboardingData(
      imagePath: "assets/mail_ticket.png",
      heading: "Find your ticket",
      subheading: "Find the PDF of your ticket sent to your email address",
    ),
    OnboardingData(
      imagePath:
          "assets/share_ticket${Platform.isAndroid ? '_android' : ''}.png",
      heading: "Share your ticket",
      subheading:
          "Share the ticket and send it to the trainhero app by selecting the app icon",
    ),
  ];

  bool sheetDown = true;
  bool animationForward = true;
  bool animationReverse = false;

  void animationListener() async {
    if (animationForward) {
      if (_buttonController.value > 0.3) {
        setState(() {
          animationForward = false;
        });
        var result = await OpenMailApp.openMailApp();

        if (!result.didOpen && result.canOpen && mounted) {
          showMaterialModalBottomSheet(
            animationCurve: Curves.easeOutCubic,
            backgroundColor: Colors.transparent,
            context: context,
            builder: (context) => SingleChildScrollView(
              controller: ModalScrollController.of(context),
              child: Container(
                decoration: BoxDecoration(
                    color: const Color(0xffCECEF4),
                    borderRadius: BorderRadius.circular(30)),
                child: MailAppOptions(
                  mailApps: result.options,
                ),
              ),
            ),
          ).whenComplete(() {
            _buttonController.reverse();
          });
        }
      }
    }

    if (!animationForward && _buttonController.value < 0.3) {
      setState(() {
        animationForward = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _buttonController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..addListener(animationListener);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemBuilder: (context, index) {
                  return MailPage(
                    data: pageData[index],
                  );
                },
                itemCount: pageData.length,
                onPageChanged: (value) {
                  setState(() {
                    currentPage = value;
                  });
                },
              ),
            ),
            Expanded(
              child: AnimatedBuilder(
                animation: _buttonController,
                builder: (context, child) {
                  return Column(
                    children: [
                      gapH8,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildDot(index: 0),
                          gapW8,
                          _buildDot(index: 1),
                        ],
                      ),
                      const Spacer(),
                      FadeTransition(
                        opacity: Tween<double>(begin: 1, end: 0).animate(
                          CurvedAnimation(
                            parent: _buttonController,
                            curve: Curves.easeInOutCubic,
                          ),
                        ),
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0, 0),
                            end: const Offset(0, 1),
                          ).animate(
                            CurvedAnimation(
                              parent: _buttonController,
                              curve: Curves.easeInOutCubic,
                            ),
                          ),
                          child: Column(
                            children: [
                              SizedBox(
                                height: Sizes.p48,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xffDEDCEF),
                                  ),
                                  child: AutoSizeText(
                                    "Go to Email App",
                                    style: GoogleFonts.nunito(
                                      fontSize: Sizes.p16,
                                      color: const Color(0xff313143),
                                    ),
                                  ),
                                  onPressed: () async {
                                    var result =
                                        await OpenMailApp.openMailApp();

                                    if (!result.didOpen && mounted) {
                                      if (!result.canOpen) {
                                        showNoMailAppsDialog(context);
                                      } else {
                                        showDialog(
                                          context: context,
                                          builder: (_) {
                                            return MailAppPickerDialog(
                                              mailApps: result.options,
                                            );
                                          },
                                        );
                                      }
                                    }
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(Sizes.p24),
                                child: Container(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    'Pssst, you can skip this step by directly sharing the eTicket PDF to TrainHero!',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.nunito(
                                      color: Colors.white70,
                                      fontSize: Sizes.p12,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  AnimatedContainer _buildDot({required int index}) {
    return AnimatedContainer(
      curve: Curves.easeOut,
      duration: const Duration(milliseconds: 300),
      height: Sizes.p6,
      width: Sizes.p6,
      decoration: BoxDecoration(
        color:
            currentPage == index ? Colors.white : Colors.white.withOpacity(0.4),
        shape: BoxShape.circle,
      ),
    );
  }

  void showNoMailAppsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Sorry!"),
          content:
              const Text("It appears as if you have no mail apps installed."),
          actions: [
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }
}

class MailAppOptions extends StatelessWidget {
  /// The title of the dialog
  final String title;

  /// The mail apps for the dialog to provide as options
  final List<MailApp> mailApps;

  const MailAppOptions({
    Key? key,
    this.title = 'Choose Mail App',
    required this.mailApps,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(), //horizontal: scaledSafeWidth(24)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.center,
            child: Container(
              // margin: EdgeInsets.only(top: scaledSafeHeight(12)),
              height: 8,
              width: 60,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: const Color(0xffA3A3C9)),
            ),
          ),
          gapH32,
          Text(
            "Choose your Mail app",
            style: GoogleFonts.nunito(
              fontSize: Sizes.p24,
              color: const Color(0xff343435),
              fontWeight: FontWeight.w800,
            ),
          ),
          gapH20,
          for (var app in mailApps)
            GestureDetector(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: Sizes.p12,
                ),
                child: Text(
                  app.name,
                  style: GoogleFonts.nunito(
                    fontSize: Sizes.p24,
                    color: const Color(0xff565668),
                  ),
                ),
              ),
              onTap: () {
                OpenMailApp.openSpecificMailApp(app);
                Navigator.pop(context);
              },
            ),
          gapH64,
        ],
      ),
    );
  }
}
