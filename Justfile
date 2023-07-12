# Deploy local changes to production
deploy : build link-check-internal
    wrangler pages deploy public
    @echo
    @echo '✨ Production site: https://kinkscene.xyz'

# Build a production bundle
build : clean
    hugo-obsidian -input=content -output=assets/indices -index -root=.
    hugo --minify

# Install dependencies required to build/deploy
setup :
    pip install LinkChecker
    npm install -g wrangler
    go install github.com/jackyzha0/hugo-obsidian@latest
    brew install hugo watchexec

[private]
_linkcheck ARGS='':
    cd public && find . -name '*.html' | linkchecker \
        --ignore-url='https://github.com/kinkscene.*' \
        --ignore-url='https://archive.is/.*' \
        --stdin \
        --recursion-level=1 \
        {{ARGS}}

# Build production bundle and verify internal links are valid
link-check-internal : build _linkcheck

# Build production bundle and verify all links are valid
link-check-all : build (_linkcheck '--check-extern')

# Delete existing build artifacts
clean :
    rm -rf public assets/indices/*.json

# Build a production bundle and serve it locally
serve-prod-bundle : build
    python3 -m http.server -d public

# Build a production bundle and output a zipfile
zip : build
    zip -r kinkscene.zip public

# Run auto-refreshing dev server
dev :
    watchexec -r -w content just serve-prod-bundle
