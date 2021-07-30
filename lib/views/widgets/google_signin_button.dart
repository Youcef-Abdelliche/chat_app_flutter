import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class GoogleSigninButton extends StatelessWidget {
  final Function press;
  const GoogleSigninButton({
    Key key,
    this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: press,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 40),
        padding: EdgeInsets.symmetric(vertical: 10),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            border: Border.all(color: Colors.grey.withOpacity(0.64)),
            borderRadius: BorderRadius.circular(30)),
        child: Row(
          children: [
            Expanded(
                child: Align(
              // alignment: Alignment.centerLeft,
              child: SvgPicture.asset("assets/icons/google.svg", height: 30),
            )),
            Expanded(
                flex: 3,
                child: Text(
                  "Continue with google",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ))
          ],
        ),
      ),
    );
  }
}
