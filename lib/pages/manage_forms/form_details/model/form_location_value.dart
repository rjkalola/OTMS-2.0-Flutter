class FormLocationValue {
  FormLocationValue({
    this.latitude,
    this.longitude,
    this.accuracyMeters,
    this.manualInput = '',
  });

  double? latitude;
  double? longitude;
  double? accuracyMeters;
  String manualInput;

  bool get hasCurrentCoordinates => latitude != null && longitude != null;

  static ({double latitude, double longitude})? parseManualInput(String input) {
    final parts = input.split(',');
    if (parts.length != 2) return null;

    final latitude = double.tryParse(parts[0].trim());
    final longitude = double.tryParse(parts[1].trim());
    if (latitude == null || longitude == null) return null;
    if (latitude < -90 || latitude > 90 || longitude < -180 || longitude > 180) {
      return null;
    }

    return (latitude: latitude, longitude: longitude);
  }

  bool hasManualCoordinates() {
    return parseManualInput(manualInput) != null;
  }
}
