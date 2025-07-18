enum Genres {
  thriller,
  crime,
  action,
  sports,
  mystic,
  comedy,
  drama,
  romance,
  sciFi,
  fantasy,
  documentary,
  animation,
  adventure,
  horror,
  musical,
}

class Demographics {
  const Demographics({
    required this.fullName,
    required this.bioText,
    required this.userName,
    required this.genres,
    required this.avatarUrl,
  });

  final String fullName;
  final String userName;
  final String bioText;
  final Genres genres;
  final String avatarUrl;
}
