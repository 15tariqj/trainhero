import 'package:flutter/material.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen(
      {Key? key,
      required this.message,
      required this.heading,
      required this.image,
      this.homepage = false})
      : super(key: key);
  final bool homepage;
  final String heading;
  final String message;
  final String image;

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  bool isEnabled = false;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    controller.forward().whenComplete(() {
      setState(() {
        isEnabled = true;
      });
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color(0xff312F3E),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              flex: 6,
              child: Container(),
            ),
            // SizedBox(
            //   height: 40,
            // ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: AnimatedBuilder(
                  animation: controller,
                  builder: (context, child) {
                    return SlideTransition(
                      position: Tween<Offset>(
                              begin: const Offset(0, 0.2),
                              end: const Offset(0, 0.0))
                          .animate(
                        CurvedAnimation(
                          curve: const Interval(
                            0.5,
                            0.7,
                            curve: Curves.easeOutCubic,
                          ),
                          parent: controller,
                        ),
                      ),
                      child: SlideTransition(
                        position: Tween<Offset>(
                                begin: const Offset(-0.5, 0.2),
                                end: const Offset(0, 0.2))
                            .animate(
                          CurvedAnimation(
                            curve: const Interval(
                              0.2,
                              0.5,
                              curve: Curves.easeOutCubic,
                            ),
                            parent: controller,
                          ),
                        ),
                        child: FadeTransition(
                          opacity: Tween(begin: 0.0, end: 1.0).animate(
                            CurvedAnimation(
                              curve: const Interval(
                                0.2,
                                0.5,
                                curve: Curves.easeOutCubic,
                              ),
                              parent: controller,
                            ),
                          ),
                          child: Image.asset(
                            widget.image,
                            height: 100,
                          ),
                        ),
                      ),
                    );
                  }),
            ),
            const SizedBox(
              height: 15,
            ),
            AnimatedBuilder(
                animation: controller,
                builder: (context, child) {
                  return SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 0.4),
                      end: const Offset(0, 0.2),
                    ).animate(
                      CurvedAnimation(
                        curve: const Interval(
                          0.6,
                          0.9,
                          curve: Curves.easeOutCubic,
                        ),
                        parent: controller,
                      ),
                    ),
                    child: FadeTransition(
                      opacity: Tween<double>(begin: 0, end: 1).animate(
                        CurvedAnimation(
                          curve: const Interval(
                            0.6,
                            0.9,
                            curve: Curves.easeOutCubic,
                          ),
                          parent: controller,
                        ),
                      ),
                      child: Container(
                        alignment: Alignment.topLeft,
                        padding: const EdgeInsets.all(15),
                        margin: const EdgeInsets.symmetric(horizontal: 25),
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(15),
                                bottomRight: Radius.circular(15),
                                bottomLeft: Radius.circular(15))),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.heading,
                              style: const TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w500,
                                color: Color(0xff312F3E),
                              ),
                              textAlign: TextAlign.left,
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Text(
                              widget.message,
                              style: const TextStyle(
                                fontSize: 18,
                                color: Color(0xff312F3E),
                              ),
                              textAlign: TextAlign.left,
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                }),
            Expanded(
              flex: 4,
              child: Container(),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: AnimatedBuilder(
                  animation: controller,
                  builder: (context, child) {
                    return FadeTransition(
                      opacity: Tween<double>(begin: 0, end: 1.0).animate(
                        CurvedAnimation(
                          curve: const Interval(
                            0.6,
                            0.9,
                            curve: Curves.easeOutCubic,
                          ),
                          parent: controller,
                        ),
                      ),
                      child: TextButton(
                        onPressed: () {
                          if (isEnabled) {
                            // Navigator.push(
                            //     // context, SlideLeftRoute(page: HomeScreen()));
                            //     context,
                            //     SlideLeftRoute(page: HomeScreen()));
                          } else {}
                        },
                        style: TextButton.styleFrom(
                            shape: const StadiumBorder(),
                            backgroundColor: const Color(0xff232130)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15.0, vertical: 8),
                          child: widget.homepage == true
                              ? const Text(
                                  "Get Started",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 22),
                                )
                              : const Text(
                                  "Okay",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 22),
                                ),
                        ),
                      ),
                    );
                  }),
            ),
            const SizedBox(
              height: 50,
            )
          ],
        ),
      ),
    );
  }
}
