import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:new_chat_app/utils/colors.util.dart';
import 'package:new_chat_app/utils/routes_utils.dart';

import '../../helpers/auth_helper.dart';
import '../../helpers/firestore_helper.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  RegExp emailRx = RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor.color1,
      body: SingleChildScrollView(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Gap(134),
            Text(
              "Welcome Back !",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: MyColor.color3,
              ),
            ),
            const Gap(74),
            Container(
              height: 646,
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: MyColor.color3,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(100),
                ),
              ),
              child: Form(
                key: formkey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  children: [
                    Text(
                      "SociaBay",
                      style: GoogleFonts.philosopher(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: MyColor.color1,
                      ),
                    ),
                    const Gap(8),
                    const Text(
                      "Please login with your personal information.",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Gap(36),
                    TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        isDense: true,
                        labelText: "Enter Email",
                        prefixIcon: Icon(
                          Icons.email,
                          color: MyColor.color1,
                          size: 24,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(
                            color: MyColor.color1,
                            width: 2,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter email id...";
                        } else if (!emailRx.hasMatch(value)) {
                          return "Please enter valid email...";
                        } else {
                          return null;
                        }
                      },
                    ),
                    const Gap(16),
                    TextFormField(
                      controller: passwordController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        isDense: true,
                        labelText: "Enter Password",
                        prefixIcon: Icon(
                          Icons.password,
                          color: MyColor.color1,
                          size: 24,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(
                            color: MyColor.color1,
                            width: 2,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (passwordController.text.isEmpty) {
                          return "Enter password";
                        }
                        return null;
                      },
                    ),
                    const Gap(16),
                    Row(
                      children: [
                        Text(
                          "Forget Password?",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: MyColor.color1,
                          ),
                        ),
                      ],
                    ),
                    const Gap(36),
                    GestureDetector(
                      onTap: () async {
                        bool validate = formkey.currentState!.validate();

                        if (validate) {
                          User? user = await AuthHelper.authHelper
                              .loginWithEmailPassword(
                            email: emailController.text.trim(),
                            password: passwordController.text.trim(),
                          );

                          if (user != null) {
                            Navigator.pushReplacementNamed(
                              context,
                              MyRoute.HomePage,
                              arguments: user,
                            );
                          }
                        }
                      },
                      child: Container(
                        height: 60,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: MyColor.color1,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          "Login",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const Gap(16),
                    GestureDetector(
                      onTap: () async {
                        User? user =
                            await AuthHelper.authHelper.loginWithGoogle();

                        if (user != null) {
                          FireStoreHelper.fireStoreHelper
                              .addUserData(user: user);
                          Navigator.pushReplacementNamed(
                            context,
                            MyRoute.HomePage,
                            arguments: user,
                          );
                        }
                      },
                      child: Container(
                        height: 60,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: MyColor.color1,
                            width: 2,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          "Login with Google",
                          style: TextStyle(
                            fontSize: 20,
                            color: MyColor.color1,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Don't have an account? "),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, MyRoute.SignUpPage);
                          },
                          child: Text(
                            "Sign up",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: MyColor.color1,
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
