import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  final String? message;
  final double? size;

  const LoadingIndicator({
    super.key,
    this.message,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          message != null
              ? Text(
                  message!,
                  style: Theme.of(context).textTheme.labelMedium,
                )
              : const SizedBox(height: 20),
          Image.asset(
            "assets/images/loading-pokeball.gif",
            color: Colors.grey.shade400,
            width: size ?? 130,
            height: size ?? 130,
          ),
        ],
      ),
    );
  }
}
