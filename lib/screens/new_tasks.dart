import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/components/components.dart';
import 'package:todo_app/cubit/cubit.dart';
import 'package:todo_app/cubit/states.dart';

import '../colors/colors.dart';

class NewTasks extends StatelessWidget {
  const NewTasks({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
        builder:(context, state) {
          AppCubit cubit =AppCubit.get(context);
          return ConditionalBuilder(condition: cubit.newTasks.isNotEmpty ,
            builder: (context)=>listBuilder(cubit.newTasks),
            fallback: (context)=>Center(

              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.menu,
                    size: 50,
                    color: Colors.grey[400],
                  ),
                  SizedBox(height: 10,),
                  Text('No tasks available',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.grey[600],
                    ),),
                ],
              ),
            ),
          );
          },
        listener:(context, state) {
          },);
  }

}
