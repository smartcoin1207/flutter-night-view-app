
for (var entry in clubData.entries) {
String clubId = entry.key;
ClubData club = entry.value;

int visitors = 0;
int firstTimeVisitors = 0;
int returningVisitors = 0;
int regularVisitors = 0;
String ageOfVisitors = "";

for (var userEntry in userData.entries) {
String userId = userEntry.key;
UserData user = userEntry.value;

if (user.lastPositionTime != null &&
user.lastPositionTime.isAfter(timeThreshold) &&
locationHelper.userInClub(userData: user, clubData: club)) {
visitors++;

if (user.birthdayYear != null) {
int age = DateTime
    .now()
    .year - user.birthdayYear;
ageOfVisitors += "$age, ";
}

if (user.visitCount == 1) {
firstTimeVisitors++;
} else if (user.visitCount > 1 && user.visitCount < 5) {
returningVisitors++;
} else if (user.visitCount >= 5) {
regularVisitors++;
}
}
}

try {
await _firestore.collection('club_data').doc(clubId).update({
'visitors': visitors,
'firstTimeVisitors': firstTimeVisitors,
'returningVisitors': returningVisitors,
'regularVisitors': regularVisitors,
'ageOfVisitors': ageOfVisitors,
});
} catch (e) {
print("Failed to update club data for $clubId: $e");
}
}
}