class PostList {
  int? id;
  String? coverImagePath;
  String? publishDate;
  int? colorThemeValue;
  String? caption;

  PostList(this.id, this.coverImagePath, this.publishDate, this.colorThemeValue,
      this.caption);

  PostList.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    coverImagePath = map['coverImagePath'];
    publishDate = map['publishDate'];
    caption = map['caption'];
  }
}
