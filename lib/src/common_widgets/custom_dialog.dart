import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:trainhero/src/constants/app_sizes.dart';

class CustomDialog extends StatelessWidget {
  final String title, description, buttonText;
  final String image;

  const CustomDialog({
    super.key,
    required this.title,
    required this.description,
    required this.buttonText,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5.5, sigmaY: 5.5),
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Sizes.p16),
        ),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        child: dialogContent(context, image),
      ),
    );
  }

  Widget dialogContent(BuildContext context, image) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.only(
          bottom: Sizes.p16,
        ),
        // margin: EdgeInsets.only(top: Consts.avatarHeight),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10.0,
              offset: Offset(0.0, 10.0),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min, // To make the card compact
          children: <Widget>[
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                  color: Color(0xff312F3E),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(Sizes.p16),
                      topRight: Radius.circular(Sizes.p16))),
              child: Column(
                children: [
                  const SizedBox(height: 15),
                  Image.asset(
                    image,
                    height: 100,
                  ),
                  const SizedBox(height: 15),
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 15)
                ],
              ),
            ),
            const SizedBox(height: 26.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                description,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xff312F3E),
                  fontSize: 16.0,
                ),
              ),
            ),
            const SizedBox(height: 24.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Align(
                alignment: Alignment.bottomRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // To close the dialog
                  },
                  child: Text(buttonText),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
