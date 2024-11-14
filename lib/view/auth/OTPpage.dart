import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:testcase1/service/authprovider.dart';

import '../../utils/constants/colors.dart';
import '../../utils/constants/widgets.dart';

class OtpPage extends StatelessWidget {
  String mobile;
   OtpPage({super.key,required this.mobile});

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
                        image: AssetImage('assets/otp.png'),
                        width: width / 2,
                        height: height / 5,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  SizedBox(height: height / 15),
                  lefttitle(
                      'OTP Verification'), //A custom widget to create the titles
                  SizedBox(height: height / 60),

                  Text(
                    "Enter the verification code we just sent to your number +91 *******821",
                    style: TextStyle(color: AppColors.textblack3,fontSize: 12),
                  ),

                  SizedBox(height: height / 60),

                  Pinput(
                    controller:auth.otpcontroller,
                    length: 6,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    defaultPinTheme: PinTheme(
                        textStyle: TextStyle(color:AppColors.textred, fontWeight: FontWeight.bold),
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.transparent,
                                blurRadius: 2.0, // soften the shadow
                                spreadRadius: 1.0, //extend the shadow
                              ),
                            ],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              width: 2,
                              color: Color(0xFF6B526B),
                            ))),

                    onCompleted: (pin) {
                      auth.verifyOTP(context,auth.otpcontroller.text);
                    },
                  ),

                  SizedBox(height: height / 60),
                  Center(
                    child: Text(
                      "59 sec",
                      style: TextStyle(fontSize:14 ,color: AppColors.textred),
                    ),
                  ),
                  SizedBox(height: height / 30),

                  Center(
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(
                            color: AppColors.textblack3,
                            fontSize: 14,
                            fontWeight: FontWeight.w400),
                        children: [
                          TextSpan(text: "Don't Get OTP? "),
                          TextSpan(
                            text: 'Resend',
                            style: TextStyle(
                                decoration: TextDecoration.underline,
                                color: AppColors.textblue),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0),

                  Center(
                    child: TextButton(
                      onPressed: () {
                      },
                      style: TextButton.styleFrom(
                          backgroundColor: AppColors.buttonblack,
                          fixedSize: Size(width / 1.2, height / 18),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(60))),
                      child: Text(
                        'Verify',
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
