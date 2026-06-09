import 'package:flutter/material.dart';
import 'router.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const SgftpApp());
}

class SgftpApp extends StatelessWidget {
  const SgftpApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'SGFTP Mobile',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      routerConfig: appRouter,
    );
  }
}
