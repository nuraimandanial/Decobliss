//
//   CategoryPicker.swift
//   Decobliss
//
//   Created by @kinderBono on 28/05/2024.
//   

import SwiftUI

struct CategoryPicker: View {
    @StateObject var categoryManager = CategoryManager(categories: Category.allCategory)
    
    @Binding var selectedCategories: [Category]
    @State var showDropdown: Bool = false
    
    var categories: String {
        selectedCategories = categoryManager.getSelectedCategories()
        return categoryManager.getSelectedCategories().map { $0.type }.joined(separator: ", ")
    }
    
    var body: some View {
        VStack(spacing: 5) {
            Button(action: {
                showDropdown.toggle()
            }, label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundStyle(.white)
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.blacky, lineWidth: 1)
                    HStack {
                        Text(categories != "" ? "[\(categories)]" : "Select Category")
                        Spacer()
                        Image(systemName: showDropdown ? "chevron.up" : "chevron.down")
                            .foregroundStyle(.yellows)
                    }
                    .padding()
                    .foregroundStyle(.blacky)
                }
                .frame(height: 60)
            })
            
            if showDropdown {
                ScrollView {
                    VStack(alignment: .leading, spacing: 10) {
                        Divider()
                        ForEach(categoryManager.categories) { cat in
                            Button(action: {
                                categoryManager.toggleSelection(for: cat)
                            }, label: {
                                HStack {
                                    Text(cat.type)
                                    Spacer()
                                    if categoryManager.selectedCategories.contains(cat.id) {
                                        Image(systemName: "checkmark")
                                    }
                                }
                            })
                            .foregroundStyle(.blacky)
                            
                            Divider()
                        }
                        
                        HStack {
                            TextField("New Category", text: $categoryManager.newCategoryType)
                            Button(action: {
                                categoryManager.addCategory()
                            }, label: {
                                Image(systemName: "plus")
                            })
                        }
                    }
                    .padding(.horizontal)
                }
                .frame(height: 80)
            } else {
                Spacer().frame(height: 80)
            }
            Spacer()
        }
    }
}

#Preview {
    CategoryPicker(selectedCategories: .constant([]))
        .environmentObject(AppModel())
}
