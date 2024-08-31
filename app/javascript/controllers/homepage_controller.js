import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "restaurantList", "restaurantItem" ]

  connect() {
    console.warn("Homepage controller connected");
  }

  search(event) {
    const query = event.target.value.toLowerCase();
    
    this.restaurantItemTargets.forEach((item) => {
      const name = item.querySelector('h2').textContent.toLowerCase();
      if (name.includes(query)) {
        item.style.display = ''
      } else {
        item.style.display = 'none'
      }
    })
  }
}