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
                    Text("12ヶ月プラン")
                        .foregroundColor(.white)
                        .fontWeight(.heavy)
                        .font(.system(size: 30))
                        .bold()
                }
                .frame(width:150 ,height: 150)
                .background(Color.customRed1)
                
                Text("2000円")
            }
            
        }
        
        .cornerRadius(20)
    }
}

struct PriceListView_Previews: PreviewProvider {
    static var previews: some View {
        PriceListView()
    }
}
