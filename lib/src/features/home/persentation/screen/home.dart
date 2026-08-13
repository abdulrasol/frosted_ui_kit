import 'package:flutter/material.dart';
import 'package:starter/src/features/auth/presentation/screen/auth_screen.dart';
import 'package:starter/src/shared/widgets/base_widget.dart';
import 'package:starter/src/shared/widgets/buttons.dart';

class Home extends StatelessWidget with Buttons {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
      title: 'Home',
      actions: [
        cricleButton(
          context: context,
          icon: Icons.login,
          onPressed: () {
            Navigator.push(context, MaterialPageRoute<void>(builder: (context) => AuthScreen()));
          },
        ),
      ],
      child: Placeholder(),
    );
  }
}
