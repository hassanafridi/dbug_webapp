import 'dart:convert';

class AdsModel {
  final bool? success;
  final Data? data;

  AdsModel({
    this.success,
    this.data,
  });

  factory AdsModel.fromRawJson(String str) => AdsModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AdsModel.fromJson(Map<String, dynamic> json) => AdsModel(
    success: json["success"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": data?.toJson(),
  };
}

class Data {
  final int? id;
  final String? admobInter;
  final String? admobNative;
  final String? admobBanner;
  final String? admobReward;
  final String? openAds;
  final String? fbInter;
  final String? fbNative;
  final String? fbBanner;
  final String? fbReward;
  final String? unityAppIdGameId;
  final String? appnextPlacementId;
  final String? startappAppId;
  final String? ironAppKey;
  final dynamic startupInter;
  final dynamic startupBanner;
  final int? industrialInterval;
  final int? nativeAds;
  final String? adTypes;
  final dynamic createdAt;
  final DateTime? updatedAt;

  Data({
    this.id,
    this.admobInter,
    this.admobNative,
    this.admobBanner,
    this.admobReward,
    this.openAds,
    this.fbInter,
    this.fbNative,
    this.fbBanner,
    this.fbReward,
    this.unityAppIdGameId,
    this.appnextPlacementId,
    this.startappAppId,
    this.ironAppKey,
    this.startupInter,
    this.startupBanner,
    this.industrialInterval,
    this.nativeAds,
    this.adTypes,
    this.createdAt,
    this.updatedAt,
  });

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    admobInter: json["admob_inter"],
    admobNative: json["admob_native"],
    admobBanner: json["admob_banner"],
    admobReward: json["admob_reward"],
    openAds: json["open_ads"],
    fbInter: json["fb_inter"],
    fbNative: json["fb_native"],
    fbBanner: json["fb_banner"],
    fbReward: json["fb_reward"],
    unityAppIdGameId: json["unity_appId_gameId"],
    appnextPlacementId: json["appnext_placementId"],
    startappAppId: json["startapp_appId"],
    ironAppKey: json["iron_appKey"],
    startupInter: json["startup_inter"],
    startupBanner: json["startup_banner"],
    industrialInterval: json["industrial_interval"],
    nativeAds: json["native_ads"],
    adTypes: json["ad_types"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "admob_inter": admobInter,
    "admob_native": admobNative,
    "admob_banner": admobBanner,
    "admob_reward": admobReward,
    "open_ads": openAds,
    "fb_inter": fbInter,
    "fb_native": fbNative,
    "fb_banner": fbBanner,
    "fb_reward": fbReward,
    "unity_appId_gameId": unityAppIdGameId,
    "appnext_placementId": appnextPlacementId,
    "startapp_appId": startappAppId,
    "iron_appKey": ironAppKey,
    "startup_inter": startupInter,
    "startup_banner": startupBanner,
    "industrial_interval": industrialInterval,
    "native_ads": nativeAds,
    "ad_types": adTypes,
    "created_at": createdAt,
    "updated_at": updatedAt?.toIso8601String(),
  };
}
