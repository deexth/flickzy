import 'package:flickzy/features/preferences/suggestions.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OTPScreen extends StatefulWidget {
  const OTPScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _OTPScreen();
  }
}

class _OTPScreen extends State<OTPScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _otp;
  String _otpField = '';

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
                            const SizedBox(height: 8),
                            Text(
                              "Check your email",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.indigo[900],
                              ),
                              textAlign: TextAlign.left,
                            ),
                            const SizedBox(height: 20),
                            Text(
                              "We just sent a verification code to your email",
                              style: TextStyle(fontSize: 12),
                              textAlign: TextAlign.left,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Didn't get the code? Check your spam folder",
                              style: TextStyle(fontSize: 12),
                              textAlign: TextAlign.left,
                            ),
                            const SizedBox(height: 20),

                            PinCodeTextField(
                              appContext: context,
                              length: 6,
                              keyboardType: TextInputType.number,
                              animationType: AnimationType.fade,
                              pinTheme: PinTheme(
                                shape: PinCodeFieldShape.box,
                                borderRadius: BorderRadius.circular(8),
                                fieldHeight: 50,
                                fieldWidth: 40,
                                activeColor: Colors.lightBlue,
                                selectedColor: Colors.indigo,
                                inactiveColor: Colors.grey[300]!,
                              ),
                              onSaved: (value) {
                                _otp = value;
                              },
                              hintCharacter: '.',
                              onChanged: (value) {
                                setState(() {
                                  if (value.trim().length == 6) {
                                    _otpField = 'full';
                                  }
                                });
                              },
                              validator: (value) {
                                if (value == null || value.length != 6) {
                                  return 'Enter the 6-digit code';
                                }
                                return null;
                              },
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
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.indigo,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () {
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (context) => Suggestions(),
                                ),
                                (Route<dynamic> route) => false,
                              );
                            },
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 100),
                              child: Text(
                                _otpField == 'full' ? 'Verify' : 'Resend email',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
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
