# Documentation du script Bash `log_analyzer.sh`

## Description
Ce script Bash analyse les fichiers de logs pour générer des rapports basés sur :
1. **Agrégation des logs** : Compte des niveaux de logs et des messages les plus fréquents.
2. **Analyse temporelle** : Analyse des jours et heures les plus actifs ainsi que des heures avec le plus d'erreurs.

---

## Usage

### Syntaxe
```bash
bash log_analyzer.sh [aggregate|temporal_analysis] logfile.log
```

### Paramètres
- **aggregate** : Agrège les logs pour afficher les statistiques par niveau et les messages les plus fréquents.
- **temporal_analysis** : Effectue une analyse temporelle des logs (jours et heures les plus actifs).
- **logfile.log** : Fichier de logs au format attendu.

### Exemple d'exécution

1. **Aide par défaut sans arguments** :
   Si aucun argument n'est passé ou s'il manque un paramètre, le script affiche l'usage :
   ```bash
   bash log_analyzer.sh
   ```
   **Sortie** :
   ```plaintext
   Usage: log_analyzer.sh [aggregate|temporal_analysis] logfile.log
   ```

2. **Agrégation des logs** :
   ```bash
   bash log_analyzer.sh aggregate logfile.log
   ```
   **Sortie** :
   ```plaintext
   =-= Aggregating file "logfile.log" =-=

   Log level counts:
     - trace: 14402
     - debug: 14473
     - info:  28283
     - warn:  21437
     - error: 14182
     - fatal: 7223

   Most common message: "session" (count: 2186)
   Least common message: "file" (count: 2735)

   =-= End of report =-=
   ```

3. **Analyse temporelle des logs** :
   ```bash
   bash log_analyzer.sh temporal_analysis logfile.log
   ```
   **Sortie** :
   ```plaintext
   =-= "logfile.log" temporal analysis =-=

   Most active day: 2023-11-19
   Most active hour: 09h
   Most error-prone hour: 05h

   =-= End of report =-=
   ```

4. **Gestion des fichiers inexistants** :
   Si le fichier de logs n'existe pas, le script retourne une erreur explicite :
   ```bash
   bash log_analyzer.sh aggregate nonexistent.log
   ```
   **Sortie** :
   ```plaintext
   Erreur : Le fichier 'nonexistent.log' n'existe pas.
   ```



---

## Fonctionnalités détaillées

### Agrégation des logs (`aggregate`)
La commande `aggregate` affiche :
- **Le nombre d'occurrences** pour chaque niveau de log : `trace`, `debug`, `info`, `warn`, `error`, `fatal`.
- Le **message le plus fréquent** dans les logs avec son nombre d'occurrences.
- Le **message le moins fréquent** dans les logs avec son nombre d'occurrences.

#### Exemple
Pour un fichier de logs `logfile.log` contenant des milliers de lignes, le script retourne un rapport clair des niveaux et des messages.

---

### Analyse temporelle (`temporal_analysis`)
La commande `temporal_analysis` fournit une analyse des logs en identifiant :
1. Le **jour le plus actif** : jour avec le plus d'entrées de logs.
2. L'**heure la plus active** : heure de la journée avec le plus d'entrées.
3. L'**heure avec le plus d'erreurs** (`error` ou `fatal`).

#### Exemple
À partir de timestamps dans les logs, le script synthétise les heures et jours critiques.

---

## Gestion des erreurs
Le script prend en charge plusieurs cas d'erreurs :
1. **Aucun argument fourni** :
   ```plaintext
   Usage: log_analyzer.sh [aggregate|temporal_analysis] logfile.log
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
   Commande invalide. Utilisez [aggregate|temporal_analysis]
   ```

---

## Pré-requis
- Le script doit être exécuté dans un environnement compatible Bash.
- Le fichier de logs doit respecter un format attendu avec :
  - Timestamps ISO 8601 (exemple : `2024-12-01T14:35:00`).
  - Messages de log avec niveaux comme `[info]`, `[error]`, etc.

---

## Notes
- Le script utilise des commandes classiques comme `grep`, `sort`, `awk` et `uniq`.
- Le test des commandes a été validé sur un fichier `logfile.log` contenant des milliers d'entrées, avec une gestion appropriée des fichiers inexistants ou invalides.

