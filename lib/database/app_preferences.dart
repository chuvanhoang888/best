import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppPreferences{
  // Constants for Preference-Value's data-type
  static const String PREF_TYPE_BOOL = "BOOL";
  static const String PREF_TYPE_INTEGER = "INTEGER";
  static const String PREF_TYPE_DOUBLE = "DOUBLE";
  static const String PREF_TYPE_STRING = "STRING";
  static const String PREF_TYPE_LIST_STRING = "LIST_STRING";

  // Constants for Preference-Name
  static const String PREF_ACCESS_TOKEN = "ACCESS_TOKEN";
  static const String PREF_LIST_BUSINESS_NAME = "LIST_BUSINESS_NAME";
  static const String PREF_LIST_BUSINESS_TOKEN = "LIST_BUSINESS_TOKEN";
  static const String PREF_LIST_TENANT = "LIST_TENANT";

  // future requests, preference instance is already ready as we are using Singleton-Instance.
  Future? _isPreferenceInstanceReady;

  // Private variable for SharedPreferences
  SharedPreferences? _preferences;

  // Final static instance of class initialized by private constructor
  static final AppPreferences _instance = AppPreferences._internal();

  // Factory Constructor
  factory AppPreferences() => _instance;

  /// AppPreference Private Internal Constructor -> AppPreference
  /// @param->_
  /// @usage-> Initialize SharedPreference object and notify when operation is complete to future variable.
  AppPreferences._internal() {
    _isPreferenceInstanceReady = SharedPreferences.getInstance()
        .then((preferences) => _preferences = preferences);
  }

  // GETTER for isPreferenceReady future
  Future get isPreferenceReady => _isPreferenceInstanceReady!;

  //--------------------------------------------------- Public Preference Methods -------------------------------------------------------------

  Future<String> getAccessToken() async {
    String token = await _getPreference(prefName: PREF_ACCESS_TOKEN) ?? "";
    return token;
  }

  void _setPreference(
      {required String prefName,
      required dynamic prefValue,
      required String prefType}) {
    // Make switch for Preference Type i.e. Preference-Value's data-type
    switch (prefType) {
      // prefType is bool
      case PREF_TYPE_BOOL:
        {
          if (_preferences != null) {
            _preferences!.setBool(prefName, prefValue);
          }
          break;
        }
      // prefType is int
      case PREF_TYPE_INTEGER:
        {
          if (_preferences != null) {
            _preferences!.setInt(prefName, prefValue);
          }
          break;
        }
      // prefType is double
      case PREF_TYPE_DOUBLE:
        {
          if (_preferences != null) {
            _preferences!.setDouble(prefName, prefValue);
          }
          break;
        }
      // prefType is String
      case PREF_TYPE_STRING:
        {
          if (_preferences != null) {
            _preferences!.setString(prefName, prefValue);
          }
          break;
        }
      //prefType is List<String>
      case PREF_TYPE_LIST_STRING:
        {
          if (_preferences != null) {
            _preferences!.setStringList(prefName, prefValue);
          }
          break;
        }
    }
  }

  void setAccessToken({required String token}) {
    _setPreference(
        prefName: PREF_ACCESS_TOKEN,
        prefType: PREF_TYPE_STRING,
        prefValue: token);
  }
  Future<List<String>> getListBusinessName() async {
    List<String> list =
        _preferences!.getStringList(PREF_LIST_BUSINESS_NAME) ?? [];
    return list;
  }

  void setListBusinessName({required List<String> list}) {
    _setPreference(
        prefName: PREF_LIST_BUSINESS_NAME,
        prefType: PREF_TYPE_LIST_STRING,
        prefValue: list);
  }

  Future<dynamic> getListBusinessToken() async {
    List<String> list =
        _preferences!.getStringList(PREF_LIST_BUSINESS_TOKEN) ?? [];
    return list;
  }

  void setListBusinessToken({required List<String> list}) {
    _setPreference(
        prefName: PREF_LIST_BUSINESS_TOKEN,
        prefType: PREF_TYPE_LIST_STRING,
        prefValue: list);
  }

  Future<dynamic> getListTenant() async {
    List<String> list = _preferences!.getStringList(PREF_LIST_TENANT) ?? [];
    return list;
  }

  void setListTenant({required List<String> list}) {
    _setPreference(
        prefName: PREF_LIST_TENANT,
        prefType: PREF_TYPE_LIST_STRING,
        prefValue: list);
  }

  /// Get Preference Method -> Future<dynamic>
  /// @param -> @required prefName -> String
  /// @usage -> Returns Preference-Value for given Preference-Name
  Future<dynamic> _getPreference({@required prefName}) async =>
      _preferences!.get(prefName);

}