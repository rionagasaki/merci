//
//  DatePlaceView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/05/10.
//

import SwiftUI
import MapKit

struct DatePlaceView: View {
    @StateObject private var viewModel = DatePlaceViewModel()
    @Binding var presentationMode: PresentationMode
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            ScrollView {
                VStack {
                    Text("場所を選択してください")
                        .foregroundColor(.black.opacity(0.7))
                        .font(.system(size: 25))
                        .fontWeight(.heavy)
                        .padding(.top, 16)
                        .padding(.leading, 16)
                    Text("")
                    Text("おまかせ")
                }
            }
            Spacer()
            NavigationLink {
                SelectPairView(presentationMode: $presentationMode)
            } label: {
                NextButtonView()
            }

        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(
                    action: {
                        dismiss()
                    }, label: {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.black)
                    }
                ).tint(.orange)
            }
        }
    }
}
