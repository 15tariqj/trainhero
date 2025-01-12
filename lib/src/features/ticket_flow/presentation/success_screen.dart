import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SuccessScreen extends StatefulHookConsumerWidget {
  const SuccessScreen({super.key});

  @override
  ConsumerState<SuccessScreen> createState() => _SuccessScreenState();
}

class _SuccessScreenState extends ConsumerState<SuccessScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this, 
      duration: const Duration(milliseconds: 2000)
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        context.go('/home');
      },
      child: Scaffold(
        backgroundColor: const Color(0xff373759),
        body: Column(
          children: [
            const Spacer(),
            Stack(
              children: [
                Image.asset('assets/success_layer_bottom.png'),
                Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 18.0),
                    child: FadeTransition(
                      opacity: Tween<double>(begin: 1, end: 0).animate(
                        CurvedAnimation(
                          parent: _controller,
                          curve: const Interval(0.7, 0.75)
                        )
                      ),
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0.0, 0), 
                          end: const Offset(-0.4, 0)
                        ).animate(CurvedAnimation(
                          parent: _controller,
                          curve: const Interval(0.2, 1, curve: Curves.easeInCubic)
                        )),
                        child: const Text(
                          'SUCCESS!',
                          style: TextStyle(
                            color: Colors.white, 
                            fontSize: 25
                          )
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(minWidth: 1, minHeight: 1),
                    child: FittedBox(
                      fit: BoxFit.cover,
                      child: ClipRect(
                        child: Container(
                          child: Align(
                            alignment: Alignment.topLeft,
                            widthFactor: 0.57,
                            heightFactor: 1,
                            child: AnimatedBuilder(
                              animation: _controller,
                              builder: (context, child) {
                                return SlideTransition(
                                  position: Tween<Offset>(
                                    begin: const Offset(0.5, 0),
                                    end: const Offset(-1, 0)
                                  ).animate(CurvedAnimation(
                                    parent: _controller,
                                    curve: const Interval(0.2, 1, curve: Curves.easeInCubic)
                                  )),
                                  child: ConstrainedBox(
                                    constraints: const BoxConstraints(
                                      minWidth: 1, 
                                      minHeight: 1
                                    ),
                                    child: Image.asset(
                                      'assets/success_layer_middle.png',
                                    ),
                                  ),
                                );
                              }
                            ),
                          ),
                        )
                      ),
                    ),
                  ),
                ),
                Image.asset('assets/success_layer_top.png'),
              ],
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: FadeTransition(
                opacity: Tween<double>(begin: 0, end: 1).animate(
                  CurvedAnimation(
                    parent: _controller,
                    curve: const Interval(0.5, 0.8, curve: Curves.easeInOutCubic)
                  )
                ),
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.15), 
                    end: Offset.zero
                  ).animate(CurvedAnimation(
                    parent: _controller,
                    curve: const Interval(0.6, 1, curve: Curves.easeInOutCubic)
                  )),
                  child: const Text(
                    'Your claim has been successfully uploaded. We\'ll notify you on the status of the claim that we\'ve processed for you',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white, 
                      fontSize: 18
                    ),
                  ),
                ),
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: SafeArea(
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff5c5fc9),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    onPressed: () => context.go('/home'),
                    child: const AutoSizeText(
                      "Done",
                      style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        )
      ),
    );
  }
} 