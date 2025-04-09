import 'package:shared_preferences/shared_preferences.dart';
import 'package:seb_hackaton/utils/info/investment_info.dart';
import 'dart:convert';

class InvestmentDatabase {
  static const String _key = "investment_info";

  static Future<void> create(InvestmentInfo info) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(info.toJson());
    await prefs.setString(_key, jsonString);
  }

  static Future<InvestmentInfo?> read() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_key);
    if (jsonString == null) return null;
    final data = jsonDecode(jsonString);
    return InvestmentInfo.fromJson(data);
  }

  static Future<void> update(InvestmentInfo info) async {
    await create(info);
  }

  static Future<void> delete() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
