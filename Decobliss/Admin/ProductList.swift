//
//   ProductList.swift
//   Decobliss
//
//   Created by @kinderBono on 28/05/2024.
//   

import SwiftUI

struct ProductList: View {
    @EnvironmentObject var appModel: AppModel
    
    @State var products: [Product] = []
    @State var selectedProduct: Product?
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.whitey.ignoresSafeArea()
                
                VStack {
                    Divider()
                    
                    VStack(spacing: 20) {
                        ForEach(products) { product in
                            NavigationLink(destination: {
                                EditProduct(product: product)
                            }, label: {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 10)
                                        .foregroundStyle(.white)
                                    HStack(spacing: 10) {
                                        if !product.images.isEmpty {
                                            AsyncImage(url: URL(string: product.images[0])) { result in
                                                switch result {
                                                case .empty:
                                                    ProgressView()
                                                case .success(let image):
                                                    image
                                                        .resizable().scaledToFill()
                                                        .frame(width: 80, height: 80)
                                                        .clipShape(LeftRoundedRectangle(radius: 10))
                                                case .failure(_):
                                                    if product.images[0] != "" {
                                                        Image(product.images[0])
                                                            .resizable().scaledToFill()
                                                            .frame(width: 80, height: 80)
                                                            .clipShape(LeftRoundedRectangle(radius: 10))
                                                    }
                                                    else {
                                                        Placeholder(width: 80, height: 80)
                                                    }
                                                @unknown default:
                                                    fatalError()
                                                }
                                            }
                                        }
                                        Text(product.name)
                                            .bold()
                                        Spacer()
                                    }
                                    .foregroundStyle(.blacky)
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(.blacky, lineWidth: 1)
                                }
                                .frame(height: 80)
                                .padding(.horizontal)
                            })
                        }
                        Spacer()
                    }
                    .padding([.horizontal, .top])
                }
                .padding(.top)
            }
            .navigationBarBackButtonHidden()
            .task {
                let sellerId = appModel.dataManager.currentUser.authId
                products = appModel.dataManager.productsForSeller(sellerId: sellerId)
            }
            .toolbar {
                Toolbar(title: "Products")
            }
        }
    }
}

#Preview {
    ProductList()
        .environmentObject(AppModel())
}
