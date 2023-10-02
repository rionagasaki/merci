//
//  StartCallView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/08/03.
//

import SwiftUI

struct StartCallButton: View {
    private let requestMicriphone = RequestMicrophone()
    @State var isCallingModal: Bool = false
    @State var isActive: Bool = false
    @State var channelTitle: String = ""
    @State var isErrorAlert: Bool = false
    @EnvironmentObject var userModel: UserObservableModel

    var body: some View {
        VStack {
            Button {
                Task {
                    let hasAudioPermissions = await self.requestMicriphone.checkForPermissions()
                    if hasAudioPermissions {
                        isCallingModal = true
                    } else {
                        requestMicriphone.requestMicrophonePermission { result in
                            if result {
                                self.isCallingModal = true
                            } else {
                                self.isErrorAlert = true
                            }
                        }
                    }
                }
            } label: {
                VStack {
                    ZStack(alignment: .bottomTrailing){
                        Image(systemName: "phone.fill")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 24, height: 24)
                            .padding(.all, 18)
                            .background(Color.gray.opacity(0.1))
                            .clipShape(Circle())
                        
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 16, height: 16)
                            .foregroundColor(.customBlack)
                            .background(Color.white)
                            .clipShape(Circle())
                    }
                    
                    Text("音声配信")
                        .foregroundColor(.customBlack)
                        .font(.system(size: 12, weight: .medium))
                }
            }
        }
        .padding(.horizontal, 16)
        .sheet(isPresented: $isCallingModal) {
            CreateCallView(
                channelTitle: $channelTitle,
                isActive: $isActive,
                userModel: userModel
            ).presentationDetents([.height(300)])
        }
        .alert(isPresented: $isErrorAlert) {
            Alert(title: Text("マイクを許可してね。"), message: Text(""), primaryButton: .cancel(Text("やめとく！")), secondaryButton: .default(Text("設定を開く"), action: {
                guard let url = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(url) else { return }
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }))
        }
        .navigationDestination(isPresented: $isActive) {
            HostCallView(
                channelTitle: $channelTitle,
                user: userModel
            )
        }
    }
}
