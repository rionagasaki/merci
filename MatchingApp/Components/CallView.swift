//
//  CallView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/07/29.
//

import SwiftUI

struct CallView: View {
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        VStack {
            Text("Welcome to the call!")
                .bold()
            AgoraRep()
                .frame(width: 0, height: 0, alignment: .center)
            Spacer()
            HStack {
                Image(systemName: "mic.circle.fill")
                    .font(.system(size:64.0))
                    .foregroundColor(.blue)
                    .padding()
                
                
                Spacer()
                Image(systemName: "phone.circle.fill")
                    .font(.system(size:64.0))
                    .foregroundColor(.red)
                    .padding()
                    .onTapGesture {
                        presentationMode.wrappedValue.dismiss()
                    }
            }
            .padding()
        }
    }
}
