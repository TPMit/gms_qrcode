
import 'package:flutter/material.dart';

class CustomDialogContainer extends StatefulWidget {
  final String title;
  final TextButton? textButton;
  final Widget child;
  final Function(String value)? onSubmitted;

  const CustomDialogContainer(
      {Key? key,
      required this.title,
      required this.child,
      this.textButton,
      this.onSubmitted})
      : super(key: key);

  @override
  _CustomDialogContainerState createState() => _CustomDialogContainerState();
}

class _CustomDialogContainerState extends State<CustomDialogContainer> {
  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  contentBox(context) {
    return Stack(
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width * 0.7,
          padding: const EdgeInsets.only(left: 20, top: 20, right: 20, bottom: 20),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: const [
                BoxShadow(
                    color: Colors.black, offset: Offset(0, 10), blurRadius: 10),
              ]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                widget.title,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                child: widget.child,
              ),
              const SizedBox(
                height: 22,
              ),
              null == widget.textButton
                  ? const SizedBox()
                  : Align(
                      alignment: Alignment.bottomRight,
                      child: widget.textButton,
                    ),
            ],
          ),
        ),
      ],
    );
  }
}
