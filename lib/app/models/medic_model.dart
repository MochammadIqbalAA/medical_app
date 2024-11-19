import 'dart:convert';

Medic medicFromJson(String str) => Medic.fromJson(json.decode(str));

String medicToJson(Medic data) => json.encode(data.toJson());

class Medic {
  DrugGroup drugGroup;

  Medic({required this.drugGroup});

  factory Medic.fromJson(Map<String, dynamic> json) => Medic(
        drugGroup: DrugGroup.fromJson(json["drugGroup"]),
      );

  Map<String, dynamic> toJson() => {
        "drugGroup": drugGroup.toJson(),
      };
}

class DrugGroup {
  String? name; // Nullable
  List<ConceptGroup> conceptGroup;

  DrugGroup({
    this.name,
    required this.conceptGroup,
  });

  factory DrugGroup.fromJson(Map<String, dynamic> json) => DrugGroup(
        name: json["name"],
        conceptGroup: List<ConceptGroup>.from(
            json["conceptGroup"].map((x) => ConceptGroup.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "conceptGroup": List<dynamic>.from(conceptGroup.map((x) => x.toJson())),
      };
}

class ConceptGroup {
  String tty;
  List<ConceptProperty>? conceptProperties;

  ConceptGroup({
    required this.tty,
    this.conceptProperties,
  });

  factory ConceptGroup.fromJson(Map<String, dynamic> json) => ConceptGroup(
        tty: json["tty"],
        conceptProperties: json["conceptProperties"] == null
            ? []
            : List<ConceptProperty>.from(json["conceptProperties"]!.map((x) =>
                ConceptProperty.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "tty": tty,
        "conceptProperties": conceptProperties == null
            ? []
            : List<dynamic>.from(conceptProperties!.map((x) => x.toJson())),
      };
}

class ConceptProperty {
  String rxcui;
  String? name; // Nullable
  String? synonym; // Nullable
  String tty;
  String language;
  String suppress;
  String umlscui;

  ConceptProperty({
    required this.rxcui,
    this.name,
    this.synonym,
    required this.tty,
    required this.language,
    required this.suppress,
    required this.umlscui,
  });

  factory ConceptProperty.fromJson(Map<String, dynamic> json) =>
      ConceptProperty(
        rxcui: json["rxcui"],
        name: json["name"],
        synonym: json["synonym"],
        tty: json["tty"],
        language: json["language"],
        suppress: json["suppress"],
        umlscui: json["umlscui"],
      );

  Map<String, dynamic> toJson() => {
        "rxcui": rxcui,
        "name": name,
        "synonym": synonym,
        "tty": tty,
        "language": language,
        "suppress": suppress,
        "umlscui": umlscui,
      };
}
