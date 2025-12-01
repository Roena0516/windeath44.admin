// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserImpl _$$UserImplFromJson(Map<String, dynamic> json) => _$UserImpl(
  userId: json['userId'] as String,
  email: json['email'] as String,
  name: json['name'] as String,
  remainToken: (json['remainToken'] as num).toInt(),
  profile: json['profile'] as String,
  role: json['role'] as String,
  createdAt: json['createdAt'] as String,
);

Map<String, dynamic> _$$UserImplToJson(_$UserImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'email': instance.email,
      'name': instance.name,
      'remainToken': instance.remainToken,
      'profile': instance.profile,
      'role': instance.role,
      'createdAt': instance.createdAt,
    };

_$UserListResponseImpl _$$UserListResponseImplFromJson(
  Map<String, dynamic> json,
) => _$UserListResponseImpl(
  content:
      (json['content'] as List<dynamic>)
          .map((e) => User.fromJson(e as Map<String, dynamic>))
          .toList(),
  page: (json['page'] as num).toInt(),
  size: (json['size'] as num).toInt(),
  totalElements: (json['totalElements'] as num).toInt(),
  totalPages: (json['totalPages'] as num).toInt(),
  totalUserCount: (json['totalUserCount'] as num).toInt(),
);

Map<String, dynamic> _$$UserListResponseImplToJson(
  _$UserListResponseImpl instance,
) => <String, dynamic>{
  'content': instance.content,
  'page': instance.page,
  'size': instance.size,
  'totalElements': instance.totalElements,
  'totalPages': instance.totalPages,
  'totalUserCount': instance.totalUserCount,
};
