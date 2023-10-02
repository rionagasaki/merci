//
//  Photo.swift
//  Merci
//
//  Created by Rio Nagasaki on 2023/09/28.
//

import SwiftUI

struct Photo: Transferable {
    static var transferRepresentation: some TransferRepresentation {
        ProxyRepresentation(exporting: \.image)
    }


    public var image: Image
    public var caption: String
    
}
