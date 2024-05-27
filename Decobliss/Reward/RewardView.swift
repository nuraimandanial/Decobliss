//
//   RewardView.swift
//   Decobliss
//
//   Created by @kinderBono on 27/05/2024.
//   

import SwiftUI

struct RewardView: View {
    @EnvironmentObject var appModel: AppModel
    @Environment(\.dismiss) var dismiss
    
    @State var user: User = .init()
    @State var categories: [Category] = []
    @State var category: Category = .all
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.whitey.ignoresSafeArea()
                
                VStack {
                    Divider()
                    
                    VStack(spacing: 20) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundStyle(.white)
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.blacky, lineWidth: 1)
                            VStack {
                                HStack {
                                    Text("\(user.points) points")
                                    Spacer()
                                }
                                RewardProgress(points: user.points)
                                    .padding(.trailing)
                            }
                            .padding()
                        }
                        .frame(height: 120)
                        
                        HStack {
                            Text("Category")
                                .font(.title2)
                                .bold()
                            Spacer()
                        }
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 10) {
                                ForEach(categories) { cat in
                                    Button(action: {
                                        category = cat
                                    }, label: {
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 10)
                                                .frame(height: 60)
                                                .foregroundStyle(category == cat ? .yellows : .gray.opacity(0.25))
                                            Text(cat.type)
                                                .font(.callout)
                                                .bold()
                                                .padding(.horizontal)
                                                .multilineTextAlignment(.center)
                                        }
                                        .frame(width: 100)
                                        .foregroundStyle(.black)
                                    })
                                }
                            }
                        }
                        
                        ScrollView(.vertical, showsIndicators: false) {
                            LazyVGrid(columns: [GridItem(), GridItem()]) {
                                ForEach(appModel.rewards.filterAndSort(by: category)) { reward in
                                    NavigationLink(destination: {
                                        
                                    }, label: {
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 10)
                                                .foregroundStyle(.white)
                                            VStack {
                                                Image(reward.image)
                                                    .resizable()
                                                    .scaledToFill()
                                            }
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(lineWidth: 1)
                                        }
                                        .padding(5)
                                        .foregroundStyle(.blacky)
                                    })
                                }
                            }
                        }
                    }
                    .padding([.horizontal, .top])
                }
                .padding(.top)
            }
            .navigationBarBackButtonHidden()
            .task {
                user = appModel.dataManager.currentUser
                categories = appModel.dataManager.categories
            }
            .toolbar {
                ToolbarUser(image: user.profile.details.image, name: user.profile.username)
            }
        }
    }
}

#Preview {
    RewardView()
        .environmentObject(AppModel())
}
