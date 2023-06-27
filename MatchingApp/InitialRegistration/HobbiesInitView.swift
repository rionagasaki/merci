//
//  HobbiesInitView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/06/25.
//

import SwiftUI

struct HobbiesInitView: View {
    @StateObject var viewModel = HobbiesViewModel()
    @EnvironmentObject var userModel: UserObservableModel
    @Environment(\.dismiss) var dismiss
    @Binding var presentationMode: PresentationMode
    let UIIFGeneratorMedium = UIImpactFeedbackGenerator(style: .medium)
    var isEnabled: Bool {
        userModel.hobbies.count >= 3
    }
    
    var body: some View {
        VStack {
            Text("興味のあるタグを\n設定してください(3つ以上)")
                .font(.system(size: 25))
                .fontWeight(.bold)
                .foregroundColor(Color.customBlack)
                .padding(.top, 16)
                .padding(.leading, 16)
                .frame(maxWidth: .infinity, alignment: .leading)
            ScrollView {
                VStack {
                    GeometryReader { geometry in
                        generateTags(geometry)
                    }
                    .padding()
                }
            }
            Spacer()
            Divider()
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(viewModel.selectedHobbies, id:\.self) { hobby in
                        OneHobbyView(hobby: hobby, selected: false)
                    }
                }
                .padding(.vertical, 8)
                .padding(.horizontal, 8)
            }
            Divider()
            if isEnabled {
                NavigationLink {
                    MainImageView(presentationMode: $presentationMode)
                        .onAppear {
                            UIIFGeneratorMedium.impactOccurred()
                        }
                } label: {
                    Text("次へ")
                        .foregroundColor(.white)
                        .bold()
                        .frame(width: UIScreen.main.bounds.width-32, height: 50)
                        .background(Color.pink)
                        .cornerRadius(10)
                }
            } else {
                Text("次へ")
                    .foregroundColor(.white)
                    .bold()
                    .frame(width: UIScreen.main.bounds.width-32, height: 50)
                    .background(Color.gray.opacity(0.8))
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
        .onChange(of: viewModel.selectedHobbies) { _ in
            userModel.hobbies = viewModel.selectedHobbies
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
