import 'package:camera/camera.dart';
import 'package:ecarbon/pages/user_homepage.dart';
import 'package:ecarbon/utils.dart';
import 'package:flutter/material.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({super.key, required this.cameras});

  final List<CameraDescription> cameras;

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  final _loginFormKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: createAppbar(context),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              const SizedBox(height: 30),
              const CircleAvatar(
                  radius: 60,
                  backgroundImage: AssetImage("assets/images/plant.png")),
              Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.85,
                  child: Form(
                    key: _loginFormKey,
                    child: Column(
                      children: [
                        const SizedBox(height: 24),
                        createUsernameBox(context),
                        const SizedBox(height: 12),
                        createPasswordBox(context),
                        const SizedBox(height: 12),
                        createLoginButton(context),
                        const SizedBox(height: 12),
                        createSignupButton(),
                      ],
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

  Row createSignupButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text("ยังไม่มีบัญชีผู้ใช้งาน?"),
        ),
        TextButton(
            onPressed: () {
              // Navigator to Signup
            },
            child: const Text("สมัครสมาชิก"))
      ],
    );
  }

  Widget createLoginButton(BuildContext context) {
    return SizedBox(
      height: 50,
      width: MediaQuery.of(context).size.width * 0.5,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(
              const Color.fromARGB(255, 17, 162, 135)),
          foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          )),
        ),
        onPressed: () async {
          if (_loginFormKey.currentState!.validate()) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        UserHomePage(cameras: widget.cameras)));
          }
        },
        child: const Text('เข้าสู่ระบบ'),
      ),
    );
  }

  SizedBox createPasswordBox(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: TextFormField(
        controller: _passwordController,
        validator: (value) {
          if (value!.isEmpty) {
            return "กรุณาระบุรหัสผ่าน";
          }
          return null;
        },
        obscureText: !_passwordVisible,
        decoration: InputDecoration(
            hintText: "รหัสผ่าน",
            filled: true,
            fillColor: const Color.fromARGB(255, 142, 253, 207),
            border: const OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.all(Radius.circular(30)),
            ),
            contentPadding: const EdgeInsets.all(20),
            prefixIcon: const Icon(
              Icons.key,
              color: Colors.black87,
            ),
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  _passwordVisible = !_passwordVisible;
                });
              },
              icon: Icon(
                // Based on passwordVisible state choose the icon
                _passwordVisible ? Icons.visibility : Icons.visibility_off,
                color: Colors.black,
              ),
            )),
      ),
    );
  }

  SizedBox createUsernameBox(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: TextFormField(
        controller: _usernameController,
        validator: (value) {
          if (value!.isEmpty) {
            return "กรุณาระบุชื่อผู้ใช้งาน";
          }
          return null;
        },
        decoration: const InputDecoration(
          hintText: "ชื่อผู้ใช้งาน",
          filled: true,
          fillColor: Color.fromARGB(255, 142, 253, 207),
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.all(Radius.circular(30)),
          ),
          contentPadding: EdgeInsets.all(20),
          prefixIcon: Icon(
            Icons.person,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }
}
