import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:testcase1/utils/constants/widgets.dart';

import '../../utils/constants/colors.dart';
import '../../viewmodel/mainprovider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenheight = MediaQuery.of(context).size.height;
    final screenwidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.bggrey,
      floatingActionButton: FloatingActionButton(
        shape: CircleBorder(),
        onPressed: () {
          _AddUserPopup(context);
        },
        child: Icon(
          CupertinoIcons.plus,
          color: AppColors.white,
        ),
        backgroundColor: AppColors.buttonblack,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenwidth / 25),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(
                    top: screenheight / 20.0, bottom: screenheight / 40.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Consumer<MainProvider>(
                        builder: (context,pro,child) {
                          return TextFormField(
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.search_rounded),
                              hintText: pro.currentHintText,
                              hintStyle: TextStyle(
                                color: AppColors.textblack3,
                                fontSize: 11,
                                fontWeight: FontWeight.w300,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 16.0, horizontal: 20.0),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide(
                                    color: AppColors.textblack3, width: 1),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide(
                                    color: AppColors.textblack3, width: 1),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide:
                                    BorderSide(color: AppColors.textblue, width: 1),
                              ),
                            ),
                            style: TextStyle(color: AppColors.textblack),
                          );
                        }
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 1.0),
                      child: GestureDetector(
                        onTap: () {

                          _sortingPopup(context);
                        },
                        child: Container(
                          width: screenwidth / 10,
                          height: screenheight / 30,
                          decoration: ShapeDecoration(
                            color: Colors.transparent,
                            shape: RoundedRectangleBorder(),
                            image: DecorationImage(
                                image: AssetImage("assets/sortbutton.png")),
                          ),
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
                      elevation: 4,
                      borderRadius: BorderRadius.circular(8),
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

void _AddUserPopup(BuildContext context) {
  final _formKey = GlobalKey<FormState>();
  final screenWidth = MediaQuery.of(context).size.width;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          width: screenWidth * 0.8,
          padding: EdgeInsets.all(screenWidth * 0.05),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              lefttitle("Add A New User"),

              SizedBox(height: screenWidth * 0.05),



            Consumer<MainProvider>(
              builder: (context, pro, child) {
                return GestureDetector(
                  onTap: () {
                    showBottomSheet(context);
                  },
                  child: Center(
                    child: Container(
                      width: screenWidth * 0.2,
                      height: screenWidth * 0.2,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey[200],
                      ),
                      child: ClipOval(
                        child: pro.userImageFile != null
                            ? Image.file(
                          pro.userImageFile!,
                          fit: BoxFit.cover,
                          width: screenWidth * 0.2,
                          height: screenWidth * 0.2,
                        )
                            : Image.asset(
                          'assets/addUser.png',
                          fit: BoxFit.cover,
                          width: screenWidth * 0.2,
                          height: screenWidth * 0.2,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),

            SizedBox(height: screenWidth * 0.05),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    _AddUserTextField(
                      labelText: "Name",
                      context: context,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a name';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: screenWidth * 0.03),
                    _AddUserTextField(
                      labelText: "Age",
                      keyboardType: TextInputType.number,
                      context: context,
                      inputFormatter: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(2),
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter age';
                        }
                        if (value.length != 2) {
                          return 'Age must be a 2-digit number';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: screenWidth * 0.03),
                    _AddUserTextField(
                      labelText: "Phone Number",
                      keyboardType: TextInputType.phone,
                      context: context,
                      inputFormatter: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(10),
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter phone number';
                        }
                        if (value.length != 10) {
                          return 'Phone number must be 10 digits';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: screenWidth * 0.05),
                    Row(
                      children: [
                        Expanded(
                          child: _Buttons(
                            context,
                            label: "Cancel",
                            color: Colors.grey[300]!,
                            textColor: Colors.grey,
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                        SizedBox(width: screenWidth * 0.02),
                        Expanded(
                          child: _Buttons(
                            context,
                            label: "Save",
                            color: Colors.blue,
                            textColor: Colors.white,
                            onPressed: () {
                              if (_formKey.currentState?.validate() ?? false) {
                                Navigator.pop(context);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

Widget _AddUserTextField({
  required String labelText,
  TextInputType keyboardType = TextInputType.text,
  required BuildContext context,
  List<TextInputFormatter>? inputFormatter,
  String? Function(String?)? validator,
}) {
  final screenWidth = MediaQuery.of(context).size.width;

  return TextFormField(
    keyboardType: keyboardType,
    inputFormatters: inputFormatter,
    decoration: InputDecoration(
      labelText: labelText,
      labelStyle: TextStyle(
        color: Colors.grey,
        fontSize: screenWidth * 0.04,
      ),
      contentPadding: EdgeInsets.symmetric(
        vertical: screenWidth * 0.02,
        horizontal: screenWidth * 0.05,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: const BorderSide(color: Colors.blue),
      ),
    ),
    validator: validator,
  );
}

Widget _Buttons(BuildContext context,
    {required String label,
    required Color color,
    required Color textColor,
    required VoidCallback onPressed}) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      padding: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.width * 0.03),
    ),
    onPressed: onPressed,
    child: Text(
      label,
      style: TextStyle(color: textColor),
    ),
  );
}

void showBottomSheet(BuildContext context) {
  showModalBottomSheet(
    elevation: 10,
    backgroundColor: AppColors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(10.0),
        topRight: Radius.circular(10.0),
      ),
    ),
    context: context,
    builder: (BuildContext bc) {
      return Consumer<MainProvider>(builder: (context, value, child) {
        return Container(
          height: 120,
          child: Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Column(
              children: [
                InkWell(
                  onTap: () async {
                    await value.pickUserImageFromGallery();
                    Navigator.pop(context);
                  },
                  child: ListTile(
                    leading: Icon(Icons.image, color: AppColors.textblue, size: 25),
                    title: Text("Gallery", style: TextStyle(color: AppColors.textblue, fontSize: 20)),
                  ),
                ),
                InkWell(
                  onTap: () async {
                    await value.pickUserImageFromCamera();
                    Navigator.pop(context);
                  },
                  child: ListTile(
                    leading: Icon(Icons.camera, color: AppColors.textblue, size: 25),
                    title: Text("Camera", style: TextStyle(color: AppColors.textblue, fontSize: 20)),
                  ),
                ),
              ],
            ),
          ),
        );
      });
    },
  );
}

void _sortingPopup(BuildContext context) {
  final screenWidth = MediaQuery.of(context).size.width;

  // Add a variable to track the selected sorting option
  int? selectedOption = 0; // 0 for All, 1 for Younger, 2 for Older

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Container(
              width: screenWidth * 0.8,
              padding: EdgeInsets.all(screenWidth * 0.05),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  lefttitle("Sort"),
                  RadioListTile<int>(
                    fillColor: WidgetStatePropertyAll(AppColors.textblue),
                    title: Text("All"),
                    value: 0,
                    groupValue: selectedOption,
                    onChanged: (int? value) {
                      setState(() {
                        selectedOption = value;
                      });
                    },
                  ),
                  RadioListTile<int>(
                    fillColor: WidgetStatePropertyAll(AppColors.textblue),

                    title: Text("Age: Younger"),
                    value: 1,
                    groupValue: selectedOption,
                    onChanged: (int? value) {
                      setState(() {
                        selectedOption = value;
                      });
                    },
                  ),
                  RadioListTile<int>(
                    fillColor: WidgetStatePropertyAll(AppColors.textblue),

                    title: Text("Age: Older"),
                    value: 2,
                    groupValue: selectedOption,
                    onChanged: (int? value) {
                      setState(() {
                        selectedOption = value;
                      });
                    },
                  ),
                  SizedBox(height: 10),
                  Center(child: _Buttons(context,label: "Apply", color: AppColors.textblue, textColor: AppColors.white, onPressed: () {  }))
                ],
              ),
            ),
          );
        },
      );
    },
  );
}

