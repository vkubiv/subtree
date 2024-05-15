import 'package:flutter/widgets.dart';
import 'package:flutter_login/app.dart';
import 'package:flutter_login/domain_layer/services.dart';

void main() => runApp(const AppWidget(createServices: createServices));
