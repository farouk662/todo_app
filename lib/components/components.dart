import 'package:flutter/material.dart';
import 'package:todo_app/cubit/cubit.dart';

import '../colors/colors.dart';

Widget taskItem(BuildContext context, Map model) =>
    Dismissible(
      key: Key(model['id'].toString()),
      onDismissed: (direction) {
        AppCubit.get(context).deleteData(id: model['id']);
      },
      child: Row(
        children: [

          CircleAvatar(
            radius: 40,
            backgroundColor: AppColors.blue,
            child: Text(
              '${model['time']}',

              style: TextStyle(color: AppColors.white),

            ),

          ),

          const SizedBox(

            width: 15,

          ),

          Column(

            mainAxisSize: MainAxisSize.max,

            crossAxisAlignment: CrossAxisAlignment.start,

            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: [

              Text(

                '${model['title']}',

                maxLines: 1,

                style: const TextStyle(

                    fontSize: 25,

                    overflow: TextOverflow.ellipsis,

                    fontWeight: FontWeight.bold),

              ),

              const SizedBox(

                height: 10,

              ),

              Text(

                '${model['date']}',

                style: Theme
                    .of(context)
                    .textTheme
                    .caption,

              ),

            ],

          ),

          const Spacer(),

          IconButton(onPressed: () {
            AppCubit.get(context).updateData(status: 'done', id: model['id']);
          },
              icon: Icon(
                Icons.check_circle_outline_outlined, color: AppColors.blue,)),


          IconButton(onPressed: () {
            AppCubit.get(context).updateData(
                status: 'archived', id: model['id']);
          }, icon: Icon(Icons.archive_outlined, color: AppColors.blue,)),

        ],

      ),
    );

Widget listBuilder(List items) =>
    Padding(
        padding: const EdgeInsets.symmetric(vertical: 25.0, horizontal: 15),
        child: ListView.separated(
            itemBuilder: (context, index) => taskItem(context, items[index]),
            separatorBuilder: (context, index) =>
            const SizedBox(
              height: 10,
            ),
            itemCount: items.length));
