class MediaTypePojo {
  int id;
  String mediaType;
  String mediaUrl;
  MediaTypePojo(
      {this.id = 0, required this.mediaUrl, this.mediaType = "image"});
}
