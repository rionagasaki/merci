//
//  WelcomeView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/07/04.
//

import SwiftUI

struct WelcomeView: View {
    @StateObject var viewModel = WelcomeViewModel()
    @EnvironmentObject var userModel: UserObservableModel
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                Text(viewModel.guideText)
                    .foregroundColor(.customBlack)
                    .font(.system(size: 24, weight: .bold))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 16)
                
                if viewModel.guideCount == 3 {
                    VStack{
                        TextField(text: $viewModel.invitationID) {
                            Text("友達のNiNi ID")
                        }
                        .padding(.all, 8)
                        .cornerRadius(10)
                        .background(Color.white.cornerRadius(10))
                        .overlay {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.black, lineWidth: 1)
                                .cornerRadius(10)
                        }
                        .padding(.horizontal, 16)
                        
                        Button {
                            withAnimation {
                                viewModel.guideCount += 1
                            }
                        } label: {
                            Text("スキップする")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.blue.opacity(0.8))
                        }
                        .padding(.top, 16)
                    }
                }
                
                if viewModel.guideCount >= 4 {
                    PairCardView(pairModel: .init(
                        pairModel: .init(
                            pair_1_nickname: "あかり",
                            pair_1_activeRegion: "新宿",
                            pair_1_birthDate: "2002/06/28",
                            pair_2_nickname: "はなこ",
                            pair_2_activeRegion: "渋谷",
                            pair_2_birthDate: "2001/06/28"
                        )
                    ), localImageName_1: "ExplanationGirl_1",
                                 localImageName_2: "ExplanationGirl_2"
                    )
                }
                Spacer()
                Button {
                    viewModel.doneOnboarding(userModel: userModel)
                } label: {
                    Text("NiNiを始める")
                        .frame(width: UIScreen.main.bounds.width-32, height: 60)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                        .background(Color.pink.opacity(0.8))
                        .cornerRadius(20)
                        .padding(.bottom, 32)
                        .offset(y: viewModel.guideCount != 4 ? 120: 0)
                }
            }
            .onReceive(viewModel.$isSuccess){ if $0 { dismiss() } }
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            .background(LinearGradient(colors: [.pink.opacity(0.2), .white], startPoint: .leading, endPoint: .trailing)
                .onTapGesture {
                    withAnimation {
                        if viewModel.guideCount != 3 {
                            viewModel.guideCount += 1
                        }
                    }
                }
            )
            .alert(isPresented: $viewModel.isErrorAlert){
                Alert(title: Text("エラー"), message: Text(viewModel.errorMessage))
            }
            .toolbar {
                ToolbarItem(placement: .keyboard) {
                    Button {
                        print("aaaa")
                    } label: {
                        Text("検索する")
                            .foregroundColor(.white)
                            .font(.system(size: 22, weight: .bold))
                            .frame(width: UIScreen.main.bounds.width, height: 60)
                            .background(Color.pink.opacity(0.7))
                            .padding(.bottom, 16)
                    }
                }
            }
        }
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
