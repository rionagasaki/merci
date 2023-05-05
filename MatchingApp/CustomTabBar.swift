//
//  CustomTabBar.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/05/04.
//

import SwiftUI

struct CustomTabBar: View {
    var body: some View {
        
        VStack {
            Spacer()
            GeometryReader { geometry in
                HStack {
                    VStack{
                        Image(systemName: "house")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                        Text("ホーム")
                    }.frame(width: geometry.size.width/3, height: 60)
                    Button {
                        print("aaaa")
                    } label: {
                        ZStack{
                            Circle()
                                .frame(width: 68, height: 68)
                                .foregroundColor(.purple)
                                
                            
                            Image(systemName: "plus")
                                .resizable()
                                .foregroundColor(.white)
                                .frame(width: 30, height: 30)
                                .padding()
                                .overlay {
                                    Circle()
                                        .stroke(Color.white, lineWidth: 2)
                                }
                                
                        }
                        .shadow(radius: 10)
                        .padding(.bottom, 50).frame(width: geometry.size.width/3,height: 60)
                    }

                    VStack{
                        Image(systemName: "person")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                        Text("マイページ")
                    }.frame(width: geometry.size.width/3)
                }
            }.frame(height: 120)
        }
        .frame(maxHeight: 500,alignment: .bottom)
    }
}

struct CustomTabBar_Previews: PreviewProvider {
    static var previews: some View {
        CustomTabBar()
    }
}
