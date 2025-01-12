import 'package:flutter/material.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';

class TicketSummaryScreen extends HookConsumerWidget {
  final String originString;
  final String origin;
  final String destString;
  final String dest;
  final int delay;
  final double comp;
  final String validFrom;
  final String depTime;
  final int returnTkt;
  final bool error;

  const TicketSummaryScreen({
    super.key,
    required this.originString,
    required this.origin,
    required this.destString,
    required this.dest,
    required this.delay,
    required this.comp,
    required this.validFrom,
    required this.depTime,
    required this.returnTkt,
    this.error = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Decide if the ticket is single or return
    final ticketType = useState(returnTkt == 0 ? 'Single' : 'Return');

    return Scaffold(
      backgroundColor: const Color(0xff302F3D),
      body: SafeArea(
        child: error
            ? TicketErrorView(
                originString: originString,
                origin: origin,
                destString: destString,
                dest: dest,
                validFrom: validFrom,
                ticketType: ticketType.value,
              )
            : TicketView(
                originString: originString,
                origin: origin,
                destString: destString,
                dest: dest,
                delay: delay,
                comp: comp,
                validFrom: validFrom,
                depTime: depTime,
                ticketType: ticketType.value,
              ),
      ),
    );
  }
}

//-----------------//
//    TicketView
//-----------------//
class TicketView extends StatelessWidget {
  final String originString;
  final String origin;
  final String destString;
  final String dest;
  final int delay;
  final double comp;
  final String validFrom;
  final String depTime;
  final String ticketType;

  const TicketView({
    Key? key,
    required this.originString,
    required this.origin,
    required this.destString,
    required this.dest,
    required this.delay,
    required this.comp,
    required this.validFrom,
    required this.depTime,
    required this.ticketType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      // Helps on smaller devices
      child: Column(
        children: [
          // The main card
          Container(
            margin: const EdgeInsets.all(20),
            clipBehavior: Clip.none,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: const Color(0xff3D3D54),
            ),
            child: Column(
              children: [
                // Header: origin, arrow, destination
                TicketHeader(
                  originString: originString,
                  origin: origin,
                  destString: destString,
                  dest: dest,
                ),

                // Details section
                TicketDetails(
                  validFrom: validFrom,
                  depTime: depTime,
                  ticketType: ticketType,
                ),

                // Divider (dashed line with circles on both sides)
                const TicketDivider(),

                // Footer: delay, compensation
                TicketFooter(
                  delay: delay,
                  comp: comp,
                ),
              ],
            ),
          ),

          // "Send Claim" button
          Container(
            margin: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xffE3D5F8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                minimumSize: const Size.fromHeight(52),
              ),
              onPressed: () {
                // Handle your claim here
                context.go('/success');
              },
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: AutoSizeText(
                  'Send Claim',
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff3D3D54),
                  ),
                  maxLines: 1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//--------------------------------//
//    TicketHeader (origin -> destination)
//--------------------------------//
class TicketHeader extends StatelessWidget {
  final String originString;
  final String origin;
  final String destString;
  final String dest;

  const TicketHeader({
    Key? key,
    required this.originString,
    required this.origin,
    required this.destString,
    required this.dest,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      // A bit more breathing room
      padding: const EdgeInsets.only(top: 30, left: 18, right: 18, bottom: 18),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Origin
          _StationInfo(
            label: originString,
            station: origin,
          ),

          // Arrow icon
          Container(
            margin: const EdgeInsets.only(top: 20),
            child: const Icon(
              Icons.arrow_forward,
              color: Colors.white,
              size: 35,
            ),
          ),

          // Destination
          _StationInfo(
            label: destString,
            station: dest,
          ),
        ],
      ),
    );
  }
}

class _StationInfo extends StatelessWidget {
  final String label;
  final String station;

  const _StationInfo({
    Key? key,
    required this.label,
    required this.station,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flexible(
      // This helps with smaller widths
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xffD9D9F9),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          FittedBox(
            child: Text(
              station,
              style: const TextStyle(
                fontSize: 40,
                color: Colors.white,
              ),
              maxLines: 1,
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

//--------------------------------//
//    TicketDetails (date, departure, ticket type)
//--------------------------------//
class TicketDetails extends StatelessWidget {
  final String validFrom;
  final String depTime;
  final String ticketType;

  const TicketDetails({
    Key? key,
    required this.validFrom,
    required this.depTime,
    required this.ticketType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Convert validFrom into your desired dd/mm/yy format
    final date =
        "${validFrom.substring(6, 8)}/${validFrom.substring(4, 6)}/${validFrom.substring(2, 4)}";

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      child: Column(
        children: [
          // Start Date & Departure
          const SizedBox(height: 10),
          Row(
            children: [
              _TicketDetailItem(
                label: 'Start Date',
                value: date,
              ),
              const Spacer(),
              _TicketDetailItem(
                label: 'Departure',
                value: depTime,
              ),
            ],
          ),

          const SizedBox(height: 35),

          // Ticket Type
          Align(
            alignment: Alignment.centerLeft,
            child: _TicketDetailItem(
              label: 'Ticket',
              value: '$ticketType Ticket',
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _TicketDetailItem extends StatelessWidget {
  final String label;
  final String value;

  const _TicketDetailItem({Key? key, required this.label, required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xffD9D9F9),
            fontSize: 15,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            color: Colors.white,
            fontSize: 22,
          ),
        ),
      ],
    );
  }
}

//--------------------------------//
//    TicketDivider (dashed line)
//--------------------------------//
class TicketDivider extends StatelessWidget {
  const TicketDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Semi-circles that extend outside the container
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Transform.translate(
              offset: const Offset(-20, 0), // Move left circle outside
              child: const _RoundCircle(color: Color(0xff302F3D)),
            ),
            Transform.translate(
              offset: const Offset(20, 0), // Move right circle outside
              child: const _RoundCircle(color: Color(0xff302F3D)),
            ),
          ],
        ),
        // Dashed line
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Dash(
            dashThickness: 3,
            dashBorderRadius: 4,
            direction: Axis.horizontal,
            length: 280,
            dashLength: 15,
            dashGap: 4,
            dashColor: Color(0x4D212128), // Opacity at 0.3
          ),
        ),
      ],
    );
  }
}

class _RoundCircle extends StatelessWidget {
  final Color color;

  const _RoundCircle({Key? key, required this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }
}

//--------------------------------//
//   TicketFooter (delay, comp)
//--------------------------------//
class TicketFooter extends StatelessWidget {
  final int delay;
  final double comp;

  const TicketFooter({
    Key? key,
    required this.delay,
    required this.comp,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 30.0,
        vertical: 25,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // Delay
          Column(
            children: [
              SizedBox(
                height: 55,
                width: 55,
                child: Image.asset('assets/delay_pink.png'),
              ),
              const SizedBox(height: 10),
              Text(
                '$delay Minute Delay',
                style: GoogleFonts.nunito(
                  color: const Color(0xffE3D5F8),
                  fontSize: 17,
                ),
              ),
            ],
          ),
          // Compensation
          Column(
            children: [
              Container(
                width: 50,
                height: 60,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xffE3D5F8),
                ),
                child: FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      '£${comp.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Color(0xff615C6B),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Compensation',
                style: GoogleFonts.nunito(
                  color: const Color(0xffE3D5F8),
                  fontSize: 17,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

//--------------------//
//  TicketErrorView
//--------------------//
class TicketErrorView extends StatelessWidget {
  final String originString;
  final String origin;
  final String destString;
  final String dest;
  final String validFrom;
  final String ticketType;

  const TicketErrorView({
    Key? key,
    required this.originString,
    required this.origin,
    required this.destString,
    required this.dest,
    required this.validFrom,
    required this.ticketType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final date =
        "${validFrom.substring(6, 8)}/${validFrom.substring(4, 6)}/${validFrom.substring(2, 4)}";

    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: const Color(0xff3D3D54),
            ),
            child: Column(
              children: [
                // Re-use same ticket header
                TicketHeader(
                  originString: originString,
                  origin: origin,
                  destString: destString,
                  dest: dest,
                ),

                // Show partial details
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: Column(
                    children: [
                      // Date
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          _TicketDetailItem(
                            label: 'Start Date',
                            value: date,
                          ),
                          const Spacer(),
                          // No departure shown in error
                        ],
                      ),

                      const SizedBox(height: 35),

                      // Ticket Type
                      Align(
                        alignment: Alignment.centerLeft,
                        child: _TicketDetailItem(
                          label: 'Ticket',
                          value: '$ticketType Ticket',
                        ),
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),

                // Divider
                const TicketDivider(),

                // You can show a message or an error image
                const SizedBox(height: 40),
                const Text(
                  'Something went wrong...',
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),

          // "Send Claim" button
          Container(
            margin: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xffE3D5F8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                minimumSize: const Size.fromHeight(52),
              ),
              onPressed: () {
                // Handle claim or handle error differently
                context.go('/success');
              },
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: AutoSizeText(
                  'Send Claim',
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff3D3D54),
                  ),
                  maxLines: 1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
