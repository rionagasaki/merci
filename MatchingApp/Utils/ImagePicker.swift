//
//  ImagePicker.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/05/11.
//
import Foundation
import CropViewController
import SwiftUI
import PhotosUI

struct ProfileImagePicker: UIViewControllerRepresentable {

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
        
        var parent: ProfileImagePicker
        
        init(_ parent: ProfileImagePicker){
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

struct PostImagePicker: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    @Binding var image: [UIImage]
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<PostImagePicker>) -> PHPickerViewController {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 4 - image.count
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: UIViewControllerRepresentableContext<PostImagePicker>) {}
    
    class Coordinator: NSObject, UINavigationControllerDelegate, PHPickerViewControllerDelegate {
        let parent: PostImagePicker
        
        init(_ parent: PostImagePicker) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            parent.presentationMode.wrappedValue.dismiss()

            results.map { result in
                let itemProvider = result.itemProvider
                if itemProvider.canLoadObject(ofClass: UIImage.self) {
                    itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, _ in
                        guard let image = image as? UIImage else {
                            return
                        }
                        DispatchQueue.main.async {
                            self?.parent.image.append(image)
                        }
                    }
                }
            }
        }
    }
}
