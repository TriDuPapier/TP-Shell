# Documentation du Script de Traitement des Logs

## Description

Ce script permet d'analyser des fichiers de logs et de produire des rapports détaillés. Il inclut trois commandes principales :

- **Agrégation des logs** : Compte les occurrences de chaque niveau de log et les messages les plus fréquents.
- **Analyse temporelle** : Identifie les jours et heures les plus actifs ainsi que ceux avec le plus d'erreurs.
- **Analyse des erreurs** : Résume les erreurs et les messages fatals.

Le script prend également en charge l'exportation des résultats dans un fichier CSV.

---

## Commandes Disponibles

### `aggregate`

Agrège les logs et affiche les statistiques par niveau de log et les messages les plus fréquents.

#### Paramètres

- **logfile.log** : Le fichier de logs à analyser.

#### Exemple d'utilisation

```bash
bash log_analyzer.sh aggregate logfile.log
```

### `temporal_analysis`

Effectue une analyse temporelle des logs, identifiant les jours et heures les plus actifs ainsi que les heures avec le plus d'erreurs.

#### Paramètres

- **logfile.log** : Le fichier de logs à analyser.

#### Exemple d'utilisation

```bash
bash log_analyzer.sh temporal_analysis logfile.log
```

### `error_analysis`

Affiche un résumé des erreurs et des messages fatals dans le fichier de logs.

#### Paramètres

- **logfile.log** : Le fichier de logs à analyser.

#### Exemple d'utilisation

```bash
bash log_analyzer.sh error_analysis logfile.log
```

---

## Paramètres Optionnels

### `--export-csv output.csv`

Permet d'exporter les résultats dans un fichier CSV. Ce paramètre est compatible avec toutes les commandes (`aggregate`, `temporal_analysis`, `error_analysis`).

#### Exemple d'utilisation

```bash
bash log_analyzer.sh aggregate logfile.log --export-csv output.csv
```

### Format du fichier CSV

Le fichier CSV généré contient les résultats sous forme de colonnes. Par exemple, pour `aggregate`, le fichier CSV contiendra les colonnes suivantes :
- **Log Level** : Niveau de log (trace, debug, info, warn, error, fatal)
- **Count** : Nombre d'occurrences pour chaque niveau de log.

Pour `temporal_analysis`, le fichier CSV contiendra :
- **Metric** : Métrique analysée (par exemple, "Most active day", "Most active hour")
- **Value** : Valeur associée (par exemple, le jour ou l'heure).

Pour `error_analysis`, le fichier CSV contiendra :
- **Error Type** : Type d'erreur (error, fatal)
- **Count** : Nombre d'occurrences de ce type d'erreur.

---

## Fonctionnalités détaillées

### Agrégation des logs (`aggregate`)

- Compte les occurrences des niveaux de logs : `trace`, `debug`, `info`, `warn`, `error`, `fatal`.
- Identifie :
  - Le **message le plus fréquent** dans les logs avec son nombre d'occurrences.
  - Le **message le moins fréquent** avec son nombre d'occurrences.

#### Exemple

Pour un fichier `logfile.log` contenant des milliers de lignes, le script retourne un rapport clair des niveaux de logs et des messages significatifs.

### Analyse temporelle (`temporal_analysis`)

- Identifie :
  1. Le **jour le plus actif** : celui avec le plus d'entrées.
  2. L'**heure la plus active** : heure avec le plus de logs.
  3. L'**heure avec le plus d'erreurs** : basée sur les niveaux `[error]` et `[fatal]`.

#### Exemple

Pour des logs horodatés, le script synthétise les jours/heures critiques.

### Analyse des erreurs (`error_analysis`)

- Fournit un résumé des messages d'erreur (`[error]` et `[fatal]`).
- Indique le nombre d'occurrences pour chaque type d'erreur.

#### Exemple

Pour des logs contenant des erreurs fréquentes, ce rapport donne un aperçu immédiat des principaux problèmes.

---

## Exemple d'exécution

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

## Explication des Variables

- **`$COMMAND`** : Commande à exécuter, soit `aggregate`, `temporal_analysis`, ou `error_analysis`.
- **`$LOGFILE`** : Le fichier de logs à analyser.
- **`$EXPORT_CSV`** : Chemin vers le fichier CSV dans lequel les résultats seront exportés. Ce paramètre est optionnel et est utilisé uniquement si `--export-csv` est spécifié.

---

## Conclusion

Le script `log_analyzer.sh` est un outil puissant pour analyser des fichiers de logs. Il fournit une vue détaillée des niveaux de log, des périodes d'activité et des erreurs, avec la possibilité d'exporter les résultats au format CSV pour une utilisation ultérieure.
