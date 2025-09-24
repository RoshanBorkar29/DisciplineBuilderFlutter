import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_discplinebuilder/common/utils.dart';
import 'package:http/http.dart' as http;

T httpErrorHandle<T>({
  required http.Response response,
  required BuildContext context,
  required T Function() onSuccess,
}) {
  switch (response.statusCode) {
    case 200:
    case 201:
      return onSuccess();
    case 400:
      showSnackBar(context, jsonDecode(response.body)['msg']);
      break;
    case 500:
      showSnackBar(context, jsonDecode(response.body)['error']);
      break;
    default:
      showSnackBar(context, response.body);
  }
  throw Exception('HTTP error: ${response.statusCode}');
}