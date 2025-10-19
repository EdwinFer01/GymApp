enum Gender { male, female, other, undisclosed }

class Client {
  Client({
    this.id,
    this.userId,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.phone,
    this.birthDate,
    this.gender = Gender.undisclosed,
    this.heightCm,
    this.weightKg,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  final int? id;
  final int? userId;
  final String firstName;
  final String lastName;
  final String email;
  final String? phone;
  final DateTime? birthDate;
  final Gender gender;
  final double? heightCm;
  final double? weightKg;
  final DateTime createdAt;
  final DateTime updatedAt;

  String get fullName => '$firstName $lastName';

  Client copyWith({
    int? id,
    int? userId,
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    DateTime? birthDate,
    Gender? gender,
    double? heightCm,
    double? weightKg,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Client(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      birthDate: birthDate ?? this.birthDate,
      gender: gender ?? this.gender,
      heightCm: heightCm ?? this.heightCm,
      weightKg: weightKg ?? this.weightKg,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'userId': userId,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phone': phone,
      'birthDate': birthDate?.toIso8601String(),
      'gender': gender.name,
      'heightCm': heightCm,
      'weightKg': weightKg,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
      id: json['id'] as int?,
      userId: json['userId'] as int?,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String?,
      birthDate: json['birthDate'] != null
          ? DateTime.parse(json['birthDate'] as String)
          : null,
      gender: Gender.values.byName(
        (json['gender'] as String?) ?? Gender.undisclosed.name,
      ),
      heightCm: (json['heightCm'] as num?)?.toDouble(),
      weightKg: (json['weightKg'] as num?)?.toDouble(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is Client &&
            runtimeType == other.runtimeType &&
            id == other.id &&
            userId == other.userId &&
            firstName == other.firstName &&
            lastName == other.lastName &&
            email == other.email &&
            phone == other.phone &&
            birthDate == other.birthDate &&
            gender == other.gender &&
            heightCm == other.heightCm &&
            weightKg == other.weightKg &&
            createdAt == other.createdAt &&
            updatedAt == other.updatedAt;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      userId,
      firstName,
      lastName,
      email,
      phone,
      birthDate,
      gender,
      heightCm,
      weightKg,
      createdAt,
      updatedAt,
    );
  }
}
