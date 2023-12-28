import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:new_chat_app/helpers/auth_helper.dart';
import 'package:new_chat_app/helpers/firestore_helper.dart';
import 'package:new_chat_app/modals/user_Modal.dart';
import 'package:new_chat_app/utils/routes_utils.dart';

import '../../utils/colors.util.dart';

class SignUpPage extends StatelessWidget {
  SignUpPage({super.key});

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

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
              "Create Your Account",
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
                key: formKey,
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
                      "Create your account so you can manage\nyour personal information.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Gap(36),
                    //email
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
                        if (emailController.text.isEmpty) {
                          return "Enter email address";
                        }
                        return null;
                      },
                    ),
                    const Gap(16),
                    //password
                    TextFormField(
                      controller: passwordController,
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
                    TextFormField(
                      controller: confirmPasswordController,
                      decoration: InputDecoration(
                        isDense: true,
                        labelText: "Enter Confirm Password",
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
                          return "Enter confirm password";
                        }
                        return null;
                      },
                      onFieldSubmitted: (value) {
                        if (passwordController.text.toString() !=
                            confirmPasswordController.text.toString()) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Password not matched.."),
                              backgroundColor: Colors.red,
                            ),
                          );
                        } else {}
                      },
                    ),
                    const Gap(36),
                    GestureDetector(
                      onTap: () async {
                        bool validate = formKey.currentState!.validate();

                        if (validate) {
                          User? user = await AuthHelper.authHelper
                              .signUpWithEmailPassword(
                            email: emailController.text.trim(),
                            password: passwordController.text.trim(),
                          );

                          if (user != null) {
                            FireStoreHelper.fireStoreHelper
                                .addUserData(user: user);

                            Navigator.pushReplacementNamed(
                              context,
                              MyRoute.profilePage,
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
                          "Sign Up",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const Gap(16),
                    Container(
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
                        "SignUp with Google",
                        style: TextStyle(
                          fontSize: 20,
                          color: MyColor.color1,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Already have an account? "),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            "Login",
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
