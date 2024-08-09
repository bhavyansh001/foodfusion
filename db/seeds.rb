# Create Users
users = User.create!([
  {
    email: "john.doe@example.com",
    password: "password123",
    password_confirmation: "password123",
    role: :visitor
  },
  {
    email: "jane.smith@example.com",
    password: "password456",
    password_confirmation: "password456",
    role: :visitor
  },
  {
    email: "alice.johnson@example.com",
    password: "password789",
    password_confirmation: "password789",
    role: :owner
  },
  {
    email: "bob.brown@example.com",
    password: "password012",
    password_confirmation: "password012",
    role: :owner
  },
  {
    email: "charlie.davis@example.com",
    password: "password345",
    password_confirmation: "password345",
    role: :visitor
  }
])

# Create Restaurants
restaurants = Restaurant.create!([
  {
    name: "The Gourmet Kitchen",
    owner: users[2], # Alice Johnson
  },
  {
    name: "Sushi Paradise",
    owner: users[3], # Bob Brown
  },
  {
    name: "Pasta Heaven",
    owner: users[2], # Alice Johnson
  },
  {
    name: "Burger Empire",
    owner: users[3], # Bob Brown
  },
  {
    name: "Vegan Delight",
    owner: users[2], # Alice Johnson
  }
])

