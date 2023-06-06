//
//  ActiveRegionView.swift
//  MatchingApp
//
//  Created by 荒木太一 on 2023/05/08.
//
import SwiftUI

struct ActiveRegionTextView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var presentationMode: PresentationMode
    @EnvironmentObject var userModel: UserObservableModel
    
    var body: some View {
        VStack(alignment: .leading){
            Text("主な活動地域を\n選択してください(東京都限定)")
                .font(.system(size: 25))
                .fontWeight(.bold)
                .foregroundColor(Color.customBlack)
                .padding(.top, 16)
                .padding(.leading, 16)
            
            VStack {
                ScrollView (showsIndicators: false){
                    ForEach(userModel.tokyo23Wards, id: \.self) { activeRegion in
                        Button {
                            userModel.activeRegion = activeRegion
                        } label: {
                            Text(activeRegion)
                                .foregroundColor(
                                    userModel.activeRegion == activeRegion ?
                                    Color.customBlack
                                    : .gray.opacity(0.6)
                                )
                                .fontWeight(.semibold)
                                .font(.system(size: 23))
                                .padding(.leading, 32)
                                .padding(.top, 8)
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            NavigationLink {
                BirthDateView(presentationMode: $presentationMode)
            } label: {
                NextButtonView()
            }
            .frame(maxWidth: .infinity, alignment: .center)
        }
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(
                    action: {
                        dismiss()
                    }, label: {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.black)
                    }
                )
            }
        }
    }
}
