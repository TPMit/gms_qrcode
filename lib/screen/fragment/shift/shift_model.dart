import 'dart:convert';
import 'package:http/http.dart' as http;

class Services {
  static const String url =
      'https://hris.tpm-facility.com/rest/shiftgms?idsite=';
  static Future<List<Shifts>> getShifts(String idsite) async {
    try {
      final response = await http.get(Uri.parse(url + idsite));
      if (200 == response.statusCode) {
        final List<Shifts> users = shiftsFromJson(response.body);
        return users;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }
}

class ModelSiteEmployees {
  static const String url =
      'https://hris.tpm-facility.com/rest/siteemployees?idsite=';
  static Future<List<Securities>> getSecurities(String idsite) async {
    try {
      final response = await http.get(Uri.parse(url + idsite));
      if (200 == response.statusCode) {
        final List<Securities> users = securitiesFromJson(response.body);
        return users;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }
}

class ModelShift {
  static const String url =
      'https://hris.tpm-facility.com/rest/listshift?pattern=';
  static Future<List<DetailShift>> getDetailShift(String pattern) async {
    try {
      final response = await http.get(Uri.parse(url + pattern));
      if (200 == response.statusCode) {
        final List<DetailShift> data = detailShiftFromJson(response.body);
        return data;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }
}

List<Shifts> shiftsFromJson(String str) =>
    List<Shifts>.from(json.decode(str).map((x) => Shifts.fromJson(x)));

String shiftsToJson(List<Shifts> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Shifts {
  Shifts({
    required this.nik,
    required this.adId,
    required this.name,
    required this.shiftPattern,
    required this.codeShift,
    required this.timeIn,
    required this.timeOut,
  });

  String nik;
  String adId;
  String name;
  String shiftPattern;
  String codeShift;
  String timeIn;
  String timeOut;

  factory Shifts.fromJson(Map<String, dynamic> json) => Shifts(
        nik: json["nik"],
        adId: json["ad_id"],
        name: json["name"],
        shiftPattern: json["shift_pattern"],
        codeShift: json["code_shift"],
        timeIn: json["time_in"],
        timeOut: json["time_out"],
      );

  Map<String, dynamic> toJson() => {
        "nik": nik,
        "ad_id": adId,
        "name": name,
        "shift_pattern": shiftPattern,
        "code_shift": codeShift,
        "time_in": timeIn,
        "time_out": timeOut,
      };
}

List<Securities> securitiesFromJson(String str) =>
    List<Securities>.from(json.decode(str).map((x) => Securities.fromJson(x)));

String securitiesToJson(List<Securities> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Securities {
  Securities({
    required this.nik,
    required this.name,
    required this.idPosition,
  });

  String nik;
  String name;
  String idPosition;

  factory Securities.fromJson(Map<String, dynamic> json) => Securities(
        nik: json["nik"],
        name: json["name"],
        idPosition: json["id_position"],
      );

  Map<String, dynamic> toJson() => {
        "nik": nik,
        "name": name,
        "id_position": idPosition,
      };
}

List<DetailShift> detailShiftFromJson(String str) => List<DetailShift>.from(
    json.decode(str).map((x) => DetailShift.fromJson(x)));

String detailShiftToJson(List<DetailShift> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DetailShift {
  DetailShift({
    required this.shiftId,
    required this.pattern,
    required this.shiftCode,
    required this.shift,
    required this.timeIn,
    required this.timeOut,
  });

  String shiftId;
  String pattern;
  String shiftCode;
  String shift;
  String timeIn;
  String timeOut;

  factory DetailShift.fromJson(Map<String, dynamic> json) => DetailShift(
        shiftId: json["shift_id"],
        pattern: json["pattern"],
        shiftCode: json["shift_code"],
        shift: json["shift"],
        timeIn: json["time_in"],
        timeOut: json["time_out"],
      );

  Map<String, dynamic> toJson() => {
        "shift_id": shiftId,
        "pattern": pattern,
        "shift_code": shiftCode,
        "shift": shift,
        "time_in": timeIn,
        "time_out": timeOut,
      };
}
