# Data Contract — SoilSample (PEPR SolsVivants)

## 1. Métadonnées du contrat (versioning & gouvernance)

```yaml
contract:
  name: SoilSampleContract
  version: 1.0.0
  status: stable
  domain: "PEPR SolsVivants - Soil Observations"
  owner: "Data Steward - SolsVivants"
  
  description: >
    Contrat de données pour les échantillons de sol standardisés,
    destiné à l'intégration inter-plateformes (Data Terra, THEIA, GIS Sol).

  compatibility:
    backward_compatible_with: ["0.9.x"]
    breaking_changes_policy: "major version bump required"

  lifecycle:
    created: 2026-06-01
    review_cycle: "12 months"
    deprecation_notice: "6 months minimum"
```

---

## 2. Schéma structurel (JSON Schema)

```json
{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "title": "SoilSample",
  "type": "object",
  "required": [
    "sample_id",
    "sampling_date",
    "location",
    "depth",
    "soil_ph",
    "organic_carbon"
  ],

  "properties": {
    
    "sample_id": {
      "type": "string",
      "description": "Identifiant unique pérenne du prélèvement",
      "example": "SOL-2026-000123"
    },

    "sampling_date": {
      "type": "string",
      "format": "date-time",
      "description": "Date ISO-8601 du prélèvement"
    },

    "location": {
      "type": "object",
      "required": ["lat", "lon", "crs"],
      "properties": {
        "lat": { "type": "number", "minimum": -90, "maximum": 90 },
        "lon": { "type": "number", "minimum": -180, "maximum": 180 },
        "crs": { "type": "string", "example": "EPSG:4326" }
      }
    },

    "depth": {
      "type": "object",
      "required": ["value", "unit"],
      "properties": {
        "value": { "type": "number", "minimum": 0 },
        "unit": { "type": "string", "enum": ["cm"] }
      }
    },

    "soil_ph": {
      "type": "number",
      "minimum": 0,
      "maximum": 14
    },

    "organic_carbon": {
      "type": "object",
      "required": ["value", "unit"],
      "properties": {
        "value": { "type": "number", "minimum": 0 },
        "unit": { "type": "string", "enum": ["%", "g/kg"] }
      }
    },

    "sampling_method": {
      "type": "string",
      "description": "Méthode de prélèvement normalisée"
    }
  }
}
```

---

## 3. Couche sémantique (ontologies & FAIR)

```yaml
semantic_layer:

  sample_id:
    iri: "http://purl.data-solvivants.fr/id/soil-sample"
    type: "prov:Entity"

  sampling_date:
    ontology: "PROV-O"
    term: "prov:generatedAtTime"

  location:
    ontology: "GeoSPARQL"
    type: "geo:Point"

  depth:
    ontology: "SOSA/SSN"
    term: "sosa:hasFeatureOfInterest"

  soil_ph:
    ontology: "ENVO"
    iri: "http://purl.obolibrary.org/obo/ENVO_01000337"

  organic_carbon:
    ontology: "AGROVOC / ENVO aligned"
    unit_standard: "ISO/IEC 80000"
```

👉 Ici, on montre que les données ne sont pas seulement structurées, mais **sémantisées pour le graphe de connaissances (RDF/SPARQL)**.

---

## 4. Règles de qualité (validation métier)

```yaml
quality_rules:

  soil_ph:
    rule: "value BETWEEN 0 AND 14"
    severity: "error"

  organic_carbon:
    rule: "value >= 0"
    severity: "error"

  location:
    rule: "must be within valid CRS bounds"
    severity: "error"

  sampling_date:
    rule: "cannot be in the future"
    severity: "warning"

  completeness:
    rule: "required fields must be present"
    threshold: 100%
```

---

## 5. Règles d’évolution du schéma (le point clé pour ton sujet)

```yaml
schema_evolution:

  allowed_changes_without_breaking:
    - add_optional_field
    - add_enum_value (if backward compatible)
    - add_metadata_annotation

  breaking_changes:
    - remove_field
    - change_field_type
    - change_unit_semantics
    - rename_field

  migration_policy:
    strategy: "dual-write + versioned APIs"
    support_old_versions: true
    deprecation_period: "6 months minimum"

  versioning_rule:
    format: "MAJOR.MINOR.PATCH"

    MAJOR:
      meaning: "breaking semantic or structural change"

    MINOR:
      meaning: "backward-compatible extension"

    PATCH:
      meaning: "bug fix / validation rule refinement"
```

---

## 🎯 Message clé à faire passer en entretien

Tu peux conclure avec cette idée forte :

> Un data contract ne décrit pas seulement la forme des données, mais constitue un engagement formel sur leur structure, leur signification, leur qualité et leur évolution. C’est ce qui transforme un pipeline modulaire en infrastructure robuste, capable de survivre à l’évolution des schémas sans casser la reproductibilité scientifique.
