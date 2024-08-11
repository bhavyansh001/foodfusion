// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
// document.addEventListener('turbolinks:load', () => {
    const searchInput = document.getElementById('restaurantSearch');
    const restaurantList = document.getElementById('restaurantList');
    const restaurants = restaurantList.getElementsByClassName('restaurant-item');
  
    searchInput.addEventListener('input', function() {
      const searchTerm = this.value.toLowerCase();
      Array.from(restaurants).forEach((restaurant) => {
        const name = restaurant.getElementsByTagName('h2')[0].textContent.toLowerCase();
        if (name.includes(searchTerm)) {
          restaurant.style.display = '';
        } else {
          restaurant.style.display = 'none';
        }
      });
    });
//   });