/// Class for the Note entity
class Note {
  /// Constructor
  Note({
    this.id,
    this.title,
    this.description,
    this.createdAt,
  });

  /// Identifier of the note
  int? id;

  /// Title of the note
  String? title;

  /// Description of the note
  String? description;

  /// Creation date of the note
  DateTime? createdAt;
}