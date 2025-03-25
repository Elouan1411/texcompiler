#!/bin/dash

print_help() {
    echo "Usage: $0 fichier.tex [OPTIONS]"
    echo ""
    echo "Options disponibles :"
    echo "  --double   Effectue une double compilation (utile si pas de bibliographie)"
    echo "  --clean    Supprime les fichiers temporaires PUIS compilation"
    echo "  --clear    Supprime les fichiers temporaires SANS compilation"
    echo "  --bib      Gère la compilation avec une bibliographie (bibtex + recompilations)"
    echo "  --help     Affiche ce message d'aide"
    exit 0
}

# TODO: proposer une compilation avec luatex

if [ "$1" = "--help" ]; then
    print_help
fi

if [ "$1" = "--clear" ]; then
    echo "Nettoyage des fichiers temporaires..."
    rm -rf "$BUILDDIR"
    exit 0
fi

if [ -z "$1" ]; then
    echo "Erreur : aucun fichier fourni."
    echo "Utilisez --help pour voir les options disponibles."
    exit 1
fi

TEXFILE="$1"

if [ "${TEXFILE##*.}" != "tex" ]; then
    echo "Erreur : le fichier doit avoir une extension .tex"
    exit 1
fi

if [ ! -f "$TEXFILE" ]; then
    echo "Erreur : le fichier $TEXFILE n'existe pas."
    exit 1
fi

BASENAME=$(basename "$TEXFILE" .tex)  
BUILDDIR=".build"
DOUBLE_COMPILE=false
CLEAN=false
CLEAR=false
BIBLIO=false

shift  
while [ "$#" -gt 0 ]; do
    case "$1" in
        --double) DOUBLE_COMPILE=true ;;
        --clean) CLEAN=true ;;
        --bib) BIBLIO=true ;;
        *) echo "Option inconnue : $1"; exit 1 ;;
    esac
    shift
done



if [ "$CLEAN" = true ]; then
    echo "Nettoyage des fichiers temporaires..."
    rm -rf "$BUILDDIR"
fi

# Créer le dossier de compilation
mkdir -p "$BUILDDIR"

run_pdflatex() {
    pdflatex -output-directory="$BUILDDIR" "$TEXFILE" 
    if [ $? -ne 0 ]; then
        echo "Erreur : échec de la compilation LaTeX."
        exit 2
    fi
}

run_bibtex() {
    # Chercher un fichier .bib dans le répertoire racine
    BIB_FILE=$(find "$BUILDDIR" -maxdepth 1 -name "*.bib" -print -quit)

    if [ -z "$BIB_FILE" ]; then
        echo "Erreur : aucun fichier .bib trouvé dans le répertoire $BUILDDIR."
        exit 3
    fi

    if [ ! -f "$BUILDDIR/$BASENAME.aux" ]; then
        echo "Erreur : le fichier .aux $BUILDDIR/$BASENAME.aux n'existe pas."
        exit 3
    fi

    bibtex "$BUILDDIR/$BASENAME"
    if [ $? -ne 0 ]; then
        echo "Erreur : échec de la compilation de la bibliographie."
        exit 3
    fi
}



# 1ere compilation
run_pdflatex

if [ "$BIBLIO" = true ]; then
    run_bibtex
    # Deux nouvelles compilations pour mettre à jour les références
    run_pdflatex
    run_pdflatex
fi

if [ "$DOUBLE_COMPILE" = true ] && [ "$BIBLIO" = false ]; then
    run_pdflatex
fi

if [ ! -f "$BUILDDIR/$BASENAME.pdf" ]; then
    echo "Erreur : la compilation a échoué."
    exit 4
fi

# Déplacer le PDF final à la racine
mv "$BUILDDIR/$BASENAME.pdf" .

echo "Compilation terminée avec succès."
