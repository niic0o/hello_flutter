/*
  Frases que serán traducidas, se deben incluir en objetos (clases) y luego llamarlas desde
  la pagina principal.
*/
// lib/app_locale.dart

mixin AppLocale {
  // Claves de traducción
  static const String home = 'home';
  static const String favorites = 'favorites';
  static const String addFavorite = 'add_favorite';
  static const String like = 'like';
  static const String next = 'next';
  static const String noFavorites = 'no_favorites';
  static const String changeLanguage = 'change_language';

  // Traducciones al inglés
  static const Map<String, dynamic> en = {
    home: 'Home',
    favorites: 'Favorites',
    addFavorite: 'Add your favorite word',
    like: 'Like',
    next: 'Next',
    noFavorites: 'No favorites yet.',
    changeLanguage: 'Change Language',
  };

  // Traducciones al español
  static const Map<String, dynamic> es = {
    home: 'Inicio',
    favorites: 'Favoritos',
    addFavorite: 'Agregá tu palabra favorita',
    like: 'Me gusta',
    next: 'Siguiente',
    noFavorites: 'Todavía no hay favoritos.',
    changeLanguage: 'Cambiar idioma',
  };
}