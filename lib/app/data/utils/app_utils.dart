import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'logger.dart';

class AppUtils {
  static int convertTime(String duration) {
    RegExp regex = new RegExp(r'(\d+)');
    List<String> a =
    regex.allMatches(duration).map((e) => e.group(0)!).toList();

    if (duration.indexOf('M') >= 0 &&
        duration.indexOf('H') == -1 &&
        duration.indexOf('S') == -1) {
      a = ["0", a[0], "0"];
    }

    if (duration.indexOf('H') >= 0 && duration.indexOf('M') == -1) {
      a = [a[0], "0", a[1]];
    }
    if (duration.indexOf('H') >= 0 &&
        duration.indexOf('M') == -1 &&
        duration.indexOf('S') == -1) {
      a = [a[0], "0", "0"];
    }

    int seconds = 0;

    if (a.length == 3) {
      seconds = seconds + int.parse(a[0]) * 3600;
      seconds = seconds + int.parse(a[1]) * 60;
      seconds = seconds + int.parse(a[2]);
    }

    if (a.length == 2) {
      seconds = seconds + int.parse(a[0]) * 60;
      seconds = seconds + int.parse(a[1]);
    }

    if (a.length == 1) {
      seconds = seconds + int.parse(a[0]);
    }
    return seconds;
  }
}