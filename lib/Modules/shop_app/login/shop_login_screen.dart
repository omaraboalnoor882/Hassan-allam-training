import 'package:course_training/Modules/shop_app/login/cubit/cubit.dart';
import 'package:course_training/Modules/shop_app/register/shop_register_screen.dart';
import 'package:course_training/Shared/Components/components.dart';
import 'package:course_training/Shared/network/local/cache_helper.dart';
import 'package:course_training/layout/shop_app/shop_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'cubit/states.dart';

class ShopLoginScreen extends StatelessWidget {

  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    var emailController = TextEditingController();
    var passwordController = TextEditingController();

    return BlocProvider(
      create: (BuildContext context) => ShopLoginCubit(),
      child: BlocConsumer<ShopLoginCubit, ShopLoginStates>(
        listener: (context, state){
          if(state is ShopLoginSuccessState){
            if(state.loginModel.status){
              print(state.loginModel.message);
              print(state.loginModel.data.token);

              CacheHelper.saveData(key: 'token', value: state.loginModel.data.token).then((value) {
                navigateAndFinish(context, ShopLayout());
              });
            }else{
              print(state.loginModel.message);
              showToast(
                  text: state.loginModel.message,
                  state: ToastStates.ERROR);
            }
          }
        },
        builder: (context, state){
          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'LOGIN',
                          style: Theme.of(context).textTheme.headlineLarge?.copyWith(color: Colors.black),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          'Login now to browse our hot offers',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(
                          height: 30.0,
                        ),
                        defaultFormField(
                          controller: emailController ,
                          type: TextInputType.emailAddress,
                          validate: (String? value){
                            if(value!.isEmpty){
                              return 'please enter your email address';
                            }
                          },
                          label: 'Email Address',
                          prefix: Icons.email_outlined,
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        defaultFormField(
                          controller: passwordController ,
                          type: TextInputType.visiblePassword,
                          suffix: ShopLoginCubit.get(context).suffix,
                          onFieldSubmitted: (value){
                            if(formKey.currentState!.validate()){
                              ShopLoginCubit.get(context).userLogin(email: emailController.text, password: passwordController.text,);
                            };
                          },
                          isPassword: ShopLoginCubit.get(context).isPassword,
                          //suffixPressed: (){},
                          onSuffixPressed: (){
                            ShopLoginCubit.get(context).changePasswordVisibility();
                          },
                          validate: (String? value){
                            if(value!.isEmpty){
                              return 'password is too short';
                            }
                          },
                          label: 'Password',
                          prefix: Icons.lock_outline,
                        ),
                        SizedBox(
                          height: 30.0,
                        ),
                        (state is ShopLoginLoadingState)?Center(child: CircularProgressIndicator(),):defaultButton(
                          text: 'Login',
                          isUpperCase: true,
                          onPressed:(){
                            if(formKey.currentState!.validate()){
                              ShopLoginCubit.get(context).userLogin(email: emailController.text, password: passwordController.text,);
                            };
                          },
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Don\'t have an account?'),
                            defaultTextButton(
                                Function: (){navigateTo(context, ShopRegisterScreen());},
                                text: 'register'),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
