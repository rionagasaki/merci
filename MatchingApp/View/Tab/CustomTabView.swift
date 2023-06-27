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
    let UIIFGeneratorMedium = UIImpactFeedbackGenerator(style: .light)
    
    var body: some View {
        HStack{
            Spacer()
            ForEach(tabItems.indices, id: \.self) { index in
                Button {
                        UIIFGeneratorMedium.impactOccurred()
                        self.selectedTab = tabItems[index].tab
                        self.navigationTitle =
                        tabItems[index].tab.rawValue
                    
                } label: {
                    VStack(spacing:0){
                        Image(systemName: tabItems[index].tab == selectedTab ? tabItems[index].selectedMenuImage: tabItems[index].menuImage).foregroundColor(tabItems[index].tab == selectedTab ? .black: .gray).font(.body.bold()).frame(width: 44, height: 29)
                        
                        Text(tabItems[index].menuTitle).foregroundColor(tabItems[index].tab == selectedTab ? .black: .gray).font(.caption2).lineLimit(1)
                    }
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
