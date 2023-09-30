import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:nedaa_test_modules/prayer_times/calculation_method.dart';
import 'package:nedaa_test_modules/prayer_times/models/prayer_times.dart';
import 'package:nedaa_test_modules/prayer_times/repositories/prayer_times_repository.dart';
import 'package:nedaa_test_modules/prayer_times/user_location.dart';

class PrayerTimesController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    print("Hello world");
   
  }
  final PrayerTimesRepository prayerTimesRepository;

  PrayerTimesController(this.prayerTimesRepository);

  Rx<PrayerTimesState> prayerTimesState = Rx<PrayerTimesState>(PrayerTimesState());

  Future<void> fetchPrayerTimes(UserLocation location, CalculationMethod method, String timezone, bool cleanCache) async {
    try {
      if (location.location == null && (location.country == null || location.city == null)) {
        return;
      }

      if (cleanCache) {
        // hi
        await prayerTimesRepository.cleanCache();
      }

      final currentPrayerTimesState = await prayerTimesRepository.getCurrentPrayerTimesState(
        location,
        method,
        timezone,
      );

      prayerTimesState.value = PrayerTimesState(
        todayPrayerTimes: currentPrayerTimesState.today,
        tomorrowPrayerTimes: currentPrayerTimesState.tomorrow,
        yesterdayPrayerTimes: currentPrayerTimesState.yesterday,
        tenDaysPrayerTimes: currentPrayerTimesState.tenDays,
      );
    } catch (e, stackTrace) {
      debugPrint(e.toString());
      debugPrintStack(stackTrace: stackTrace);
      // Handle the error, you can add error handling logic here.
    }
  }
}
class PrayerTimesState {
  DayPrayerTimes? todayPrayerTimes;
  DayPrayerTimes? tomorrowPrayerTimes;
  DayPrayerTimes? yesterdayPrayerTimes;
  List<DayPrayerTimes> tenDaysPrayerTimes;

  PrayerTimesState({
    this.todayPrayerTimes,
    this.tomorrowPrayerTimes,
    this.yesterdayPrayerTimes,
    this.tenDaysPrayerTimes = const [],
  });
}

class FailedPrayerTimesState extends PrayerTimesState {
  String error;

  FailedPrayerTimesState(this.error) : super();
}

class PrayerTimesEvent {}

class FetchPrayerTimesEvent extends PrayerTimesEvent {
  UserLocation location;
  CalculationMethod method;
  String timezone;

  FetchPrayerTimesEvent(this.location, this.method, this.timezone);
}

class CleanFetchPrayerTimesEvent extends PrayerTimesEvent {
  UserLocation location;
  CalculationMethod method;
  String timezone;

  CleanFetchPrayerTimesEvent(this.location, this.method, this.timezone);
}
