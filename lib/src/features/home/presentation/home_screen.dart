import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trainhero/src/constants/app_sizes.dart';
import 'package:trainhero/src/routing/app_router.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  gapH48,
                  Image.asset(
                    "assets/trainHeroLogo.png",
                    height: 100,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                      ),
                    ),
                    // height: SizeConfig.safeBlockVertical * 11,
                    child: Stack(
                      fit: StackFit.passthrough,
                      alignment: Alignment.bottomCenter,
                      children: [
                        TabBar(
                          labelColor: const Color(0xff9E9EDB),
                          indicatorColor: const Color(0xFF9D9EDA),
                          indicatorWeight: 2,
                          unselectedLabelColor: const Color(0xFFB1B1B1),
                          tabs: [
                            Tab(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: AutoSizeText(
                                  'Pending Claims',
                                  style: GoogleFonts.nunito(
                                    fontSize: 19,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),
                            Tab(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: AutoSizeText(
                                  'Completed',
                                  style: GoogleFonts.nunito(
                                    fontSize: 19,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: TabBarView(
                      children: [
                        Container(
                          height: double.maxFinite,
                          width: double.maxFinite,
                          decoration: BoxDecoration(
                            color: const Color(0xffEBE8EF),
                            border: Border.all(
                              color: const Color(0xffEBE8EF),
                            ),
                          ),
                          child: ListView.builder(
                            padding: const EdgeInsets.only(top: 10),
                            itemCount: 0, //pendingTickets!.length,
                            itemBuilder: (context, index) {
                              return null;

                              // return TicketContainer(
                              //   ticket: pendingTickets![index],
                              //   pending: true,
                              // );
                              // TODO: Fix Dis
                            },
                          ),
                        ),
                        Container(
                          height: double.maxFinite,
                          width: double.maxFinite,
                          color: const Color(0xffEBE8EF),
                          child: ListView.builder(
                            itemCount:
                                0, //completedTickets!.length, //TODO: Fix dis
                            itemBuilder: (context, index) {
                              return null;

                              // return TicketContainer(
                              //   ticket: completedTickets![index],
                              //   pending: false,
                              // );
                              // TODO: Fix dis
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xffEBE8EF),
                      border: Border.all(
                        color: const Color(0xffEBE8EF),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ButtonTheme(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            // minWidth: SizeConfig.safeBlockHorizontal * 93,
                            //height: SizeConfig.safeBlockVertical * 8,
                            child: SafeArea(
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xff5c5fc9),
                                  ),
                                  child: Center(
                                    child: AutoSizeText(
                                      "Make a Claim",
                                      style: GoogleFonts.nunito(
                                        fontSize: Sizes.p24,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  onPressed: () => GoRouter.of(context)
                                      .pushNamed(AppRoute.mail.name)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                left: Sizes.p12,
                top: Sizes.p8,
                child: GestureDetector(
                  onTap: () =>
                      GoRouter.of(context).pushNamed(AppRoute.settings.name),
                  child: const Icon(
                    Icons.settings,
                    color: Colors.white,
                    size: Sizes.p32,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
