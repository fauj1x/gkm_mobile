  class TahunAjaran {
    final int id;
    final String tahunAjaran;
    final String semester;
    final String slug;
    final DateTime? deletedAt;
    final DateTime createdAt;
    final DateTime updatedAt;

    TahunAjaran({
      required this.id,
      required this.tahunAjaran,
      required this.semester,
      required this.slug,
      this.deletedAt,
      required this.createdAt,
      required this.updatedAt,
    });

    factory TahunAjaran.fromJson(Map<String, dynamic> json) {
      return TahunAjaran(
        id: int.tryParse(json['id'].toString()) ?? 0,
        tahunAjaran: json['tahun_ajaran'] as String,
        semester: json['semester'] as String,
        slug: json['slug'] as String,
        deletedAt: json['deleted_at'] != null
            ? DateTime.tryParse(json['deleted_at'])
            : null,
        createdAt: DateTime.parse(json['created_at']),
        updatedAt: DateTime.parse(json['updated_at']),
      );
    }
    @override
    bool operator ==(Object other) {
      if (identical(this, other)) return true;

      return other is TahunAjaran &&
          other.id == id &&
          other.tahunAjaran == tahunAjaran &&
          other.semester == semester &&
          other.slug == slug;
    }

    @override
    int get hashCode => Object.hash(id, tahunAjaran, semester, slug);

  }
