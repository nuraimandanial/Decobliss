//
//   HomeView.swift
//   Decobliss
//
//   Created by @kinderBono on 27/05/2024.
//   

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var appModel: AppModel
    
    @State var searchText: String = ""
    
    @State var products: [Product] = []
    @State var categories: [Category] = Category.allCategory
    @State var selectedCategory: Category? = .init(type: "")
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.whitey.ignoresSafeArea()
                
                VStack {
                    SearchBar(searchText: $searchText)
                        .environmentObject(appModel)
                        .padding()
                    
                    HStack {
                        TabView {
                            ForEach(0..<3) { index in
                                Image("homeview-\(index + 1)")
                                    .resizable().scaledToFit()
                                    .clipShape(RoundedRectangle(cornerRadius: 20))
                                    .tag(index)
                            }
                        }
                        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                        .frame(height: 200)
                    }
                    .padding(.horizontal)
                    
                    HStack {
                        Text("Shop by Categories")
                            .bold()
                        Spacer()
                    }
                    .padding()
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(categories) { cat in
                                NavigationLink(destination: {
                                    
                                }, label: {
                                    VStack {
                                        Image(systemName: cat.image)
                                            .resizable().scaledToFit()
                                            .frame(width: 30, height: 30)
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
                        Text("Trending Items")
                            .bold()
                        Spacer()
                    }
                    .padding()
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHGrid(rows: [GridItem(), GridItem()], spacing: 20) {
                            ForEach($products) { $product in
                                NavigationLink(destination: {
                                    
                                }, label: {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 10)
                                            .foregroundStyle(.white)
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(.black, lineWidth: 1)
                                    }
                                })
                            }
                        }
                    }
                }
            }
            .navigationBarBackButtonHidden()
            .task {
                
            }
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(AppModel())
}
