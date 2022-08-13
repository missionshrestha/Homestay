// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HomeStayBooking _$HomeStayBookingFromJson(Map<String, dynamic> json) =>
    HomeStayBooking(
      email: json['email'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      placeAddress: json['placeAddress'] as String?,
      bookingStart: timeStampToDateTime(json['bookingStart'] as Timestamp),
      bookingEnd: timeStampToDateTime(json['bookingEnd'] as Timestamp),
      postId: json['postId'] as String?,
      userID: json['userID'] as String?,
      serviceDuration: json['serviceDuration'] as int?,
      servicePrice: json['servicePrice'] as int?,
      userName: json['userName'] as String?,
    );

Map<String, dynamic> _$HomeStayBookingToJson(HomeStayBooking instance) =>
    <String, dynamic>{
      'userID': instance.userID,
      'userName': instance.userName,
      'postId': instance.postId,
      'serviceDuration': instance.serviceDuration,
      'servicePrice': instance.servicePrice,
      'bookingStart': dateTimeToTimeStamp(instance.bookingStart),
      'bookingEnd': dateTimeToTimeStamp(instance.bookingEnd),
      'email': instance.email,
      'phoneNumber': instance.phoneNumber,
      'placeAddress': instance.placeAddress,
    };
