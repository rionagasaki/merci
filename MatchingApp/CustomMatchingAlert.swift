//
//  CustomMatchingAlert.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/06/03.
//

import SwiftUI

struct CustomMatchingAlert: View {
    var body: some View {
        VStack {
            Text("Match")
                .bold()
                .font(.system(size: 20))
            Text("一度マッチングすると、そのマッチングが解除されるまで、他のユーザーを表示できなくなります。")
                .padding(.horizontal, 16)
            Button {
                print("aaa")
            } label: {
                Text("マッチング")
                    .foregroundColor(.white)
                    .bold()
            }
            .frame(width: 200, height: 50)
            .background(Color.customGreen)
            .cornerRadius(10)

        }
        .frame(width: 300, height: 300)
    }
}

struct CustomMatchingAlert_Previews: PreviewProvider {
    static var previews: some View {
        CustomMatchingAlert()
    }
}
