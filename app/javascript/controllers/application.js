import { Application } from "@hotwired/stimulus"

const application = Application.start()

// Configure Stimulus development experience
application.debug = false
window.Stimulus   = application

export { application }

// TODO: Added by me, not sure if it's the best place!
import Clipboard from 'stimulus-clipboard'
application.register('clipboard', Clipboard)
