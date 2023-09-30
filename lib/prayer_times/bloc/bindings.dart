import 'package:get/get.dart';
import 'package:nedaa_test_modules/main.dart';
import 'package:nedaa_test_modules/prayer_times/bloc/prayer_times_getx.dart';
import 'package:nedaa_test_modules/prayer_times/calculation_method.dart';
import 'package:nedaa_test_modules/prayer_times/repositories/prayer_times_repository.dart';
import 'package:nedaa_test_modules/prayer_times/user_location.dart';

import '../../constants/default_timezone_calculation_method.dart';

class RootBinding implements Bindings {
  @override
  void dependencies() async{
   var prayerTimesRepository =
      await PrayerTimesRepository.newRepo(UserLocation(), CalculationMethod(4),'Asia/Riyadh');
      Get.put<PrayerTimesController>(PrayerTimesController( prayerTimesRepository));


  }
}