final class AppRoutes {
  static const intro = '/';
  static const gallery = '/gallery';
  static const addPhoto = '/add-photo';
  static const photoDetail = '/photo-detail/:id';

  static String photoDetailPath(String id) => '/photo-detail/$id';
}
