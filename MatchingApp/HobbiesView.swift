//
//  HobbiesView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/05/24.
//

import SwiftUI

struct HobbiesView: View {
    @StateObject var viewModel = HobbiesViewModel()
    var body: some View {
        VStack {
            ScrollView {
                HStack {
                    ForEach(viewModel.selectedHobbies, id:\.self) { hobby in
                        OneHobbyView(hobby: hobby, selected: true)
                    }
                }
                GeometryReader { geometry in
                    generateTags(geometry)
                }
                .padding()
            }
            Button {
                print("aaa")
            } label: {
                Text("決定する")
            }
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
        .navigationTitle("Tag Break")
    }
}

struct HobbiesView_Previews: PreviewProvider {
    static var previews: some View {
        HobbiesView()
    }
}
