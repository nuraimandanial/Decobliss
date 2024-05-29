//
//   EditProduct.swift
//   Decobliss
//
//   Created by @kinderBono on 28/05/2024.
//

import SwiftUI
import PhotosUI

struct EditProduct: View {
    @EnvironmentObject var appModel: AppModel
    
    @State var product: Product
    @State var price: String = ""
    @State var selectedItems: [PhotosPickerItem] = []
    @State var selectedImagesData: [Data] = []
    
    init(product: Product) {
        self._product = State(initialValue: product)
        self._price = State(initialValue: String(product.price))
        self._selectedImagesData = State(initialValue: product.images.compactMap { Data(base64Encoded: $0) })
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.whitey.ignoresSafeArea()
                
                VStack {
                    Divider()
                    
                    VStack(spacing: 20) {
                        if selectedImagesData.isEmpty {
                            PhotosPicker(selection: $selectedItems, maxSelectionCount: 5, matching: .images, label: {
                                HStack {
                                    Circle()
                                        .frame(width: 80)
                                        .overlay {
                                            Image(systemName: "plus")
                                                .imageScale(.large)
                                                .foregroundStyle(.blacky)
                                        }
                                }
                            })
                            .onChange(of: selectedItems) {
                                loadPhotos(from: selectedItems)
                            }
                        } else {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack {
                                    Spacer()
                                    ForEach(selectedImagesData, id: \.self) { data in
                                        if let uiImage = UIImage(data: data) {
                                            Image(uiImage: uiImage)
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 80, height: 80)
                                                .clipShape(Circle())
                                        }
                                    }
                                    if selectedImagesData.count < 5 {
                                        PhotosPicker(selection: $selectedItems, maxSelectionCount: 5, matching: .images, label: {
                                            HStack {
                                                Circle()
                                                    .frame(width: 80)
                                                    .overlay {
                                                        Image(systemName: "plus")
                                                            .imageScale(.large)
                                                            .foregroundStyle(.blacky)
                                                    }
                                            }
                                        })
                                        .onChange(of: selectedItems) {
                                            loadPhotos(from: selectedItems)
                                        }
                                    }
                                    Spacer()
                                }
                            }
                            .frame(height: 80)
                        }
                        
                        TextBox(hint: "Name", text: $product.name)
                        TextBox(hint: "Price", text: $price)
                        TextBox(hint: "Description", text: $product.description)
                        CategoryPicker(selectedCategories: $product.category)
                        
                        Spacer()
                        
                        Button(action: {
                            saveProduct()
                        }, label: {
                            ButtonLabel(text: "Save")
                                .padding(.horizontal, 20)
                        })
                        
                        Spacer()
                    }
                    .padding(.horizontal, 40)
                    .padding(.top)
                }
                .padding(.top)
            }
            .navigationBarBackButtonHidden()
            .toolbar {
                Toolbar(title: "Edit Product")
            }
        }
    }
    
    private func loadPhotos(from items: [PhotosPickerItem]) {
        selectedImagesData = []
        for item in items {
            item.loadTransferable(type: Data.self) { result in
                switch result {
                case .success(let data):
                    if let data = data {
                        selectedImagesData.append(data)
                    }
                case .failure(let error):
                    print("Error loading image: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func saveProduct() {
        
    }
}

#Preview {
    EditProduct(product: .init(name: "Chair", price: 20))
}
