import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  final String? message;
  final double? size;

  const LoadingIndicator({
    this.message,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          "assets/images/loading-pokeball.gif",
          color: Colors.grey.shade400,
          width: size ?? 100,
          height: size ?? 100,
        ),
        message != null
            ? Text(
                message!,
                style: Theme.of(context).textTheme.labelSmall,
              )
            : const SizedBox(height: 20),
      ],
    );
  }
}
