import 'package:flutter/material.dart';
import 'package:kudiaccess/screens/login_page.dart';
import 'package:kudiaccess/utils/commons/custom_button.dart';
import 'package:kudiaccess/widgets/custom_textfield.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});
  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Create An Account",
                style: TextStyle(color: Colors.lightGreen, fontSize: 25),
              ),
              const SizedBox(
                height: 30,
              ),
              Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomTextField(
                        controller: emailController,
                        prefix: const Icon(Icons.email),
                        hint: "Email"),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomTextField(
                        controller: usernameController,
                        prefix: const Icon(Icons.person),
                        hint: "Username"),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomTextField(
                        controller: phoneNumberController,
                        prefix: const Icon(Icons.phone),
                        hint: "Phone Number"),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomTextField(
                        isPass: true,
                        controller: passwordController,
                        prefix: const Icon(Icons.lock),
                        hint: "Password"),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomTextField(
                        isPass: true,
                        controller: passwordController,
                        prefix: const Icon(Icons.lock),
                        hint: "Confirm Password"),
                    const SizedBox(
                      height: 25,
                    ),
                    CustomButton(
                        onPressed: () {},
                        txt: "Sign Up",
                        width: double.infinity,
                        color: Colors.lightGreen),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Already Have An Account?',
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                        TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const LoginPage()));
                            },
                            child: const Text(
                              "Login",
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ))
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
