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
        
        let picker = PHPickerViewController.init(configuration: .init())
        picker.delegate = self
        
        present(picker, animated: true)
    }
    
    
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
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
