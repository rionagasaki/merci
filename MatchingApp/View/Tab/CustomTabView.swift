//
//  CustomTabBar.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/05/04.
//

import SwiftUI

struct CustomTabView: View {
    
    enum Presentation: View, Hashable, Identifiable {
        var id: Self {
            
            return self
        }
        case cardList
        case addCard
        var body: some View {
            switch self {
            case .cardList: return AnyView(CardView())
            case .addCard: return AnyView(DateView())
            }
        }
    }
    
    @Binding var selectedTab:Tab
    @Binding var navigationTitle:String
    @State var presentation: Presentation?
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
                    if index == 1 {
                        withAnimation {
                            isOpen.toggle()
                        }
                    } else {
                        self.selectedTab = tabItems[index].tab
                        self.navigationTitle =
                        tabItems[index].tab.rawValue
                    }
                } label: {
                    if index == 1 {
                        ZStack {
                            if isOpen {
                                HStack {
                                    Button {
                                        presentation = .cardList
                                    } label: {
                                        Image(systemName: "hand.draw")
                                            .resizable()
                                            .scaledToFit()
                                            .padding()
                                            .foregroundColor(.black)
                                            .frame(width: 60, height: 60)
                                            .background(.yellow)
                                            .clipShape(Circle())
                                            .shadow(radius: 10)
                                    }
                                    .offset(CGSize(width: -30, height: -50))
                                    
                                    Button {
                                        presentation = .addCard
                                    } label: {
                                        Image(systemName: "list.bullet.rectangle.portrait")
                                            .resizable()
                                            .scaledToFit()
                                            .padding()
                                        
                                            .foregroundColor(.black)
                                            .frame(width: 60, height: 60)
                                            .background(.yellow)
                                            .clipShape(Circle())
                                            .shadow(radius: 10)
                                    }
                                    .offset(CGSize(width:30, height: -50))
                                }
                            }
                            
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
                .fullScreenCover(item: $presentation) { $0 }
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
