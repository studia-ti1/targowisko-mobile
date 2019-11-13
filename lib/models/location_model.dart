class LocationModel {
  final String id;
  final String name;
  final LocationDetails location;

  LocationModel.fromJson(dynamic json)
      : id = json["id"],
        name = json["name"],
        location = json["location"] != null
            ? LocationDetails.fromJson(json["location"])
            : null;
}

class LocationDetails {
  String zip;
  String city;
  String street;
  String country;
  double latitude;
  double longitude;

  LocationDetails.fromJson(dynamic json)
      : zip = json["zip"],
        city = json["city"],
        street = json["street"],
        country = json["country"],
        latitude = json["latitude"],
        longitude = json["longitude"];
}
