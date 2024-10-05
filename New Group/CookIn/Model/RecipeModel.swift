import Foundation

struct Recipe: Identifiable, Codable {
    let id: UUID
    var mainInformation: MainInformation
    var ingredients: [Ingredient]
    var directions: [Direction]
    
    init(id: UUID = UUID(), mainInformation: MainInformation, ingredients: [Ingredient], directions: [Direction]) {
        self.id = id
        self.mainInformation = mainInformation
        self.ingredients = ingredients
        self.directions = directions
    }
}


struct MainInformation: Codable {
    var name: String
    var description: String
    var author: String
    var category: Category
    
    enum Category: String, Codable, CaseIterable {
        case breakfast = "Breakfast"
        case lunch = "Lunch"
        case dinner = "Dinner"
        case dessert = "Dessert"
    }
}

struct Direction: Identifiable, Codable {
    let id: UUID
    var description: String
    var isOptional: Bool
    
    init(id: UUID = UUID(), description: String, isOptional: Bool) {
        self.id = id
        self.description = description
        self.isOptional = isOptional
    }
}

struct Ingredient: Identifiable, Codable {
    let id: UUID
    var name: String
    var quantity: Double
    var unit: Unit
    
    init(id: UUID = UUID(), name: String, quantity: Double, unit: Unit) {
        self.id = id
        self.name = name
        self.quantity = quantity
        self.unit = unit
    }
    
    enum Unit: String, Codable, CaseIterable {
        case oz = "Ounces"
        case g = "Grams"
        case cups = "Cups"
        case tbs = "Tablespoons"
        case tsp = "Teaspoons"
        case none = "No units"
        
        var singularName: String {
            self == .none ? "" : String(rawValue.dropLast())
        }
    }
}


extension Ingredient {
    var description: String {
        let formattedQuantity = quantity.truncatingRemainder(dividingBy: 1) == 0 ?
            String(format: "%.0f", quantity) : String(format: "%.1f", quantity)
        
        switch unit {
        case .none:
            let formattedName = quantity == 1 ? name : "\(name)s"
            return "\(formattedQuantity) \(formattedName)"
        default:
            if quantity == 1 {
                return "1 \(unit.singularName) \(name)"
            } else {
                return "\(formattedQuantity) \(unit.rawValue) \(name)"
            }
        }
    }
}


class RecipeStorage {
    static let shared = RecipeStorage()
    private let userDefaults = UserDefaults.standard
    private let recipesKey = "savedRecipes"
    
    var recipes: [Recipe] {
        get {
            guard let data = userDefaults.data(forKey: recipesKey),
                  let decodedRecipes = try? JSONDecoder().decode([Recipe].self, from: data) else {
                return []
            }
            return decodedRecipes
        }
        set {
            guard let encoded = try? JSONEncoder().encode(newValue) else { return }
            userDefaults.set(encoded, forKey: recipesKey)
        }
    }
    
    func addRecipe(_ recipe: Recipe) {
        var currentRecipes = recipes
        currentRecipes.append(recipe)
        recipes = currentRecipes
    }
    
    func deleteRecipe(at index: Int) {
        var currentRecipes = recipes
        currentRecipes.remove(at: index)
        recipes = currentRecipes
    }
    
    func updateRecipe(_ recipe: Recipe) {
        guard let index = recipes.firstIndex(where: { $0.id == recipe.id }) else { return }
        var currentRecipes = recipes
        currentRecipes[index] = recipe
        recipes = currentRecipes
    }
}


extension Recipe {
    static let sampleRecipe = Recipe(
        mainInformation: MainInformation(
            name: "Classic Margherita Pizza",
            description: "A simple yet delicious traditional Italian pizza",
            author: "Chef Antonio",
            category: .dinner
        ),
        ingredients: [
            Ingredient(name: "Pizza Dough", quantity: 1, unit: .none),
            Ingredient(name: "Tomato Sauce", quantity: 0.5, unit: .cups),
            Ingredient(name: "Fresh Mozzarella", quantity: 200, unit: .g),
            Ingredient(name: "Fresh Basil Leaves", quantity: 8, unit: .none),
            Ingredient(name: "Olive Oil", quantity: 2, unit: .tbs)
        ],
        directions: [
            Direction(description: "Preheat oven to 500°F (260°C)", isOptional: false),
            Direction(description: "Roll out the pizza dough", isOptional: false),
            Direction(description: "Spread tomato sauce evenly", isOptional: false),
            Direction(description: "Add torn mozzarella pieces", isOptional: false),
            Direction(description: "Bake for 12-15 minutes", isOptional: false),
            Direction(description: "Add fresh basil leaves and drizzle with olive oil", isOptional: false)
        ]
    )
}
