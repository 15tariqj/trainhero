import 'package:flutter/material.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TicketSummaryScreen extends HookConsumerWidget {
  final String originString;
  final String origin;
  final String destString;
  final String dest;
  final int? delay;
  final double? comp;
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
    this.delay,
    this.comp,
    required this.validFrom,
    required this.depTime,
    required this.returnTkt,
    this.error = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ticketType = useState(returnTkt == 0 ? 'Single' : 'Return');

    if (error) {
      return ticketError(context, ticketType.value);
    } else {
      return ticket(context, ticketType.value);
    }
  }

  Widget ticket(BuildContext context, String ticketType) {
    return Stack(
      children: [
        Container(width: double.maxFinite, height: double.maxFinite, color: const Color(0xFF302F3D)),
        SafeArea(
          child: Scaffold(
            backgroundColor: const Color(0xff302F3D),
            body: Column(
              children: [
                Expanded(
                  child: Stack(children: [
                    Container(
                      margin: const EdgeInsets.only(top: 23, left: 20, right: 20, bottom: 8),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: const Color(0xff3D3D54)),
                    ),
                    Column(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 15.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 0, left: 18, right: 18, bottom: 28),
                                  child: Container(
                                    decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.only(topRight: Radius.circular(15), topLeft: Radius.circular(15))),
                                    padding: const EdgeInsets.only(top: 55, left: 55, right: 55),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              originString,
                                              style: const TextStyle(fontSize: 14, color: Color(0xffD9D9F9)),
                                            ),
                                            Text(
                                              origin,
                                              style: const TextStyle(fontSize: 40, color: Colors.white),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            )
                                          ],
                                        ),
                                        const SizedBox(width: 10),
                                        Container(
                                          margin: const EdgeInsets.only(top: 20),
                                          child: const Icon(
                                            Icons.arrow_forward,
                                            color: Colors.white,
                                            size: 35,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              destString,
                                              style: const TextStyle(fontSize: 14, color: Color(0xffD9D9F9)),
                                            ),
                                            Text(
                                              dest,
                                              style: const TextStyle(fontSize: 40, color: Colors.white),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 25),
                                Padding(
                                  padding: const EdgeInsets.only(left: 18, right: 18),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 55),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    const Text(
                                                      'Start Date',
                                                      style: TextStyle(color: Color(0xffD9D9F9), fontSize: 15),
                                                    ),
                                                    const SizedBox(height: 5),
                                                    Text(
                                                      "${validFrom.substring(6, 8)}/${validFrom.substring(4, 6)}/${validFrom.substring(2, 4)}",
                                                      maxLines: 1,
                                                      style: const TextStyle(fontWeight: FontWeight.w700, color: Colors.white, fontSize: 22),
                                                    ),
                                                  ],
                                                ),
                                                const Spacer(),
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    const Text(
                                                      'Departure',
                                                      style: TextStyle(color: Color(0xffD9D9F9), fontSize: 15),
                                                    ),
                                                    const SizedBox(height: 5),
                                                    Text(
                                                      depTime,
                                                      maxLines: 1,
                                                      style: const TextStyle(fontWeight: FontWeight.w700, color: Colors.white, fontSize: 22),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                            const SizedBox(height: 45),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    const Text(
                                                      'Ticket',
                                                      style: TextStyle(color: Color(0xffD9D9F9), fontSize: 15),
                                                    ),
                                                    const SizedBox(height: 5),
                                                    Text(
                                                      '$ticketType Ticket',
                                                      maxLines: 1,
                                                      style: const TextStyle(fontWeight: FontWeight.w700, color: Colors.white, fontSize: 22),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Stack(alignment: Alignment.center, children: [
                                Dash(
                                  dashThickness: 3,
                                  dashBorderRadius: 4,
                                  direction: Axis.horizontal,
                                  length: 290,
                                  dashLength: 15,
                                  dashGap: 4,
                                  dashColor: const Color(0xff212128).withOpacity(0.3),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: 40,
                                      height: 40,
                                      decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xff302F3D)),
                                    ),
                                    Container(
                                      width: 40,
                                      height: 40,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Color(0xff302F3D),
                                      ),
                                    )
                                  ],
                                ),
                              ]),
                            ),
                          ],
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 35),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            height: 55,
                                            width: 55,
                                            child: Image.asset(
                                              'assets/delay_pink.png',
                                            ),
                                          ),
                                          const SizedBox(height: 15),
                                          Text(
                                            '$delay Minute Delay',
                                            style: GoogleFonts.nunito(
                                              textStyle: const TextStyle(color: Color(0xffE3D5F8), fontSize: 17),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          Container(
                                            width: 50,
                                            height: 60,
                                            alignment: Alignment.center,
                                            decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xffE3D5F8)),
                                            child: FittedBox(
                                              fit: BoxFit.fitWidth,
                                              child: Padding(
                                                padding: const EdgeInsets.all(4.0),
                                                child: Text(
                                                  '£${comp!.toStringAsFixed(2)}',
                                                  style: const TextStyle(color: Color(0xff615C6B), fontWeight: FontWeight.w600),
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 15),
                                          Text(
                                            'Compensation',
                                            style: GoogleFonts.nunito(
                                              textStyle: const TextStyle(color: Color(0xffE3D5F8), fontSize: 17),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  ]),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 15),
                  decoration: const BoxDecoration(
                    color: Color(0xff302F3D),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 22.0),
                    child: ButtonTheme(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      minWidth: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xffE3D5F8)),
                          child: const Padding(
                            padding: EdgeInsets.all(16),
                            child: Center(
                              child: AutoSizeText(
                                "Send Claim",
                                style: TextStyle(
                                  fontSize: 23,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xff3D3D54),
                                ),
                              ),
                            ),
                          ),
                          onPressed: () {}),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget ticketError(BuildContext context, String ticketType) {
    return Stack(
      children: [
        Container(width: double.maxFinite, height: double.maxFinite, color: const Color(0xFF302F3D)),
        SafeArea(
          child: Scaffold(
            backgroundColor: const Color(0xff302F3D),
            body: Column(
              children: [
                Expanded(
                  child: Stack(children: [
                    Container(
                      margin: const EdgeInsets.only(top: 23, left: 20, right: 20, bottom: 8),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: const Color(0xff3D3D54)),
                    ),
                    Column(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 15.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 0, left: 18, right: 18, bottom: 28),
                                  child: Container(
                                    decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.only(topRight: Radius.circular(15), topLeft: Radius.circular(15))),
                                    padding: const EdgeInsets.only(top: 55, left: 55, right: 55),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              originString,
                                              style: const TextStyle(fontSize: 14, color: Color(0xffD9D9F9)),
                                            ),
                                            Text(
                                              origin,
                                              style: const TextStyle(fontSize: 40, color: Colors.white),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            )
                                          ],
                                        ),
                                        const SizedBox(width: 10),
                                        Container(
                                          margin: const EdgeInsets.only(top: 20),
                                          child: const Icon(
                                            Icons.arrow_forward,
                                            color: Colors.white,
                                            size: 35,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              destString,
                                              style: const TextStyle(fontSize: 14, color: Color(0xffD9D9F9)),
                                            ),
                                            Text(
                                              dest,
                                              style: const TextStyle(fontSize: 40, color: Colors.white),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 25),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 18),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  const Text(
                                                    'Start Date',
                                                    style: TextStyle(color: Color(0xffD9D9F9), fontSize: 15),
                                                  ),
                                                  const SizedBox(height: 5),
                                                  Text(
                                                    "${validFrom.substring(6, 8)}/${validFrom.substring(4, 6)}/${validFrom.substring(2, 4)}",
                                                    maxLines: 1,
                                                    style: const TextStyle(fontWeight: FontWeight.w700, color: Colors.white, fontSize: 22),
                                                  ),
                                                ],
                                              ),
                                              const Spacer(),
                                              Container()
                                            ],
                                          ),
                                          const SizedBox(height: 45),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  const Text(
                                                    'Ticket',
                                                    style: TextStyle(
                                                      color: Color(0xffD9D9F9),
                                                      fontSize: 15,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 5),
                                                  Text(
                                                    '$ticketType Ticket',
                                                    maxLines: 1,
                                                    style: const TextStyle(fontWeight: FontWeight.w700, color: Colors.white, fontSize: 22),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Stack(alignment: Alignment.center, children: [
                                Dash(
                                  dashThickness: 3,
                                  dashBorderRadius: 4,
                                  direction: Axis.horizontal,
                                  length: 290,
                                  dashLength: 15,
                                  dashGap: 4,
                                  dashColor: const Color(0xff212128).withOpacity(0.3),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: 40,
                                      height: 40,
                                      decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xff302F3D)),
                                    ),
                                    Container(
                                      width: 40,
                                      height: 40,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Color(0xff302F3D),
                                      ),
                                    )
                                  ],
                                ),
                              ]),
                            ),
                          ],
                        ),
                        Expanded(
                          flex: 1,
                          child: Padding(padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 32), child: Container()),
                        ),
                      ],
                    )
                  ]),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  decoration: const BoxDecoration(
                    color: Color(0xff302F3D),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 22.0),
                    child: ButtonTheme(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      minWidth: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xffE3D5F8)),
                        child: const Center(
                          child: AutoSizeText(
                            "Send Claim",
                            style: TextStyle(
                              fontSize: 23,
                              fontWeight: FontWeight.w400,
                              color: Color(0xff3D3D54),
                            ),
                          ),
                        ),
                        onPressed: () {},
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
