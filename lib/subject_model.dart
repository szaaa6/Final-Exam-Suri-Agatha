class Subject {
  final String name;
  final int credits;

  Subject({required this.name, required this.credits});

  // Convert Subject object to Map for database storage
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'credits': credits,
    };
  }

  // Create Subject object from Map retrieved from database
  factory Subject.fromMap(Map<String, dynamic> map) {
    return Subject(
      name: map['name'],
      credits: map['credits'],
    );
  }
}
