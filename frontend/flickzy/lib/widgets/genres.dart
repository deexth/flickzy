import 'package:flickzy/data/models.dart';
import 'package:flutter/material.dart';

class GenreList extends StatefulWidget {
  const GenreList({super.key, required this.accountGenres});

  final List<Demographics> accountGenres;

  @override
  State<StatefulWidget> createState() {
    return _GenreList();
  }
}

class _GenreList extends State<GenreList> {
  final Set<String> selectedGenres = {};

  @override
  Widget build(BuildContext context) {
    final accountGenres = widget.accountGenres;
    // Assuming Demographics has a 'name' property of type String
    final genreNames =
        accountGenres.map((demographic) => demographic.genres.name).toList();
    return SizedBox(
      width: double.infinity,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.all(8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: ChoiceChip(
                label: Text('For You'),
                selected: selectedGenres.contains('For You'),
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      selectedGenres.add('For You');
                    } else {
                      selectedGenres.remove('For You');
                    }
                  });
                },
              ),
            ),
            for (String genre in genreNames)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: ChoiceChip(
                  label: Text(genre),
                  selected: selectedGenres.contains(genre),
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        selectedGenres.add(genre);
                      } else {
                        selectedGenres.remove(genre);
                      }
                    });
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
