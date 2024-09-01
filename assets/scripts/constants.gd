extends Node

# Some global constant values. Speeds are expressed in seconds
const HUMAN_ANIMATION_SPEED = 0.5

enum Direction {
	LEFT,
	RIGHT,
	UP,
	DOWN,
	INVALID,
}

enum FoodType {
	BURGER,
	SWEET,
	FRUIT,
	MAIN,
	SOUP,
	VEGETABLE
}

# These should appear in the order that they show up
# inside the assets/ingredients folder
var ingredients = [
	{
		"name": "Vanilla Stick"
	},
	{
		"name": "Tomatoes"
	},
	{
		"name": "Corn"
	},
	{
		"name": "Sugar"
	},
	{
		"name": "Rosemary"
	},
	{
		"name": "Rice"
	},
	{
		"name": "Rubarb"
	},
	{
		"name": "Potatoes"
	},
	{
		"name": "Pineapple"
	},
	{
		"name": "Peas"
	},
	{
		"name": "Pasta"
	},
	{
		"name": "Parsley"
	},
	{
		"name": "Onions"
	},
	{
		"name": "Oil"
	},
	{
		"name": "Nutmeg"
	},
	{
		"name": "?"
	},
	{
		"name": "Minced Meat"
	},
	{
		"name": "Lettuce"
	},
	{
		"name": "Horseradish"
	},
	{
		"name": "Garlic"
	},
	{
		"name": "Flour"
	},
	{
		"name": "Eggs"
	},
	{
		"name": "Eggplant"
	},
	{
		"name": "Cucumber"
	},
	{
		"name": "Cream"
	},
	{
		"name": "?"
	},
	{
		"name": "Cinammon"
	},
	{
		"name": "Chocolate"
	},
	{
		"name": "Chili"
	},
	{
		"name": "Chicken"
	},
	{
		"name": "Butter"
	},
	{
		"name": "Beet Root"
	},
	{
		"name": "Beans"
	},
	{
		"name": "?"
	},
	{
		"name": "Beacon"
	},
	{
		"name": "Peppers"
	},
	{
		"name": "?"
	},
	{
		"name": "?"
	},
	{
		"name": "Turkey mix"
	},
	{
		"name": "?"
	},
	{
		"name": "Strawberries"
	},
	{
		"name": "?"
	},
	{
		"name": "?"
	},
	{
		"name": "Oranges"
	},
	{
		"name": "Milk"
	},
	{
		"name": "?"
	},
	{
		"name": "Duck"
	},
	{
		"name": "Cookies"
	},
	{
		"name": "Cocktail Cherry"
	},
	{
		"name": "Cherries"
	},
	{
		"name": "Carrots"
	},
	{
		"name": "Butter"
	},
	{
		"name": "Dough mix"
	}
]

# These items should appear in the order that they need
# to show up in the recipes book. 
var food = [
	{
		"name": "Salad",
		"pre_time": 180,
		"price": 24,
		"xp": 5,
		"servings": 10,
		"type": FoodType.VEGETABLE,
		"ingredients": [[1, 1], [12, 1], [18, 1]],
		"spice": [11, 1]
	},
	{
		"name": "Omelette",
		"pre_time": 60,
		"price": 100,
		"xp": 2,
		"servings": 5,
		"type": FoodType.VEGETABLE,
		# Ingredients will be provided as touples of type and quanitity
		"ingredients": [[22, 1]],
		"spice": [29, 1]
	},
	{
		"name": "Tomato Soup",
		"pre_time": 600,
		"price": 14,
		"xp": 14,
		"servings": 40,
		"type": FoodType.SOUP,
		"ingredients": [[1, 1], [12, 1], [25, 1]],
		"spice": [11, 1]
	},
	{
		"name": "Mousse au chocolat",
		"pre_time": 10800,
		"price": 4,
		"xp": 259,
		"servings": 390,
		"type": FoodType.SWEET,
		"ingredients": [[22, 1], [28, 1], [25, 1]],
		"spice": [0, 1]
	},
	{
		"name": "Spaghetti bolognese",
		"pre_time": 32400,
		"price": 1,
		"xp": 624,
		"servings": 1040,
		"type": FoodType.MAIN,
		"ingredients": [[10, 1], [16, 1], [1, 1]],
		"spices": [],
	},
	{
		"name": "Hamburger",
		"pre_time": 3600,
		"price": 7,
		"xp": 97,
		"servings": 130,
		"type": FoodType.BURGER,
		"ingredients": [[16, 1], [1, 1], [21, 1]],
		"spices": [],
	},
	{
		"name": "Cheese Dish",
		"pre_time": 10800,
		"price": 3,
		"xp": 287,
		"servings": 390,
		"type": FoodType.VEGETABLE,
		"ingredients": [[31, 3]],
		"spices": [],
	}
]
