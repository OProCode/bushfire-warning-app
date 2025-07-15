import 'package:flutter/material.dart';
import "create_account.dart";
import '../connector/fire_danger_rating_api_connector.dart';

class Login extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Login({super.key});

  final title = "Login";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("LOGIN")),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), labelText: "Email"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), labelText: "Password"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 16.0),
                child: Column(
                  children: [
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                String email = emailController.text;
                                String password = passwordController.text;
                                if (await FireDangerRatingAPI()
                                    .login(email, password)) {
                                  SnackBar(
                                    backgroundColor:
                                        Theme.of(context).colorScheme.surface,
                                    content: const Text('Successfully Logged In!'),
                                  );
                                  Navigator.of(context).pop();
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor:
                                          Theme.of(context).colorScheme.surface,
                                      content: Text(
                                        'Login failed. Please check your credentials.',
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .tertiary),
                                      ),
                                    ),
                                  );
                                }
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      backgroundColor:
                                          Theme.of(context).colorScheme.surface,
                                      content: Text('Please fill all fields',
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .tertiary))),
                                );
                              }
                            },
                            child: const Text('Login'),
                          ),
                          ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => CreateAccount()));
                              },
                              child: const Text("Create Account")),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        TextButton(
                          child: const Text(
                            'Forgot Password?',
                            style: TextStyle(
                                fontStyle: FontStyle.italic,
                                decoration: TextDecoration.underline),
                          ),
                          onPressed: () {
                            // TODO: Implement password reset.
                          },
                        ),
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
