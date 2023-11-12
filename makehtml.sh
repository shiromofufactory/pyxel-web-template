pyxel package ./app ./app/main.py
pyxel app2html app.pyxapp
rm -rf public/*
mv app.html public/index.html
OLD="<!DOCTYPE html>"
NEW="<!DOCTYPE html><meta name='viewport' content='width=512' /><link rel='manifest' href='/manifest.json' /><script> if ('serviceWorker' in navigator) navigator.serviceWorker.register('/sw.js')</script>"
OLD_ESCAPED=$(echo "$OLD" | sed 's/[\/&]/\\&/g')
NEW_ESCAPED=$(echo "$NEW" | sed 's/[\/&]/\\&/g')
sed -i '' "s/${OLD_ESCAPED}/${NEW_ESCAPED}/g" public/index.html
cp static/* public/
rm -f app.pyxapp
cd public
python3 -m http.server 8000