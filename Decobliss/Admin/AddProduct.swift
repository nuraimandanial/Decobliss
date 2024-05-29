//
//   AddProduct.swift
//   Decobliss
//
//   Created by @kinderBono on 28/05/2024.
//   

import SwiftUI
import PhotosUI

struct AddProduct: View {
    @EnvironmentObject var appModel: AppModel
    @Environment(\.dismiss) var dismiss
    
    @State var product: Product = .init(name: "", price: 0)
    @State var price: String = ""
    @State var selectedItems: [PhotosPickerItem] = []
    @State var selectedImagesData: [Data] = []
    
    @State var alert: Bool = false
    @State var alertMessage: String = ""
    @State var success: Bool = false
    
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
                        .alert(isPresented: $alert) {
                            Alert(title: Text(""), message: Text(alertMessage), dismissButton: .default(Text("OK"), action: {
                                if success {
                                    dismiss()
                                }
                            }))
                        }
                        
                        Spacer()
                    }
                    .padding(.horizontal, 40)
                    .padding(.top)
                }
                .padding(.top)
            }
            .navigationBarBackButtonHidden()
            .toolbar {
                Toolbar(title: "Add Product")
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
        product.price = Float(price) ?? 0
        
        appModel.dataManager.addProduct(product, imageDatas: selectedImagesData) { error in
            if let error = error {
                alertMessage = "Error Adding Product: \(error.localizedDescription)"
            } else {
                alertMessage = "Product Added Successfully"
                success = true
            }
            alert = true
        }
    }
}

#Preview {
    AddProduct()
}
