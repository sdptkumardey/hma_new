class AssociationData {
  final String profileTitle;
  final String profileContent;
  final String foundationTitle;
  final String foundationContent;
  final String historyTitle;
  final String historyContent;

  AssociationData({
    required this.profileTitle,
    required this.profileContent,
    required this.foundationTitle,
    required this.foundationContent,
    required this.historyTitle,
    required this.historyContent,
  });

  factory AssociationData.fromJson(Map<String, dynamic> json) {
    return AssociationData(
      profileTitle: json['profile_title'] ?? '',
      profileContent: json['profile_content'] ?? '',
      foundationTitle: json['foundation_title'] ?? '',
      foundationContent: json['foundation_content'] ?? '',
      historyTitle: json['history_title'] ?? '',
      historyContent: json['history_content'] ?? '',
    );
  }
}