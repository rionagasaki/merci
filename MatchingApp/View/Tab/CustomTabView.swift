//
//  CustomTabBar.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/05/04.
//

import SwiftUI

struct CustomTabView: View {
    
    @Binding var selectedTab:Tab
    @Binding var navigationTitle:String
    @State var isOpen: Bool = false
    @State var swipeViewVisivle: Bool = false
    private var degress: Double {
        isOpen ? 45: 90
    }
    
    var body: some View {
        HStack{
            Spacer()
            ForEach(tabItems.indices, id: \.self) { index in
                Button {
                    if index == 2 {
                        isOpen = true
                    } else {
                        self.selectedTab = tabItems[index].tab
                        self.navigationTitle =
                        tabItems[index].tab.rawValue
                    }
                } label: {
                    if index == 2 {
                        ZStack {
                            Image(systemName: tabItems[index].selectedMenuImage)
                                .resizable()
                                .scaledToFit()
                                .rotationEffect(.degrees(degress))
                                .padding()
                                .foregroundColor(.white)
                                .frame(width: 50, height: 50)
                                .background(.black)
                                .clipShape(Circle())
                                .shadow(radius: 10)
                        }
                    } else {
                        VStack(spacing:0){
                            Image(systemName: tabItems[index].tab == selectedTab ? tabItems[index].selectedMenuImage: tabItems[index].menuImage).foregroundColor(tabItems[index].tab == selectedTab ? .black: .gray).font(.body.bold()).frame(width: 44, height: 29)
                            
                            Text(tabItems[index].menuTitle).foregroundColor(tabItems[index].tab == selectedTab ? .black: .gray).font(.caption2).lineLimit(1)
                        }
                    }
                }
                .fullScreenCover(isPresented: $isOpen) {
                    MakeRecuruitView()
                }
                Spacer()
            }
        }
        .background(.white)
    }
}

struct CustomTabView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
