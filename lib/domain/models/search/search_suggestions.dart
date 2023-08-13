class SearchSuggestions {
  final String result;
  final String redirectUrl;
  final String source;

  SearchSuggestions({
    required this.result,
    required this.redirectUrl,
    this.source = "google",
  });
}
