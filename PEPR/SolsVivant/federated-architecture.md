# 11.2 – Architecture fédérée de la plateforme de données

## Une chaîne de valeur complète : des données à la connaissance

```text
                  Sources de données
     (API • Capteurs • Bases • Référentiels • Données externes)
                               │
                               ▼
              INGESTION & EXPOSITION
         FastAPI • GeoServer • GBIF
                               │
                               ▼
        COUCHE SÉMANTIQUE & MÉTADONNÉES
      Ontologies • RDF • SPARQL • FAIR
                               │
                               ▼
           ANALYSE & VISUALISATION
              QGIS • R Shiny
                               │
          ┌────────────────────┴────────────────────┐
          ▼                                         ▼
 Gestion des dépôts scientifiques        Collaboration
       InvenioRDM                         La Suite
          └────────────────────┬────────────────────┘
                               ▼
        IA & Recherche Augmentée (AI-RAG)
                               ▼
      Décision • Science ouverte • Réutilisation
```

### Principes d'architecture

* **Interopérabilité** : API REST, standards OGC, Darwin Core, RDF/SPARQL.
* **Couche sémantique** : relier les données, les métadonnées et les connaissances via des graphes.
* **Modularité** : chaque composant remplit une fonction spécialisée.
* **FAIR** : rendre les données trouvables, accessibles, interopérables et réutilisables.
* **IA augmentée** : AI-RAG exploite à la fois les documents, les données et le graphe de connaissances.

**Objectif :** mettre en place une plateforme fédérée où les données sont collectées, enrichies sémantiquement, analysées, publiées et exploitées de manière intelligente.
