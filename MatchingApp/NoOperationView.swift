//
//  NoOperationView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/06/02.
//

import SwiftUI

struct NoOperationView: View {
    var body: some View {
        VStack {
           
            Image(systemName: "heart.square")
                .resizable()
                .frame(width: 120, height: 120)
                .foregroundColor(.customGreen)
            Text("現在マッチング中です！")
                .bold()
                .font(.system(size: 25))
            Text("ページを表示するためには、マッチングを解除させる必要があります。")
                .font(.system(size: 16, weight: .light))
                .foregroundColor(.black)
        }
        .padding(.horizontal, 16)
    }
}

struct NoOperationView_Previews: PreviewProvider {
    static var previews: some View {
        NoOperationView()
    }
}
