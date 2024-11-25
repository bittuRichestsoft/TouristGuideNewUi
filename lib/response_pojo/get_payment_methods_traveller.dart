// To parse this JSON data, do
//
//     final paymentMethodsResponse = paymentMethodsResponseFromJson(jsonString);

import 'dart:convert';

PaymentMethodsResponse paymentMethodsResponseFromJson(String str) =>
    PaymentMethodsResponse.fromJson(json.decode(str));

String paymentMethodsResponseToJson(PaymentMethodsResponse data) =>
    json.encode(data.toJson());

class PaymentMethodsResponse {
  bool? success;
  int? statusCode;
  Data? data;
  String? message;

  PaymentMethodsResponse({
    this.success,
    this.statusCode,
    this.data,
    this.message,
  });

  factory PaymentMethodsResponse.fromJson(Map<String, dynamic> json) =>
      PaymentMethodsResponse(
        success: json["success"],
        statusCode: json["statusCode"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "statusCode": statusCode,
        "data": data?.toJson(),
        "message": message,
      };
}

class Data {
  String? object;
  List<PaymentMethodList>? data;
  bool? hasMore;
  String? url;

  Data({
    this.object,
    this.data,
    this.hasMore,
    this.url,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        object: json["object"],
        data: json["data"] == null
            ? []
            : List<PaymentMethodList>.from(
                json["data"]!.map((x) => PaymentMethodList.fromJson(x))),
        hasMore: json["has_more"],
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "object": object,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "has_more": hasMore,
        "url": url,
      };
}

class PaymentMethodList {
  String? id;
  String? object;
  BillingDetails? billingDetails;
  Card? card;
  int? created;
  String? customer;
  bool? livemode;
  Metadata? metadata;
  String? type;

  PaymentMethodList({
    this.id,
    this.object,
    this.billingDetails,
    this.card,
    this.created,
    this.customer,
    this.livemode,
    this.metadata,
    this.type,
  });

  factory PaymentMethodList.fromJson(Map<String, dynamic> json) =>
      PaymentMethodList(
        id: json["id"],
        object: json["object"],
        billingDetails: json["billing_details"] == null
            ? null
            : BillingDetails.fromJson(json["billing_details"]),
        card: json["card"] == null ? null : Card.fromJson(json["card"]),
        created: json["created"],
        customer: json["customer"],
        livemode: json["livemode"],
        metadata: json["metadata"] == null
            ? null
            : Metadata.fromJson(json["metadata"]),
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "object": object,
        "billing_details": billingDetails?.toJson(),
        "card": card?.toJson(),
        "created": created,
        "customer": customer,
        "livemode": livemode,
        "metadata": metadata?.toJson(),
        "type": type,
      };
}

class BillingDetails {
  Address? address;
  dynamic email;
  dynamic name;
  dynamic phone;

  BillingDetails({
    this.address,
    this.email,
    this.name,
    this.phone,
  });

  factory BillingDetails.fromJson(Map<String, dynamic> json) => BillingDetails(
        address:
            json["address"] == null ? null : Address.fromJson(json["address"]),
        email: json["email"],
        name: json["name"],
        phone: json["phone"],
      );

  Map<String, dynamic> toJson() => {
        "address": address?.toJson(),
        "email": email,
        "name": name,
        "phone": phone,
      };
}

class Address {
  dynamic city;
  String? country;
  dynamic line1;
  dynamic line2;
  String? postalCode;
  dynamic state;

  Address({
    this.city,
    this.country,
    this.line1,
    this.line2,
    this.postalCode,
    this.state,
  });

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        city: json["city"],
        country: json["country"],
        line1: json["line1"],
        line2: json["line2"],
        postalCode: json["postal_code"],
        state: json["state"],
      );

  Map<String, dynamic> toJson() => {
        "city": city,
        "country": country,
        "line1": line1,
        "line2": line2,
        "postal_code": postalCode,
        "state": state,
      };
}

class Card {
  String? brand;
  Checks? checks;
  String? country;
  int? expMonth;
  int? expYear;
  String? fingerprint;
  String? funding;
  dynamic generatedFrom;
  String? last4;
  Networks? networks;
  ThreeDSecureUsage? threeDSecureUsage;
  dynamic wallet;

  Card({
    this.brand,
    this.checks,
    this.country,
    this.expMonth,
    this.expYear,
    this.fingerprint,
    this.funding,
    this.generatedFrom,
    this.last4,
    this.networks,
    this.threeDSecureUsage,
    this.wallet,
  });

  factory Card.fromJson(Map<String, dynamic> json) => Card(
        brand: json["brand"],
        checks: json["checks"] == null ? null : Checks.fromJson(json["checks"]),
        country: json["country"],
        expMonth: json["exp_month"],
        expYear: json["exp_year"],
        fingerprint: json["fingerprint"],
        funding: json["funding"],
        generatedFrom: json["generated_from"],
        last4: json["last4"],
        networks: json["networks"] == null
            ? null
            : Networks.fromJson(json["networks"]),
        threeDSecureUsage: json["three_d_secure_usage"] == null
            ? null
            : ThreeDSecureUsage.fromJson(json["three_d_secure_usage"]),
        wallet: json["wallet"],
      );

  Map<String, dynamic> toJson() => {
        "brand": brand,
        "checks": checks?.toJson(),
        "country": country,
        "exp_month": expMonth,
        "exp_year": expYear,
        "fingerprint": fingerprint,
        "funding": funding,
        "generated_from": generatedFrom,
        "last4": last4,
        "networks": networks?.toJson(),
        "three_d_secure_usage": threeDSecureUsage?.toJson(),
        "wallet": wallet,
      };
}

class Checks {
  dynamic addressLine1Check;
  String? addressPostalCodeCheck;
  String? cvcCheck;

  Checks({
    this.addressLine1Check,
    this.addressPostalCodeCheck,
    this.cvcCheck,
  });

  factory Checks.fromJson(Map<String, dynamic> json) => Checks(
        addressLine1Check: json["address_line1_check"],
        addressPostalCodeCheck: json["address_postal_code_check"],
        cvcCheck: json["cvc_check"],
      );

  Map<String, dynamic> toJson() => {
        "address_line1_check": addressLine1Check,
        "address_postal_code_check": addressPostalCodeCheck,
        "cvc_check": cvcCheck,
      };
}

class Networks {
  List<String>? available;
  dynamic preferred;

  Networks({
    this.available,
    this.preferred,
  });

  factory Networks.fromJson(Map<String, dynamic> json) => Networks(
        available: json["available"] == null
            ? []
            : List<String>.from(json["available"]!.map((x) => x)),
        preferred: json["preferred"],
      );

  Map<String, dynamic> toJson() => {
        "available": available == null
            ? []
            : List<dynamic>.from(available!.map((x) => x)),
        "preferred": preferred,
      };
}

class ThreeDSecureUsage {
  bool? supported;

  ThreeDSecureUsage({
    this.supported,
  });

  factory ThreeDSecureUsage.fromJson(Map<String, dynamic> json) =>
      ThreeDSecureUsage(
        supported: json["supported"],
      );

  Map<String, dynamic> toJson() => {
        "supported": supported,
      };
}

class Metadata {
  Metadata();

  factory Metadata.fromJson(Map<String, dynamic> json) => Metadata();

  Map<String, dynamic> toJson() => {};
}
