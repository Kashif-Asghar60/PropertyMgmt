import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:propertymgmt_uae/src/constants.dart';
import 'package:propertymgmt_uae/src/myapp.dart';
import 'package:propertymgmt_uae/src/widgets/CustomTextandFields/customTextField.dart';
import 'package:propertymgmt_uae/src/widgets/buttonCustom.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../providers/auth_provider.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _loading = false;

  double padding = 40;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController =
      TextEditingController(text: "kk@gmail.com");
  final TextEditingController _passwordController =
      TextEditingController(text: "123456");
  bool _rememberMe = false;
  String _errorText = '';

  @override
  void initState() {
    super.initState();
  }

  Future<void> _login(BuildContext context) async {
    final AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);

    setState(() {
      _loading = true;
      _errorText = ''; // Clear any previous error messages
    });

    final String email = _emailController.text.trim(); // Trim whitespace
    final String password = _passwordController.text;
    final bool rememberMe = _rememberMe; // Get the rememberMe status

    print('Email to be validated: $email ... remember $rememberMe');

    // Check if the email is in a valid format
    final emailRegExp = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
    if (!emailRegExp.hasMatch(email)) {
      setState(() {
        _loading = false;
        _errorText = 'Invalid email format. Please check your email. $email';
      });
      return; // Exit the method if the email format is invalid
    }

    try {
      await authProvider.login(
        email,
        password,
        rememberMe,
      ); // Pass the rememberMe status
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => MyHomePage()),
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        _loading = false;
        switch (e.code) {
          case 'invalid-email':
            _errorText = 'Invalid email address.';
            break;
          case 'user-not-found':
            _errorText = 'User not found. Please register.';
            break;
          case 'wrong-password':
            _errorText = 'Wrong password. Please try again.';
            break;
          default:
            _errorText = 'An error occurred during login: ${e.message}';
            break;
        }
      });
    } catch (e) {
      setState(() {
        _loading = false;
        _errorText = 'An error occurred during login: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          color: AppConstants.content_areaClr,
          width: Dimensions.screenWidth,
          height: Dimensions.screenHeight,
          child: Center(
            child: ListView.builder(
              itemCount: 1,
              itemBuilder: (context, index) {
                return Center(
                  child: SizedBox(
                    width: Dimensions.screenWidth / 2.5,
                    child: Padding(
                      padding: EdgeInsets.only(top: Dimensions.widthTxtField),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        // mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: Container(
                              color: const Color.fromARGB(255, 122, 130, 190),
                              width: Dimensions.logoSize,
                              height: Dimensions.logoSize,
                              child: Image.asset(
                                'assets/logo.png',
                              ),
                            ),
                          ),
                          Center(
                            child: Text(
                              'Log in',
                              style: TextStyle(
                                color: Color(0xFF2B3576),
                                fontSize: Dimensions.Txtfontsize,
                                fontFamily: 'Lato',
                                fontWeight: FontWeight.w700,
                                height: 0,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: padding),
                            child: Text(
                              'Please enter your credentials to access your account.',
                              style: TextStyle(
                                color: Color(0xFF2B3576),
                                fontSize: Dimensions.Txtfontsize,
                                fontFamily: 'Lato',
                                fontWeight: FontWeight.w400,
                                height: 0,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: padding),
                            child: Text(
                              'Email / Username',
                              style: TextStyle(
                                color: Color(0xFF2B3576),
                                fontSize: Dimensions.Txtfontsize,
                                fontFamily: 'Lato',
                                fontWeight: FontWeight.w600,
                                height: 0,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: padding, top: 10),
                            child: CustomTextField(
                              controller: _emailController,
                              width: Dimensions.widthTxtField * 1.5,
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: padding),
                            child: Text(
                              'Password',
                              style: TextStyle(
                                color: Color(0xFF2B3576),
                                fontSize: Dimensions.Txtfontsize,
                                fontFamily: 'Lato',
                                fontWeight: FontWeight.w600,
                                height: 0,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: padding, top: 10),
                            child: CustomTextField(
                              controller: _passwordController,
                              width: Dimensions.widthTxtField * 1.5,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding:
                                EdgeInsets.only(left: padding, right: padding),
                            child: CheckboxListTile(
                              title: Text('Remember me on this computer'),
                              value: _rememberMe,
                              onChanged: (value) {
                                setState(() {
                                  _rememberMe = value!;
                                });
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          FittedBox(
                            child: Padding(
                              padding: EdgeInsets.only(
                                  left: padding, right: padding),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        AppConstants.purplethemecolor,
                                    fixedSize: Size(
                                        Dimensions.widthTxtField * 1.5,
                                        Dimensions
                                            .buttonHeight), // Set the button size
                                    textStyle: TextStyle(
                                        color: AppConstants.whiteTxtColor)
                                    // You can customize the button size here if needed
                                    ),
                                child: _loading
                                    ? CircularProgressIndicator() // Show loading indicator
                                    : Text('Login'),
                                onPressed:
                                    _loading ? null : () => _login(context),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Center(
                            child: Text(
                              'Forgot password?',
                              style: TextStyle(
                                color: Color(0xFF8A8282),
                                fontSize: Dimensions.Txtfontsize,
                                fontFamily: 'Lato',
                                fontWeight: FontWeight.w500,
                                height: 0,
                              ),
                            ),
                          ),
                          if (_errorText.isNotEmpty)
                            Text(
                              _errorText,
                              style: TextStyle(color: Colors.red),
                            ),
                          const SizedBox(
                            height: 10,
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return RegistrationForm();
                                    },
                                  );
                                },
                                child: Text("Register?")),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          )),
    );
  }
}

class RegistrationForm extends StatefulWidget {
  @override
  _RegistrationFormState createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String _errorText = '';

  Future<void> _register(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      final AuthProvider authProvider =
          Provider.of<AuthProvider>(context, listen: false);

      try {
        await authProvider.register(
          _emailController.text,
          _passwordController.text,
          _nameController.text,
          _dobController.text,
        );

        // You can now store additional user information like name and DOB in a database or Firebase Firestore.
        // Here, we just display a success message.
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Registration successful!'),
          ),
        );

        Navigator.of(context)
            .pop(); // Close the dialog after successful registration.
      } on FirebaseAuthException catch (e) {
        print("ff $e");
        setState(() {
          _errorText = e.message ?? 'An error occurred during registration.';
        });
      } catch (e) {
        print("ff $e");

        setState(() {
          _errorText = 'An error occurred during registration.';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Registration'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name.';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email.';
                  }
                  if (!value.contains('@')) {
                    return 'Please enter a valid email address.';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password.';
                  }
                  if (value.length < 1) {
                    return 'Password must be at least 6 characters long.';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _dobController,
                decoration: InputDecoration(labelText: 'Date of Birth'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your date of birth.';
                  }
                  // You can add more specific validation for the date of birth if needed.
                  return null;
                },
              ),
              if (_errorText.isNotEmpty)
                Text(
                  _errorText,
                  style: TextStyle(color: Colors.red),
                ),
            ],
          ),
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () => _register(context),
          child: Text('Register'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          child: Text('Cancel'),
        ),
      ],
    );
  }
}
