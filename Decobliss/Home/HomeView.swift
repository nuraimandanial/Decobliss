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
    @State var bannerIndex: Int = 0
    let timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
    
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
                        TabView(selection: $bannerIndex) {
                            ForEach(0..<3) { index in
                                Image("homeview-\(index + 1)")
                                    .resizable().scaledToFit()
                                    .clipShape(RoundedRectangle(cornerRadius: 20))
                                    .tag(index)
                            }
                        }
                        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                        .frame(height: 200)
                        .onReceive(timer, perform: { _ in
                            withAnimation {
                                bannerIndex = (bannerIndex + 1) % 3
                            }
                        })
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
                                    ExploreView(category: cat)
                                        .environmentObject(appModel)
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
                    
                    if !products.isEmpty {
                        ScrollView(.horizontal, showsIndicators: false) {
                            LazyHGrid(rows: [GridItem()], spacing: 15) {
                                ForEach($products) { $product in
                                    NavigationLink(destination: {
                                        ProductDetail(product: $product)
                                            .environmentObject(appModel)
                                    }, label: {
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 10)
                                                .foregroundStyle(.white)
                                            VStack {
                                                if !product.images.isEmpty {
                                                    AsyncImage(url: URL(string: product.images[0])) { result in
                                                        switch result {
                                                        case .empty:
                                                            ProgressView()
                                                        case .success(let image):
                                                            image
                                                                .resizable().scaledToFill()
                                                                .frame(width: 140, height: 140)
                                                                .clipShape(TopRoundedRectangle(radius: 10))
                                                        case .failure(_):
                                                            if product.images[0] != "" {
                                                                Image(product.images[0])
                                                                    .resizable().scaledToFill()
                                                                    .frame(width: 140, height: 140)
                                                                    .clipShape(TopRoundedRectangle(radius: 10))
                                                            }
                                                            else {
                                                                Placeholder(width: 140, height: 140)
                                                            }
                                                        @unknown default:
                                                            fatalError()
                                                        }
                                                    }
                                                }
                                                VStack(alignment: .leading) {
                                                    Text(product.name)
                                                        .font(.callout)
                                                        .bold()
                                                        .multilineTextAlignment(.leading)
                                                    Text("\(product.price, format: .currency(code: "MYR"))")
                                                        .font(.caption)
                                                    StarRating(rating: product.rating)
                                                }
                                                .padding(10)
                                            }
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(.black, lineWidth: 1)
                                        }
                                        .padding(5)
                                        .frame(width: 140)
                                        .foregroundStyle(.blacky)
                                    })
                                }
                            }
                            .padding(.leading)
                        }
                        .frame(height: 240)
                    } else {
                        Text("Error fetching products!")
                    }
                    
                    Spacer()
                }
            }
            .navigationBarBackButtonHidden()
            .task {
                products = appModel.dataManager.allProducts()
            }
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(AppModel())
}
