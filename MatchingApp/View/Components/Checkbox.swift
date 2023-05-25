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
                    .frame(width: 30)
                    .fixedSize()
                    .foregroundColor(.black)
                Circle()
                    .frame(width: 27)
                    .fixedSize()
                    .foregroundColor(isOn ? .black: .white)
                    .overlay {
                        Circle()
                            .stroke(.white, lineWidth: 2)
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
