//
//  IntroductionView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/06/25.
//

import SwiftUI

struct IntroductionInitView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var userModel: UserObservableModel
    @Binding var presentationMode: PresentationMode
    @FocusState var focus: Bool
    let UIIFGeneratorMedium = UIImpactFeedbackGenerator(style: .medium)
    var isEnabled: Bool {
        userModel.introduction.count >= 20
    }
    var body: some View {
        ScrollView(showsIndicators: false){
            VStack{
                Text("自己紹介を\n記述してください(20文字以上)")
                    .font(.system(size: 25))
                    .fontWeight(.bold)
                    .foregroundColor(Color.customBlack)
                    .padding(.top, 16)
                    .frame(maxWidth: .infinity, alignment: .leading)
                TextEditor(text: $userModel.introduction)
                    .padding(.all, 8)
                    .frame(width: UIScreen.main.bounds.width-32, height: 500)
                    
                    .cornerRadius(10)
                    .focused($focus)
                    .overlay {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.gray.opacity(0.2), lineWidth: 2)
                    }
                Spacer()
            }
        }
        .padding(.horizontal, 16)
        .navigationBarBackButtonHidden()
        .navigationTitle("自己紹介")
        .onAppear {
            focus = true
        }
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
        .toolbar {
            ToolbarItem(placement: .keyboard){
                if isEnabled {
                    NavigationLink{
                        HobbiesInitView(presentationMode: $presentationMode)
                            .onAppear{
                                UIIFGeneratorMedium.impactOccurred()
                            }
                    } label: {
                        Text("次へ")
                            .foregroundColor(.white)
                            .font(.system(size: 22, weight: .bold))
                            .frame(width: UIScreen.main.bounds.width, height: 60)
                            .background(Color.pink)
                            .padding(.bottom, 16)
                    }
                } else {
                    Text("次へ")
                        .foregroundColor(.white)
                        .font(.system(size: 22, weight: .bold))
                        .frame(width: UIScreen.main.bounds.width, height: 60)
                        .background(Color.gray.opacity(0.7))
                        .padding(.bottom, 16)
                }
            }
        }
    }
}
