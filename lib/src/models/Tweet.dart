class TweetData {
  String? id;
  String? text;
  String? url;
  List<String> imgUrls;

  TweetData(
      {required this.id,
      required this.text,
      required this.url,
      required this.imgUrls});
}
