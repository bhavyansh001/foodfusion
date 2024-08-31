import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["message"]

  connect() {
    console.info("Flash controller connected!")
    this.messageTargets.forEach(message => {
      setTimeout(() => this.show(message), 100)
      setTimeout(() => this.close(message), 5000)
    })
  }

  show(message) {
    message.classList.remove('translate-x-full', 'opacity-0')
  }

  close(event) {
    const message = event.target ? event.target.closest('[data-flash-target="message"]') : event
    message.classList.add('opacity-0', 'translate-x-full')
    setTimeout(() => {
      message.remove()
      if (this.messageTargets.length === 0) {
        this.element.remove()
      }
    }, 500)
  }
}