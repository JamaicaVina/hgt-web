import 'package:my_app/consts/consts.dart';

SnackBar customSnackBar(message) => SnackBar(
      content: Text(
        message,
      ),
    );

void showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    customSnackBar(message),
  );
}
