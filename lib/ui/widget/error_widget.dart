import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedex/blocs/pokemon/bloc/pokemon_bloc.dart';

class MyErrorWidget extends StatelessWidget {
  final String? message;
  const MyErrorWidget({
    super.key,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          "assets/images/sad-pickachu.png",
          color: Colors.amber.shade600,
        ),
        message != null
            ? Text(message!,
                style: Theme.of(context)
                    .textTheme
                    .headlineLarge!
                    .copyWith(color: Theme.of(context).disabledColor))
            : const SizedBox(),
        const SizedBox(height: 20),
        _retryButton(context),
      ],
    );
  }

  Widget _retryButton(BuildContext context) => IntrinsicWidth(
        child: GestureDetector(
          onTap: () => BlocProvider.of<PokemonBloc>(context).fetchInitialData(),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(),
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(CupertinoIcons.refresh),
                const SizedBox(width: 10),
                Text(
                  "refresh",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
          ),
        ),
      );
}
