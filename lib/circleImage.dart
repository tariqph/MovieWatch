
import 'package:flutter/cupertino.dart';

// ignore: camel_case_types
class circleImageNetwork extends StatelessWidget{

  final double radius;
  final String link;


  circleImageNetwork(this.radius,this.link);

  @override
  Widget build(BuildContext context) {
   return  Container(
        width: radius,
        height: radius,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
                fit: BoxFit.fill,
                image:NetworkImage(link)
      ),
        ),
   );
  }
}

// ignore: camel_case_types
class circleImageAsset extends StatelessWidget{

  final double radius;
  final String link;


  circleImageAsset(this.radius,this.link);

  @override
  Widget build(BuildContext context) {
    return  Container(
      width: radius,
      height: radius,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
            fit: BoxFit.fill,
            image:AssetImage(link)


        ),
      ),
    );
  }

}