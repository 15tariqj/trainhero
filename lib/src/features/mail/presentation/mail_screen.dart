import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:open_mail_app/open_mail_app.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'dart:io' show Platform;
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:trainhero/src/constants/app_sizes.dart';
import 'package:trainhero/src/features/mail/domain/onboarding_data.dart';
import 'package:trainhero/src/features/mail/presentation/onboarding.dart';

class MailScreen extends StatefulWidget {
  const MailScreen({super.key});

  @override
  State<MailScreen> createState() => _MailScreenState();
}

class _MailScreenState extends State<MailScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _buttonController;
  late PageController _pageController;
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

  void scrollListener() {}

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
    _pageController = PageController()..addListener(scrollListener);

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
              flex: 3,
              child: PageView.builder(
                controller: _pageController,
                itemBuilder: (context, index) {
                  return Onboarding(
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
              flex: 2,
              child: AnimatedBuilder(
                animation: _buttonController,
                builder: (context, child) {
                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _pageDot(index: 0),
                          gapW8,
                          _pageDot(index: 1),
                        ],
                      ),
                      const Spacer(),
                      FadeTransition(
                        opacity: Tween<double>(begin: 1, end: 0).animate(
                            CurvedAnimation(
                                parent: _buttonController,
                                curve: Curves.easeInOutCubic)),
                        child: SlideTransition(
                          position: Tween<Offset>(
                                  begin: const Offset(0, 0),
                                  end: const Offset(0, 1))
                              .animate(CurvedAnimation(
                                  parent: _buttonController,
                                  curve: Curves.easeInOutCubic)),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(Sizes.p24),
                                // EdgeInsets.all(scaledSafeWidth(24.0)),
                                child: Container(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    'For future reference, you can skip to this step by just directly sharing the eticket pdf to trainhero!',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.nunito(
                                      color: Colors.white70,
                                      fontSize: Sizes.p14,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: Sizes.p64 * 3,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xffDEDCEF),
                                  ),
                                  child: Center(
                                    child: AutoSizeText(
                                      "Go to Email App",
                                      style: GoogleFonts.nunito(
                                        textStyle: const TextStyle(
                                          fontSize: Sizes.p16,
                                          color: Color(0xff313143),
                                        ),
                                      ),
                                    ),
                                  ),
                                  onPressed: () async {
                                    // Android: Will open mail app or show native picker.
                                    // iOS: Will open mail app if single mail app found.
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

  AnimatedContainer _pageDot({required int index}) {
    return AnimatedContainer(
      curve: Curves.easeOut,
      duration: const Duration(milliseconds: 300),
      height: 6,
      width: 6,
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
          title: const Text("Open Mail App"),
          content: const Text("No mail apps installed"),
          actions: <Widget>[
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
        children: <Widget>[
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
          const SizedBox(
              // height: scaledSafeHeight(29),
              ),
          Text(
            "Choose your Mail app",
            style: GoogleFonts.nunito(
              textStyle: const TextStyle(
                  // fontSize: scaledSafeWidth(28),
                  color: Color(0xff343435),
                  fontWeight: FontWeight.w800),
            ),
          ),
          const SizedBox(
              // height: scaledSafeHeight(18),
              ),
          for (var app in mailApps)
            GestureDetector(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 10.0,
                ), //scaledSafeHeight(5.0))
                child: Text(app.name,
                    style: GoogleFonts.nunito(
                      textStyle: const TextStyle(
                        // fontSize: scaledSafeWidth(24),
                        color: Color(0xff565668),
                      ),
                    )),
              ),
              onTap: () {
                //OpenMailApp.openSpecificMailApp(app);
                //Navigator.pop(context);
              },
            ),
          const SizedBox(
            height: 70,
          ),
        ],
      ),
    );
  }
}
