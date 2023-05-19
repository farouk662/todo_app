import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/cubit/cubit.dart';
import 'package:todo_app/cubit/states.dart';

import '../colors/colors.dart';

class HomeLayout extends StatelessWidget {
  HomeLayout({Key? key}) : super(key: key);
  final scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  var titleController = TextEditingController();
  var dateController = TextEditingController();
  var timeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(listener: (context, state) {
        if(state is AppInsertIntoDataState)
        {
          Navigator.pop(context);
        }
      }, builder: (context, state) {
        AppCubit cubit = AppCubit.get(context);
        return Scaffold(
          key: scaffoldKey,
          backgroundColor: AppColors.white,
          appBar: AppBar(
            backgroundColor: AppColors.blue,
            elevation: 0,
            iconTheme:IconThemeData(color: AppColors.blue) ,
            toolbarHeight: 30,
          ),
          body: SafeArea(
            child: SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: 70,
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    decoration: BoxDecoration(
                        color: AppColors.blue,
                        borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(40))),
                    child: Text(
                      cubit.titles[cubit.currentIndex],
                      style: TextStyle(
                          color: AppColors.white,
                          fontSize: 31,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  Expanded(child: cubit.screens[cubit.currentIndex])
                ],
              ),
            ),
          ),
          bottomNavigationBar: GNav(
              selectedIndex: cubit.currentIndex,
              //rippleColor: Colors.grey, // tab button ripple color when pressed
              //hoverColor: Colors.grey, // tab button hover color
              haptic: true,
              // haptic feedback
              tabBorderRadius: 15,
              onTabChange: (index) {
                cubit.changeIndex(index);
              },
              //tabActiveBorder: Border.all(color: Colors.black, width: 1), // tab button border
              //tabBorder: Border.all(color: Colors.grey, width: 1), // tab button border
              //tabShadow: [BoxShadow(color: Colors.grey.withOpacity(0.5), blurRadius: 8)], // tab button shadow
              curve: Curves.easeOutExpo,
              // tab animation curves
              duration: const Duration(milliseconds: 500),
              // tab animation duration
              gap: 8,
              // the tab button gap between icon and text
              color: Colors.grey[600],
              // unselected icon color
              activeColor: Colors.white,
              // selected icon and text color
              iconSize: 24,
              // tab button icon size
              tabBackgroundColor: AppColors.blue,
              // selected tab background color
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 9),
              style: GnavStyle.google,
              tabMargin:
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              // navigation bar padding
              tabs: const [
                GButton(
                  icon: Icons.menu,
                  text: 'Tasks',
                ),
                GButton(
                  icon: Icons.task_alt_rounded,
                  text: 'Done',
                ),
                GButton(
                  icon: Icons.archive,
                  text: 'Archived',
                ),
              ]),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              if(cubit.isBottomSheetShown){
                if(formKey.currentState!.validate()) {
                  cubit.insertIntoDatabase(title: titleController.text,
                      date: dateController.text,
                      time: timeController.text);
                  titleController.clear();
                  timeController.clear();
                  dateController.clear();
                }
                }else{
                  scaffoldKey.currentState!.showBottomSheet((context) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormField(
                            controller: titleController,
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.title),
                              border: OutlineInputBorder(),
                              hintText: 'Task Title',
                            ),
                            validator: (String? value) {
                              if (value!.isEmpty) {
                                return 'tile must not be empty';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                            controller: timeController,
                            keyboardType: TextInputType.datetime,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.watch_later_outlined),
                              border: OutlineInputBorder(),
                              hintText: 'Task Time',
                            ),
                            validator: (String? value) {
                              if (value!.isEmpty) {
                                return 'time must not be empty';
                              }
                              return null;
                            },
                            onTap: () {
                              showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now())
                                  .then((value) {
                                timeController.text =
                                    value!.format(context).toString();
                                print(value.format(context));
                              });
                            },
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                            controller: dateController,
                            keyboardType: TextInputType.datetime,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.calendar_month_rounded),
                              border: OutlineInputBorder(),
                              hintText: 'Task Date',
                            ),
                            validator: (String? value) {
                              if (value!.isEmpty) {
                                return 'Date must not be empty';
                              }
                              return null;
                            },
                            onTap: () {
                              showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime.parse('2024-11-25'))
                                  .then((value) {
                                dateController.text =
                                    DateFormat.yMMMd().format(value!);
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  )).closed
                      .then((value) {
                    cubit.changeBottomSheetState(isShown: false, icon: Icons.edit);
                  });
                  cubit.changeBottomSheetState(isShown: true, icon: Icons.add);

              }

            },
            backgroundColor: AppColors.blue,
            child:  Icon(cubit.fabIcon),
          ),
        );
        // return widget here based on BlocA's state
      }),
    );
  }
}
