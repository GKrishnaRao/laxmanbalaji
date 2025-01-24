import 'dart:ffi';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:laxmanbalaji/models/login_otp_request.dart';
import 'package:laxmanbalaji/uiviews/dashboard/dashboard_screen.dart';
import 'package:laxmanbalaji/utils/api_network_call.dart';
import 'package:laxmanbalaji/utils/app_url.dart';
import 'package:loader_overlay/loader_overlay.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  NetworkHandler apiNetworkHandler = NetworkHandler();
  bool _showPrefix = false;
  final _formKey = GlobalKey<FormState>();
  TextEditingController _mobilenumberController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  String _mobilenumber = '';
  String _password = '';
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _mobilenumberController.addListener(() {
      setState(() {
        _showPrefix = _mobilenumberController.text.isNotEmpty;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Sign In',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 20,
              ),
              mobileNumber(),
              const SizedBox(
                height: 20,
              ),
              password(),
              const SizedBox(
                height: 50,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: InkWell(
                  onTap: () {
                    _validateAndSave();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: const Color.fromRGBO(36, 129, 188, 1.0),
                        borderRadius: BorderRadius.circular(8)),
                    child: const Center(
                      child: Text(
                        "Send OTP",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget mobileNumber() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: TextFormField(
        controller: _mobilenumberController,
        keyboardType: TextInputType.phone, // Shows numeric keyboard
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly, // Allows only digits
          LengthLimitingTextInputFormatter(10), // Limits to 10 digits
        ],
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          //border: InputBorder.none,
          hintText: "Mobile Number",
          prefixIcon: Icon(Icons.mobile_friendly),
          prefixText: _showPrefix ? "+91 " : null,
          prefixStyle: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold), // Optional: style for prefix
          isDense: true,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 0.8),
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black, width: 1.5),
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
          ), // Helps to reduce the height of the input field
        ),
        onSaved: (value) {
          _mobilenumber = value.toString();
          setState(() {
            _mobilenumber = _mobilenumber.replaceAll("+91 ", '');
            _mobilenumberController.text = _mobilenumber;
          });
        },
        validator: (value) =>
            value!.isEmpty ? 'Mobile Number can\'t be empty' : null,
      ),
    );
  }

  Widget password() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: TextFormField(
        controller: _passwordController,
        obscureText: _obscureText,
        keyboardType: TextInputType.name,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          hintText: "Password",
          isDense: true,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 0.8),
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black, width: 1.5),
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
          ),
          prefixIcon: Icon(Icons.lock_clock_outlined),
          suffixIcon: IconButton(
            icon: Icon(
              _obscureText == true ? Icons.visibility_off : Icons.visibility,
              color: Colors.grey,
            ),
            onPressed: () {
              if (_obscureText == true) {
                _obscureText = false;
              } else {
                _obscureText = true;
              }
              setState(() {});
            },
          ), // // Helps to reduce the height of the input field
        ),
        onSaved: (value) {
          setState(() {
            _password = value.toString();
            _passwordController.text = _password;
          });
        },
        validator: (value) => value!.isEmpty ? 'Name can\'t be empty' : null,
      ),
    );
  }

  void _validateAndSave() async {
    try {
      final form = _formKey.currentState;
      if (form!.validate()) {
        _formKey.currentState!.save();

        context.loaderOverlay.show();

        try {
          Map<String, String> data = {
            "mobile_no": _mobilenumberController.text,
            "password": _passwordController.text,
          };

          if (kDebugMode) {
            print(data);
          }

          var response =
              await apiNetworkHandler.post(AppUrl.loginOtpRequest, data);

          if (response.statusCode == 200 || response.statusCode == 201) {
            try {
              final responseModel = loginModelFromJson(response.body);
              if (responseModel.response?.errorCode == "1") {
                context.loaderOverlay.hide();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Login successful')),
                );
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DashboardScreen(),
                  ),
                );
              } else if (responseModel.response?.errorCode == "0") {
                context.loaderOverlay.hide();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Something went wrong')),
                );
              }
            } catch (e) {
              context.loaderOverlay.hide();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text('Error parsing response: ${e.toString()}')),
              );
              if (kDebugMode) {
                print('Error parsing response: $e');
              }
            }
          } else {
            context.loaderOverlay.hide();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Server error: ${response.statusCode}'),
              ),
            );
            if (kDebugMode) {
              print('Failed');
              print(response.statusCode);
              print(response.body);
            }
          }
        } catch (e) {
          context.loaderOverlay.hide();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Network error: ${e.toString()}')),
          );
          if (kDebugMode) {
            print('Network error: $e');
          }
        }
      }
    } catch (e) {
      context.loaderOverlay.hide();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Validation error: ${e.toString()}')),
      );
      if (kDebugMode) {
        print('Validation error: $e');
      }
    }
  }
}
