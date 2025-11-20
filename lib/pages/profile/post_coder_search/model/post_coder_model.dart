class PostCoderModel {
  final String? summaryline;
  final String? addressline1;
  final String? addressline2;
  final String? posttown;
  final String? postcode;

  PostCoderModel({
    this.summaryline,
    this.addressline1,
    this.addressline2,
    this.posttown,
    this.postcode,
  });

  factory PostCoderModel.fromJson(Map<String, dynamic> json) {
    return PostCoderModel(
      summaryline: json['summaryline'],
      addressline1: json['addressline1'],
      addressline2: json['addressline2'],
      posttown: json['posttown'],
      postcode: json['postcode'],
    );
  }
}