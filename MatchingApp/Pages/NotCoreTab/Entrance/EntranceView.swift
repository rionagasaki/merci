//
//  EntranceView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/06/15.
//

import SwiftUI

struct EntranceView: View {
    @State var selection: Int = 0
    let tabSection = ["新規登録", "ログイン"]
    @State var isShow: Bool = false
    @State var isLoginShow: Bool = false
    @State var alert: Bool = false
    @State var alertText: String = ""
    @EnvironmentObject var userModel: UserObservableModel
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) var dismiss
    var body: some View {
        ZStack {
            VStack {
                VStack {
                    Image("owl")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 144, height: 144)
                    
                    Image("Logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 144)
                    Text("~ 匿名通話、チャットアプリ ~")
                }
                .frame(height: (UIScreen.main.bounds.height/2)-56)
                HStack {
                    ForEach(tabSection.indices, id: \.self) { index in
                        Button {
                            withAnimation {
                                selection = index
                            }
                        } label: {
                            Text(tabSection[index])
                                .foregroundColor(index == selection ? .customBlack: .customBlack.opacity(0.5))
                                .font(.system(size: 16, weight: .bold))
                                .frame(maxWidth: .infinity, alignment: .center)
                        }
                    }
                }
                ZStack(alignment: selection == 0 ? .leading: .trailing) {
                    Rectangle()
                        .foregroundColor(.gray.opacity(0.8))
                        .frame(width: UIScreen.main.bounds.width, height: 2)
                    Rectangle()
                        .foregroundColor(Color.customBlue)
                        .frame(width: (UIScreen.main.bounds.width/2), height: 2)
                }
                TabView(selection: $selection){
                    RegisterView(
                        isShow: $isShow,
                        alreadyHasAccount: $alert,
                        alertText: $alertText)
                    .tag(0)
                    LoginView(
                        isShow: $isLoginShow,
                        noAccountAlert: $alert,
                        alertText: $alertText)
                    .tag(1)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            }
            
            if isShow {
                EmailRegisterView(isShow: $isShow)
                    .transition(.flipFromRight)
            }
            if isLoginShow {
                EmailLoginView(isShow: $isLoginShow)
                    .transition(.flipFromRight)
            }
        }
        .onAppear {
            userModel.initial()
        }
    }
}

struct EntranceView_Previews: PreviewProvider {
    static var previews: some View {
        EntranceView()
    }
}
