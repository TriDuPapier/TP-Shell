#!/bin/bash

# Couleurs pour le terminal
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
CYAN='\033[1;36m'
WHITE='\033[1;37m'
NC='\033[0m' # Sans couleur

# Afficher l'aide si aucune commande n'est passée
if [ $# -eq 0 ]; then
    echo -e "${YELLOW}Usage: $0 [aggregate|temporal_analysis|error_analysis] logfile.log [--export-csv output.csv]${NC}"
    exit 1
fi

# Vérifier les paramètres
COMMAND=$1
LOGFILE=$2
EXPORT_CSV=""

if [ $# -ge 4 ] && [ "$3" == "--export-csv" ]; then
    EXPORT_CSV=$4
fi

# Vérifier si le fichier existe
if [ ! -f "$LOGFILE" ]; then
    echo -e "${RED}Erreur : Le fichier '$LOGFILE' n'existe pas.${NC}"
    exit 1
fi

# Fonction pour agréger les logs
aggregate_logs() {
    echo -e "${CYAN}=-= Agrégation des logs du fichier \"$LOGFILE\" =-=${NC}"

    trace_count=$(grep -c "^\[trace\]" "$LOGFILE")
    debug_count=$(grep -c "^\[debug\]" "$LOGFILE")
    info_count=$(grep -c "^\[info\]" "$LOGFILE")
    warn_count=$(grep -c "^\[warn\]" "$LOGFILE")
    error_count=$(grep -c "^\[error\]" "$LOGFILE")
    fatal_count=$(grep -c "^\[fatal\]" "$LOGFILE")

    most_common_msg=$(grep -o 'msg="[^"]*"' "$LOGFILE" | sort | uniq -c | sort -nr | head -1 | awk '{print $2}' | sed 's/msg=//g')
    most_common_msg_count=$(grep -o "$most_common_msg" "$LOGFILE" | wc -l)

    least_common_msg=$(grep -o 'msg="[^"]*"' "$LOGFILE" | sort | uniq -c | sort -n | head -1 | awk '{print $2}' | sed 's/msg=//g')
    least_common_msg_count=$(grep -o "$least_common_msg" "$LOGFILE" | wc -l)

    echo -e "${BLUE}Statistiques par niveau de log :${NC}"
    echo -e "${GREEN}  - trace:${NC} $trace_count"
    echo -e "${GREEN}  - debug:${NC} $debug_count"
    echo -e "${GREEN}  - info:${NC}  $info_count"
    echo -e "${YELLOW}  - warn:${NC}  $warn_count"
    echo -e "${RED}  - error:${NC} $error_count"
    echo -e "${RED}  - fatal:${NC} $fatal_count"
    echo ""
    echo -e "${BLUE}Messages fréquents :${NC}"
    echo -e "${GREEN}  Message le plus fréquent:${NC} \"$most_common_msg\" (${most_common_msg_count} occurrences)"
    echo -e "${YELLOW}  Message le moins fréquent:${NC} \"$least_common_msg\" (${least_common_msg_count} occurrences)"
    echo ""
    echo -e "${CYAN}=-= Fin du rapport =-=${NC}"

    # Exporter en CSV si demandé
    if [ -n "$EXPORT_CSV" ]; then
        echo "Log Level,Count" > "$EXPORT_CSV"
        echo "trace,$trace_count" >> "$EXPORT_CSV"
        echo "debug,$debug_count" >> "$EXPORT_CSV"
        echo "info,$info_count" >> "$EXPORT_CSV"
        echo "warn,$warn_count" >> "$EXPORT_CSV"
        echo "error,$error_count" >> "$EXPORT_CSV"
        echo "fatal,$fatal_count" >> "$EXPORT_CSV"
        echo "" >> "$EXPORT_CSV"
        echo "Message,Type,Count" >> "$EXPORT_CSV"
        echo "\"$most_common_msg\",Most Common,$most_common_msg_count" >> "$EXPORT_CSV"
        echo "\"$least_common_msg\",Least Common,$least_common_msg_count" >> "$EXPORT_CSV"
        echo -e "${GREEN}Export terminé dans : $EXPORT_CSV${NC}"
    fi
}

# Fonction pour analyser les logs temporellement
temporal_analysis() {
    echo -e "${CYAN}=-= Analyse temporelle des logs du fichier \"$LOGFILE\" =-=${NC}"

    most_active_day=$(grep -oE '[0-9]{4}-[0-9]{2}-[0-9]{2}' "$LOGFILE" | sort | uniq -c | sort -nr | head -1 | awk '{print $2}')
    most_active_hour=$(grep -oE '^\[.*\] [0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}' "$LOGFILE" | cut -d'T' -f2 | cut -d':' -f1 | sort | uniq -c | sort -nr | head -1 | awk '{print $2}')
    most_errors_hour=$(grep -E '^\[(error|fatal)\]' "$LOGFILE" | grep -oE '[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}' | cut -d'T' -f2 | cut -d':' -f1 | sort | uniq -c | sort -nr | head -1 | awk '{print $2}')

    echo -e "${GREEN}Jour le plus actif :${NC} $most_active_day"
    echo -e "${GREEN}Heure la plus active :${NC} ${most_active_hour}h"
    echo -e "${RED}Heure avec le plus d'erreurs :${NC} ${most_errors_hour}h"
    echo ""
    echo -e "${CYAN}=-= Fin du rapport =-=${NC}"

    # Exporter en CSV si demandé
    if [ -n "$EXPORT_CSV" ]; then
        echo "Metric,Value" > "$EXPORT_CSV"
        echo "Most active day,$most_active_day" >> "$EXPORT_CSV"
        echo "Most active hour,${most_active_hour}h" >> "$EXPORT_CSV"
        echo "Most error-prone hour,${most_errors_hour}h" >> "$EXPORT_CSV"
        echo -e "${GREEN}Export terminé dans : $EXPORT_CSV${NC}"
    fi
}

# Fonction pour analyser les erreurs
error_analysis() {
    echo -e "${CYAN}=-= Analyse des erreurs dans \"$LOGFILE\" =-=${NC}"

    error_summary=$(grep -E '^\[(error|fatal)\]' "$LOGFILE" | cut -d']' -f2 | sort | uniq -c | sort -nr)

    echo -e "${RED}Résumé des erreurs :${NC}"
    echo "$error_summary"
    echo ""
    echo -e "${CYAN}=-= Fin du rapport =-=${NC}"

    # Exporter en CSV si demandé
    if [ -n "$EXPORT_CSV" ]; then
        echo "Error Type,Count" > "$EXPORT_CSV"
        echo "$error_summary" | awk '{print $2","$1}' >> "$EXPORT_CSV"
        echo -e "${GREEN}Export terminé dans : $EXPORT_CSV${NC}"
    fi
}

# Exécuter la commande
case $COMMAND in
    aggregate)
        aggregate_logs
        ;;
    temporal_analysis)
        temporal_analysis
        ;;
    error_analysis)
        error_analysis
        ;;
    *)
        echo -e "${RED}Commande invalide.${NC} Utilisez ${YELLOW}[aggregate|temporal_analysis|error_analysis]${NC}."
        exit 1
        ;;
esac
