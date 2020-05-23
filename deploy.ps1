if (Test-Path public) {
    rm -R -Force public
    mkdir public
}
elm make src/Main.elm --optimize --output public/main.js
cp -R img public/
cp index.html public/index.html