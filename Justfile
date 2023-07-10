# Deploy local changes to production
deploy : build
    wrangler pages deploy public
    @echo
    @echo '✨ Production site: https://kinkscene.xyz'

# Build a production bundle
build :
    hugo-obsidian -input=content -output=assets/indices -index -root=.
    hugo --minify

# Build a production bundle and serve it locally
serve-prod-bundle : build
    python3 -m http.server -d public

# Build a production bundle and output a zipfile
zip : build
    zip -r kinkscene.zip public

# Run auto-refreshing dev server
dev :
    make serve
