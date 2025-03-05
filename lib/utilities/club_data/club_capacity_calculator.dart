import 'dart:math';
import 'package:nightview/models/clubs/club_data.dart';
import 'package:nightview/utilities/club_data/club_opening_hours_formatter.dart';

class ClubCapacityCalculator {
  static double displayCalculatedPercentageOfCapacity(ClubData club) {
    return calculateCurrentCapacityPercent(club);
  }

  static double calculateCurrentCapacityPercent(ClubData club) {
    double percentOfCapacity =
        club.visitors / club.totalPossibleAmountOfVisitors;

    if (percentOfCapacity <= 0.10 && ClubOpeningHoursFormatter.isClubOpen(club)) {
      final Random random = Random(42);
      percentOfCapacity =
          (10 + random.nextInt(7)) / 100; // set to between 10% and 16%)
    }
    if (percentOfCapacity > 0.95) {
      percentOfCapacity = 0.95; // Cap at 95%
    }
    if (!ClubOpeningHoursFormatter.isClubOpen(club)) {
      percentOfCapacity = 0;
    }// TODO Figure out exact time. (if open at 18 and is 17 still say 0)
    return percentOfCapacity;
  }

  double getDecimalValue({required int amount, required int fullAmount}) {
    double value = amount / fullAmount;
    if (value < 0.01) return 0.01;
    if (value > 1.0) return 1.0;
    return value;
  }

  int getPercentValue({required int amount, required int fullAmount}) {
    return (amount / fullAmount * 100).round();
  }
}
