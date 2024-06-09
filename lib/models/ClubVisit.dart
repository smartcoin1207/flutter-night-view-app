class ClubVisit {
  String userId;
  String clubId;
  int visitCount;

  ClubVisit({
    required this.userId,
    required this.clubId,
    required this.visitCount,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'clubId': clubId,
      'visitCount': visitCount,
    };
  }

  static ClubVisit fromMap(Map<String, dynamic> map) {
    return ClubVisit(
      userId: map['userId'],
      clubId: map['clubId'],
      visitCount: map['visitCount'],
    );
  }
}
