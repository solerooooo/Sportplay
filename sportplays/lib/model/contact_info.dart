// contact_info.dart
class ContactInfo {
  String name;
  String position;
  String phoneNumber;

  ContactInfo({
    required this.name,
    required this.position,
    required this.phoneNumber,
  });

  // Getter methods
  String getName() => name;
  String getPosition() => position;
  String getPhoneNumber() => phoneNumber;

  // Setter methods
  set setName(String name) => this.name = name;
  set setPosition(String position) => this.position = position;
  set setPhoneNumber(String phoneNumber) => this.phoneNumber = phoneNumber;
}
