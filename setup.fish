#!/usr/bin/env fish

# Setup script to copy configuration files to their proper locations

# Copy tmux configuration
echo "Copying .tmux.conf to ~/.tmux.conf..."
cp .tmux.conf ~/.tmux.conf

# Create fish config directory if it doesn't exist
echo "Creating ~/.config/fish directories if needed..."
mkdir -p ~/.config/fish/functions
mkdir -p ~/.config/fish/themes

# Copy fish functions
echo "Copying fish functions..."
for f in fish/functions/*.fish
    cp $f ~/.config/fish/functions/
end

# Copy fish themes
echo "Copying fish themes..."
cp fish/themes/"Dracula Official.theme" ~/.config/fish/themes/

echo "All done."
