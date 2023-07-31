//
//  Checkbox.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/05/10.
//

import SwiftUI

struct Checkbox: View {
    @State var isOn = false
    var body: some View {
        Button {
            isOn.toggle()
        } label: {
            ZStack {
                Circle()
                    .stroke(Color.customBlack, lineWidth: 2)
                    .frame(width: 25)
                    .foregroundColor(.customBlack)
                    
                if isOn {
                    Circle()
                        .frame(width: 20)
                        .fixedSize()
                        .foregroundColor(.customBlack)
                }
            }
        }
    }
}

struct Checkbox_Previews: PreviewProvider {
    static var previews: some View {
        Checkbox()
    }
}
