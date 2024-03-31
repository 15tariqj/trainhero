import 'package:flutter/material.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:group_button/group_button.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// TODO: Get the datepicker to a healthy start pos without spazzing

class FlexibleTicketScreen extends HookConsumerWidget {
  final List<String> timeOptionsList = List.generate(
    48,
    (index) {
      final int hour = index ~/ 2;
      final int minute = (index % 2) * 30;
      return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
    },
  );

  final DatePickerController _dateController = DatePickerController();
  final DateTime _today = DateTime.now();

  FlexibleTicketScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final animationController = useAnimationController(
      duration: const Duration(milliseconds: 1500),
    );

    useEffect(() {
      animationController.forward();
      return null;
    }, const []);

    useAnimation(animationController);

    final scrollController = useScrollController(
      initialScrollOffset: 2200,
      keepScrollOffset: true,
    );

    final timeSelected = useState(false);
    final loadingData = useState(false);
    final selectedDateTime = useState(DateTime.now().subtract(const Duration(days: 10)));

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          body: Container(
            color: const Color(0xffF7CC94),
            child: Column(
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 15.0, left: 25, bottom: 10),
                        child: SizedBox(
                          height: 80,
                          width: 80,
                          child: SlideTransition(
                            position: Tween<Offset>(begin: const Offset(-0.5, 0.2), end: const Offset(0, 0.2)).animate(
                              CurvedAnimation(
                                curve: const Interval(
                                  0.2,
                                  0.5,
                                  curve: Curves.easeOutCubic,
                                ),
                                parent: animationController,
                              ),
                            ),
                            child: SlideTransition(
                              position: Tween<Offset>(begin: const Offset(0, 0.2), end: const Offset(0, 0.0)).animate(
                                CurvedAnimation(
                                  curve: const Interval(
                                    0.5,
                                    0.7,
                                    curve: Curves.easeOutCubic,
                                  ),
                                  parent: animationController,
                                ),
                              ),
                              child: FadeTransition(
                                opacity: Tween<double>(begin: 0, end: 1).animate(
                                  CurvedAnimation(
                                    parent: animationController,
                                    curve: const Interval(
                                      0.2,
                                      0.5,
                                      curve: Curves.easeOutCubic,
                                    ),
                                  ),
                                ),
                                child: Image.asset('assets/trainHeroLogo.png'),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 25, bottom: 10, right: 25),
                        child: FadeTransition(
                          opacity: Tween<double>(begin: 0, end: 1.0).animate(
                            CurvedAnimation(
                              parent: animationController,
                              curve: const Interval(
                                0.6,
                                0.9,
                                curve: Curves.easeOutCubic,
                              ),
                            ),
                          ),
                          child: SlideTransition(
                            position: Tween<Offset>(begin: const Offset(0, 0.4), end: const Offset(0, 0.2)).animate(
                              CurvedAnimation(
                                parent: animationController,
                                curve: const Interval(
                                  0.6,
                                  0.9,
                                  curve: Curves.easeOutCubic,
                                ),
                              ),
                            ),
                            child: Container(
                                decoration: const BoxDecoration(
                                  color: Color(0xffF8F8F8),
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(20),
                                    bottomLeft: Radius.circular(20),
                                    bottomRight: Radius.circular(20),
                                  ),
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      "Hey Bob, before we send off your claim we need a couple more specific details for this ticket.",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Color(0xff2B2C34),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                )),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Hero(
                    tag: 'container',
                    child: Material(
                      color: Colors.transparent,
                      child: AnimatedBuilder(
                          animation: animationController,
                          builder: (context, child) {
                            return SlideTransition(
                              position: Tween<Offset>(
                                begin: const Offset(0, 0.3),
                                end: const Offset(0, 0),
                              ).animate(
                                CurvedAnimation(
                                  parent: animationController,
                                  curve: const Interval(
                                    0.4,
                                    0.8,
                                    curve: Curves.easeInOut,
                                  ),
                                ),
                              ),
                              child: FadeTransition(
                                opacity: Tween<double>(begin: 0, end: 1).animate(
                                  CurvedAnimation(
                                    parent: animationController,
                                    curve: const Interval(0.4, 0.6),
                                  ),
                                ),
                                child: Container(
                                  width: double.infinity,
                                  decoration: const BoxDecoration(
                                    color: Color(0xff302F3D),
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(30),
                                      topRight: Radius.circular(30),
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 35.0,
                                          vertical: 35,
                                        ),
                                        child: Text(
                                          'Slide and select when the train was roughly scheduled to leave.',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 17,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          children: [
                                            DatePicker(
                                              _today.subtract(
                                                const Duration(days: 30),
                                              ),
                                              height: 90,
                                              daysCount: 31,
                                              initialSelectedDate: selectedDateTime.value,
                                              selectionColor: const Color(0xff404059),
                                              monthTextStyle: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                              ),
                                              dayTextStyle: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                              ),
                                              dateTextStyle: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 19,
                                                fontWeight: FontWeight.w900,
                                              ),
                                              selectedTextColor: const Color(0xffEADCFF),
                                              controller: _dateController,
                                              onDateChange: (newDate) {
                                                selectedDateTime.value = DateTime(
                                                  newDate.year,
                                                  newDate.month,
                                                  newDate.day,
                                                  selectedDateTime.value.hour,
                                                  selectedDateTime.value.minute,
                                                );
                                              },
                                            ),
                                            const SizedBox(height: 20),
                                            SizedBox(
                                              height: 70,
                                              child: ShaderMask(
                                                shaderCallback: (Rect rect) {
                                                  return const LinearGradient(
                                                    begin: Alignment.centerLeft,
                                                    end: Alignment.centerRight,
                                                    colors: [
                                                      Color(0xff302F3D),
                                                      Colors.transparent,
                                                      Colors.transparent,
                                                      Color(0xff302F3D),
                                                    ],
                                                    stops: [0.0, 0.13, 0.87, 1.0], // 10% purple, 80% transparent, 10% purple
                                                  ).createShader(rect);
                                                },
                                                blendMode: BlendMode.dstOut,
                                                child: ListView(
                                                  controller: scrollController,
                                                  scrollDirection: Axis.horizontal,
                                                  children: [
                                                    GroupButton(
                                                      isRadio: true,
                                                      onSelected: (val, index, isSelected) {
                                                        timeSelected.value = true;
                                                        selectedDateTime.value = DateTime(
                                                          selectedDateTime.value.year,
                                                          selectedDateTime.value.month,
                                                          selectedDateTime.value.day,
                                                          int.parse(val.split(":")[0]),
                                                          int.parse(val.split(":")[1]),
                                                        );
                                                      },
                                                      buttons: timeOptionsList,
                                                      options: GroupButtonOptions(
                                                        spacing: 8,
                                                        direction: Axis.horizontal,
                                                        selectedTextStyle: const TextStyle(
                                                          fontWeight: FontWeight.w800,
                                                          fontSize: 22,
                                                          color: Color(0xffEADCFF),
                                                        ),
                                                        unselectedTextStyle: const TextStyle(
                                                          fontWeight: FontWeight.w600,
                                                          fontSize: 22,
                                                          color: Color(0xffE5E5E6),
                                                        ),
                                                        selectedColor: const Color(0xff404059),
                                                        unselectedColor: const Color(0xff404059),
                                                        selectedBorderColor: const Color(0xffEADCFF),
                                                        unselectedBorderColor: Colors.transparent,
                                                        borderRadius: BorderRadius.circular(8.0),
                                                        selectedShadow: <BoxShadow>[
                                                          const BoxShadow(
                                                            color: Colors.transparent,
                                                          )
                                                        ],
                                                        unselectedShadow: <BoxShadow>[
                                                          const BoxShadow(color: Colors.transparent),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 20.0,
                                          horizontal: 30,
                                        ),
                                        child: SizedBox(
                                          width: double.infinity,
                                          height: 55,
                                          child: TextButton(
                                              style: TextButton.styleFrom(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(12),
                                                ),
                                                backgroundColor: timeSelected.value ? const Color(0xffEADCFF) : Colors.grey,
                                              ),
                                              child: loadingData.value
                                                  ? const Center(
                                                      child: CircularProgressIndicator(
                                                        valueColor: AlwaysStoppedAnimation(
                                                          Color(0xFF373759),
                                                        ),
                                                      ),
                                                    )
                                                  : const Text(
                                                      "Next",
                                                      style: TextStyle(
                                                        fontSize: 20,
                                                        color: Color(0xFF323140),
                                                      ),
                                                    ),
                                              onPressed: () async {
                                                if (timeSelected.value) {
                                                  loadingData.value = true;

                                                  Future.delayed(const Duration(seconds: 1));

                                                  loadingData.value = false;
                                                }
                                              }),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
