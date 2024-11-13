import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:testcase1/utils/constants/widgets.dart';

import '../../utils/constants/colors.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.bggrey,
      floatingActionButton: FloatingActionButton(shape: CircleBorder(),
        onPressed: () {},
        child: Icon(
          CupertinoIcons.plus,
          color: AppColors.white,
        ),
        backgroundColor: AppColors.buttonblack,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: width / 25),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: height / 20.0,bottom: height / 40.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.search_rounded),
                          hintText: 'Search',
                          hintStyle: TextStyle(
                            color: AppColors.textblack3,
                            fontSize: 11,
                            fontWeight: FontWeight.w300,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 16.0, horizontal: 20.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide:
                            BorderSide(color: AppColors.textblack3, width: 1),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide:
                            BorderSide(color: AppColors.textblack3, width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide:
                            BorderSide(color: AppColors.textblue, width: 1),
                          ),
                        ),
                        style: TextStyle(color: AppColors.textblack),
                      ),
                    ),
                    Padding(
                      padding:  EdgeInsets.only(left: 8.0),
                      child: IconButton(
                        onPressed: () {},
                        color: AppColors.buttonblack,
                        icon: Icon(
                          Icons.save_rounded,
                          color: AppColors.buttonblack,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              lefttitle("User Lists"),
              ListView.builder(
                itemCount: 5,
                padding: EdgeInsets.symmetric(vertical: 4.0),
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 4.0),
                    child: Material(
                      elevation: 4,  // Adjust the shadow intensity
                      borderRadius: BorderRadius.circular(8),  // Make the shadow round like the ListTile
                      shadowColor: Colors.black.withOpacity(0.1),
                      child: ListTile(
                        contentPadding: EdgeInsets.all(8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        tileColor: AppColors.white,
                        leading: CircleAvatar(
                          backgroundImage: AssetImage("assets/otp.png"),
                          radius: 40,
                        ),
                        title: Text("Name"),
                        subtitle: Text("Age: 33"),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
