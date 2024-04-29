

import 'package:assignment/screens/profile_screen.dart';
import 'package:assignment/widgets/custom_text_field.dart';
import 'package:assignment/widgets/custum_button.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

class SignUpPage extends StatelessWidget {
   SignUpPage({super.key});

  TextEditingController nameController = TextEditingController();

  TextEditingController genderController = TextEditingController();

  TextEditingController emailController = TextEditingController();

  TextEditingController idController = TextEditingController();

  TextEditingController levelController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  TextEditingController confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up Screen',
        style: TextStyle(color: Colors.white,
        ),
        ),
        backgroundColor: Colors.blue,
        ),
        body: ListView(children: [
          SizedBox(height: 15,),
          CustomTextField(obsText: false,
          controllerText: nameController,
          hint: 'Type your name',
          icon: Icon(Icons.person),
          label:'Name'),
          SizedBox(height: 10,),
          CustomTextField(obsText: false,
          controllerText: genderController,
          hint: 'i.e, Male/Female',
          label: 'Gender',
          icon: Icon(Icons.text_fields),),
          SizedBox(height: 10,),
          CustomTextField(obsText: false,
          controllerText: emailController,
          hint: 'i.e, studentID@stud.fci-cu.edu.eg',
          label: 'Email',
          icon: Icon(Icons.email),),
          SizedBox(height: 10,),
          CustomTextField(obsText: false,
          controllerText: idController,
          hint: 'i.e, 20200001',
          icon: Icon(Icons.perm_identity),
          label: 'ID',),
          SizedBox(height: 10,),
          CustomTextField(obsText: false,
          controllerText: levelController,
          hint: 'i.e, 1/2/3/4',
          label: 'Level',
          icon: Icon(Icons.numbers),),
          SizedBox(height: 10,),
          CustomTextField(obsText: true,
          controllerText: passwordController,
          hint: 'Password',
          label: 'Password',
          icon: Icon(Icons.password),),
          SizedBox(height: 10,),
          CustomTextField(obsText: true,
          controllerText: confirmPasswordController,
          hint: 'Confirm Password',
          label: 'Confirm Password',
          icon: Icon(Icons.password),),
          SizedBox(height: 15,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Already a member?                                   ',
              style: TextStyle(fontSize: 16),),
              TextButton(onPressed: (){
                Navigator.pushNamed(context, 'LoginPage');
              },
               child: Text('Login',
               style: TextStyle(fontSize: 16),))
            ],
          ),
          SizedBox(height: 15,),
          CustomButton(text: 'Submit',
          onPressed: () async{
            //Navigator.pushNamed(context, 'ProfilePage');
            registerUser(
                        nameController.text,
                        genderController.text,
                        emailController.text,
                        idController.text,
                        levelController.text,
                        passwordController.text,
                        confirmPasswordController.text,
                        context);
          },)
        ],)
    );
  }
}


void registerUser(String name, String gender, String email,
    String studentId, String level, String password, String confirmPassword,BuildContext context) async {
  final dio = Dio();
  const url = 'http://10.0.2.2:5266/api/Auth/signup';

  try {
    Map<String, dynamic> userData = {
      "name": name,
      "gender": gender,
      "email": email,
      "studentID" : studentId,
      "level": level,
      "password": password,
      "confirmPassword": confirmPassword
    };

    var response = await dio.post(
      url,
      data: userData,
    );
    //print(response.data);
    print(response.statusCode);

    if (response.data['isAuthenticated'] == true) {
      String token = response.data['token'];// Extract token from response
      String email = response.data['email'];
      // Store the token locally using shared_preferences or flutter_secure_storage
      await SharedPreferences.getInstance().then((prefs) {
        prefs.setString('token', token);
        prefs.setString('email', email);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Registration Success'),
        ),
      );

      // Navigate to role selection page
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => ProfilePage()),
        (route) => false,
      );
    }
    print('Response status: ${response.statusCode}');
    print('Response data: ${response.data}');
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Registration Failed'),
        ),
      );
  } catch (error) {
    print('Error: $error');

  }
}