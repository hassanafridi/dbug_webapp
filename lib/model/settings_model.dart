import 'dart:convert';

class SettingsModel {
  final String? status;
  final List<SettingItem>? data;

  SettingsModel({
    this.status,
    this.data,
  });

  factory SettingsModel.fromRawJson(String str) => SettingsModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SettingsModel.fromJson(Map<String, dynamic> json) => SettingsModel(
    status: json["status"],
    data: json["data"] == null ? [] : List<SettingItem>.from(json["data"]!.map((x) => SettingItem.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class SettingItem {
  final int? id;
  final String? appFcmKey;
  final int? zoomControl;
  final dynamic apiKey;
  final dynamic appVersion;
  final String? aboutUsUrl;
  final String? privacyPolicyUrl;
  final dynamic termsAndConditionUrl;
  final dynamic rateUsUrl;
  final dynamic customUserAgent;
  final dynamic privacyPolicy;
  final dynamic oneSignal;
  final dynamic createdAt;
  final DateTime? updatedAt;

  SettingItem({
    this.id,
    this.appFcmKey,
    this.zoomControl,
    this.apiKey,
    this.appVersion,
    this.aboutUsUrl,
    this.privacyPolicyUrl,
    this.termsAndConditionUrl,
    this.rateUsUrl,
    this.customUserAgent,
    this.privacyPolicy,
    this.oneSignal,
    this.createdAt,
    this.updatedAt,
  });

  factory SettingItem.fromRawJson(String str) => SettingItem.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SettingItem.fromJson(Map<String, dynamic> json) => SettingItem(
    id: json["id"],
    appFcmKey: json["app_fcm_key"],
    zoomControl: json["zoom_control"],
    apiKey: json["api_key"],
    appVersion: json["app_version"],
    aboutUsUrl: json["about_us_url"],
    privacyPolicyUrl: json["privacy_policy_url"],
    termsAndConditionUrl: json["terms_and_condition_url"],
    rateUsUrl: json["rate_us_url"],
    customUserAgent: json["custom_user_agent"],
    privacyPolicy: json["privacy_policy"],
    oneSignal: json["one_signal"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "app_fcm_key": appFcmKey,
    "zoom_control": zoomControl,
    "api_key": apiKey,
    "app_version": appVersion,
    "about_us_url": aboutUsUrl,
    "privacy_policy_url": privacyPolicyUrl,
    "terms_and_condition_url": termsAndConditionUrl,
    "rate_us_url": rateUsUrl,
    "custom_user_agent": customUserAgent,
    "privacy_policy": privacyPolicy,
    "one_signal": oneSignal,
    "created_at": createdAt,
    "updated_at": updatedAt?.toIso8601String(),
  };
}
