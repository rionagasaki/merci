//
//  generateTags.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/06/09.
//

import Foundation
import SwiftUI

class TagViewGenerator {
    
    static func generateTags(_ width: CGFloat, tags:[String]) -> some View {
        var leading = CGFloat.zero
        var top = CGFloat.zero
        
        return ZStack(alignment: .topLeading) {
            
            ForEach(tags, id: \.self) { tag in
                TagLabelView(tagName: tag)
                .padding([.horizontal, .vertical], 4)
                .alignmentGuide(.leading, computeValue: { context in
                    if abs(leading - context.width) > width {
                        // 改行の場合はleadingをリセットする
                        leading = 0
                        // topも積算する
                        top -= context.height
                    }
                    
                    // 改行判定後に返却値を代入
                    let result = leading
                    
                    if tag == tags.last {
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
                    if tag == tags.last {
                        // 複数回計算されるためリセットする
                        top = 0
                    }
                    
                    return result
                })
            }
        }
    }
    
    static func generateEditTags(allTags: [String], selectedTags: Binding<[String]>, _ geometry: GeometryProxy) -> some View {
        var leading = CGFloat.zero
        var top = CGFloat.zero
        
        return ZStack(alignment: .topLeading) {
            
            ForEach(allTags, id: \.self) { tag in
                Button {
                    if selectedTags.wrappedValue.contains(tag) {
                        selectedTags.wrappedValue = selectedTags.wrappedValue.filter({ result in
                            result != tag
                        })
                    } else {
                        selectedTags.wrappedValue.append(tag)
                    }
                } label: {
                    OneHobbyView(hobby: tag, selected: selectedTags.wrappedValue.contains(tag))
                }
                .padding([.horizontal, .vertical], 4)
                .alignmentGuide(.leading, computeValue: { context in
                    if abs(leading - context.width) > geometry.size.width {
                        leading = 0
                        top -= context.height
                    }
                    
                    let result = leading
                    
                    if tag == allTags.last {
                        leading = 0
                    } else {
                        leading -= context.width
                    }
                    return result
                })
                .alignmentGuide(.top, computeValue: { _ in
                    let result = top
                    if tag == allTags.last {
                        top = 0
                    }
                    return result
                })
            }
        }
    }
}
