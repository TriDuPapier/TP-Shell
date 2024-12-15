### Documentation du script Bash `log_analyzer.sh`

---

## Description
Ce script Bash analyse des fichiers de logs pour générer des rapports détaillés sur :
1. **Agrégation des logs** : Compte des niveaux de logs et des messages fréquents.
2. **Analyse temporelle** : Identification des jours/heures les plus actifs et les plus sujets aux erreurs.
3. **Analyse des erreurs** : Résumé des erreurs (`[error]` et `[fatal]`) avec leurs occurrences.

Le script utilise des couleurs pour améliorer la lisibilité des rapports.

---

## Usage

### Syntaxe
```bash
bash log_analyzer.sh [aggregate|temporal_analysis|error_analysis] logfile.log
```

### Paramètres
- **aggregate** : Analyse les logs pour afficher les statistiques par niveau et les messages fréquents.
- **temporal_analysis** : Analyse temporelle pour identifier les périodes critiques (jours/heures actifs et propices aux erreurs).
- **error_analysis** : Fournit un résumé des erreurs (`[error]` et `[fatal]`) et leur répartition.
- **logfile.log** : Chemin du fichier de logs à analyser.

### Exemple d'exécution

1. **Aide par défaut** :
   Si aucun argument n'est fourni, ou si les arguments sont incomplets, le script affiche l'usage :
   ```bash
   bash log_analyzer.sh
   ```
   **Sortie** :
   ```plaintext
   Usage: log_analyzer.sh [aggregate|temporal_analysis|error_analysis] logfile.log
   ```

2. **Agrégation des logs** :
   ```bash
   bash log_analyzer.sh aggregate logfile.log
   ```
   **Sortie** :
   ```plaintext
   -=- Agrégation des logs du fichier "logfile.log" -=-

   Statistiques par niveau de log :
     - trace: 14402
     - debug: 14473
     - info:  28283
     - warn:  21437
     - error: 14182
     - fatal: 7223

   Messages fréquents :
     Message le plus fréquent: "session" (2186 occurrences)
     Message le moins fréquent: "file" (2735 occurrences)

   -=- Fin du rapport -=-
   ```

3. **Analyse temporelle** :
   ```bash
   bash log_analyzer.sh temporal_analysis logfile.log
   ```
   **Sortie** :
   ```plaintext
   -=- Analyse temporelle des logs du fichier "logfile.log" -=-

   Jour le plus actif : 2023-11-19
   Heure la plus active : 09h
   Heure avec le plus d'erreurs : 05h

   -=- Fin du rapport -=-
   ```

4. **Analyse des erreurs** :
   ```bash
   bash log_analyzer.sh error_analysis logfile.log
   ```
   **Sortie** :
   ```plaintext
   -=- Analyse des erreurs dans "logfile.log" -=-

   Résumé des erreurs et fatales :
       341 [error] Connection lost
       123 [fatal] Critical failure

   -=- Fin du rapport -=-
   ```

---

## Fonctionnalités détaillées

### Agrégation des logs (`aggregate`)
- Compte les occurrences des niveaux de logs : `trace`, `debug`, `info`, `warn`, `error`, `fatal`.
- Identifie :
  - Le **message le plus fréquent** dans les logs avec son nombre d'occurrences.
  - Le **message le moins fréquent** avec son nombre d'occurrences.

#### Exemple
Pour un fichier `logfile.log` contenant des milliers de lignes, le script retourne un rapport clair des niveaux de logs et des messages significatifs.

---

### Analyse temporelle (`temporal_analysis`)
- Identifie :
  1. Le **jour le plus actif** : celui avec le plus d'entrées.
  2. L'**heure la plus active** : heure avec le plus de logs.
  3. L'**heure avec le plus d'erreurs** : basée sur les niveaux `[error]` et `[fatal]`.

#### Exemple
Pour des logs horodatés, le script synthétise les jours/heures critiques.

---

### Analyse des erreurs (`error_analysis`)
- Fournit un résumé des messages d'erreur (`[error]` et `[fatal]`).
- Indique le nombre d'occurrences pour chaque type d'erreur.

#### Exemple
Pour des logs contenant des erreurs fréquentes, ce rapport donne un aperçu immédiat des principaux problèmes.

---

## Gestion des erreurs
Le script gère plusieurs cas d'erreurs :
1. **Aucun argument fourni** :
   ```plaintext
   Usage: log_analyzer.sh [aggregate|temporal_analysis|error_analysis] logfile.log
   ```
2. **Nombre d'arguments incorrect** :
   ```plaintext
   Erreur : Deux arguments attendus. Commande et fichier de logs.
   ```
3. **Fichier de logs inexistant** :
   ```plaintext
   Erreur : Le fichier 'logfile.log' n'existe pas.
   ```
4. **Commande invalide** :
   ```plaintext
   Commande invalide. Utilisez [aggregate|temporal_analysis|error_analysis].
   ```

---

## Couleurs dans les sorties
- **Vert** : Information positive ou résultats normaux.
- **Jaune** : Avertissements ou informations importantes.
- **Rouge** : Messages d'erreur ou niveaux critiques.
- **Cyan** : Début et fin des rapports.

---

## Pré-requis
- Le script doit être exécuté dans un environnement compatible Bash.
- Le fichier de logs doit respecter un format attendu, avec des timestamps ISO 8601 (`2024-12-01T14:35:00`) et des niveaux de logs comme `[info]`, `[error]`, etc.

---

## Notes
- Le script utilise des commandes Bash standard telles que `grep`, `sort`, `uniq`, et `awk`.
- Testé sur des fichiers contenant plusieurs milliers de lignes, il est optimisé pour produire des rapports rapidement.

---

## Améliorations possibles
- Ajouter une option pour exporter les résultats au format CSV ou JSON.
- Permettre une analyse multi-fichiers en une seule commande.
- Intégrer un mode interactif pour choisir les options via un menu.

--- 

## Auteur
Script créé et amélioré pour une utilisation intuitive et une lisibilité maximale.
