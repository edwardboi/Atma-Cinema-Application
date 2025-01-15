import 'package:flutter/material.dart';
import 'package:main/view/HomePage.dart';
import 'package:main/view/login.dart';
import 'package:main/component/form_component.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:main/client/UserClient.dart';
import 'package:main/entity/user.dart'; // pastikan Anda memiliki model User

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();
  TextEditingController dobController = TextEditingController();

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
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 1.0),
                      height: MediaQuery.of(context).size.height * 0.81,
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.2),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Get Started',
                          style: TextStyle(
                            fontSize: 36.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 25.0),
                      Padding(
                        padding: const EdgeInsets.only(left: 43),
                        child: Text(
                          "Username",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      inputForm(
                        (p0) {
                          if (p0 == null || p0.isEmpty) {
                            return "Username can't be empty";
                          }
                          return null;
                        },
                        controller: usernameController,
                        hintTxt: "Username",
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.only(left: 43),
                        child: Text(
                          "Phone Number",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      inputForm(
                        (p0) {
                          final RegExp regex = RegExp(r'^08[1-9]\d{7,11}$');
                          if (p0 == null || p0.isEmpty) {
                            return "Phone Number can't be empty";
                          }
                          if (!regex.hasMatch(p0)) {
                            return "Phone Number isn't valid";
                          }
                          return null;
                        },
                        controller: phoneController,
                        hintTxt: "Phone Number",
                      ),
                      SizedBox(height: 10),
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
                      inputForm(
                        (p0) {
                          if (p0 == null || p0.isEmpty) {
                            return "Email can't be empty";
                          }
                          if (!p0.contains('@')) {
                            return "Email must contain @";
                          }
                          return null;
                        },
                        controller: emailController,
                        hintTxt: "Email",
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.only(left: 43),
                        child: Text(
                          "Date of Birth",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          // Membuka DatePicker ketika pengguna mengetuk kolom
                          DateTime? selectedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now(),
                          );

                          if (selectedDate != null) {
                            // Jika ada tanggal yang dipilih, tampilkan di controller
                            dobController.text =
                                "${selectedDate.toLocal()}".split(' ')[0];
                          }
                        },
                        child: AbsorbPointer(
                          // AbsorbPointer agar TextField tidak dapat diinteraksikan langsung
                          child: inputForm(
                            (p0) {
                              if (p0 == null || p0.isEmpty) {
                                return "Date of Birth can't be empty";
                              }
                              return null;
                            },
                            controller: dobController,
                            hintTxt: "Date of Birth (YYYY-MM-DD)",
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
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
                      inputForm(
                        (p0) {
                          if (p0 == null || p0.isEmpty) {
                            return "Password can't be empty";
                          }
                          if (p0.length < 5) {
                            return "Password must be more than 5 characters";
                          }
                          return null;
                        },
                        controller: passwordController,
                        hintTxt: "Password",
                        password: true,
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.only(left: 43),
                        child: Text(
                          "Confirm Password",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      inputForm(
                        (p0) {
                          if (p0 == null || p0.isEmpty) {
                            return "Confirm Password can't be empty";
                          }
                          if (p0 != passwordController.text) {
                            return "Passwords don't match";
                          }
                          return null;
                        },
                        controller: confirmPassController,
                        hintTxt: "Confirm Password",
                        password: true,
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 155),
                        child: AnimatedButton(
                          text: 'Register',
                          buttonTextStyle: TextStyle(
                            color: Colors.black,
                          ),
                          color: Colors.grey[300],
                          pressEvent: () async {
                            if (_formKey.currentState!.validate()) {
                              // Parse date of birth to DateTime
                              DateTime? dob =
                                  DateTime.tryParse(dobController.text);
                              if (dob == null) {
                                // If the date is invalid
                                AwesomeDialog(
                                  context: context,
                                  animType: AnimType.leftSlide,
                                  headerAnimationLoop: false,
                                  dialogType: DialogType.error,
                                  showCloseIcon: true,
                                  title: 'Invalid Date',
                                  desc: 'Please provide a valid Date of Birth.',
                                  btnOkOnPress: () {},
                                ).show();
                                return;
                              }

                              // Simpan form data
                              var user = User(
                                id: 0, // ID biasanya dihasilkan oleh server, bisa diubah jika perlu
                                nama: usernameController.text,
                                email: emailController.text,
                                telp: phoneController.text,
                                password: passwordController.text,
                                tanggal_lahir: dob,
                                // Anda bisa menambah field foto jika diperlukan
                              );

                              try {
                                AwesomeDialog(
                                  context: context,
                                  animType: AnimType.leftSlide,
                                  headerAnimationLoop: false,
                                  dialogType: DialogType.success,
                                  showCloseIcon: false,
                                  title: 'Confirmation',
                                  desc: 'Apakah Anda yakin ingin mendaftar?',
                                  btnCancelOnPress: () {
                                  
                                        },
                                        btnCancelIcon: Icons.cancel,
                                  btnOkOnPress: () async {
                                    var response =
                                        await UserClient.register(user);
                                    if (response.statusCode == 201) {
                                      showSnackBar(
                                          context,
                                          "Registration successful!",
                                          Colors.green);
                                      AwesomeDialog(
                                        context: context,
                                        animType: AnimType.leftSlide,
                                        headerAnimationLoop: false,
                                        dialogType: DialogType.success,
                                        showCloseIcon: false,
                                        title: 'Success',
                                        desc: 'Registration successful!',
                                        
                                        btnOkOnPress: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => LoginForm(),
                                            ),
                                          );
                                        },
                                        btnOkIcon: Icons.check_circle,
                                      ).show();
                                    } else {
                                      showSnackBar(
                                          context,
                                          "Registration failed. Please try again.",
                                          Colors.red);
                                      AwesomeDialog(
                                        context: context,
                                        animType: AnimType.leftSlide,
                                        headerAnimationLoop: false,
                                        dialogType: DialogType.error,
                                        showCloseIcon: true,
                                        title: 'Error',
                                        desc:
                                            'Registration failed. Please try again.',
                                        btnOkOnPress: () {},
                                      ).show();
                                    }
                                  },
                                  btnOkIcon: Icons.check_circle,
                                ).show();
                              } catch (e) {
                                showSnackBar(
                                    context,
                                    "Registration failed. Please try again.",
                                    Colors.red);
                                AwesomeDialog(
                                  context: context,
                                  animType: AnimType.leftSlide,
                                  headerAnimationLoop: false,
                                  dialogType: DialogType.error,
                                  showCloseIcon: true,
                                  title: 'Error',
                                  desc:
                                      'Something went wrong. Please try again.',
                                  btnOkOnPress: () {},
                                ).show();
                              }
                            }
                          },
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
                          Text("Already have an account?"),
                          TextButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const LoginForm()),
                              );
                            },
                            child: Text('Log in'),
                          ),
                        ],
                      ),
                    ],
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

void showSnackBar(BuildContext context, String message, MaterialColor color) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: color,
    ),
  );
}
