//
//  CustomTabBar.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/05/04.
//

import SwiftUI

struct CustomTabView: View {
    @EnvironmentObject var userModel: UserObservableModel
    @EnvironmentObject var appState: AppState
    @Binding var selectedTab:Tab
    @State var isPostCreateModal: Bool = false
    let UIIFGeneratorMedium = UIImpactFeedbackGenerator(style: .medium)
    
    var body: some View {
        VStack(spacing: .zero){
            Spacer()
            HStack{
                Spacer()
                ForEach(tabItems.indices, id: \.self) { index in
                    if tabItems[index].tab == .post {
                        Button {
                            UIIFGeneratorMedium.impactOccurred()
                            self.isPostCreateModal = true
                        } label: {
                            Image(systemName: tabItems[index].menuImage)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 48, height: 48)
                                .foregroundColor(.customBlack)
                                .font(.body.bold())
                                .padding(.bottom, 16)
                        }
                    } else {
                        VStack(spacing:0){
                            ZStack(alignment: .topTrailing){
                                Image(systemName: tabItems[index].tab == selectedTab ? tabItems[index].selectedMenuImage: tabItems[index].menuImage)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 24, height: 24)
                                    .foregroundColor(tabItems[index].tab == selectedTab ? .customBlack: .gray)
                                if appState.tabWithNotice.contains(tabItems[index].tab){
                                    Circle()
                                        .foregroundColor(.pink)
                                        .frame(width: 10, height: 10)
                                        .overlay {
                                            Circle()
                                                .stroke(.white, lineWidth: 2)
                                        }
                                }
                            }
                        }
                        .onTapGesture {
                            UIIFGeneratorMedium.impactOccurred()
                            self.selectedTab = tabItems[index].tab
                        }
                    }
                    Spacer()
                }
            }
        }
        .frame(height: 50)
        .background(Color.white.frame(height: 50))
        .fullScreenCover(isPresented: $isPostCreateModal) {
            CreatePostView(user: userModel)
        }
        .onAppear {
            
        }
    }
}

struct CustomTabView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
