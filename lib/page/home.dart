import 'package:flutter/material.dart';
import 'package:sprinkle/SprinkleExtension.dart';
import 'package:using_websocket/manager.dart/state.dart';


class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: Container(
            margin: EdgeInsets.only(left: 25),
            child: Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
        actions: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 25),
            child: Icon(Icons.favorite_border),
          )
        ],
      ),
      backgroundColor: Colors.black,
      body: LayoutStarts(),
    );
  }
}

class LayoutStarts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        CarDetailsAnimation(),
        CustomBottomSheet(),
        // RentButton(),
      ],
    );
  }
}

// class RentButton extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Align(
//       alignment: Alignment.bottomRight,
//       child: SizedBox(
//         width: 200,
//         child: FlatButton(
//           onPressed: () {},
//           child: Text(
//             "Rent Car",
//             style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 18,
//                 letterSpacing: 1.4,
//                 fontFamily: "arial"),
//           ),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.only(topLeft: Radius.circular(35)),
//           ),
//           color: Colors.black,
//           padding: EdgeInsets.all(25),
//         ),
//       ),
//     );
//   }
// }

class CarDetailsAnimation extends StatefulWidget {
  @override
  _CarDetailsAnimationState createState() => _CarDetailsAnimationState();
}

class _CarDetailsAnimationState extends State<CarDetailsAnimation>
    with TickerProviderStateMixin {
  AnimationController fadeController;
  AnimationController scaleController;

  Animation fadeAnimation;
  Animation scaleAnimation;

  @override
  void initState() {
    super.initState();

    fadeController =
        AnimationController(duration: Duration(milliseconds: 180), vsync: this);

    scaleController =
        AnimationController(duration: Duration(milliseconds: 350), vsync: this);

    fadeAnimation = Tween(begin: 0.0, end: 1.0).animate(fadeController);
    scaleAnimation = Tween(begin: 0.8, end: 1.0).animate(CurvedAnimation(
      parent: scaleController,
      curve: Curves.easeInOut,
      reverseCurve: Curves.easeInOut,
    ));
  }

  forward() {
    scaleController.forward();
    fadeController.forward();
  }

  reverse() {
    scaleController.reverse();
    fadeController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final manager = context.fetch<StateBloc>();

    return StreamBuilder<Object>(
        initialData: StateProvider().isAnimating,
        stream: manager.animationStatus,
        builder: (context, snapshot) {
          snapshot.data ? forward() : reverse();
          return ScaleTransition(
            scale: scaleAnimation,
            child: FadeTransition(
              opacity: fadeAnimation,
              child: CarDetails(),
            ),
          );
        });
  }
}

class CarDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(left: 30),
          child: _carTitle(),
        ),
        Container(
          width: double.infinity,
          child: CarCarousel(),
        )
      ],
    ));
  }

  _carTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
              style: TextStyle(color: Colors.white, fontSize: 38),
              children: [
                TextSpan(text: "Mitshibishi"),
                TextSpan(text: "\n"),
                TextSpan(
                    text: "Pajero",
                    style: TextStyle(fontWeight: FontWeight.w700)),
              ]),
        ),
        SizedBox(height: 10),
        RichText(
          text: TextSpan(style: TextStyle(fontSize: 16), children: [
            TextSpan(
                text: "10\$",
                style: TextStyle(color: Colors.grey[20])),
            TextSpan(
              text: " / day",
              style: TextStyle(color: Colors.grey),
            )
          ]),
        ),
      ],
    );
  }
}

class CarCarousel extends StatefulWidget {
  @override
  _CarCarouselState createState() => _CarCarouselState();
}

class _CarCarouselState extends State<CarCarousel> {
  

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
  
        ],
      ),
    );
  }
}

class CustomBottomSheet extends StatefulWidget {
  @override
  _CustomBottomSheetState createState() => _CustomBottomSheetState();
}

class _CustomBottomSheetState extends State<CustomBottomSheet>
    with SingleTickerProviderStateMixin {
  double sheetTop = 400;
  double minSheetTop = 30;

  Animation<double> animation;
  AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        duration: const Duration(milliseconds: 200), vsync: this);
    animation = Tween<double>(begin: sheetTop, end: minSheetTop)
        .animate(CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOut,
      reverseCurve: Curves.easeInOut,
    ))
          ..addListener(() {
            setState(() {});
          });
  }

  forwardAnimation() {
    final manager = context.fetch<StateBloc>();
    controller.forward();
    manager.toggleAnimation();
  }

  reverseAnimation() {
    final manager = context.fetch<StateBloc>();
    controller.reverse();
    manager.toggleAnimation();
  }

  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: animation.value,
      left: 0,
      child: GestureDetector(
        onTap: () {
           controller.isCompleted ? reverseAnimation() : forwardAnimation();
        },
        onVerticalDragEnd: (DragEndDetails dragEndDetails) {
          //upward drag
          if (dragEndDetails.primaryVelocity < 0.0) {
            forwardAnimation();
            controller.forward();
          } else if (dragEndDetails.primaryVelocity > 0.0) {
            //downward drag
            reverseAnimation();
          } else {
            return;
          }
        },
        child: SheetContainer(),
      ),
    );
  }
}

class SheetContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double sheetItemHeight = 110;
    return Container(
      padding: EdgeInsets.only(top: 25),
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
          color: Color(0xfff1f1f1)),
      child: Column(
        children: <Widget>[
          drawerHandle(),
          Expanded(
            flex: 1,
            child: ListView(
              children: <Widget>[
                offerDetails(sheetItemHeight),
                specifications(sheetItemHeight),
                features(sheetItemHeight),
                SizedBox(height: 220),
              ],
            ),
          )
        ],
      ),
    );
  }

  drawerHandle() {
    return Container(
      margin: EdgeInsets.only(bottom: 25),
      height: 3,
      width: 65,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15), color: Color(0xffd9dbdb)),
    );
  }

  specifications(double sheetItemHeight) {
    return Container(
      padding: EdgeInsets.only(top: 15, left: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Specifications",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 15),
            height: sheetItemHeight,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 3,
              itemBuilder: (context, index) {
                return Text('hi');
              },
            ),
          )
        ],
      ),
    );
  }

  features(double sheetItemHeight) {
    return Container(
      padding: EdgeInsets.only(top: 15, left: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Features",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }

  offerDetails(double sheetItemHeight) {
    return Container(
      padding: EdgeInsets.only(top: 15, left: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Offer Details",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}
