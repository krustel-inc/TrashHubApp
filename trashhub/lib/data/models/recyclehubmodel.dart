class RCHPartner {
  final int id;
  final String name;
  final String type;
  final String imagePath;
  final String contact;

  RCHPartner({
    required this.id,
    required this.name,
    required this.type,
    required this.imagePath,
    required this.contact,
  });
}

class ReCycleHubJob {
  final int id;
  final String name;
  final String partnerName;
  final String partnerType;
  final String status;
  final String date;

  ReCycleHubJob(
    this.id,
    this.name,
    this.partnerName,
    this.partnerType,
    this.status,
    this.date,
  );

  factory ReCycleHubJob.fromMap(Map x) {
    return ReCycleHubJob(
      0,
      x['name'],
      x['partner']['name'],
      x['partner']['type'],
      x['status'],
      x['date'],
    );
  }
}
