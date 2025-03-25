# Projet de Compilation LaTeX Automatisée

Ce projet permet d'automatiser la compilation de documents LaTeX en utilisant un script shell. Il prend en charge la gestion des bibliographies et des fichiers temporaires, avec la possibilité d'effectuer une double compilation ou de nettoyer les fichiers temporaires.

## Dépendances

Avant de pouvoir utiliser ce projet, vous devez avoir les outils suivants installés sur votre machine :

- `pdflatex` (partie du paquet TeX Live ou MikTeX)
- `bibtex` (pour la gestion des bibliographies)
- `make` (pour l'automatisation de l'installation et de la désinstallation)

## Installation

Pour installer le script et le rendre exécutable n'importe où, suivez ces étapes :

1. Clonez ce dépôt dans votre répertoire de travail.
2. Ouvrez un terminal et naviguez jusqu'à votre répertoire de projet.
3. Exécutez la commande suivante pour installer le script :

```bash
make install
```

Cela va copier le fichier `texcompiler.sh` dans `/usr/local/bin/texcompiler`, lui attribuer les permissions d'exécution, et le rendre disponible en tant que commande globale.

## Intégration avec LaTeX Workshop dans VS Code

Pour utiliser `texcompiler` directement depuis **LaTeX Workshop** dans **VS Code**, vous devez modifier votre fichier de configuration `settings.json`.

### Configuration de `LaTeX Workshop`

1. **Ouvrez VS Code**.
2. **Appuyez sur** `F1` et recherchez **"Open User Settings (JSON)"**.
3. **Ajoutez les lignes suivantes dans `settings.json`** :

```json
"latex-workshop.latex.recipes": [
    {
        "name": "Compiler avec texcompiler",
        "tools": ["texcompiler"]
    }
],

"latex-workshop.latex.tools": [
    {
        "name": "texcompiler",
        "command": "/usr/local/bin/texcompiler",
        "args": [
            "%DOCFILE%.tex"
        ]
    }
],
```

4. **Enregistrez et redémarrez VS Code**.

Cette configuration permet d'exécuter texcompiler directement depuis VS Code et de recompiler automatiquement vos documents LaTeX à chaque enregistrement (Ctrl + S) grâce à LaTeX Workshop.

## Commandes disponibles

Le script accepte les options suivantes :

- `--double` : Effectue une double compilation (utile si vous n'avez pas de bibliographie).
- `--clean` : Supprime les fichiers temporaires, puis effectue la compilation.
- `--clear` : Supprime les fichiers temporaires sans effectuer de compilation.
- `--bib` : Gère la compilation avec une bibliographie (bibtex + recompilations).
- `--help` : Affiche le message d'aide et les options disponibles.

### Exemple d'utilisation

Pour compiler un fichier LaTeX avec bibliographie :

```bash
texcompiler mon_document.tex --bib
```

Pour effectuer une double compilation sans bibliographie :

```bash
texcompiler mon_document.tex --double
```

Pour nettoyer les fichiers temporaires sans compilation :

```bash
texcompiler mon_document.tex --clear
```

## Désinstallation

Pour supprimer le script et le rendre inutilisable, exécutez simplement la commande suivante :

```bash
make uninstall
```

Cela supprimera le script de `/usr/local/bin`.
