import 'package:flickzy/features/auth/loginwithmemailpasswd.dart';
import 'package:flickzy/features/auth/otp.dart';
import 'package:flickzy/widgets/continue_button.dart';
import 'package:flutter/material.dart';

class LoginSignup extends StatefulWidget {
  const LoginSignup({super.key, required this.isLogin});

  final bool isLogin;

  @override
  State<StatefulWidget> createState() {
    return _LoginSignup();
  }
}

class _LoginSignup extends State<LoginSignup> {
  final _formKey = GlobalKey<FormState>();
  String? _enteredEmail;
  String? _emailStatus;

  bool isValidEmail(String value) {
    final emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
    return emailRegex.hasMatch(value.trim());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 20),
                            Text(
                              "What's your email?",
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.indigo[900],
                              ),
                              textAlign: TextAlign.left,
                            ),
                            const SizedBox(height: 14),
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: 'your email',
                                labelStyle: TextStyle(color: Colors.grey[700]),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: Colors.lightBlue,
                                    width: 2,
                                  ),
                                ),
                              ),
                              keyboardType: TextInputType.emailAddress,
                              autocorrect: false,
                              textCapitalization: TextCapitalization.none,
                              // validator: (value) {
                              //   if (value == null || value.trim().isEmpty) {
                              //     return 'Please enter your email address';
                              //   }
                              //   if (!isValidEmail(value)) {
                              //     return 'Please enter a valid email address';
                              //   }
                              //   return null;
                              // },
                              onChanged: (value) {
                                setState(() {
                                  if (value.trim().isEmpty) {
                                    _emailStatus = null;
                                  } else if (isValidEmail(value)) {
                                    _emailStatus = 'valid';
                                  } else {
                                    _emailStatus = 'invalid';
                                  }
                                });
                              },
                              onSaved: (value) {
                                _enteredEmail = value!;
                              },
                            ),
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 100),
                              child: Container(
                                alignment: Alignment.centerLeft,
                                padding: const EdgeInsets.only(
                                  left: 12,
                                  top: 6,
                                ),
                                width: double.infinity,
                                child: Text(
                                  _emailStatus == null ||
                                          _emailStatus == 'valid'
                                      ? "We'll send you a confirmation email."
                                      : "Please enter a valid email address",
                                  key: ValueKey(_emailStatus),
                                  style: TextStyle(
                                    color:
                                        _emailStatus == 'invalid'
                                            ? Colors.red
                                            : Colors.grey[700],
                                    fontSize: 13,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 40, top: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Continue(newScreen: OTPScreen(), isNewScreen: false),
                        if (widget.isLogin) const SizedBox(height: 12),
                        if (widget.isLogin)
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                side: const BorderSide(
                                  color: Colors.lightBlue,
                                  width: 2,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => EmailAndPsswd(),
                                  ),
                                );
                              },
                              child: const Text(
                                'Login with password',
                                style: TextStyle(
                                  color: Colors.lightBlue,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
