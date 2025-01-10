import 'dart:developer';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:csv/csv.dart';
import 'package:flutter/cupertino.dart';
import 'package:iterasi1/model/activity.dart';
import 'package:iterasi1/model/day.dart';
import 'package:iterasi1/model/itinerary.dart';

class ItineraryProvider extends ChangeNotifier {
  late Itinerary _itinerary;
  late Itinerary initialItinerary;
  Itinerary get itinerary => _itinerary;

  bool get isDataChanged =>
      _itinerary.toJsonString() != initialItinerary.toJsonString();

  void initItinerary(Itinerary newItinerary) {
    _itinerary = newItinerary.copy();
    initialItinerary = newItinerary.copy();
    notifyListeners();
  }

  void setNewItineraryTitle(String newTitle) {
    _itinerary.title = newTitle;
  }

  void addDay(Day newDay) {
    try {
      _itinerary.days = [..._itinerary.days, newDay];
    } catch (e) {
      log("$e", name: 'qqq');
    }
    notifyListeners();
  }

  void initializeDays(List<DateTime> dates) {
    List<DateTime> sortedNewDates = dates..sort();

    List<DateTime> currentDates =
        _itinerary.days.map((e) => e.getDatetime()).toList();

    List<Day> finalDays = [];

    var i = 0;
    var j = 0;
    // Push semua currentDates yang gak ada di sortedNewDates
    while (i < sortedNewDates.length && j < currentDates.length) {
      if (currentDates[j].isBefore(sortedNewDates[i])) {
        j++;
      } else if (currentDates[j].isAfter(sortedNewDates[i]))
        finalDays.add(Day.from(sortedNewDates[i++]));
      else {
        finalDays.add(_itinerary.days[j].copy());
        j++;
        i++;
      }
    }
    while (i < sortedNewDates.length) {
      finalDays.add(Day.from(sortedNewDates[i++]));
    }

    _itinerary.days = finalDays;
    print('final : ${_itinerary.days[0].date}');

    notifyListeners();
  }

  List<Day> getDateTime() {
    return _itinerary.days;
  }

  // String convertDateTimeToString({required DateTime dateTime}) =>
  //     "${dateTime.day}/" "${dateTime.month}/" "${dateTime.year}";

  void updateActivity({
    required int updatedDayIndex,
    required int updatedActivityIndex,
    required Activity newActivity,
  }) {
    _itinerary = itinerary.copy(
        days: itinerary.days.mapIndexed((index, day) {
      if (index == updatedDayIndex) {
        return day.copy(
            activities: day.activities.mapIndexed((index, activity) {
          if (index == updatedActivityIndex) {
            return newActivity;
          }
          return activity;
        }).toList());
      }
      return day;
    }).toList());
    notifyListeners();
  }

  void insertNewActivity(
      {required List<Activity> activities, required Activity newActivity}) {
    print('new activity :${newActivity.endDateTime}');
    activities.add(newActivity);
    notifyListeners();
  }

  void removeActivity(
      {required List<Activity> activities, required int removedHashCode}) {
    activities.removeWhere((element) => element.hashCode == removedHashCode);
    notifyListeners();
  }

  void addPhotoActivity(
      {required Activity activity, required String pathImage}) {
    activity.images!.add(pathImage);
    log("ADD IMAGE $pathImage");
    notifyListeners();
  }

  void removePhotoActivity({
    required Activity activity,
    required String pathImage,
  }) {
    activity.removedImages!.add(pathImage);
    log("ADD TO REMOVED IMAGE $pathImage");
    log("removed images" + activity.removedImages.toString());
    notifyListeners();
  }

  void returnPhotoActivity({
    required Activity activity,
    required String pathImage,
  }) {
    activity.removedImages!.remove(pathImage);
    log("RETURN IMAGE $pathImage");
    log("removed images${activity.removedImages}");
    notifyListeners();
  }

  void cleanPhotoActivity({
    required Activity activity,
  }) {
    activity.images = [];
    log("CLEANING");
    notifyListeners();
  }

  Future<List<Activity>> getSortedActivity(List<Activity> activities) async {
    return activities
      ..sort((a, b) {
        return a.startDateTime.compareTo(b.startDateTime);
      });
  }

  List<String> getImage(Activity activity) {
    return activity.images!;
  }

  Future<List<Itinerary>> parseCsvToItinerary(
      String asal, String tujuan, int jumlahHari) async {
    // Membaca file CSV dari perangkat
    log('message');
    File file = File('assets/pepekk.csv');
    if (await file.exists()) {
      log('File ditemukan cokkkk');
    } else {
      log('File tidak ditemukan di path: prepekkk');
    }
    String csvString = await file.readAsString();

    // Parse CSV
    List<List<dynamic>> rows = const CsvToListConverter().convert(csvString);

    late Itinerary recommendation1;
    late Itinerary recommendation2;

    // Menentukan indeks kolom berdasarkan jumlahHari
    int startRowIndex =
        (jumlahHari - 1) * 2 + 2; // Logika untuk memilih row yang sesuai

    // Loop melalui baris-baris data CSV
    for (var row in rows) {
      String lokasiBerangkat = row[0] ?? ''; // Lokasi Berangkat
      String lokasiTujuan = row[1] ?? ''; // Lokasi Tujuan

      // Pastikan kecocokan antara asal dan tujuan
      if (lokasiBerangkat == asal && lokasiTujuan == tujuan) {
        // Menentukan hasil itinerary yang sesuai berdasarkan jumlahHari
        String hasilItinerary1 = row[startRowIndex] ??
            ''; // Hasil rekomendasi 1 (row[2], row[4], row[6])
        String hasilItinerary2 = row[startRowIndex + 1] ??
            ''; // Hasil rekomendasi 2 (row[3], row[5], row[7])

        // Pisahkan hasil itinerary menjadi List<Day>
        var days1 = splitItineraryToDays(hasilItinerary1);
        var days2 = splitItineraryToDays(hasilItinerary2);

        // Simpan hasil rekomendasi ke dalam list yang sesuai
        recommendation1 = Itinerary(
          title: 'Rekomendasi 1',
          dateModified: DateTime.now().toString(),
          days: days1,
        );
        recommendation2 = Itinerary(
          title: 'Rekomendasi 2',
          dateModified: DateTime.now().toString(),
          days: days2,
        );
      }
    }

    List<Itinerary> result = [recommendation1, recommendation2];

    // Mengembalikan hasil rekomendasi 1 dan rekomendasi 2 dalam bentuk List<Day>
    return result;
  }

  List<Day> splitItineraryToDays(String itinerary) {
    List<Day> days = [];

    final dayRegex = RegExp(
        r'HARI KE-(\d+)[\s\S]+?((?:Judul: [\s\S]+?Estimasi Selesai: [\s\S]+?)+)',
        caseSensitive: false);
    final matches = dayRegex.allMatches(itinerary);

    for (final match in matches) {
      final dayActivitiesText = match.group(2) ?? '';
      final activityRegex = RegExp(
        r'Judul: (.?)\nMulai: (.?)\nEstimasi Selesai: (.?)\nTempat: (.?)\nInformasi Tambahan: (.*?)\n',
        caseSensitive: false,
      );

      List<Activity> activities = [];
      final activityMatches = activityRegex.allMatches(dayActivitiesText);
      for (final activityMatch in activityMatches) {
        final activityName = activityMatch.group(1)?.trim() ?? '';
        final startActivityTime = activityMatch.group(2)?.trim() ?? '';
        final endActivityTime = activityMatch.group(3)?.trim() ?? '';
        final lokasi = activityMatch.group(4)?.trim() ?? '';
        final keterangan = activityMatch.group(5)?.trim() ?? '';

        Activity activity = Activity(
          activityName: activityName,
          startActivityTime: startActivityTime,
          endActivityTime: endActivityTime,
          lokasi: lokasi,
          keterangan: keterangan,
        );
        activities.add(activity);
      }

      String dayName = 'HARI KE-${days.length + 1}';
      days.add(Day(date: dayName, activities: activities));
    }

    return days;
  }
}
