import 'package:flutter/material.dart';
import 'package:skeleton_animation/skeleton_animation.dart';

Widget imageError(BuildContext context, Object error, StackTrace? stackTrace) {
  return const Icon(Icons.image_not_supported, color: Colors.grey);
}

Widget imageOnLoad(BuildContext context, Widget child, ImageChunkEvent? stackTrace) {
  if(stackTrace == null){
    return child;
  }
  return Skeleton(
    width: double.infinity,
    height: double.infinity,
    borderRadius: BorderRadius.circular(7.0),
  );
}

