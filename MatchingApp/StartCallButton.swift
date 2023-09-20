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
    @EnvironmentObject var userModel: UserObservableModel
    var body: some View {
        VStack {
            NavigationLink(isActive: $isActive){
                HostCallView(
                    channelTitle: $channelTitle,
                    user: userModel
                )
            } label: {
                EmptyView()
            }

            Button {
                Task {
                    let hasAudioPermissions = await self.requestMicriphone.checkForPermissions()
                    if hasAudioPermissions {
                        isCallingModal = true
                    } else {
                        print("マイクへのアクセス許可がありません")
                        requestMicriphone.requestMicrophonePermission()
                    }
                }
                
            } label: {
                VStack {
                    ZStack(alignment: .bottomTrailing){
                        ZStack(alignment: .center){
                            Circle()
                                .size(width: 60, height: 60)
                                .foregroundColor(.gray.opacity(0.1))
                            
                            Image(systemName: "phone.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 24, height: 24)
                                .foregroundColor(.customBlack)
                        }
                        
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 16, height: 16)
                            .foregroundColor(.customBlack)
                        
                    }
                    .frame(width: 60, height: 60)
                    Text("通話を募集")
                        .foregroundColor(.customBlack)
                        .font(.system(size: 12, weight: .medium))
                }
            }
        }
        .padding(.horizontal, 16)
        .halfModal(isPresented: $isCallingModal) {
            CreateCallView(
                channelTitle: $channelTitle,
                isActive: $isActive,
                userModel: userModel
            )
        }
    }
}
