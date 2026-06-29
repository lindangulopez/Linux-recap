# 11.2 – Architecture fédérée de la plateforme de données

## Une chaîne de valeur complète, de la donnée brute à la connaissance

```text
Sources de données
(API • Capteurs • Bases • Référentiels • Données externes)
                           │
                           ▼
      INGESTION & EXPOSITION
  FastAPI • GeoServer • GBIF
                           │
                           ▼
     ANALYSE & VISUALISATION
        QGIS • R Shiny
                           │
          ┌────────────────┴────────────────┐
          ▼                                 ▼
Gestion des dépôts                 Collaboration
 scientifiques                     et workflows
   InvenioRDM                        La Suite
          └────────────────┬────────────────┘
                           ▼
            IA & Recherche augmentée
                    AI-RAG
                           ▼
      Décision • Réutilisation • Science ouverte
```

### Principes d'architecture

* **Interopérabilité** grâce aux standards ouverts (OGC, Darwin Core, API REST).
* **Modularité** : chaque composant remplit une fonction spécialisée.
* **FAIR** : gestion, diffusion et réutilisation des données scientifiques.
* **Valorisation** : de l'acquisition des données jusqu'à l'aide à la décision par l'IA.

**Objectif :** construire une plateforme fédérée, évolutive et souveraine, couvrant l'ensemble du cycle de vie des données, de leur collecte à leur exploitation scientifique et métier.
