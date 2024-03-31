import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trainhero/src/constants/app_sizes.dart';
import 'package:trainhero/src/features/mail/domain/onboarding_data.dart';

class MailPage extends StatelessWidget {
  final OnboardingData data;

  const MailPage({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        gapH64,
        Image.asset(
          data.imagePath,
          height: Sizes.p64 * 2.5,
        ),
        Text(
          data.heading,
          style: GoogleFonts.nunito(
            color: Colors.white,
            fontSize: Sizes.p24,
            fontWeight: FontWeight.w600,
          ),
        ),
        gapH12,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Sizes.p20),
          child: Text(
            data.subheading,
            style: GoogleFonts.nunito(
              color: Colors.white,
              fontSize: Sizes.p16,
              fontWeight: FontWeight.w300,
            ),
            textAlign: TextAlign.center,
          ),
        )
      ],
    );
  }
}
