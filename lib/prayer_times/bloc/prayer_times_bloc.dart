import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nedaa_test_modules/prayer_times/models/prayer_times.dart';
import 'package:nedaa_test_modules/prayer_times/repositories/prayer_times_repository.dart';
import 'package:nedaa_test_modules/prayer_times/user_location.dart';
import 'package:nedaa_test_modules/prayer_times/calculation_method.dart';

class PrayerTimesBloc extends Bloc<PrayerTimesEvent, PrayerTimesState> {
  PrayerTimesBloc(this.prayerTimesRepository)
      : super(
          PrayerTimesState(),
        ) {
    on<FetchPrayerTimesEvent>((event, emit) async {
      await _fetchPrayerTimes(event, emit);
    });
    on<CleanFetchPrayerTimesEvent>((event, emit) async {
      await prayerTimesRepository.cleanCache();
      await _fetchPrayerTimes(event, emit);
    });
  }

  Future<void> _fetchPrayerTimes(event, emit) async {
    try {
      if (event.location.location == null &&
          (event.location.country == null || event.location.city == null)) {
        return;
      }
      var currentPrayerTimesState =
          await prayerTimesRepository.getCurrentPrayerTimesState(
        event.location,
        event.method,
        event.timezone,
      );
      emit(PrayerTimesState(
        todayPrayerTimes: currentPrayerTimesState.today,
        tomorrowPrayerTimes: currentPrayerTimesState.tomorrow,
        yesterdayPrayerTimes: currentPrayerTimesState.yesterday,
        tenDaysPrayerTimes: currentPrayerTimesState.tenDays,
      ));
    } catch (e, stackTrace) {
      debugPrint(e.toString());
      debugPrintStack(stackTrace: stackTrace);
      // TODO: use failed state to display error
      emit(FailedPrayerTimesState(
          "Failed to fetch prayer times: ${e.toString()}"));
    }
  }

  final PrayerTimesRepository prayerTimesRepository;
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
