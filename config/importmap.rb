# Pin npm packages by running ./bin/importmap

pin 'application', preload: true
pin '@hotwired/turbo-rails', to: 'turbo.min.js', preload: true
pin '@hotwired/stimulus', to: 'stimulus.min.js', preload: true
pin '@hotwired/stimulus-loading', to: 'stimulus-loading.js', preload: true
pin_all_from 'app/javascript/controllers', under: 'controllers'
pin 'stimulus-clipboard', to: 'stimulus-clipboard.es.js'

# pin "stimulus-clipboard", to: "https://ga.jspm.io/npm:stimulus-clipboard@3.2.2/dist/stimulus-clipboard.es.js"
