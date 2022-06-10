class ContactModel {
  ContactModel({
    required this.name,
    required this.phone,
    required this.service,
    required this.address,
  });

  String name;
  String phone;
  String service;
  String address;

  factory ContactModel.fromJson(Map<String, dynamic> json) => ContactModel(
        name: json["name"],
        phone: json["phone"],
        service: json["service"],
        address: json["address"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "phone": phone,
        "service": service,
        "address": address,
      };
}
