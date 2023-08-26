class SearchSuggestionsModel {
  final String result;
  final String redirectUrl;
  final String source;

  SearchSuggestionsModel({
    required this.result,
    required this.redirectUrl,
    this.source = "google",
  });
}
