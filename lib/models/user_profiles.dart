class UserProfile {
  final int id;
  final String nip;
  final String nik;
  final String nidn;
  final String nama;
  final String jabatanFungsional;
  final int jabatanId;
  final String handphone;
  final int userId;

  UserProfile({
    required this.id,
    required this.nip,
    required this.nik,
    required this.nidn,
    required this.nama,
    required this.jabatanFungsional,
    required this.jabatanId,
    required this.handphone,
    required this.userId,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'],
      nip: json['nip'],
      nik: json['nik'],
      nidn: json['nidn'],
      nama: json['nama'],
      jabatanFungsional: json['jabatan_fungsional'],
      jabatanId: json['jabatan_id'],
      handphone: json['handphone'],
      userId: json['user_id'],
    );
  }
}
