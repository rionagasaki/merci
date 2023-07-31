//
//  HobbiesView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/05/24.
//

import SwiftUI

struct UserHobbiesEditorView: View {
    @StateObject var viewModel = UserHobbiesEditorViewModel()
    @EnvironmentObject var userModel: UserObservableModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            ScrollView {
                GeometryReader { geometry in
                    tagGenerater(geometry)
                }
                .padding()
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
                        }
                    }
                    .padding(.vertical, 8)
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
                    .background(Color.pink.opacity(0.8))
                    .cornerRadius(10)
            }
            .offset(y:
                (userModel.user.hobbies == viewModel.selectedHobbies) ? 120 : 0
            )
        }
        .navigationTitle("興味")
        .navigationBarBackButtonHidden()
        .onReceive(viewModel.$isSuccess){ if $0 { dismiss() } }
        .onAppear {
            viewModel.selectedHobbies = userModel.user.hobbies
        }
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
        .alert(isPresented: $viewModel.isFailedStoreData) {
            Alert(title: Text("エラー"), message: Text("データの更新に失敗しました。ネットワーク等の接続をご確認の上、再度お試しください。"))
        }
    }
    
    func tagGenerater(_ geometry: GeometryProxy) -> some View {
        var leading = CGFloat.zero
        var top = CGFloat.zero
        
        return ZStack(alignment: .topLeading) {
            
            ForEach(viewModel.hobbies, id: \.self) { tag in
                Button {
                    withAnimation {
                        if viewModel.selectedHobbies.contains(tag){
                            viewModel.selectedHobbies = viewModel.selectedHobbies.filter({ result in
                                result != tag
                            })
                        } else {
                            viewModel.selectedHobbies.append(tag)
                        }
                    }
                } label: {
                    OneHobbyView(hobby: tag, selected: viewModel.selectedHobbies.contains(tag))
                }
                .padding([.horizontal, .vertical], 4)
                .alignmentGuide(.leading, computeValue: { context in
                    if abs(leading - context.width) > geometry.size.width {
                        // 改行の場合はleadingをリセットする
                        leading = 0
                        // topも積算する
                        top -= context.height
                    }
                    
                    // 改行判定後に返却値を代入
                    let result = leading
                    
                    if tag == viewModel.hobbies.last {
                        // 複数回計算されるためリセットする
                        leading = 0
                    } else {
                        // leadingを積算する (次の基準とするため返却値に積算させない)
                        leading -= context.width
                    }
                    return result
                })
                .alignmentGuide(.top, computeValue: { _ in
                    let result = top
                    if tag == viewModel.hobbies.last {
                        // 複数回計算されるためリセットする
                        top = 0
                    }
                    return result
                })
            }
        }
    }
}

struct HobbiesView_Previews: PreviewProvider {
    static var previews: some View {
        UserHobbiesEditorView()
    }
}
