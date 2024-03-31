import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:trainhero/src/common_widgets/custom_dialog.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          backgroundColor: const Color(0xff2C2C44),
          body: SafeArea(
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      children: [
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(bottom: 15.0),
                              child: Text(
                                "Settings",
                                style: TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xffD2D2FF),
                                ),
                              ),
                            ),
                            Text(
                              "These details will be used in your claim, please ensure that they are accurate.",
                              style: TextStyle(
                                  fontSize: 15, color: Color(0xffD2D2FF)),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        const SettingsTile(
                          title: "Got your name wrong?",
                          description:
                              "You can change your full name if it's been entered wrong.",
                          button: "Change Name",
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const SettingsTile(
                          title: "Change banking details",
                          description:
                              "You can change your banking details for where you’d like your compensation to be transferred.",
                          button: "Change Details",
                        ),
                        const SizedBox(height: 20),
                        TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: const Color(0xff5A5A72),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () async {
                              showDialog(
                                barrierDismissible: false,
                                barrierColor: Colors.black.withOpacity(0.8),
                                context: context,
                                builder: (BuildContext context) =>
                                    const CustomDialog(
                                  image: 'assets/trainHeroLogo.png',
                                  title: "See you again soon!",
                                  description:
                                      "Are you sure you would like to log out?",
                                  buttonText: "Sign out",
                                ),
                              ).then(
                                (_) async {
                                  // TODO: Implement sign out flow
                                },
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              alignment: Alignment.center,
                              width: double.infinity,
                              child: const Text(
                                'Sign out',
                                style: TextStyle(
                                    color: Color(0xffEADCFF), fontSize: 18),
                              ),
                            )),
                        GestureDetector(
                          onTap: () async {
                            if (await canLaunchUrl(Uri.parse(
                                'http://109.228.36.170/privacy-notice/'))) {
                              await launchUrl(Uri.parse(
                                  'http://109.228.36.170/privacy-notice/'));
                            } else {
                              throw 'Could not launch url';
                            }
                          },
                          child: Container(
                            margin: const EdgeInsets.all(20),
                            padding: const EdgeInsets.symmetric(horizontal: 32),
                            child: const Text(
                              "Privacy policy",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xffEADCFF),
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                      ],
                    ),
                  ),
                ),
                SafeArea(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 28.0,
                          vertical: 10,
                        ),
                        child: buttonRouter(context),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }

  Widget buttonRouter(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        backgroundColor: const Color(0xffEADCFF),
      ),
      child: const Padding(
        padding: EdgeInsets.all(8.0),
        child: Text(
          "Home",
          style: TextStyle(
            fontSize: 20,
            color: Color(0xFF323140),
          ),
        ),
      ),
      onPressed: () {
        context.pop();
      },
    );
  }
}

class SettingsTile extends StatelessWidget {
  final String title;
  final String description;
  final String button;
  final Widget? route;

  const SettingsTile({
    Key? key,
    required this.title,
    required this.description,
    required this.button,
    this.route,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color fontColor = const Color(0xffE1E1F9);
    Color containerColor = const Color(0xff5A5A72);
    Color buttonFontColor = const Color(0xffEADCFF);
    Color buttonColor = const Color(0xff48465E);

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
          color: containerColor, borderRadius: BorderRadius.circular(15)),
      child: Column(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: fontColor),
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                description,
                style: TextStyle(fontSize: 15, color: fontColor),
              )
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          TextButton(
              onPressed: () {
                //Navigator.push(context, SlideLeftRoute(page: route));
              },
              style: TextButton.styleFrom(
                  backgroundColor: buttonColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9))),
              child: Container(
                padding: const EdgeInsets.all(5),
                alignment: Alignment.center,
                width: double.infinity,
                child: Text(
                  button,
                  style: TextStyle(fontSize: 18, color: buttonFontColor),
                ),
              ))
        ],
      ),
    );
  }
}
