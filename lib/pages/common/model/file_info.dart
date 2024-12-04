class FilesInfo {
  int? id;
  String? file, fileThumb;

  FilesInfo({
    this.id,
    this.file,
    this.fileThumb,
  });

  FilesInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    file = json['file'];
    fileThumb = json['fileThumb'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['file'] = file;
    data['fileThumb'] = fileThumb;
    return data;
  }
}
