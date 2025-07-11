# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers", preload: false
pin_all_from "app/javascript/misc", under: "misc"
pin "@github/webauthn-json", to: "@github--webauthn-json.js" # @2.1.1
pin "@rails/request.js", to: "@rails--request.js.js" # @0.0.11
pin "notyf" # @3.10.0
pin "morphdom" # @2.7.4
pin "@js-from-routes/client", to: "@js-from-routes--client.js" # @1.0.4
pin "@js-from-routes/core", to: "@js-from-routes--core.js" # @1.0.2
pin_all_from "app/javascript/api", under: "api", preload: false
pin "@hotwired/stimulus", to: "@hotwired--stimulus.js" # @3.2.2
