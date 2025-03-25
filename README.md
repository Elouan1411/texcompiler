# Projet de Compilation LaTeX Automatisée

Ce projet permet d'automatiser la compilation de documents LaTeX en utilisant un script shell. Il prend en charge la gestion des bibliographies et des fichiers temporaires, avec la possibilité d'effectuer une double compilation ou de nettoyer les fichiers temporaires.

## Dépendances

Avant de pouvoir utiliser ce projet, vous devez avoir les outils suivants installés sur votre machine :

- `pdflatex` (partie du paquet TeX Live ou MikTeX)
- `bibtex` (pour la gestion des bibliographies)
- `make` (pour l'automatisation de l'installation et de la désinstallation)

Sur une machine Ubuntu, vous pouvez installer les dépendances nécessaires avec les commandes suivantes :

```bash
sudo apt update
sudo apt install texlive-base texlive-bibtex make
```

## Installation

Pour installer le script et le rendre exécutable dans votre répertoire `/usr/local/bin`, suivez ces étapes :

1. Clonez ce dépôt dans votre répertoire de travail.
2. Ouvrez un terminal et naviguez jusqu'à votre répertoire de projet.
3. Exécutez la commande suivante pour installer le script :

```bash
make install
```

Cela va copier le fichier `texcompiler.sh` dans `/usr/local/bin/texcompiler`, lui attribuer les permissions d'exécution, et le rendre disponible en tant que commande globale.

### Commandes disponibles

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

## Fonctionnement du script

Le script effectue les étapes suivantes lors de la compilation :

1. Vérifie que le fichier `.tex` existe et a la bonne extension.
2. Si l'option `--clean` ou `--clear` est choisie, les fichiers temporaires sont supprimés.
3. Crée un répertoire temporaire `.build` pour stocker les fichiers compilés.
4. Exécute `pdflatex` pour compiler le fichier `.tex`.
5. Si l'option `--bib` est activée, le script exécutera `bibtex` pour gérer les bibliographies, puis effectuera deux compilations supplémentaires pour mettre à jour les références.
6. Si l'option `--double` est activée, une seconde compilation de `pdflatex` est effectuée.
7. Finalement, le PDF est déplacé à la racine du projet.
