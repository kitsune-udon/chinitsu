test -e public && rm -rf public && mkdir public
elm make src/Main.elm --optimize --output public/main.js
cp img public/
cp index.html public/index.html