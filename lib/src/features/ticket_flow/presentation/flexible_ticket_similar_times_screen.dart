import 'package:auto_animated/auto_animated.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:trainhero/src/features/ticket_flow/data/ticket_repository.dart';
import 'package:trainhero/src/features/ticket_flow/domain/models/departure.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:trainhero/src/routing/app_router.dart';

class FlexibleTicketSimilarTimesScreen extends HookConsumerWidget {
  const FlexibleTicketSimilarTimesScreen({Key? key}) : super(key: key);

  static const _liveOptions = LiveOptions(
    showItemInterval: Duration(milliseconds: 150),
    showItemDuration: Duration(milliseconds: 400),
    visibleFraction: 0.05,
    reAnimateOnVisibility: false,
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Animation controller for the title
    final animationController = useAnimationController(
      duration: const Duration(milliseconds: 1300),
    )..forward();
    useAnimation(animationController);

    // State variables
    final isLoading = useState(false);
    final selectedDeparture = useState<Departure?>(null);

    // Fetch possible train times and ticket details
    final departuresResponse = ref.watch(departuresResponseStateProvider);
    final ticketResponse = ref.watch(ticketResponseStateProvider);
    final possibleTrainTimes = departuresResponse?.departures ?? [];

    return Scaffold(
      backgroundColor: const Color(0xffF7CC94),
      body: SafeArea(
        child: Column(
          children: [
            // Back button
            _BackButton(),
            // Main content
            Expanded(
              flex: 9,
              child: Hero(
                tag: 'container',
                child: Material(
                  child: Container(
                    color: const Color(0xff302F3D),
                    padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 30),
                    child: Column(
                      children: [
                        // Animated title
                        _AnimatedTitle(animationController: animationController),
                        const SizedBox(height: 15),
                        // List of train times
                        Expanded(
                          child: _TrainTimesList(
                            possibleTrainTimes: possibleTrainTimes,
                            selectedDeparture: selectedDeparture,
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Confirm button
                        _ConfirmButton(
                          isEnabled: selectedDeparture.value != null,
                          isLoading: isLoading.value,
                          onPressed: () async {
                            if (selectedDeparture.value != null && ticketResponse != null && ticketResponse.tickets != null) {
                              isLoading.value = true;
                              final ticket = ticketResponse.tickets!.values.first;
                              final departure = selectedDeparture.value!;
                              
                              // Format departure time to match the expected format (HH:mm)
                              final depTime = '${departure.departureTime.hour.toString().padLeft(2, '0')}:${departure.departureTime.minute.toString().padLeft(2, '0')}';
                              
                              // Navigate to ticket summary
                              ref.read(goRouterProvider).pushNamed(
                                AppRoute.ticketSummary.name,
                                pathParameters: {
                                  'origin': ticket.origCrs,
                                  'originString': ticket.origCrs, // You might want to map station codes to full names
                                  'dest': ticket.destCrs,
                                  'destString': ticket.destCrs, // You might want to map station codes to full names
                                  'validFrom': ticket.validFrom,
                                  'depTime': depTime,
                                  'returnTkt': ticket.returnTkt.toString(),
                                  'delay': '15', // This should come from your delay calculation
                                  'comp': '25.50', // This should come from your compensation calculation
                                },
                              );
                              isLoading.value = false;
                            }
                          },
                        ),
                      ],
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

class _BackButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Align(
        alignment: Alignment.centerLeft,
        child: InkWell(
          onTap: () => Navigator.pop(context),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Hero(
              tag: "backArrow",
              child: Icon(
                Icons.arrow_back,
                size: 30,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AnimatedTitle extends StatelessWidget {
  final AnimationController animationController;

  const _AnimatedTitle({required this.animationController});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (context, child) {
        return FadeTransition(
          opacity: Tween<double>(begin: 0, end: 1).animate(
            CurvedAnimation(parent: animationController, curve: Curves.easeInOut),
          ),
          child: const Text(
            'Here are the trains that departed around that time, please select yours.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
        );
      },
    );
  }
}

class _TrainTimesList extends StatelessWidget {
  final List<Departure> possibleTrainTimes;
  final ValueNotifier<Departure?> selectedDeparture;

  const _TrainTimesList({
    required this.possibleTrainTimes,
    required this.selectedDeparture,
  });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
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
          stops: [0.0, 0.1, 0.85, 1.0],
        ).createShader(rect);
      },
      blendMode: BlendMode.dstOut,
      child: LiveList.options(
        padding: const EdgeInsets.symmetric(vertical: 30),
        options: FlexibleTicketSimilarTimesScreen._liveOptions,
        itemBuilder: (context, index, animation) {
          final departure = possibleTrainTimes[index];
          final isSelected = departure == selectedDeparture.value;

          return FadeTransition(
            opacity: Tween<double>(begin: 0, end: 1).animate(animation),
            child: SlideTransition(
              position: Tween<Offset>(begin: const Offset(0, -0.1), end: Offset.zero).animate(animation),
              child: Padding(
                padding: const EdgeInsets.all(6),
                child: TextButton(
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    backgroundColor: const Color(0xff404059),
                    side: isSelected
                        ? const BorderSide(width: 2.0, color: Color(0xffE3D6F8))
                        : BorderSide.none,
                  ),
                  onPressed: () {
                    selectedDeparture.value = departure;
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _TimeColumn(
                          label: 'Departure',
                          time: departure.departureTime.format(context),
                        ),
                        _TimeColumn(
                          label: 'Arrival',
                          time: departure.arrivalTime.format(context),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
        itemCount: possibleTrainTimes.length,
      ),
    );
  }
}

class _TimeColumn extends StatelessWidget {
  final String label;
  final String time;

  const _TimeColumn({required this.label, required this.time});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white, fontSize: 20),
        ),
        Text(
          time,
          style: const TextStyle(color: Colors.white, fontSize: 39),
        ),
      ],
    );
  }
}

class _ConfirmButton extends StatelessWidget {
  final bool isEnabled;
  final bool isLoading;
  final VoidCallback onPressed;

  const _ConfirmButton({
    required this.isEnabled,
    required this.isLoading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: TextButton(
          style: TextButton.styleFrom(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            backgroundColor: isEnabled ? const Color(0xffDEFAFF) : Colors.grey,
          ),
          onPressed: isEnabled ? onPressed : null,
          child: isLoading
              ? const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Color(0xFF373759)),
                )
              : const Text(
                  'Confirm',
                  style: TextStyle(
                    fontSize: 20,
                    color: Color(0xFF323140),
                  ),
                ),
        ),
      ),
    );
  }
}
