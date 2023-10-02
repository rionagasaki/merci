//
//  CallingView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/08/06.
//

import SwiftUI
import SDWebImageSwiftUI


struct JoinCallButton: View {
    private let requestMicriphone = RequestMicrophone()
    let call: CallObservableModel
    @State var isCallDetailModal: Bool = false
    @State var isActive: Bool = false
    @State var isErrorAlert: Bool = false
    @State var errorTitle: String = ""
    @State var errorMessage: String = ""
    @EnvironmentObject var userModel: UserObservableModel
    
    var body: some View {
        VStack {
            Button {
                Task {
                    let hasAudioPermissions = await self.requestMicriphone.checkForPermissions()
                    if hasAudioPermissions {
                        
                    } else {
                        requestMicriphone.requestMicrophonePermission { result in
                            if result {
                                self.isCallDetailModal = true
                            } else {
                                self.isErrorAlert = true
                            }
                        }
                    }
                    if userModel.user.isCallingChannelId.isEmpty {
                        self.isCallDetailModal = true
                    } else {
                        self.isErrorAlert = true
                    }
                }
            } label: {
                VStack {
                    ZStack(alignment: .bottomTrailing){
                        Image(call.call.hostUserImageUrlString)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 48, height: 48)
                            .padding(.all, 6)
                            .background(Color.gray.opacity(0.1))
                            .clipShape(Circle())
                        
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 16, height: 16)
                            .foregroundColor(.green)
                            .background(Color.white)
                            .clipShape(Circle())
                    }
                    Text("\(call.call.userIdToUserName.keys.count)人参加中")
                        .foregroundColor(.customBlack)
                        .font(.system(size: 12, weight: .medium))
                }
            }
        }
        .navigationDestination(isPresented: $isActive){
            AttendeeCallView(user: userModel, channelId: call.call.channelId)
        }
        .alert(isPresented: $isErrorAlert){
            Alert(
                title: Text("他の通話ルームに参加しています。"),
                message: Text("現在通話中のルームから退出してください。")
            )
        }
        .halfModal(isPresented: $isCallDetailModal) {
            CallDetailModalView(
                isActive: $isActive,
                call: call,
                user: userModel
            )
        }
    }
}

