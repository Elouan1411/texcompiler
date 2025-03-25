# Nom du fichier script
SCRIPT_NAME=texcompiler.sh
DESTINATION=/usr/local/bin/texcompiler

# Règle par défaut
all: install

install: $(SCRIPT_NAME)
		sudo cp $(SCRIPT_NAME) $(DESTINATION)
		sudo chmod +x $(DESTINATION)
		@echo "Script installé et exécutable à $(DESTINATION)"

uninstall:
		sudo rm -f $(DESTINATION)
		@echo "Script supprimé de $(DESTINATION)"