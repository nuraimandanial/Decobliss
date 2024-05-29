//
//   ExploreView.swift
//   Decobliss
//
//   Created by @kinderBono on 27/05/2024.
//   

import SwiftUI

struct ExploreView: View {
    @EnvironmentObject var appModel: AppModel
    
    @State var searchText: String = ""
    
    @State var products: [Product] = []
    @State var categories: [Category] = Category.allCategory
    @State var category: Category?
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.whitey.ignoresSafeArea()
                
                VStack {
                    SearchBar(searchText: $searchText)
                        .environmentObject(appModel)
                        .padding(.horizontal)
                    
                    HStack {
                        Text("Category")
                            .bold()
                        Spacer()
                    }
                    .padding()
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(categories) { cat in
                                Button(action: {
                                    category = cat
                                    products = appModel.dataManager.allProducts().filterAndSort(by: category)
                                }, label: {
                                    VStack {
                                        Image(systemName: cat.image)
                                            .resizable().scaledToFit()
                                            .frame(width: 30, height: 30)
                                            .foregroundStyle(category == cat ? .yellows : .blacky)
                                        Text(cat.type)
                                            .font(.caption)
                                            .multilineTextAlignment(.center)
                                    }
                                    .frame(width: 80)
                                    .foregroundStyle(.blacky)
                                })
                            }
                        }
                    }
                    
                    HStack {
                        Text("Best Sellers")
                            .bold()
                        Spacer()
                    }
                    .padding()
                    
                    if !products.isEmpty {
                        ScrollView(.vertical, showsIndicators: false) {
                            ForEach(products) { product in
                                NavigationLink(destination: {
                                    ProductDetail(product: Binding(get: {product}, set: {_ in}))
                                }, label: {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 10)
                                            .foregroundStyle(.white)
                                        HStack(alignment: .top) {
                                            VStack(alignment: .leading) {
                                                Text(product.name)
                                                    .bold()
                                                    .multilineTextAlignment(.leading)
                                                Text("\(product.price, format: .currency(code: "MYR"))")
                                                StarRating(rating: product.rating)
                                            }
                                            .padding()
                                            Spacer()
                                            if !product.images.isEmpty {
                                                AsyncImage(url: URL(string: product.images[0])) { result in
                                                    switch result {
                                                    case .empty:
                                                        ProgressView()
                                                    case .success(let image):
                                                        image
                                                            .resizable().scaledToFill()
                                                            .frame(width: 140, height: 140)
                                                            .clipShape(RightRoundedRectangle(radius: 10))
                                                    case .failure(_):
                                                        if product.images[0] != "" {
                                                            Image(product.images[0])
                                                                .resizable().scaledToFill()
                                                                .frame(width: 140, height: 140)
                                                                .clipShape(RightRoundedRectangle(radius: 10))
                                                        }
                                                        else {
                                                            Placeholder(width: 140, height: 140)
                                                        }
                                                    @unknown default:
                                                        fatalError()
                                                    }
                                                }
                                            }
                                        }
                                        .foregroundStyle(.blacky)
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(.blacky, lineWidth: 1)
                                    }
                                    .padding(.horizontal)
                                    .padding(.vertical, 5)
                                })
                            }
                        }
                    } else {
                        Text("Error fetching products")
                        Spacer()
                    }
                }
                .padding(.top)
            }
            .navigationBarBackButtonHidden()
            .task {
                products = appModel.dataManager.allProducts().filterAndSort(by: category)
            }
            .toolbar {
                Toolbar(title: "Explore")
            }
        }
    }
}

#Preview {
    ExploreView()
        .environmentObject(AppModel())
}
