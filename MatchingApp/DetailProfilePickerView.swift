//
//  DetailProfileView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/06/07.
//

import SwiftUI
import Combine

struct DetailProfilePickerView: View {
    
    let fieldName: String
    let pickerItems: [String]
    let UIIFGeneratorMedium = UIImpactFeedbackGenerator(style: .medium)
    @State var selected: Int = 0
    @Binding var selectedValue: String
    @Binding var detailProfile: DetailProfile?
    @EnvironmentObject var userModel: UserObservableModel
    
    
    var body: some View {
        VStack(spacing: .zero) {
            Rectangle()
                .foregroundColor(.gray)
                .frame(width: UIScreen.main.bounds.width, height: 1)
            HStack {
                Button {
                    detailProfile = nil
                } label: {
                    Text("キャンセル")
                }
                .foregroundColor(.customBlack)
                .font(.system(size: 16, weight: .bold))
                Spacer()
                Button {
                    if selectedValue != "-" { UIIFGeneratorMedium.impactOccurred() }
                    SetToFirestore.shared.updateDetailProfile(
                        uid: userModel.uid,
                        fieldName: fieldName,
                        value: selectedValue == "-" ? "": selectedValue){
                            detailProfile = nil
                        }
                } label: {
                    Text("OK")
                }
                .foregroundColor(.white)
                .padding(.vertical, 8)
                .padding(.horizontal, 16)
                .background(Color.pink.opacity(0.7))
                .cornerRadius(15)
            }
            .padding(.top, 8)
            .padding(.horizontal, 16)
            
            Picker(selection: $selected, label: Text("")) {
                ForEach(pickerItems.indices, id: \.self) { index in
                    Text(pickerItems[index])
                }
            }
            .pickerStyle(.wheel)
            .onChange(of: selected) { newValue in
                selectedValue = pickerItems[newValue]
            }
        }
        .background(Color.white)
        .onAppear {
            selectedValue = pickerItems[0]
        }
    }
}


struct SelectedProfileCellList {
    var detailProfile: DetailProfile
    var selected: String
}
