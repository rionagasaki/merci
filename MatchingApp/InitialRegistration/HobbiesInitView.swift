//
//  HobbiesInitView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/06/25.
//

import SwiftUI

struct HobbiesInitView: View {
    @StateObject var viewModel = HobbiesInitViewModel() 
    @EnvironmentObject var userModel: UserObservableModel
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) var dismiss
    @Binding var presentationMode: PresentationMode
    let UIIFGeneratorMedium = UIImpactFeedbackGenerator(style: .medium)
    var isEnabled: Bool {
        userModel.user.hobbies.count >= 3
    }
    
    var body: some View {
        VStack {
            Text("興味のあるタグを\n設定してください(3つ以上)")
                .font(.system(size: 25))
                .fontWeight(.bold)
                .foregroundColor(Color.customBlack)
                .padding(.top, 16)
                .padding(.leading, 16)
                .frame(maxWidth: .infinity, alignment: .leading)
            ScrollView {
                VStack {
                    GeometryReader { geometry in
                        TagViewGenerator.generateEditTags(
                            allTags: PickerItems.hobbies,
                            selectedTags: $viewModel.selectedHobbies, geometry
                        )
                    }
                    .padding()
                }
            }
            Spacer()
            Divider()
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(viewModel.selectedHobbies, id:\.self) { hobby in
                        OneHobbyView(hobby: hobby, selected: false)
                    }
                }
                .padding(.vertical, 8)
                .padding(.horizontal, 8)
            }
            Divider()
            if isEnabled {
                Button {
                    viewModel.completeRegister(
                        userModel: userModel,
                        appState: appState
                    ){
                        presentationMode.dismiss()
                    }
                } label: {
                    Text("登録する")
                        .foregroundColor(.white)
                        .bold()
                        .frame(width: UIScreen.main.bounds.width-32, height: 50)
                        .background(Color.pink)
                        .cornerRadius(10)
                }
            } else {
                Text("登録する")
                    .foregroundColor(.white)
                    .bold()
                    .frame(width: UIScreen.main.bounds.width-32, height: 50)
                    .background(Color.gray.opacity(0.8))
                    .cornerRadius(10)
            }
        }
        .navigationTitle("興味")
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
        .onAppear {
            viewModel.selectedHobbies = userModel.user.hobbies
        }
        .onChange(of: viewModel.selectedHobbies) { _ in
            userModel.user.hobbies = viewModel.selectedHobbies
        }
    }
}
