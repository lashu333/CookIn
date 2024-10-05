//
//  RecipeListView.swift
//  CookIn
//
//  Created by Lasha Tavberidze on 05.10.24.
//

import SwiftUI

struct RecipeFormView: View {
    let recipe: Recipe
    
    var body: some View {
        Form {
            Section(header: Text("Main Information")) {
                VStack(alignment: .leading) {
                    Text(recipe.mainInformation.name)
                        .font(.title)
                    Text("By \(recipe.mainInformation.author)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Text(recipe.mainInformation.description)
                        .padding(.top, 2)
                    Text("Category: \(recipe.mainInformation.category.rawValue)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.vertical, 8)
            }
            
            Section(header: Text("Ingredients")) {
                ForEach(recipe.ingredients) { ingredient in
                    Text(ingredient.description)
                }
            }
            
            Section(header: Text("Directions")) {
                ForEach(recipe.directions) { direction in
                    HStack {
                        if direction.isOptional {
                            Text("(Optional)")
                                .italic()
                                .foregroundColor(.secondary)
                        }
                        Text(direction.description)
                    }
                }
            }
        }
        .navigationTitle("Recipe Details")
    }
}

#Preview {
    NavigationView {
        RecipeFormView(recipe: Recipe.sampleRecipe)
    }
}
