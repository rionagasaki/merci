//
//  HobbiesView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/05/24.
//

import SwiftUI
import MusicKit

struct UserHobbiesEditorView: View {
    @StateObject var viewModel = UserHobbiesEditorViewModel()
    @EnvironmentObject var userModel: UserObservableModel
    @Environment(\.presentationMode) var presentationMode
    private let UIIFGeneratorMedium = UIImpactFeedbackGenerator(style: .heavy)
    var body: some View {
        VStack {
            ScrollView(.vertical, showsIndicators: false){
                Text("😁ベース")
                    .foregroundColor(.customBlack)
                    .font(.system(size: 24, weight: .medium))
                    .frame(maxWidth: UIScreen.main.bounds.width, alignment: .leading)
                FlowLayout(alignment: .center, spacing: 7) {
                    ForEach(PickerItems.base, id: \.self) { tag in
                        OneHobbyView(hobby: tag, selected: viewModel.selectedHobbies.contains(tag))
                            .onTapGesture {
                                if viewModel.selectedHobbies.contains(tag){
                                    withAnimation {
                                        self.viewModel.selectedHobbies = self.viewModel.selectedHobbies.filter { $0 != tag }
                                        UIIFGeneratorMedium.impactOccurred()
                                    }
                                } else {
                                    withAnimation {
                                        self.viewModel.selectedHobbies.append(tag)
                                        UIIFGeneratorMedium.impactOccurred()
                                    }
                                }
                            }
                    }
                }
                .padding(.vertical, 16)
                
                Text("💩絵文字")
                    .foregroundColor(.customBlack)
                    .font(.system(size: 24, weight: .medium))
                    .frame(maxWidth: UIScreen.main.bounds.width, alignment: .leading)
                FlowLayout(alignment: .center, spacing: 7) {
                    ForEach(PickerItems.emoji, id: \.self) { tag in
                        OneHobbyView(hobby: tag, selected: viewModel.selectedHobbies.contains(tag))
                            .onTapGesture {
                                if viewModel.selectedHobbies.contains(tag){
                                    withAnimation {
                                        self.viewModel.selectedHobbies = self.viewModel.selectedHobbies.filter { $0 != tag }
                                        UIIFGeneratorMedium.impactOccurred()
                                    }
                                } else {
                                    withAnimation {
                                        self.viewModel.selectedHobbies.append(tag)
                                        UIIFGeneratorMedium.impactOccurred()
                                    }
                                }
                            }
                    }
                }
                .padding(.vertical, 16)
                
                Text("🎵なう")
                    .foregroundColor(.customBlack)
                    .font(.system(size: 24, weight: .medium))
                    .frame(maxWidth: UIScreen.main.bounds.width, alignment: .leading)
                FlowLayout(alignment: .center, spacing: 7) {
                    ForEach(PickerItems.status, id: \.self) { tag in
                        OneHobbyView(hobby: tag, selected: viewModel.selectedHobbies.contains(tag))
                            .onTapGesture {
                                if viewModel.selectedHobbies.contains(tag){
                                    withAnimation {
                                        self.viewModel.selectedHobbies = self.viewModel.selectedHobbies.filter { $0 != tag }
                                        UIIFGeneratorMedium.impactOccurred()
                                    }
                                } else {
                                    withAnimation {
                                        self.viewModel.selectedHobbies.append(tag)
                                        UIIFGeneratorMedium.impactOccurred()
                                    }
                                }
                            }
                    }
                }
                .padding(.vertical, 16)
                
                Text("🎡遊び")
                    .foregroundColor(.customBlack)
                    .font(.system(size: 24, weight: .medium))
                    .frame(maxWidth: UIScreen.main.bounds.width, alignment: .leading)
                FlowLayout(alignment: .center, spacing: 7) {
                    ForEach(PickerItems.playing, id: \.self) { tag in
                        OneHobbyView(hobby: tag, selected: viewModel.selectedHobbies.contains(tag))
                            .onTapGesture {
                                if viewModel.selectedHobbies.contains(tag){
                                    withAnimation {
                                        self.viewModel.selectedHobbies = self.viewModel.selectedHobbies.filter { $0 != tag }
                                        UIIFGeneratorMedium.impactOccurred()
                                    }
                                } else {
                                    withAnimation {
                                        self.viewModel.selectedHobbies.append(tag)
                                        UIIFGeneratorMedium.impactOccurred()
                                    }
                                }
                            }
                    }
                }
                .padding(.vertical, 16)
                
                Text("📖勉強")
                    .foregroundColor(.customBlack)
                    .font(.system(size: 24, weight: .medium))
                    .frame(maxWidth: UIScreen.main.bounds.width, alignment: .leading)
                FlowLayout(alignment: .center, spacing: 7) {
                    ForEach(PickerItems.study, id: \.self) { tag in
                        OneHobbyView(hobby: tag, selected: viewModel.selectedHobbies.contains(tag))
                            .onTapGesture {
                                if viewModel.selectedHobbies.contains(tag){
                                    withAnimation {
                                        self.viewModel.selectedHobbies = self.viewModel.selectedHobbies.filter { $0 != tag }
                                        UIIFGeneratorMedium.impactOccurred()
                                    }
                                } else {
                                    withAnimation {
                                        self.viewModel.selectedHobbies.append(tag)
                                        UIIFGeneratorMedium.impactOccurred()
                                    }
                                }
                            }
                    }
                }
                .padding(.vertical, 16)
            }
            VStack(alignment: .leading, spacing: .zero){
                Text("設定中のタグ  \(viewModel.selectedHobbies.count)")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.gray.opacity(0.8))
                    .padding(.leading, 16)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack{
                        ForEach(viewModel.selectedHobbies, id:\.self) { hobby in
                            OneHobbyView(hobby: hobby, selected: true)
                                .onTapGesture {
                                    withAnimation {
                                        self.viewModel.selectedHobbies = self.viewModel.selectedHobbies.filter { $0 != hobby }
                                    }
                                }
                        }
                    }
                    .padding(.bottom, 32)
                    .padding(.top, 8)
                    .padding(.leading, 16)
                }
            }
            Button {
                viewModel.storeHobbiesToFirestore(userModel: userModel)
            } label: {
                Text("変更を保存する")
                    .foregroundColor(.white)
                    .bold()
                    .frame(width: UIScreen.main.bounds.width-32, height: 50)
                    .background(Color.customBlue.opacity(0.8))
                    .cornerRadius(10)
            }
            .offset(y: (
                !(viewModel.selectedHobbies.filter { !userModel.user.hobbies.contains($0) }.count != 0 || viewModel.selectedHobbies.count != userModel.user.hobbies.count) ) ? 160 : -16)
        }
        .padding(.horizontal, 16)
        .onReceive(viewModel.$isSuccess){ if $0 { presentationMode.wrappedValue.dismiss() } }
        .onAppear {
            viewModel.selectedHobbies = userModel.user.hobbies
        }
        .toolbar {
            ToolbarItem(placement: .principal){
                Text("タグ")
                    .foregroundColor(.customBlack)
                    .font(.system(size: 16, weight: .medium))
            }
        }
        .alert(isPresented: $viewModel.isFailedStoreData) {
            Alert(title: Text("エラー"), message: Text("データの更新に失敗しました。ネットワーク等の接続をご確認の上、再度お試しください。"))
        }
    }
}

struct HobbiesView_Previews: PreviewProvider {
    static var previews: some View {
        UserHobbiesEditorView()
    }
}
