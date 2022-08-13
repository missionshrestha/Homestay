import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:homestay/utils/utils.dart';
import 'package:json_annotation/json_annotation.dart';
part 'booking.g.dart';

@JsonSerializable()
class HomeStayBooking {
  final String? userID;
  final String? userName;
  final String? postId;
  final int? serviceDuration;
  final int? servicePrice;

  @JsonKey(fromJson: timeStampToDateTime, toJson: dateTimeToTimeStamp)
  final DateTime? bookingStart;
  @JsonKey(fromJson: timeStampToDateTime, toJson: dateTimeToTimeStamp)
  final DateTime? bookingEnd;
  final String? email;
  final String? phoneNumber;
  final String? placeAddress;

  HomeStayBooking({
    this.email,
    this.phoneNumber,
    this.placeAddress,
    this.bookingStart,
    this.bookingEnd,
    this.postId,
    this.userID,
    this.serviceDuration,
    this.servicePrice,
    this.userName,
  });

  factory HomeStayBooking.fromJson(Map<String, dynamic> json) =>
      _$HomeStayBookingFromJson(json);

  /// Connect the generated [_$HomeStayBookingToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$HomeStayBookingToJson(this);
}
