import 'package:flutter/material.dart';
import 'package:pokedex/extensions/capitalize.dart';
import 'package:pokedex/extensions/pokemon_id_formatter.dart';
import 'package:pokedex/models/pokemon.dart';
import 'package:pokedex/ui/widget/favourite_button.dart';
import 'package:pokedex/ui/widget/pokemon_type_widget.dart';
import 'package:pokedex/ui/widget/stats_indicator.dart';
import 'package:pokedex/utils/map_card_color.dart';
import 'package:pokedex/utils/map_type_icon.dart';

class PokemonDetailsSheet extends StatefulWidget {
  final Pokemon pokemon;

  const PokemonDetailsSheet({Key? key, required this.pokemon})
      : super(key: key);

  @override
  PokemonDetailsSheetState createState() => PokemonDetailsSheetState();
}

class PokemonDetailsSheetState extends State<PokemonDetailsSheet>
    with SingleTickerProviderStateMixin {
  late ScrollController _scrollController;
  late AnimationController _animationController;
  late Animation<double> _topAnimation;
  late Animation<double> _scaleAnimation;
  bool _isScrolled = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _topAnimation = Tween<double>(begin: 15, end: -5).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0, end: 2.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    setState(() {
      _isScrolled = _scrollController.position.pixels > 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: _isScrolled ? 280 : 330,
            child: Stack(
              children: [
                _backGroundHeder(context),
                _pokeBall(),
                _pokemonImage(),
                _favouriteButton(),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: [_pokemonDetails()],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _pokeBall() => AnimatedPositioned(
        duration: const Duration(milliseconds: 500),
        top: _isScrolled ? -200 : 135,
        left: 0,
        right: 0,
        child: Image.asset(
          "assets/images/pokeball.png",
          width: 200,
          height: 200,
          color: widget.pokemon.color.withOpacity(0.5),
        ),
      );

  Widget _pokemonImage() => AnimatedPositioned(
        duration: const Duration(milliseconds: 500),
        top: _isScrolled ? -20 : _topAnimation.value,
        right: 0,
        left: 0,
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            final scale = _scaleAnimation.value;
            return Transform.scale(
              scale: scale,
              child: Image.memory(
                widget.pokemon.image!,
              ),
            );
          },
        ),
      );

  Widget _backGroundHeder(BuildContext context) => Container(
        height: 240,
        decoration: BoxDecoration(
          color: widget.pokemon.color,
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              widget.pokemon.color,
              widget.pokemon.color.withOpacity(0.9),
              widget.pokemon.color.withOpacity(0.8),
              widget.pokemon.color.withOpacity(0.6),
              widget.pokemon.color.withOpacity(0.4),
              widget.pokemon.color.withOpacity(0.2),
            ],
          ),
          borderRadius:
              const BorderRadius.only(bottomLeft: Radius.circular(50)),
        ),
        child: Stack(
          children: [
            _typeIcon(),
            _nameAndIndex(context),
          ],
        ),
      );

  Widget _typeIcon() => Positioned(
        right: -50,
        child: Text(
          setTypeIcon(widget.pokemon.types.first),
          style: TextStyle(
            fontSize: 180,
            fontFamily: "PokeGoTypes",
            color: setTypeColor(widget.pokemon.types.first).withOpacity(0.7),
          ),
        ),
      );

  Widget _nameAndIndex(BuildContext context) => Positioned(
        top: 10,
        right: 0,
        left: 0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              widget.pokemon.name.capitalize(),
              style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                  ),
            ),
            Text(
              widget.pokemon.id.toString().pokemonIdFormatter(),
              style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade200,
                  ),
            ),
          ],
        ),
      );

  Widget _favouriteButton() => Positioned(
        top: 5,
        left: 10,
        child: FavouriteButton(
          pokemon: widget.pokemon,
          color: Colors.black54,
        ),
      );

  Widget _ability() => widget.pokemon.ability != null
      ? Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Text(
            widget.pokemon.ability!,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        )
      : const SizedBox();

  Widget _pokemonDetails() => Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            _pokemonTypes(),
            _ability(),
            _stats(),
          ],
        ),
      );
  Widget _pokemonTypes() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: List.generate(widget.pokemon.types.length,
            (index) => PokemonTypeWidget(type: widget.pokemon.types[index])),
      );

  Widget _stats() => Padding(
        padding: const EdgeInsets.only(top: 12.0, bottom: 100),
        child: Column(
          children: [
            Text(
              "STATS",
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Colors.black54,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const Divider(
              thickness: 0.4,
              indent: 8,
              endIndent: 8,
            ),
            StatsIndicator(
                value: widget.pokemon.stats.hp,
                label: "hp",
                color: widget.pokemon.color),
            StatsIndicator(
                value: widget.pokemon.stats.attack,
                label: "atk",
                color: widget.pokemon.color),
            StatsIndicator(
                value: widget.pokemon.stats.defense,
                label: "def",
                color: widget.pokemon.color),
            StatsIndicator(
                value: widget.pokemon.stats.specialAttack,
                label: "satk",
                color: widget.pokemon.color),
            StatsIndicator(
                value: widget.pokemon.stats.specialDefense,
                label: "sdef",
                color: widget.pokemon.color),
          ],
        ),
      );
}
