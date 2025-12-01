// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LoginResponseImpl _$$LoginResponseImplFromJson(Map<String, dynamic> json) =>
    _$LoginResponseImpl(
      token: json['token'] as String?,
      accessToken: json['accessToken'] as String?,
      authToken: json['authToken'] as String?,
    );

Map<String, dynamic> _$$LoginResponseImplToJson(_$LoginResponseImpl instance) =>
    <String, dynamic>{
      'token': instance.token,
      'accessToken': instance.accessToken,
      'authToken': instance.authToken,
    };

_$ProfileDataImpl _$$ProfileDataImplFromJson(Map<String, dynamic> json) =>
    _$ProfileDataImpl(
      userId: json['userId'] as String,
      name: json['name'] as String,
      remainToken: (json['remainToken'] as num).toInt(),
      profile: json['profile'] as String,
      role: json['role'] as String,
    );

Map<String, dynamic> _$$ProfileDataImplToJson(_$ProfileDataImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'name': instance.name,
      'remainToken': instance.remainToken,
      'profile': instance.profile,
      'role': instance.role,
    };

_$ProfileResponseImpl _$$ProfileResponseImplFromJson(
  Map<String, dynamic> json,
) => _$ProfileResponseImpl(
  message: json['message'] as String,
  data: ProfileData.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$$ProfileResponseImplToJson(
  _$ProfileResponseImpl instance,
) => <String, dynamic>{'message': instance.message, 'data': instance.data};
