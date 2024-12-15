#!/bin/bash

# Afficher l'aide si aucune commande n'est passée
if [ $# -eq 0 ]; then
    echo "Usage: $0 [aggregate|temporal_analysis] logfile.log"
    exit 1
fi

# Vérifier que le fichier de logs est passé en paramètre
if [ $# -ne 2 ]; then
    echo "Erreur : Deux arguments attendus. Commande et fichier de logs."
    echo "Usage: $0 [aggregate|temporal_analysis] logfile.log"
    exit 1
fi

COMMAND=$1
LOGFILE=$2

# Vérifier si le fichier existe
if [ ! -f "$LOGFILE" ]; then
    echo "Erreur : Le fichier '$LOGFILE' n'existe pas."
    exit 1
fi

# Fonction pour agréger les logs
aggregate_logs() {
    echo "=-= Aggregating file \"$LOGFILE\" =-="

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

    echo "Log level counts:"
    echo "  - trace: $trace_count"
    echo "  - debug: $debug_count"
    echo "  - info:  $info_count"
    echo "  - warn:  $warn_count"
    echo "  - error: $error_count"
    echo "  - fatal: $fatal_count"
    echo ""
    echo "Most common message: $most_common_msg (count: $most_common_msg_count)"
    echo "Least common message: $least_common_msg (count: $least_common_msg_count)"
    echo ""
    echo "=-= End of report =-="
}

# Fonction pour analyser les logs temporellement
temporal_analysis() {
    echo "=-= \"$LOGFILE\" temporal analysis =-="

    most_active_day=$(grep -oE '[0-9]{4}-[0-9]{2}-[0-9]{2}' "$LOGFILE" | sort | uniq -c | sort -nr | head -1 | awk '{print $2}')
    most_active_hour=$(grep -oE '^\[.*\] [0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}' "$LOGFILE" | cut -d'T' -f2 | cut -d':' -f1 | sort | uniq -c | sort -nr | head -1 | awk '{print $2}')
    most_errors_hour=$(grep -E '^\[(error|fatal)\]' "$LOGFILE" | grep -oE '[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}' | cut -d'T' -f2 | cut -d':' -f1 | sort | uniq -c | sort -nr | head -1 | awk '{print $2}')

    echo "Most active day: $most_active_day"
    echo "Most active hour: ${most_active_hour}h"
    echo "Most error-prone hour: ${most_errors_hour}h"
    echo ""
    echo "=-= End of report =-="
}

# Exécuter la commande
case $COMMAND in
    aggregate)
        aggregate_logs
        ;;
    temporal_analysis)
        temporal_analysis
        ;;
    *)
        echo "Commande invalide. Utilisez [aggregate|temporal_analysis]"
        exit 1
        ;;
esac
