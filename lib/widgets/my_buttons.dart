import 'package:flutter/material.dart';

class MyElevatedButton extends StatelessWidget {

  final String buttonText;
  final Function onPressHandler;

  MyElevatedButton(this.buttonText,this.onPressHandler);
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
              side: BorderSide(color: Colors.blue),
            )
        ),
        backgroundColor: MaterialStateProperty.all<Color>(Colors.blue[700]),
      ),
      onPressed: () => onPressHandler(),
      child: SizedBox(
        width: 107,
        height: 39,
        child: Center(
          child: Text(
            buttonText,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
class MyTextButton extends StatelessWidget {

  final String buttonText;
  final Function onPressHandler;

  MyTextButton(this.buttonText,this.onPressHandler);
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
              side: BorderSide(color: Colors.white),
            )
        ),
        backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
      ),
      onPressed: () => onPressHandler(),
      child: SizedBox(
        width: 107,
        height: 39,
        child: Center(
          child: Text(
            buttonText,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}