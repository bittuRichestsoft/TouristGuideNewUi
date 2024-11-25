import 'package:image_picker/image_picker.dart';

class ImageSelectionPojo {
  ImageSelectionPojo({
    required this.file,
    required this.title,
  });

  List<XFile> file;
  String title;

  factory ImageSelectionPojo.fromJson(Map<String, dynamic> json) =>
      ImageSelectionPojo(
        file: json["file"],
        title: json["title"],
      );

  Map<String, dynamic> toJson() => {
    "file": file,
    "title": title,
  };
}