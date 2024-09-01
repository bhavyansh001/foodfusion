# Create Users
users = [
  {
    email: 'john.doe@example.com',
    password: 'password123',
    password_confirmation: 'password123',
    role: :visitor
  },
  {
    email: 'jane.smith@example.com',
    password: 'password456',
    password_confirmation: 'password456',
    role: :visitor
  },
  {
    email: 'alice.johnson@example.com',
    password: 'password789',
    password_confirmation: 'password789',
    role: :owner
  },
  {
    email: 'bob.brown@example.com',
    password: 'password012',
    password_confirmation: 'password012',
    role: :owner
  },
  {
    email: 'charlie.davis@example.com',
    password: 'password345',
    password_confirmation: 'password345',
    role: :visitor
  }
]

users.each do |user_attrs|
  User.find_or_create_by!(email: user_attrs[:email]) do |user|
    user.password = user_attrs[:password]
    user.password_confirmation = user_attrs[:password_confirmation]
    user.role = user_attrs[:role]
  end
end

# Create Restaurants
restaurants = [
  {
    name: 'The Gourmet Kitchen',
    owner: User.find_by(email: 'alice.johnson@example.com')
  },
  {
    name: 'Sushi Paradise',
    owner: User.find_by(email: 'bob.brown@example.com')
  },
  {
    name: 'Pasta Heaven',
    owner: User.find_by(email: 'alice.johnson@example.com')
  },
  {
    name: 'Burger Empire',
    owner: User.find_by(email: 'bob.brown@example.com')
  },
  {
    name: 'Vegan Delight',
    owner: User.find_by(email: 'alice.johnson@example.com')
  }
]

restaurants.each do |restaurant_attrs|
  Restaurant.find_or_create_by!(name: restaurant_attrs[:name]) do |restaurant|
    restaurant.owner = restaurant_attrs[:owner]
  end
end

# Create Menus
menus = [
  { restaurant: Restaurant.find_by(name: 'The Gourmet Kitchen') },
  { restaurant: Restaurant.find_by(name: 'Sushi Paradise') },
  { restaurant: Restaurant.find_by(name: 'Pasta Heaven') },
  { restaurant: Restaurant.find_by(name: 'Burger Empire') },
  { restaurant: Restaurant.find_by(name: 'Vegan Delight') }
]

menus.each do |menu_attrs|
  Menu.find_or_create_by!(restaurant: menu_attrs[:restaurant])
end

# Create Menu Items
menu_items = [
  # The Gourmet Kitchen
  {
    name: 'Gourmet Salad',
    price: 12.99,
    availability: :available,
    menu: Menu.find_by(restaurant: Restaurant.find_by(name: 'The Gourmet Kitchen'))
  },
  {
    name: 'Gourmet Steak',
    price: 29.99,
    availability: :available,
    menu: Menu.find_by(restaurant: Restaurant.find_by(name: 'The Gourmet Kitchen'))
  },
  {
    name: 'Truffle Pasta',
    price: 24.99,
    availability: :available,
    menu: Menu.find_by(restaurant: Restaurant.find_by(name: 'The Gourmet Kitchen'))
  },
  {
    name: 'Lobster Bisque',
    price: 19.99,
    availability: :out_of_stock,
    menu: Menu.find_by(restaurant: Restaurant.find_by(name: 'The Gourmet Kitchen'))
  },
  {
    name: 'Chocolate Lava Cake',
    price: 8.99,
    availability: :available,
    menu: Menu.find_by(restaurant: Restaurant.find_by(name: 'The Gourmet Kitchen'))
  },
  # Sushi Paradise
  {
    name: 'Sushi Roll',
    price: 8.99,
    availability: :available,
    menu: Menu.find_by(restaurant: Restaurant.find_by(name: 'Sushi Paradise'))
  },
  {
    name: 'Sashimi Platter',
    price: 19.99,
    availability: :out_of_stock,
    menu: Menu.find_by(restaurant: Restaurant.find_by(name: 'Sushi Paradise'))
  },
  {
    name: 'Tempura',
    price: 11.99,
    availability: :available,
    menu: Menu.find_by(restaurant: Restaurant.find_by(name: 'Sushi Paradise'))
  },
  {
    name: 'Miso Soup',
    price: 4.99,
    availability: :available,
    menu: Menu.find_by(restaurant: Restaurant.find_by(name: 'Sushi Paradise'))
  },
  {
    name: 'Green Tea Ice Cream',
    price: 5.99,
    availability: :available,
    menu: Menu.find_by(restaurant: Restaurant.find_by(name: 'Sushi Paradise'))
  },
  # Pasta Heaven
  {
    name: 'Spaghetti Carbonara',
    price: 14.99,
    availability: :available,
    menu: Menu.find_by(restaurant: Restaurant.find_by(name: 'Pasta Heaven'))
  },
  {
    name: 'Lasagna',
    price: 16.99,
    availability: :available,
    menu: Menu.find_by(restaurant: Restaurant.find_by(name: 'Pasta Heaven'))
  },
  {
    name: 'Fettuccine Alfredo',
    price: 13.99,
    availability: :available,
    menu: Menu.find_by(restaurant: Restaurant.find_by(name: 'Pasta Heaven'))
  },
  {
    name: 'Pesto Pasta',
    price: 15.99,
    availability: :out_of_stock,
    menu: Menu.find_by(restaurant: Restaurant.find_by(name: 'Pasta Heaven'))
  },
  {
    name: 'Tiramisu',
    price: 7.99,
    availability: :available,
    menu: Menu.find_by(restaurant: Restaurant.find_by(name: 'Pasta Heaven'))
  },
  # Burger Empire
  {
    name: 'Classic Burger',
    price: 10.99,
    availability: :available,
    menu: Menu.find_by(restaurant: Restaurant.find_by(name: 'Burger Empire'))
  },
  {
    name: 'Cheeseburger',
    price: 11.99,
    availability: :available,
    menu: Menu.find_by(restaurant: Restaurant.find_by(name: 'Burger Empire'))
  },
  {
    name: 'Bacon Burger',
    price: 12.99,
    availability: :out_of_stock,
    menu: Menu.find_by(restaurant: Restaurant.find_by(name: 'Burger Empire'))
  },
  {
    name: 'Veggie Burger',
    price: 9.99,
    availability: :available,
    menu: Menu.find_by(restaurant: Restaurant.find_by(name: 'Burger Empire'))
  },
  {
    name: 'Fries',
    price: 3.99,
    availability: :available,
    menu: Menu.find_by(restaurant: Restaurant.find_by(name: 'Burger Empire'))
  },
  # Vegan Delight
  {
    name: 'Vegan Bowl',
    price: 9.99,
    availability: :available,
    menu: Menu.find_by(restaurant: Restaurant.find_by(name: 'Vegan Delight'))
  },
  {
    name: 'Vegan Smoothie',
    price: 7.99,
    availability: :out_of_stock,
    menu: Menu.find_by(restaurant: Restaurant.find_by(name: 'Vegan Delight'))
  },
  {
    name: 'Vegan Burger',
    price: 11.99,
    availability: :available,
    menu: Menu.find_by(restaurant: Restaurant.find_by(name: 'Vegan Delight'))
  },
  {
    name: 'Quinoa Salad',
    price: 8.99,
    availability: :available,
    menu: Menu.find_by(restaurant: Restaurant.find_by(name: 'Vegan Delight'))
  },
  {
    name: 'Avocado Toast',
    price: 6.99,
    availability: :available,
    menu: Menu.find_by(restaurant: Restaurant.find_by(name: 'Vegan Delight'))
  }
]

menu_items.each do |menu_item_attrs|
  MenuItem.find_or_create_by!(name: menu_item_attrs[:name], menu: menu_item_attrs[:menu]) do |menu_item|
    menu_item.price = menu_item_attrs[:price]
    menu_item.availability = menu_item_attrs[:availability]
  end
end
