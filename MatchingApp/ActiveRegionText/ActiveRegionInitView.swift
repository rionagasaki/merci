//
//  ActiveRegionView.swift
//  MatchingApp
//

//
import SwiftUI

struct ActiveRegionInitView: View {
    
    @Environment(\.dismiss) var dismiss
    @Binding var presentationMode: PresentationMode
    @EnvironmentObject var userModel: UserObservableModel
    let UIIFGeneratorMedium = UIImpactFeedbackGenerator(style: .medium)
    var isEnabled: Bool {
        userModel.activeRegion != ""
    }
    
    var body: some View {
        VStack{
            Text("主な活動地域を\n選択してください(東京都限定)")
                .font(.system(size: 25))
                .fontWeight(.bold)
                .foregroundColor(Color.customBlack)
                .padding(.top, 16)
                .padding(.leading, 16)
                .frame(maxWidth: UIScreen.main.bounds.width, alignment: .leading)
            
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
                    .frame(maxWidth: UIScreen.main.bounds.width, alignment: .leading)
                }
            }
            if isEnabled {
                NavigationLink {
                    BirthDateView(presentationMode: $presentationMode)
                        .onAppear {
                            UIIFGeneratorMedium.impactOccurred()
                        }
                } label: {
                    Text("次へ")
                        .foregroundColor(.white)
                        .bold()
                        .frame(width: UIScreen.main.bounds.width-32, height: 50)
                        .background(Color.pink)
                        .cornerRadius(10)
                }
            } else {
                Text("次へ")
                    .foregroundColor(.white)
                    .bold()
                    .frame(width: UIScreen.main.bounds.width-32, height: 50)
                    .background(Color.gray.opacity(0.8))
                    .cornerRadius(10)
            }
            Spacer()
        }
        .navigationTitle("活動地域")
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
