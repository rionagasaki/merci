//
//  PriceListView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/05/08.
//

import SwiftUI

struct PriceListView: View {
    var body: some View {
        VStack {
            HStack {
                VStack {
                    Text("SALE")
                        .foregroundColor(.yellow)
                        .bold()
                        .font(.system(size: 20))
                    Text("200枚")
                        .foregroundColor(.white)
                        .fontWeight(.heavy)
                        .font(.system(size: 30))
                        .bold()
                }
                .frame(width:150 ,height: 150)
                .background(Color.customRed1)
                
                VStack {
                    Text("25,000円")
                        .foregroundColor(.black)
                        .fontWeight(.heavy)
                        .font(.system(size: 35))
                        .bold()
                    Text("15000円お得※")
                }
            }
            
        }
        .cornerRadius(20)
        .background {
            RoundedRectangle(cornerRadius: 20)
                .foregroundColor(.white)
                .shadow(radius: 2)
        }
    }
}

struct PriceListView_Previews: PreviewProvider {
    static var previews: some View {
        PriceListView()
    }
}
