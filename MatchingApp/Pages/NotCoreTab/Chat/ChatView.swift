//
//  ChatView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/05/01.
//

import SwiftUI

enum MessageType: String {
    case normal = "Message"
    case concern = "Concern"
    case call = "Call"
}

struct ChatView: View {
    @StateObject private var viewModel = ChatViewModel()
    @ObservedObject var realTimeCall = RealTimeCallStatus.shared
    
    @EnvironmentObject var fromUser: UserObservableModel
    let toUser: UserObservableModel
    
    private let requestMicrophone = RequestMicrophone()
    @EnvironmentObject var appState: AppState
    @FocusState var focus: Bool
    
    var body: some View {
        VStack {
            switch viewModel.callingStatus {
            case .calling:
                CallingTopBarView(
                    toUser: toUser,
                    chatRoomID: viewModel.chatRoomId,
                    viewModel: viewModel
                )
            case .createCallRoom:
                CreateCallRoomView(user: toUser)
            case .noCall:
                EmptyView()
            case .waitingUser:
                CallWaitingView(fromUser: fromUser, toUser: toUser, viewModel: viewModel)
            case .waitedUser:
                CallWaitedView(
                    viewModel: viewModel,
                    fromUser: fromUser,
                    toUser: toUser,
                    channelID: viewModel.channelId,
                    chatRoomID: viewModel.chatRoomId
                )
            case .deadCall:
                DeadCallView(fromUser: fromUser, toUser: toUser, viewModel: viewModel)
            }
            
            ScrollViewReader { reader in
                VStack {
                    VStack {
                        ScrollView {
                            LazyVStack {
                                if viewModel.isLoading {
                                    ProgressView()
                                        .frame(width: 30, height: 30)
                                }
                                ForEach(viewModel.allMessages.indices, id: \.self){ index in
                                    let messageType = MessageType(rawValue: viewModel.allMessages[index].type)
                                    if index == 0 || !DateFormat.isSameDay(date1: viewModel.allMessages[index].createdAtDateValue, date2: viewModel.allMessages[index - 1].createdAtDateValue) {
                                        Text(DateFormat.dayFormat(date: viewModel.allMessages[index].createdAtDateValue))
                                            .foregroundColor(.customBlack)
                                            .font(.system(size: 14))
                                            .padding(.vertical, 4)
                                            .padding(.horizontal, 8)
                                            .background(Color.customLightGray)
                                            .cornerRadius(20)
                                            .padding(.vertical, 12)
                                    }
                                    
                                    switch messageType {
                                    case .normal:
                                        Group {
                                            if viewModel.allMessages[index].fromUserUid == fromUser.user.uid {
                                                MyMessageBubbleView(message: viewModel.allMessages[index])
                                                    .id(UUID.init(uuidString: viewModel.allMessages[index].chatId))
                                                
                                            } else {
                                                OtherUserMessageBubbleView(message: viewModel.allMessages[index], user: toUser)
                                                    .id(UUID.init(uuidString: viewModel.allMessages[index].chatId))
                                                
                                            }
                                        }
                                    case .concern:
                                        Group {
                                            if viewModel.allMessages[index].fromUserUid == fromUser.user.uid {
                                                MyConcernMessageBubbleView(message: viewModel.allMessages[index])
                                                    .id(UUID.init(uuidString: viewModel.allMessages[index].chatId))
                                                
                                            } else {
                                                OtherUserConcernMessageBubbleView(message: viewModel.allMessages[index], user: toUser)
                                                    .id(UUID.init(uuidString: viewModel.allMessages[index].chatId))
                                                
                                            }
                                        }
                                    case .call:
                                        Group {
                                            if viewModel.allMessages[index].fromUserUid == fromUser.user.uid {
                                                MyCallBubbleView(message: viewModel.allMessages[index])
                                                    .id(UUID.init(uuidString: viewModel.allMessages[index].chatId))
                                                
                                            } else {
                                                OtherUserCallBubbleView(message: viewModel.allMessages[index], user: toUser)
                                                    .id(UUID.init(uuidString: viewModel.allMessages[index].chatId))
        
                                            }
                                        }
                                    case .none:
                                        Group {
                                            if viewModel.allMessages[index].fromUserUid == fromUser.user.uid {
                                                MyMessageBubbleView(message: viewModel.allMessages[index])
                                                    .id(UUID.init(uuidString: viewModel.allMessages[index].chatId))
                                                
                                            } else {
                                                OtherUserMessageBubbleView(message: viewModel.allMessages[index], user: toUser)
                                                    .id(UUID.init(uuidString: viewModel.allMessages[index].chatId))
                                                
                                            }
                                        }
                                    }
                                }
                            }
                            .padding(.top, 16)
                        }
                        
                        .onChange(of: viewModel.scrollID) { id in
                            withAnimation {
                                reader.scrollTo(viewModel.scrollID)
                            }
                        }
                        .onAppear {
                            withAnimation {
                                reader.scrollTo(viewModel.scrollID)
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
                                withAnimation {
                                    viewModel.requestedCallNoticeOffSet = 0
                                }
                            }
                        }
                        Group {
                            Divider()
                            HStack(alignment: .bottom){
                                TextField(text: $viewModel.messageText, axis: .vertical) {
                                    Text("Aa")
                                }
                                .onTapGesture {
                                    DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
                                        withAnimation {
                                            reader.scrollTo(viewModel.scrollID)
                                        }
                                    }
                                }
                                .lineLimit(5)
                                .focused(self.$focus)
                                .padding(.bottom, 8)
                                
                                
                                Button {
                                    if viewModel.chatRoomId.isEmpty {
                                        Task {
                                            await viewModel.createChatRoomAndSendMessage(
                                                fromUser: fromUser,
                                                toUser: toUser,
                                                appState: appState
                                            )
                                        }
                                    } else {
                                        Task {
                                            await viewModel.sendMessage(
                                                fromUser: fromUser,
                                                toUser: toUser,
                                                appState: appState
                                            )
                                        }
                                    }
                                } label: {
                                    Text("送信")
                                        .foregroundColor(.white)
                                        .font(.system(size: 16, weight: .medium))
                                        .padding(.horizontal, 16)
                                        .frame(height: 40)
                                        .background(Color.customBlue)
                                        .cornerRadius(5)
                                }
                            }
                            .padding(.horizontal, 16)
                            .padding(.bottom, 8)
                        }
                    }
                }
            }
            .padding(.top, 16)
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .toolbar {
            ToolbarItem(placement: .principal) {
                NavigationLink {
                    UserProfileView(userId: toUser.user.uid, isFromHome: false)
                } label: {
                    Text("\(toUser.user.nickname)")
                        .foregroundColor(.customBlack)
                        .font(.system(size: 16, weight: .medium))
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    if !fromUser.user.friendUids.contains(toUser.user.uid) {
                        self.viewModel.errorMessage = "通話をするには、\(toUser.user.nickname)さんと友達になる必要があります。"
                        self.viewModel.isErrorAlert = true
                    } else {
                        Task {
                            let hasAudioPermissions = await self.requestMicrophone.checkForPermissions()
                            if hasAudioPermissions {
                                self.viewModel.isCreateCallActionSheet = true
                            } else {
                                requestMicrophone.requestMicrophonePermission { result in
                                    if result {
                                        self.viewModel.isCreateCallActionSheet = true
                                    } else {
                                        viewModel.errorMessage = "マイクの許可をしてね。"
                                        self.viewModel.isErrorAlert = true
                                    }
                                }
                            }
                        }
                        
                    }
                } label: {
                    VStack {
                        Image(systemName: "phone.circle.fill")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 32, height: 32)
                            .foregroundColor(.purple)
                        
                    }
                    .foregroundColor(.customBlack)
                }
                
            }
        }
        .actionSheet(isPresented: $viewModel.isCreateCallActionSheet){
            ActionSheet(
                title: Text("📞発信"),
                message: Text("\(toUser.user.nickname)さんへ発信するよ。"),
                buttons: [
                    .default(Text("発信"), action: {
                        if !fromUser.user.isCallingChannelId.isEmpty {
                            viewModel.errorMessage = "現在、他の通話に参加中だよ。"
                            viewModel.isErrorAlert = true
                        }
                        else if !viewModel.toUserCallingChannelId.isEmpty {
                            viewModel.errorMessage = "相手のユーザーが通話中だよ。"
                            viewModel.isErrorAlert = true
                        } else {
                            if !viewModel.chatRoomId.isEmpty {
                                viewModel.createOneToOneChannel(
                                    chatRoomId: viewModel.chatRoomId,
                                    fromUser: fromUser,
                                    toUser: toUser)
                            } else {
                                viewModel.errorMessage = "一言以上チャットしてみよう。"
                                viewModel.isErrorAlert = true
                            }
                        }
                    }),
                    .cancel()
                ]
            )
        }
        .alert(isPresented: $viewModel.isErrorAlert){
            Alert(title: Text("エラー"), message: Text(viewModel.errorMessage))
        }
        .onTapGesture {
            self.focus = false
        }
        .onReceive(realTimeCall.$dropUser){ dropUsers in
            if dropUsers.count > 0 {
                viewModel.stopChannel(fromUserID: fromUser.user.uid, toUserID: toUser.user.uid)
            }
        }
        .onAppear {
            if let chatRoomId = fromUser.user.chatmateMapping[toUser.user.uid] {
                self.viewModel.chatRoomId = chatRoomId
                self.viewModel.toUserCallingChannelId = toUser.user.isCallingChannelId
                viewModel.monitorChatRoomData(
                    chatRoomId: chatRoomId,
                    fromUser: fromUser,
                    toUserID: toUser.user.uid
                )
                Task {
                    await viewModel.getMessageData(user: fromUser, chatRoomId: chatRoomId)
                }
            }
        }
        .onDisappear {
            self.viewModel.isInitChat = true
            Task {
                await viewModel.updateMessageUnReadCountZero(user: fromUser)
            }
        }
    }
}

struct CallingTopBarView: View {
    @EnvironmentObject var fromUser: UserObservableModel
    let toUser: UserObservableModel
    let chatRoomID: String
    @StateObject var viewModel: ChatViewModel
    var body: some View {
        VStack(alignment: .leading){
            HStack(alignment: .top){
                Image(toUser.user.profileImageURLString)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .padding(.all, 12)
                    .background(Color.customLightGray)
                    .clipShape(Circle())
                
                VStack(alignment: .leading){
                    Text("\(toUser.user.nickname)さんと通話中です。")
                        .foregroundColor(.white)
                        .font(.system(size: 16, weight: .medium))
                    
                    HStack {
                        Button {
                            viewModel.muteAudio()
                        } label: {
                            Image(systemName: viewModel.isMuted ? "mic.slash.fill": "mic.fill")
                                .resizable()
                                .scaledToFill()
                                .foregroundColor(viewModel.isMuted ? .customRed: .customBlack)
                                .frame(width: 14, height: 14)
                                .padding(.all, 9)
                                .background(Color.white)
                                .clipShape(Circle())
                        }
                        
                        Button {
                            viewModel.changeOutputRouter()
                        } label: {
                            Image(systemName: viewModel.isSpeaker ? "speaker.wave.3.fill": "speaker.fill")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 14, height: 14)
                                .padding(.all, 9)
                                .background(Color.white)
                                .clipShape(Circle())
                        }
                        
                        Spacer()
                        
                        Button {
                            viewModel.stopChannel (
                                fromUserID: fromUser.user.uid,
                                toUserID: toUser.user.uid
                            )
                        } label: {
                            Text(viewModel.isLoading ? "切断中...": "退出する")
                                .foregroundColor(viewModel.isLoading ? .customBlack: .white)
                                .font(.system(size: 12, weight: .medium))
                                .padding(.all, 8)
                                .background(viewModel.isLoading ? Color.customLightGray: Color.customRed)
                                .cornerRadius(10)
                        }
                        .disabled(viewModel.isLoading)
                    }
                }
                .padding(.leading, 8)
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 24)
        .background(Color.purple)
        .cornerRadius(16)
        .padding(.top, 8)
        .padding(.horizontal, 8)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {
                viewModel.deadCallBar(fromUser: fromUser)
            }
        }
    }
}

struct CallWaitingView: View {
    let fromUser: UserObservableModel
    let toUser: UserObservableModel
    @StateObject var viewModel: ChatViewModel
    var body: some View {
        HStack(alignment: .top) {
            ZStack(alignment: .bottomTrailing){
                Image(toUser.user.profileImageURLString)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .padding(.all, 12)
                    .background(Color.customLightGray)
                    .clipShape(Circle())
                
                Image(systemName: "phone.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width:24, height:24)
                    .foregroundColor(.green)
                    .background(Color.white)
                    .clipShape(Circle())
            }
            Spacer()
            VStack(alignment: .trailing){
                Text("\(toUser.user.nickname)さんを呼び出しています")
                    .foregroundColor(.white)
                    .font(.system(size: 16, weight: .medium))
                
                Button {
                    viewModel.stopChannel (
                        fromUserID: fromUser.user.uid,
                        toUserID: toUser.user.uid
                    )
                } label: {
                    Text(viewModel.isLoading ? "切断中...": "退出する")
                        .foregroundColor(viewModel.isLoading ? .customBlack: .white)
                        .font(.system(size: 12, weight: .medium))
                        .padding(.all, 8)
                        .background(viewModel.isLoading ? Color.customLightGray: Color.customRed)
                        .cornerRadius(10)
                }
                .disabled(viewModel.isLoading)
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 24)
        .background(Color.purple)
        .cornerRadius(16)
        .padding(.top, 8)
        .padding(.horizontal, 8)
    }
}

struct CallWaitedView: View {
    @StateObject var viewModel: ChatViewModel
    let fromUser: UserObservableModel
    let toUser: UserObservableModel
    let channelID: String
    let chatRoomID: String
    
    var body: some View {
        HStack(alignment: .top) {
            ZStack(alignment: .bottomTrailing){
                Image(toUser.user.profileImageURLString)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .padding(.all, 12)
                    .background(Color.customLightGray)
                    .clipShape(Circle())
                
                Image(systemName: "phone.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width:24, height:24)
                    .foregroundColor(.green)
                    .background(Color.white)
                    .clipShape(Circle())
            }
            Spacer()
            VStack(alignment: .trailing){
                Text("\(toUser.user.nickname)さんはもうそこにいます！")
                    .foregroundColor(.white)
                    .font(.system(size: 16, weight: .medium))
                
                Button {
                    viewModel.joinCall(
                        channelID: channelID,
                        chatRoomID: chatRoomID,
                        userModel: fromUser
                    )
                } label: {
                    Text(viewModel.isLoading ? "参加中...": "通話に参加する")
                        .foregroundColor(viewModel.isLoading ? .customBlack: .white)
                        .font(.system(size: 12, weight: .medium))
                        .padding(.all, 8)
                        .background(viewModel.isLoading ? Color.customLightGray: Color.green)
                        .cornerRadius(10)
                }
                .disabled(viewModel.isLoading)
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 24)
        .background(Color.purple)
        .cornerRadius(16)
        .padding(.top, 8)
        .padding(.horizontal, 8)
    }
}

struct DeadCallView: View {
    let fromUser: UserObservableModel
    let toUser: UserObservableModel
    @StateObject var viewModel: ChatViewModel
    var body: some View {
        HStack(alignment: .top) {
            ZStack(alignment: .bottomTrailing){
                Image(toUser.user.profileImageURLString)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .padding(.all, 12)
                    .background(Color.customLightGray)
                    .clipShape(Circle())
                
                Image(systemName: "phone.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width:24, height:24)
                    .foregroundColor(.green)
                    .background(Color.white)
                    .clipShape(Circle())
            }
            Spacer()
            VStack(alignment: .trailing){
                Text("前回の通話が予期せぬ形で終了しました。")
                    .foregroundColor(.white)
                    .font(.system(size: 16, weight: .medium))
                
                Button {
                    self.viewModel.stopChannelInfoFromFirestore(fromUserID: fromUser.user.uid, toUserID: toUser.user.uid)
                } label: {
                    Text("OK")
                        .foregroundColor(.white)
                        .font(.system(size: 12, weight: .medium))
                        .padding(.all, 8)
                        .background(Color.green)
                        .cornerRadius(10)
                }
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 24)
        .background(Color.purple)
        .cornerRadius(16)
        .padding(.top, 8)
        .padding(.horizontal, 8)
    }
    
}

struct CreateCallRoomView: View {
    let user: UserObservableModel
    var body: some View {
        HStack(alignment: .top) {
            ZStack(alignment: .bottomTrailing){
                Image(user.user.profileImageURLString)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .padding(.all, 12)
                    .background(Color.customLightGray)
                    .clipShape(Circle())
                
                Image(systemName: "phone.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width:24, height:24)
                    .foregroundColor(.green)
                    .background(Color.white)
                    .clipShape(Circle())
            }
            Spacer()
            VStack(alignment: .trailing){
                Text("通話ルームを作成しているよ。少し待ってね。")
                    .foregroundColor(.white)
                    .font(.system(size: 16, weight: .medium))
                
                LottieView(animationResourceName: "loading", loopMode: .loop, isActive: true)
                    .scaledToFill()
                    .frame(width: 120, height: 20)
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 24)
        .background(Color.purple)
        .cornerRadius(16)
        .padding(.top, 8)
        .padding(.horizontal, 8)
    }
}
