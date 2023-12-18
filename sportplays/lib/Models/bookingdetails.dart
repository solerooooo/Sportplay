//bookingdetails.dart
class Booking {
  final String userName;
  final String facility;
  final DateTime startTime;
  final DateTime endTime;

  Booking(this.userName, this.facility, this.startTime, this.endTime);

   static String selectedTime = ''; // Make it global
  static Map<String, int> selectedCourts = {}; // Make it global

  static void updateAvailability(String time, int pingPongCourts, int badmintonCourts, int squashCourts) {
    selectedTime = time;
    selectedCourts['pingPong_$time'] = pingPongCourts;
    selectedCourts['badminton_$time'] = badmintonCourts;
    selectedCourts['squash_$time'] = squashCourts;
  }
}