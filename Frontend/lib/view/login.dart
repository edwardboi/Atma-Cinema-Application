import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:main/component/form_component.dart';
import 'package:main/view/register.dart';
import 'package:main/view/home/welcome.dart';
import 'package:main/client/UserClient.dart';
import 'package:main/entity/user.dart';

class LoginForm extends StatefulWidget {
  final Map? data;

  const LoginForm({super.key, this.data});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController emailPhoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Map? dataForm;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    // Initialize dataForm after widget is created
    dataForm = widget.data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 33, 61, 41),
      body: SafeArea(
        child: SingleChildScrollView(
            child: IntrinsicHeight(
          child: Stack(
            children: [
              Positioned(
                top:0,
                left: 25,
                right:0,
                bottom:200,
                child: Image.asset(
                  
                  'images/logo.png',
                  
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 0.0, vertical: 0.0),
                    height: MediaQuery.of(context).size.height * 0.5,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(30),
                        topLeft: Radius.circular(30),
                      ),
                    )),
              ),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                        height: MediaQuery.of(context).size.height * 0.525),

                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Welcome Back',
                        style: TextStyle(
                          fontSize: 36.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 30.0),

                    // email or phone
                    Padding(
                      padding: const EdgeInsets.only(left: 43),
                      child: Text(
                        "Email",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    inputForm((p0) {
                      if (p0 == null || p0.isEmpty) {
                        return "Username tidak boleh kosong";
                      }
                      return null;
                    },
                        controller: emailPhoneController,
                        hintTxt: "Email"),

                    // password
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.only(left: 43),
                      child: Text(
                        "Password",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    inputForm((p0) {
                      if (p0 == null || p0.isEmpty) {
                        return "Password kosong";
                      }
                      return null;
                    },
                        password: true,
                        controller: passwordController,
                        hintTxt: "Password"),

                    if (_errorMessage != null)
                      Padding(
                        padding: EdgeInsets.only(top: 16.0),
                        child: Text(
                          _errorMessage!,
                          style: TextStyle(color: Colors.red),
                        ),
                      ),

                    SizedBox(height: 10.0),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: _login,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[300],
                          ),
                          child: const Text(
                            'Login',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(
                              width: 110,
                              child: Divider(
                                color: Colors.grey,
                                thickness: 1,
                                endIndent: 5,
                              ),
                            ),
                            Text(
                              "Or",
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              width: 110,
                              child: Divider(
                                color: Colors.grey,
                                thickness: 1,
                                indent: 5,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Don't have an account?"),
                            TextButton(
                              onPressed: () {
                                pushRegister(context);
                              },
                              child: Text('Sign Up'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        )),
      ),
    );
  }

  void showSnackBar(BuildContext context, String message, MaterialColor color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
      ),
    );
  }

  // Fungsi login yang memanggil UserClient.login
  void _login() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Menjalankan login dengan data yang diinput
        var email = emailPhoneController.text;
        var password = passwordController.text;

        var result = await UserClient.login(email, password);

        // Jika login berhasil, navigasi ke halaman home
        var user = result['user'] as User;
        var token = result['token'];
        var statusCode = result['statusCode'];

        print('Login sukses: $user');
        print('Token: $token');

        if (statusCode == 200 || statusCode == 201) {
          showSnackBar(context, "Login successful!", Colors.green);
          AwesomeDialog(
            context: context,
            animType: AnimType.leftSlide,
            headerAnimationLoop: false,
            dialogType: DialogType.success,
            showCloseIcon: false,
            title: 'Success',
            desc: 'Login successful!',
            btnOkOnPress: () {
              Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const Welcome()),
              (Route<dynamic> route) => false,
              );
            },
            btnOkIcon: Icons.check_circle,
          ).show();
        }
      } catch (e) {
        showSnackBar(context, "Login failed. Please try again.", Colors.red);
        AwesomeDialog(
          context: context,
          animType: AnimType.leftSlide,
          headerAnimationLoop: false,
          dialogType: DialogType.error,
          showCloseIcon: true,
          title: 'Error',
          desc: 'Login failed. Please try again.',
          btnOkOnPress: () {},
        ).show();
      }
    }
  }

  void pushRegister(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const RegisterForm()),
    );
  }
}
