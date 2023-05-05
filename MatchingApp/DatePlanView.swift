//
//  DatePlanView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/05/05.
//

import SwiftUI

struct DatePlanView: View {
    var body: some View {
        VStack {
            Text("どんな気分？")
                .font(.system(size: 25))
                .fontWeight(.heavy)
                .padding(.top, 16)
                .padding(.leading, 16)
            VStack {
                HStack {
                    VStack {
                        Image("Person")
                            .resizable()
                            .frame(width: (UIScreen.main.bounds.width/2)-20, height: 250)
                            .cornerRadius(20)
                        Text("お茶でもしたい")
                    }
                    Image("Person")
                        .resizable()
                        .frame(width: (UIScreen.main.bounds.width/2)-20, height: 250)
                        .cornerRadius(20)
                    Text("")
                }
                HStack {
                    Image("Person")
                        .resizable()
                        .frame(width: (UIScreen.main.bounds.width/2)-20, height: 250)
                        .cornerRadius(20)
                    Image("Person")
                        .resizable()
                        .frame(width: (UIScreen.main.bounds.width/2)-20, height: 250)
                        .cornerRadius(20)
                }
            }
            Spacer()
        }
    }
}

struct DatePlanView_Previews: PreviewProvider {
    static var previews: some View {
        DatePlanView()
    }
}
