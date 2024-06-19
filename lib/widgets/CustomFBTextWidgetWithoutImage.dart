import 'package:flutter/material.dart';
import '../utils/SizeConfig.dart';

class CustomFBTextWidgetWithoutImage extends StatelessWidget {
  

  const CustomFBTextWidgetWithoutImage({
    Key? key,
    required this.size,
    this.color,
    this.text,
    
    required this.callback,
  }) : super(key: key);

  final Size size;
  final Color? color;
  final String? text;
  final VoidCallback callback;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: callback,

      child: Container(
          height: size.height * 0.27,
          width: size.width * 0.27,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(SizeConfig.height(10)),
          ),
          child: Stack(
            children: <Widget>[
              
              Positioned(
                top: 0,
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  decoration: BoxDecoration(
                    //color: Colors.red,
                    borderRadius: BorderRadius.circular(
                      SizeConfig.height(10),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      text!,
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              ],
          )),
    );
  }
}
