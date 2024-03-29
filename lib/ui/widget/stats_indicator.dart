import 'package:flutter/material.dart';

class StatsIndicator extends StatelessWidget {
  final int value;
  final String label;
  final Color color;
  const StatsIndicator({
    super.key,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 60,
          child: Text(
            label.toUpperCase(),
            style: TextStyle(
              color: color,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 10),
        SizedBox(
          width: 44,
          child: Text(
            value.toString(),
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        _indicator(context),
      ],
    );
  }

  Widget _indicator(BuildContext context) => Expanded(
        child: LinearProgressIndicator(
            backgroundColor: Colors.grey.shade300,
            borderRadius: BorderRadiusDirectional.circular(16),
            minHeight: 14,
            value: value / 200,
            color: color),
      );
}
