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
    private let requestNotification = RequestNotificaton()

    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                if viewModel.guideCount == 1 {
                    HStack {
                        Image("Penguin")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 60, height:60)
                           
                        Image("Chick")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 60, height: 60)
                        
                        Image("Hayabusa")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 60, height: 60)
                            
                        Image("Crab")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 60, height: 60)
                        
                        Image("Deer")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 60, height: 60)
            
                    }
                    .padding(.vertical, 24)
                } else if viewModel.guideCount == 2 {
                    Text("🔔")
                        .font(.system(size: 60, weight: .medium))
                }
                
                Text(viewModel.guideText)
                    .foregroundColor(.customBlack)
                    .font(.system(size: 24, weight: .bold))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 16)
                
                if viewModel.guideCount == 4 {
                    Image("CallingCat")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 100)
                }
                Spacer()
                Button {
                    viewModel.doneOnboarding(userModel: userModel)
                } label: {
                    Text("merciを始める")
                        .frame(width: UIScreen.main.bounds.width-32, height: 60)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                        .background(Color.customBlue.opacity(0.8))
                        .cornerRadius(20)
                        .padding(.bottom, 32)
                        .offset(y: viewModel.guideCount < 4 ? 120: 0)
                }
            }
            .onReceive(viewModel.$isSuccess){ if $0 { dismiss() } }
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            .background(LinearGradient(colors: [.customBlue.opacity(0.2), .white], startPoint: .leading, endPoint: .trailing)
                .onTapGesture {
                    withAnimation {
                        if viewModel.guideCount != 4 {
                            viewModel.guideCount += 1
                        }
                        
                        if viewModel.guideCount == 3 {
                            requestNotification.requestNotification()
                        }
                    }
                }
            )
            .alert(isPresented: $viewModel.isErrorAlert){
                Alert(title: Text("通知の許可"), message: Text(viewModel.errorMessage))
            }
        }
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}

class RequestNotificaton {
    
    func requestNotification(){
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { result, error in
            if let error = error {
                print("UNUserNotificationCenter:\(error)")
            } else {
                if result {
                    DispatchQueue.main.async {
                        UIApplication.shared.registerForRemoteNotifications()
                    }
                } else {
                    
                }
            }
        }
    }
}
