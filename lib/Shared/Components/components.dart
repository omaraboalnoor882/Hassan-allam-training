//import 'dart:nativewrappers/_internal/vm/lib/core_patch.dart'as prefix;
import 'package:course_training/Shared/cubit/cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

Widget defaultButton({
  double width = double.infinity,
  Color background = Colors.blue,
  bool isUpperCase = true,
  double radius = 3.0,
  required void Function()? onPressed,
  required String text,
}) =>
    Container(child:MaterialButton(
      onPressed:onPressed,
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    ),
      width: width,
      decoration: BoxDecoration(
        color: background,
          borderRadius: BorderRadius.circular(
            radius,
        ),

      ),
    );

Widget defaultTextButton({
  required void Function()?,
  required String text,


}) => TextButton(onPressed: Function, child: Text(text.toUpperCase(), style: TextStyle(color: Colors.deepOrange),), );


Widget defaultFormField({
  required TextEditingController controller,
  required TextInputType type,
  void Function(String)? onFieldSubmitted,
   void Function(String)? onChanged,
  bool isPassword = false,
  required String? Function(String?)? validate,
  required String label,
  required IconData prefix,
  IconData? suffix,
  void Function()? onSuffixPressed,
  void Function()? onTap,
  bool isClickable = true,
}) => TextFormField(
  onTap:onTap ,
  controller: controller,
  keyboardType: type,
  obscureText: isPassword,
  onFieldSubmitted:onFieldSubmitted ,
  onChanged: onChanged,
  validator:validate ,
  decoration: InputDecoration(
    labelText: label,
    prefixIcon: Icon(
      prefix,
    ),
    suffixIcon: suffix != null ? IconButton(
      onPressed:onSuffixPressed ,
      icon: Icon(
        suffix,
      ),
    ) : null,
    border: OutlineInputBorder(),
  ),
);

Widget buildTaskItem(Map model, context) => Dismissible(
  key: Key(model['id'].toString()),
  child: Padding(
    padding: const EdgeInsets.all(20.0),
    child: Row(
      children: [
        CircleAvatar(
          radius: 40.0,
          child: Text('${model['time']}'),
        ),
        SizedBox(
          width: 20.0,
        ),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${model['title']}',
                style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold
                ),
              ),
              Text(
                '2 april 2024',
                style: TextStyle(
                    color: Colors.grey
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          width: 20.0,
        ),
        IconButton(
            onPressed: (){
              AppCubit.get(context).updateData(status: 'done', id: model['id'],);
            },
            icon: Icon(
              Icons.check_box,
              color: Colors.green,
            )
        ),
        IconButton(
            onPressed: (){
              AppCubit.get(context).updateData(status: 'archive', id: model['id'],);
            },
            icon: Icon(
              Icons.archive,
              color: Colors.black45,
            )
        ),
      ],
    ),
  ),
  onDismissed: (direction){
    AppCubit.get(context).deleteData(id: model['id'],);
  },
);


Widget buildArticleItem(article, context) => Padding(
  padding: const EdgeInsets.all(20.0),
  child: Row(
    children: [
      Container(
        width: 120.0,
        height: 140.0,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0,),
            image: DecorationImage(
                image: NetworkImage('${article['urlToImage']}'),
                fit: BoxFit.cover
            )
        ),
      ),
      SizedBox(width: 20.0,),
      Expanded(
        child: Container(
          height: 140.0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  '${article['title']}',
                  style: Theme.of(context).textTheme.bodyMedium,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                '${article['publishedAt']}',
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      )
    ],
  ),
);



void navigateTo(context, widget) => Navigator.push(
    context,
    MaterialPageRoute(
        builder: (context) => widget,
    ),
);

void navigateAndFinish(
    context,
    widget
    ) => Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => widget),
    (route){
      return false;
    },

);

void showToast({
required String text,
required ToastStates state,
}) =>  Fluttertoast.showToast(
msg: text,
toastLength: Toast.LENGTH_LONG,
gravity: ToastGravity.BOTTOM,
timeInSecForIosWeb: 5,
backgroundColor: chooseToastColor(state),
textColor: Colors.white,
fontSize: 16.0
);

enum ToastStates {SUCCESS, ERROR, WARNING}

Color chooseToastColor(ToastStates state)
{
  Color color;
  switch(state){
    case ToastStates.SUCCESS:
      color = Colors.green;
      break;
    case ToastStates.ERROR  :
      color = Colors.red;
      break;
    case ToastStates.WARNING:
      color = Colors.amber;
      break;
  }

  return color;
}

/*Widget articleBuilder(list, context) =>
  condition: list.length > 0,
  builder: (context) =>
      ListView.separated(
          itemBuilder: (context, index) => buildArticleItem(list[index], context),
          separatorBuilder: (context, index) => myDivider(),
          itemCount: 10,),
  fallback: (context) => Center(child: CircularProgressIndicator(),)
)*/