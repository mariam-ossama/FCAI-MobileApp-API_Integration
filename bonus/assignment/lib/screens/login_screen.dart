import 'package:assignment/screens/profile_screen.dart';
import 'package:assignment/widgets/custom_text_field.dart';
import 'package:assignment/widgets/custum_button.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatelessWidget {
   LoginPage({super.key});

  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Screen',
        style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.blue,
      ),
      body: ListView(
        children: [
          SizedBox(height: 80,),
          Image.asset('lib/assets/images/undraw_Mobile_login_re_9ntv.png'),
          CustomTextField(obsText: false,
          controllerText: emailController,
          hint: 'i.e, studentID@stud.fci-cu.edu.eg',
          label: 'Email',
          icon: Icon(Icons.email),),
          SizedBox(height: 10,),
          CustomTextField(obsText: true,
          controllerText: passwordController,
          hint: 'Password',
          label: 'Password',
          icon: Icon(Icons.password),),
          SizedBox(height: 15,),
          CustomButton(text: 'Login',
          onPressed: ()async{
            //Navigator.pushNamed(context, 'ProfilePage');
            loginUser(emailController.text, passwordController.text, context);
          },)
        ],
      ),
    );
  }
}


void loginUser(String email, String password, BuildContext context) async {
  final dio = Dio();
  const url = 'http://10.0.2.2:5266/api/Auth/login';

  try {
    Map<String, dynamic> userData = {
      "email": email,
      "password": password,
    };

    var response = await dio.post(
      url,
      data: userData,
    );

    if (response.statusCode == 200) {
      String e_mail = response.data['email'];
      // Store the token locally using shared_preferences or flutter_secure_storage
      await SharedPreferences.getInstance().then((prefs) {
        prefs.setString('email', e_mail);
      });

      // Navigate to role selection page
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => ProfilePage()),
        (route) => false,
      );
    } else {
      // Handle unsuccessful login
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Login failed. Please check your credentials.'),
        ),
      );
    }

    print('Response status: ${response.statusCode}');
    print('Response data: ${response.data}');
  } catch (error) {
    print('Error: $error');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('An error occurred. Please try again later.'),
      ),
    );
  }
}