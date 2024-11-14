import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:testcase1/utils/constants/widgets.dart';

import '../../model/models.dart';
import '../../utils/constants/colors.dart';
import '../../viewmodel/mainprovider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenheight = MediaQuery.of(context).size.height;
    final screenwidth = MediaQuery.of(context).size.width;

    MainProvider mainprovider = Provider.of<MainProvider>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      mainprovider.fetchUsers();
    });

    return Scaffold(
      backgroundColor: AppColors.bggrey,
      floatingActionButton:
          Consumer<MainProvider>(builder: (context, pro, child) {
        return FloatingActionButton(
          shape: CircleBorder(),
          onPressed: () {
            _AddUserPopup(context);
            pro.cleartextfield();
          },
          child: Icon(
            CupertinoIcons.plus,
            color: AppColors.white,
          ),
          backgroundColor: AppColors.buttonblack,
        );
      }),
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
                        builder: (context, pro, child) {
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
                                borderSide: BorderSide(
                                    color: AppColors.textblue, width: 1),
                              ),
                            ),
                            style: TextStyle(color: AppColors.textblack),
                            onChanged: (value) {
                              pro.filterUsers(value);
                            },
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 1.0),
                      child: InkWell(
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
              Consumer<MainProvider>(
                builder: (context, pro, child) {
                  return ListView.builder(
                    itemCount: pro.filteredUsersList.length + 1,
                    padding: EdgeInsets.symmetric(vertical: 4.0),
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      if (index == pro.filteredUsersList.length) {
                        return Center(
                          child: ElevatedButton(
                            onPressed: pro.isFetching ? null : pro.fetchUsers,
                            child: pro.isFetching
                                ? CircularProgressIndicator()
                                : Text("Load More"),
                          ),
                        );
                      }

                      User item = pro.filteredUsersList[index];
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
                              backgroundColor: AppColors.textblue,
                              child: Text(
                                item.name[0].toUpperCase(),
                                style: TextStyle(color: Colors.white),
                              ),
                              radius: 40,
                            ),
                            title: Text(item.name),
                            subtitle: Text(item.number),
                            trailing: Text(
                              "Age: ${item.age}",
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
              SizedBox(
                height: screenheight / 10,
              )
            ],
          ),
        ),
      ),
    );
  }
}

void _AddUserPopup(BuildContext context) {
  final screenWidth = MediaQuery.of(context).size.width;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          width: screenWidth * 0.8,
          padding: EdgeInsets.all(screenWidth * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              lefttitle("Add A New User"),
              SizedBox(height: screenWidth * 0.05),
              SizedBox(height: screenWidth * 0.05),
              Consumer<MainProvider>(builder: (context, pro, child) {
                return Column(
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
                      controller: pro.nameController,
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
                      controller: pro.ageController,
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
                      controller: pro.numberController,
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
                              if (pro.nameController.text.isNotEmpty &&
                                  pro.ageController.text.isNotEmpty &&
                                  pro.numberController.text.isNotEmpty) {
                                pro.addUser(context);
                                Navigator.pop(context);
                                pro.fetchUsers();
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        "Please fill all fields and select an image"),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              }),
            ],
          ),
        ),
      );
    },
  );
}

Widget _AddUserTextField({
  required String labelText,
  required TextEditingController controller,
  TextInputType keyboardType = TextInputType.text,
  required BuildContext context,
  List<TextInputFormatter>? inputFormatter,
  String? Function(String?)? validator,
}) {
  final screenWidth = MediaQuery.of(context).size.width;

  return TextFormField(
    controller: controller,
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

void _sortingPopup(BuildContext context) {
  final screenWidth = MediaQuery.of(context).size.width;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Consumer<MainProvider>(builder: (context, prov, child) {
              int? tempOption = prov.selectedOption;
              return Container(
                width: screenWidth * 0.8,
                padding: EdgeInsets.all(screenWidth * 0.05),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    lefttitle("Sort"),
                    RadioListTile<int>(
                      fillColor: WidgetStatePropertyAll(AppColors.textblue),
                      title: Text("All"),
                      value: 0,
                      groupValue: tempOption,
                      onChanged: (int? value) {
                        setState(() {
                          prov.selectedOption = value;
                        });
                      },
                    ),
                    RadioListTile<int>(
                      fillColor: WidgetStatePropertyAll(AppColors.textblue),
                      title: Text("Age: Younger"),
                      value: 1,
                      groupValue: tempOption,
                      onChanged: (int? value) {
                        setState(() {
                          prov.selectedOption = value;
                        });
                      },
                    ),
                    RadioListTile<int>(
                      fillColor: WidgetStatePropertyAll(AppColors.textblue),
                      title: Text("Age: Older"),
                      value: 2,
                      groupValue: tempOption,
                      onChanged: (int? value) {
                        setState(() {
                          prov.selectedOption = value;
                        });
                      },
                    ),
                    SizedBox(height: 10),
                    Center(
                      child: _Buttons(
                        context,
                        label: "Apply",
                        color: AppColors.textblue,
                        textColor: AppColors.white,
                        onPressed: () {
                          String currentQuery = prov.nameController.text;
                          prov.filterUsers(currentQuery);
                          Navigator.pop(context);
                        },
                      ),
                    )
                  ],
                ),
              );
            }),
          );
        },
      );
    },
  );
}
