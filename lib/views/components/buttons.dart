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
