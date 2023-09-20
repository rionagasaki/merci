//
//  CropImageViewController.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/06/19.
//

import UIKit
import CropViewController
import PhotosUI

class CropImageViewController: UIViewController, PHPickerViewControllerDelegate , CropViewControllerDelegate  {
    
    weak var delegate: CropImageViewControllerDelegate?
    var originalImage: UIImage?
    let UIIFGeneratorMedium = UIImpactFeedbackGenerator(style: .medium)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIIFGeneratorMedium.impactOccurred()
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 5 // 選択数
        configuration.filter = .images // 写真のみ
        configuration.preferredAssetRepresentationMode = .current // これがないとJPEGが選択できなかった
        
        let picker = PHPickerViewController.init(configuration: configuration)
        picker.delegate = self
        
        present(picker, animated: true)
    }
    
    
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        results.forEach { result in
            let itemProvider = result.itemProvider
            if itemProvider.canLoadObject(ofClass: UIImage.self) {
                itemProvider.loadObject(ofClass: UIImage.self) { [weak self] (image, error) in
                    DispatchQueue.main.async {
                        if let image = image as? UIImage {
                            self?.showCrop(image: image)
                        }
                    }
                }
            }
        }
        
        if let firstItemProvider = results.first?.itemProvider, firstItemProvider.canLoadObject(ofClass: UIImage.self) {
            firstItemProvider.loadObject(ofClass: UIImage.self) { [weak self] (image, error) in
                DispatchQueue.main.async {
                    if let image = image as? UIImage {
                        self?.showCrop(image: image)
                    }
                }
            }
        } else {
            delegate?.cancel()
        }
    }
    
    func showCrop(image: UIImage){
        let vc = CropViewController(croppingStyle: .default, image: image)
        vc.aspectRatioPreset = .presetSquare
        vc.aspectRatioLockEnabled = true
        vc.toolbarPosition = .bottom
        vc.doneButtonTitle = "続ける"
        vc.cancelButtonTitle = "キャンセル"
        vc.delegate = self
        present(vc, animated: true)
    }
    
    func cropViewController(_ cropViewController: CropViewController, didFinishCancelled cancelled: Bool) {
        delegate?.cancel()
        cropViewController.dismiss(animated: true)
    }
    
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        delegate?.imageEditorViewController(self, editedImage: image)
        cropViewController.dismiss(animated: true)
    }
}

protocol CropImageViewControllerDelegate: AnyObject {
    func imageEditorViewController(_ editor: CropImageViewController, editedImage: UIImage?)
    func cancel()
}
