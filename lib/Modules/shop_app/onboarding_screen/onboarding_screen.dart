import 'package:course_training/Modules/shop_app/login/shop_login_screen.dart';
import 'package:course_training/Shared/Components/components.dart';
import 'package:course_training/Shared/network/local/cache_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class BoardingModel{
  final String image;
  final String title;
  final String body;

  BoardingModel({
    required this.title,
    required this.image,
    required this.body,
  });
}


class OnBoardingScreen extends StatefulWidget {

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  var boardController = PageController();

  List<BoardingModel> boarding = [
    BoardingModel(
        title: 'On Board 1 Title',
        image: 'assets/images/on_board_img.jpg',
        body: 'On Board 1 Title',
    ),
    BoardingModel(
      title: 'On Board 2 Title',
      image: 'assets/images/on_board_img.jpg',
      body: 'On Board 2 Title',
    ),
    BoardingModel(
      title: 'On Board 3 Title',
      image: 'assets/images/on_board_img.jpg',
      body: 'On Board 3 Title',
    ),
  ];

  bool isLast = false;

  void submit(){
    CacheHelper.saveData(key: 'onBoarding', value: true,).then((value) {
      if(value){
        navigateAndFinish(context, ShopLoginScreen());
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          defaultTextButton(
              Function: submit,
              text: 'skip'),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
              physics: BouncingScrollPhysics(),
              controller: boardController,
              onPageChanged: (int index){
                if(index == boarding.length - 1){
                  setState(() {
                    isLast = true;
                  });
                  print('last');
                }else{
                  print('last');
                  setState(() {
                    isLast = false;
                  });
                }
              },
              itemBuilder: (context, index) => buildBoardingItem(boarding[index]),
              itemCount: boarding.length,
              ),
            ),
            const SizedBox(
              height: 40.0,
            ),
            Row(
              children: [
                SmoothPageIndicator(
                    controller: boardController,
                    count: boarding.length,
                    effect: ExpandingDotsEffect(
                      dotColor: Colors.grey,
                      dotHeight: 10,
                      expansionFactor: 4,
                      dotWidth: 10,
                      spacing: 5.0,
                      activeDotColor: Colors.deepOrange
                    ),
                ),
                Spacer(),
                FloatingActionButton(
                  shape: CircleBorder(),
                    onPressed: (){
                    if(isLast){
                      submit();
                    }else{
                      boardController.nextPage(duration: Duration(milliseconds: 750), curve: Curves.fastLinearToSlowEaseIn);
                    }
                    },
                  child: Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                  ),
                  backgroundColor: Colors.deepOrange,
                )
              ],
            )
          ],
        ),
      )
    );
  }

  Widget buildBoardingItem(BoardingModel model) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded(
          child: Image(image: AssetImage('${model.image}')),
      ),
      SizedBox(
        height: 30.0,
      ),
      Text(
        '${model.title}',
        style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold
        ),
      ),
      SizedBox(
        height: 15.0,
      ),
      Text(
        '${model.body}',
        style: TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      SizedBox(
        height: 15.0,
      ),
    ],
  );
}
