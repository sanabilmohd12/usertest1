import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:testcase1/service/authprovider.dart';
import 'package:testcase1/utils/constants/colors.dart';
import 'package:testcase1/utils/constants/widgets.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final _phoneFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: width / 15,
        ),
        child: SingleChildScrollView(
          child: Consumer<LoginProvider>(
            builder: (context,auth,child) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: height / 17.0),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Image(
                        image: AssetImage('assets/login.png'),
                        width: width / 2,
                        height: height / 5,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  SizedBox(height: height / 15),
                  Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: lefttitle('Enter Phone Number'),
                  ), //A custom widget to easily create the titles on left
                  SizedBox(height: height / 60),

                  Form(
                    key: _phoneFormKey,
                    child: TextFormField(
                      controller: auth.Loginnumber,
                      keyboardType: TextInputType.phone,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(10),
                      ],
                      decoration: InputDecoration(
                        hintText: 'Enter your phone number *',
                        hintStyle: TextStyle(
                            color: AppColors.textblack3,
                            fontSize: 11,
                            fontWeight: FontWeight.w300),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 16.0, horizontal: 20.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: AppColors.textblack3, width: 1),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: AppColors.textblack3, width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: AppColors.textblue, width: 1),
                        ),
                      ),
                      style: TextStyle(color: AppColors.textblack),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your phone number';
                        } else if (value.length != 10) {
                          return 'Please enter 10 digits';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: height / 60),

                  Center(
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(color: AppColors.textblack3, fontSize: 12,fontWeight: FontWeight.w300),
                        children: [
                          TextSpan(text: 'By Continuing, I agree to TotalX’s'),
                          TextSpan(
                            text: ' Terms and Conditions ',
                            style: TextStyle(color: AppColors.textblue),
                          ),
                          TextSpan(text: '& '),
                          TextSpan(
                            text: 'Privacy Policy',
                            style: TextStyle(color: AppColors.textblue),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0),

                  Center(
                    child: TextButton(
                      onPressed: () {
                        auth.sendOTP(context);
                        if (_phoneFormKey.currentState?.validate() ?? false) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('OTP sent')),
                          );
                        }
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: AppColors.buttonblack,
                        fixedSize: Size(width/1.2, height/18),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(60))
                      ),
                      child: Text(
                        'Get OTP',
                        style: TextStyle(color: AppColors.white),
                      ),
                    ),
                  ),
                ],
              );
            }
          ),
        ),
      ),
    );
  }
}
