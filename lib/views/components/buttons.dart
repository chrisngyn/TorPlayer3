import 'package:flutter/material.dart';

ElevatedButton elevatedButton({
  required String text,
  required Function() onPressed,
  disable = false,
}) {
  return ElevatedButton(
    onPressed: disable ? null : onPressed,
    child: Text(text),
  );
}

class LoadingElevatedButton extends StatefulWidget {
  const LoadingElevatedButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.disable = false,
    this.icon,
  });

  final String text;
  final Future<void> Function() onPressed;
  final bool disable;
  final IconData? icon;

  @override
  State<LoadingElevatedButton> createState() => _LoadingElevatedButtonState();
}

class _LoadingElevatedButtonState extends State<LoadingElevatedButton> {
  bool _loading = false;

  Future<void> _onPressed() async {
    setState(() {
      _loading = true;
    });

    try {
      await widget.onPressed();
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: widget.disable ? null : _onPressed,
      icon: _loading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(),
            )
          : widget.icon != null
              ? Icon(widget.icon)
              : const SizedBox(),
      label: Text(widget.text),
    );
  }
}
