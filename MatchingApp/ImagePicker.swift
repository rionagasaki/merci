//
//  ImagePicker.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/05/11.
//
import Foundation
import CropViewController
import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {

    var sourceType: UIImagePickerController.SourceType = .photoLibrary
    
    @Binding var selectedImage: UIImage?
    @Environment(\.presentationMode) private var presentationMode
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let vc = CropImageViewController.init()
        vc.delegate = context.coordinator
        vc.originalImage = selectedImage
        return vc
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    final class Coordinator: NSObject, CropImageViewControllerDelegate {
        
        var parent: ImagePicker
        
        init(_ parent: ImagePicker){
            self.parent = parent
        }
        
        func imageEditorViewController(_ editor: CropImageViewController, editedImage: UIImage?) {
            guard let editedImage = editedImage else { return }
            // メインイメージはそのまま設定する.
            parent.selectedImage = editedImage
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        func cancel() {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

struct SubImagePicker: UIViewControllerRepresentable {
    
    var sourceType: UIImagePickerController.SourceType = .photoLibrary
    let index: Int
    @Binding var selectedImages: [UIImage]
    @Environment(\.presentationMode) private var presentationMode
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let vc = CropImageViewController.init()
        vc.delegate = context.coordinator
        return vc
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    final class Coordinator: CropImageViewControllerDelegate {
        func imageEditorViewController(_ editor: CropImageViewController, editedImage: UIImage?) {
            if let image = editedImage {
                //　写真が3つあったらINDEXは2
                if parent.selectedImages.count - 1 < parent.index {
                    parent.selectedImages.append(image)
                } else {
                    parent.selectedImages[parent.index] = image
                }
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        func cancel() {
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        var parent: SubImagePicker
        
        init(_ parent: SubImagePicker){
            self.parent = parent
        }
    }
}
