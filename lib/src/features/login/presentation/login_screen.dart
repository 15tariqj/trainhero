import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:string_validator/string_validator.dart';
import 'package:trainhero/src/common_widgets/custom_dialog.dart';
import 'package:trainhero/src/common_widgets/input_with_icon.dart';
import 'package:trainhero/src/common_widgets/outline_button.dart';
import 'package:trainhero/src/common_widgets/primary_button.dart';
import 'package:url_launcher/url_launcher.dart';

// TODO: Fix the keyboard stuff

enum LoginContainerStates {
  closed,
  login,
  register,
  name,
}

class LoginScreen extends HookConsumerWidget {
  LoginScreen({Key? key, this.coldStart = false, this.error = false}) : super(key: key);

  final bool coldStart;
  final bool error;

  final keyboardVisibilityController = KeyboardVisibilityController();

  var _backgroundColor = Colors.white;
  var _headingColor = const Color(0xfb40284a);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final containerState = useState(LoginContainerStates.closed);
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final keyboardVisible = useState(false);
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final nameController = useTextEditingController();
    final headingTop = useState<double>(0);
    final loginHeight = useState<double>(0);
    final loginOpacity = useState<double>(0);
    final registerHeight = useState<double>(0);
    final registerOpacity = useState<double>(0);
    final nameHeight = useState<double>(0);
    final nameOpacity = useState<double>(0);

    useEffect(() {
      keyboardVisibilityController.onChange.listen((bool visible) {
        keyboardVisible.value = visible;
      });
      return () {};
    }, []);

    switch (containerState.value) {
      case LoginContainerStates.closed:
        _backgroundColor = const Color(0xff373759);
        _headingColor = Colors.white;
        headingTop.value = screenHeight / 7.5;
        loginOpacity.value = 0;
        loginHeight.value = 0;
        registerOpacity.value = 0;
        registerHeight.value = 0;
        nameHeight.value = 0;
        nameOpacity.value = 0;
        break;

      case LoginContainerStates.login:
        _backgroundColor = const Color(0xffF7CC94);
        _headingColor = const Color(0xff373759);
        headingTop.value = screenHeight / 10;
        loginOpacity.value = 1;
        loginHeight.value = keyboardVisible.value ? screenHeight : screenHeight - screenHeight / 2.75;
        registerHeight.value = 0;
        registerOpacity.value = 0;
        nameHeight.value = 0;
        nameOpacity.value = 0;
        break;

      case LoginContainerStates.register:
        _backgroundColor = const Color(0xFF8A89DB);
        _headingColor = Colors.white;
        headingTop.value = screenHeight / 12.5;
        loginOpacity.value = 0;
        loginHeight.value = 0;
        registerHeight.value = keyboardVisible.value ? screenHeight : screenHeight - screenHeight / 2.75;
        registerOpacity.value = 1;
        nameHeight.value = 0;
        nameOpacity.value = 0;
        break;

      case LoginContainerStates.name:
        _backgroundColor = const Color(0xFF8A89DB);
        _headingColor = Colors.white;
        headingTop.value = screenHeight / 15;
        loginOpacity.value = 0;
        loginHeight.value = 0;
        registerOpacity.value = 0;
        registerHeight.value = 0;
        nameHeight.value = keyboardVisible.value ? screenHeight : screenHeight - screenHeight / 2.75;
        nameOpacity.value = 1;
        break;
    }

    return KeyboardVisibilityProvider(
      controller: keyboardVisibilityController,
      child: SafeArea(
        child: AnimatedContainer(
          curve: Curves.fastLinearToSlowEaseIn,
          duration: const Duration(milliseconds: 1000),
          color: _backgroundColor,
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: Stack(
              alignment: Alignment.bottomCenter,
              children: <Widget>[
                GestureDetector(
                  behavior: containerState.value == LoginContainerStates.closed ? HitTestBehavior.opaque : HitTestBehavior.translucent,
                  child: SingleChildScrollView(
                    physics: containerState.value == LoginContainerStates.closed 
                        ? const ClampingScrollPhysics()
                        : const NeverScrollableScrollPhysics(),
                    child: AnimatedContainer(
                      curve: Curves.fastLinearToSlowEaseIn,
                      duration: const Duration(milliseconds: 1000),
                      color: _backgroundColor,
                      height: screenHeight,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              containerState.value = LoginContainerStates.closed;
                            },
                            child: Column(
                              children: <Widget>[
                                AnimatedContainer(
                                  curve: Curves.fastLinearToSlowEaseIn,
                                  duration: const Duration(milliseconds: 1000),
                                  margin: EdgeInsets.only(
                                    top: headingTop.value,
                                  ),
                                  child: Text(
                                    "Sign in to claim",
                                    style: TextStyle(color: _headingColor, fontSize: 28, fontWeight: FontWeight.w600),
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.all(30),
                                  padding: const EdgeInsets.symmetric(horizontal: 32),
                                  child: Text(
                                    "Sign in or sign up so that I know who I am processing the ticket for!",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: _headingColor, fontSize: 16),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 32),
                            child: Center(
                              child: Opacity(
                                opacity: containerState.value == LoginContainerStates.closed ? 1 : 0,
                                child: Image.asset(
                                  "assets/trainHeroLogo.png",
                                  width: 80,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            child: GestureDetector(
                              onTap: () {
                                containerState.value = LoginContainerStates.closed;
                              },
                              child: Opacity(
                                opacity: containerState.value == LoginContainerStates.closed ? 1 : 0,
                                child: Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        containerState.value = LoginContainerStates.login;
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(20),
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: const Color(0xffEADCFF),
                                          borderRadius: BorderRadius.circular(50),
                                        ),
                                        child: const Center(
                                          child: Text(
                                            "Sign in",
                                            style: TextStyle(color: Color(0xff3B3949), fontSize: 16),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        containerState.value = LoginContainerStates.register;
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(20),
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: const Color(0xffEADCFF),
                                          borderRadius: BorderRadius.circular(50),
                                        ),
                                        child: const Center(
                                          child: Text(
                                            "Sign up",
                                            style: TextStyle(color: Color(0xff3B3949), fontSize: 16),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        if (await canLaunchUrl(Uri.parse('http://109.228.36.170/privacy-notice/'))){
                                          await launchUrl(Uri.parse('http://109.228.36.170/privacy-notice/'));
                                        } else {
                                          throw 'Could not launch url';
                                        }
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.all(20),
                                        padding: const EdgeInsets.symmetric(horizontal: 32),
                                        child: Text(
                                          "Privacy policy",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(color: _headingColor, fontSize: 16),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Login Container
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  child: AnimatedContainer(
                    padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                    width: screenWidth,
                    height: loginHeight.value,
                    curve: Curves.fastLinearToSlowEaseIn,
                    duration: const Duration(milliseconds: 1000),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(loginOpacity.value),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(25),
                        topRight: Radius.circular(25),
                      ),
                    ),
                    child: SingleChildScrollView(
                      physics: containerState.value == LoginContainerStates.login 
                          ? const ClampingScrollPhysics()
                          : const NeverScrollableScrollPhysics(),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              Container(
                                margin: const EdgeInsets.only(bottom: 20),
                                child: Opacity(
                                  opacity: containerState.value == LoginContainerStates.name ? 0 : 1,
                                  child: const Text(
                                    "Sign in To Continue",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ),
                              InputWithIcon(
                                icon: Icons.email,
                                hint: "Enter Email",
                                controller: emailController,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              InputWithIcon(
                                icon: Icons.vpn_key,
                                hint: "Enter Password",
                                controller: passwordController,
                                isPasswordField: true,
                              ),
                              const SizedBox(height: 10)
                            ],
                          ),
                          Column(
                            children: <Widget>[
                              GestureDetector(
                                onTap: () {
                                  // TODO: Login logic
                                },
                                child: const SizedBox(
                                  width: double.maxFinite,
                                  child: PrimaryButton(
                                    text: "Sign in",
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 40,
                              ),
                              GestureDetector(
                                onTap: () {
                                  containerState.value = LoginContainerStates.register;
                                },
                                child: const OutlineButton(
                                  text: "Create New Account",
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Register User Container
                GestureDetector(
                  behavior: containerState.value == LoginContainerStates.register ? HitTestBehavior.deferToChild : HitTestBehavior.translucent,
                  child: AnimatedContainer(
                    height: registerHeight.value,
                    width: screenWidth,
                    padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                    curve: Curves.fastLinearToSlowEaseIn,
                    duration: const Duration(milliseconds: 1000),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(registerOpacity.value),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(25),
                        topRight: Radius.circular(25),
                      ),
                    ),
                    child: SingleChildScrollView(
                      physics: containerState.value == LoginContainerStates.register 
                          ? const ClampingScrollPhysics()
                          : const NeverScrollableScrollPhysics(),
                      child: Column(
                        children: <Widget>[
                          SingleChildScrollView(
                            physics: const NeverScrollableScrollPhysics(),
                            child: Column(
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(bottom: screenHeight / 36.872),
                                  child: const Text(
                                    "Create a New Account",
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ),
                                InputWithIcon(
                                  icon: Icons.email,
                                  hint: "Enter Email",
                                  controller: emailController,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                InputWithIcon(
                                  icon: Icons.vpn_key,
                                  hint: "Enter Password",
                                  controller: passwordController,
                                  isPasswordField: true,
                                ),
                                Container(
                                  color: Colors.black,
                                  child: const SizedBox(
                                    height: 10,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            children: <Widget>[
                              GestureDetector(
                                onTap: () {
                                  containerState.value = LoginContainerStates.name;
                                },
                                child: const SizedBox(
                                  width: double.maxFinite,
                                  child: PrimaryButton(
                                    text: "Next",
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 40,
                              ),
                              GestureDetector(
                                onTap: () {
                                  containerState.value = LoginContainerStates.login;
                                },
                                child: const OutlineButton(
                                  text: "Login Instead",
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Select Name container
                GestureDetector(
                  behavior: containerState.value == LoginContainerStates.name ? HitTestBehavior.deferToChild : HitTestBehavior.translucent,
                  child: AnimatedContainer(
                    padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                    width: screenWidth,
                    height: nameHeight.value,
                    curve: Curves.fastLinearToSlowEaseIn,
                    duration: const Duration(milliseconds: 1000),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(nameOpacity.value),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(25),
                        topRight: Radius.circular(25),
                      ),
                    ),
                    child: SingleChildScrollView(
                      physics: containerState.value == LoginContainerStates.name 
                          ? const ClampingScrollPhysics()
                          : const NeverScrollableScrollPhysics(),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              Container(
                                margin: const EdgeInsets.only(bottom: 20),
                                child: const Text(
                                  "What's your name?",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                              InputWithIcon(
                                icon: Icons.email,
                                hint: "Enter Full Name",
                                controller: nameController,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const SizedBox(height: 10)
                            ],
                          ),
                          Column(
                            children: <Widget>[
                              GestureDetector(
                                onTap: () {
                                  if (nameController.text.split(" ").length < 2 ||
                                      !isAlpha(nameController.text.replaceAll(" ", "").replaceAll("-", ""))) {
                                    showDialog(
                                      barrierDismissible: true,
                                      barrierColor: Colors.black.withOpacity(0.8),
                                      context: context,
                                      builder: (BuildContext context) => const CustomDialog(
                                        image: 'assets/th_confused.png',
                                        title: "Full name needed",
                                        description: "Please provide your first and last name.",
                                        buttonText: "Okay",
                                      ),
                                    );
                                  } else {
                                    // TODO: Register user logic
                                  }
                                },
                                child: const SizedBox(
                                  width: double.maxFinite,
                                  child: PrimaryButton(
                                    text: "Create Account",
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              GestureDetector(
                                onTap: () {
                                  containerState.value = LoginContainerStates.register;
                                },
                                child: const OutlineButton(
                                  text: "Back",
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
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
