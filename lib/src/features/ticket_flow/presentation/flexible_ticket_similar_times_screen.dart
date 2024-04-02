import 'package:auto_animated/auto_animated.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:trainhero/src/features/ticket_flow/data/ticket_repository.dart';
import 'package:trainhero/src/features/ticket_flow/domain/models/departure.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class FlexibleTicketSimilarTimesScreen extends HookConsumerWidget {
  final liveOptions = const LiveOptions(
    showItemInterval: Duration(milliseconds: 150),
    showItemDuration: Duration(milliseconds: 400),
    visibleFraction: 0.05,
    reAnimateOnVisibility: false,
  );

  const FlexibleTicketSimilarTimesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final animationController = useAnimationController(
      duration: const Duration(milliseconds: 1300),
    )..forward();

    useAnimation(animationController);

    final loadingData = useState(false);
    final timeSelected = useState(false);
    final possibleTrainTimes = ref.watch(departuresResponseStateProvider)?.departures ?? [];

    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xffF7CC94),
        body: Column(
          children: [
            Expanded(
              flex: 1,
              child: Align(
                alignment: Alignment.centerLeft,
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      children: [
                        Hero(
                          tag: "backArrow",
                          child: Icon(
                            Icons.arrow_back,
                            size: 30,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 9,
              child: Hero(
                tag: 'container',
                child: Material(
                  child: Container(
                    color: const Color(0xff302F3D),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 30, left: 35, right: 35),
                      child: Column(
                        children: [
                          AnimatedBuilder(
                              animation: animationController,
                              builder: (child, context) {
                                return FadeTransition(
                                  opacity:
                                      Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: animationController, curve: Curves.easeInOut)),
                                  child: const Text(
                                    'Here are the trains that departed around that time, please select yours.',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                    ),
                                  ),
                                );
                              }),
                          const SizedBox(
                            height: 15,
                          ),
                          Expanded(
                            child: ShaderMask(
                              shaderCallback: (Rect rect) {
                                return const LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Color(0xff302F3D),
                                    Colors.transparent,
                                    Colors.transparent,
                                    Color(0xff302F3D),
                                  ],
                                  stops: [0.0, 0.1, 0.85, 1.0], // 10% purple, 80% transparent, 10% purple
                                ).createShader(rect);
                              },
                              blendMode: BlendMode.dstOut,
                              child: LiveList.options(
                                padding: const EdgeInsets.only(
                                  bottom: 40,
                                  top: 30,
                                ),
                                options: liveOptions,
                                itemBuilder: (
                                  BuildContext context,
                                  int index,
                                  Animation<double> animation,
                                ) =>
                                    // For example wrap with fade transition
                                    FadeTransition(
                                  opacity: Tween<double>(
                                    begin: 0,
                                    end: 1,
                                  ).animate(animation),
                                  // And slide transition
                                  child: SlideTransition(
                                    position: Tween<Offset>(
                                      begin: const Offset(0, -0.1),
                                      end: Offset.zero,
                                    ).animate(animation),
                                    // Paste you Widget
                                    child: Padding(
                                      padding: const EdgeInsets.all(6),
                                      child: TextButton(
                                        style: TextButton.styleFrom(
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                          backgroundColor: const Color(0xff404059),
                                          // side: possibleTrainTimes[index].isPressed
                                          //     ? const BorderSide(width: 4.0, color: Color(0xffE3D6F8))
                                          //     : const BorderSide(width: 0.01, color: Colors.transparent),
                                        ),
                                        onPressed: () {},
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 6.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            children: [
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  const Text(
                                                    'Departure',
                                                    style: TextStyle(color: Colors.white, fontSize: 20),
                                                  ),
                                                  Text(
                                                    possibleTrainTimes[index].departureTime.format(context),
                                                    style: const TextStyle(color: Colors.white, fontSize: 39),
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  const Text(
                                                    'Arrival',
                                                    style: TextStyle(color: Colors.white, fontSize: 20),
                                                  ),
                                                  Text(
                                                    possibleTrainTimes[index].arrivalTime.format(context),
                                                    style: const TextStyle(color: Colors.white, fontSize: 39),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                scrollDirection: Axis.vertical,
                                itemCount: possibleTrainTimes.length,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: TextButton(
                                style: TextButton.styleFrom(
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                    backgroundColor: timeSelected.value ? const Color(0xffDEFAFF) : Colors.grey),
                                child: loadingData.value
                                    ? const Center(
                                        child: CircularProgressIndicator(
                                          valueColor: AlwaysStoppedAnimation(
                                            Color(0xFF373759),
                                          ),
                                        ),
                                      )
                                    : const Text(
                                        "Confirm",
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Color(0xFF323140),
                                        ),
                                      ),
                                onPressed: () async {
                                  if (timeSelected.value) {
                                    loadingData.value = true;
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
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
