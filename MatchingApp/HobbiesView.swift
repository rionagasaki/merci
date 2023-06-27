//
//  HobbiesView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/05/24.
//

import SwiftUI

struct HobbiesView: View {
    @StateObject var viewModel = HobbiesViewModel()
    @EnvironmentObject var userModel: UserObservableModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            ScrollView {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack{
                            ForEach(viewModel.selectedHobbies, id:\.self) { hobby in
                                OneHobbyView(hobby: hobby, selected: true)
                            }
                        }
                        .padding(.vertical, 8)
                        .padding(.leading, 16)
                    }
                    
                GeometryReader { geometry in
                    generateTags(geometry)
                }
                .padding()
            }
            Button {
                SetToFirestore.shared.updateHobbies(uid: userModel.uid, hobbies: viewModel.selectedHobbies)
                userModel.hobbies = viewModel.selectedHobbies
                dismiss()
            } label: {
                Text("変更を保存する")
                    .foregroundColor(.white)
                    .bold()
                    .frame(width: UIScreen.main.bounds.width-32, height: 50)
                    .background(Color.pink.opacity(0.7))
                    .cornerRadius(10)
            }
        }
        .navigationTitle("興味")
        .navigationBarBackButtonHidden()
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
        .onAppear {
            viewModel.selectedHobbies = userModel.hobbies
        }
    }
    
    
    private func generateTags(_ geometry: GeometryProxy) -> some View {
        var leading = CGFloat.zero
        var top = CGFloat.zero
        
        return ZStack(alignment: .topLeading) {
            
            ForEach(viewModel.hobbies, id: \.self) { tag in
                Button {
                    if viewModel.selectedHobbies.contains(tag){
                        viewModel.selectedHobbies = viewModel.selectedHobbies.filter({ result in
                            result != tag
                        })
                    } else {
                        viewModel.selectedHobbies.append(tag)
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
        HobbiesView()
    }
}
