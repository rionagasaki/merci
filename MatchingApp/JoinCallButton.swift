//
//  CallingView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/08/06.
//

import SwiftUI
import SDWebImageSwiftUI


struct JoinCallButton: View {
    @StateObject var viewModel = JoinCallViewModel()
    @EnvironmentObject var userModel: UserObservableModel
    @State var isAlert: Bool = false
    let call: CallObservableModel
    
    var body: some View {
        VStack {
            Button {
                if userModel.user.isCallingChannelId.isEmpty {
                    viewModel.isCallDetailModal = true
                } else {
                    viewModel.errorMessage = "現在、すで"
                    viewModel.isErrorAlert = true
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
        .navigationDestination(isPresented: $viewModel.isActive){
            AttendeeCallView(user: userModel, channelId: call.call.channelId)
        }
        .alert(isPresented: $isAlert){
            Alert(title: Text("他の通話ルームに参加しています。"), message: Text("現在通話中のルームから退出してください。"))
        }
        .halfModal(isPresented: $viewModel.isCallDetailModal) {
            CallDetailModalView(
                isActive: $viewModel.isActive,
                call: call,
                user: userModel
            )
        }
    }
}

