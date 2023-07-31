//
//  HalfModal.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/07/05.
//

import SwiftUI

extension View {
    func halfModal<SheetView>(
        isPresented: Binding<Bool>,
        @ViewBuilder sheetView: @escaping () -> SheetView
    ) -> some View where SheetView: View {
        return self
            .background {
                HalfSheetHelper(sheetView: sheetView(), isPresented: isPresented)
            }
    }
}

struct HalfSheetHelper<SheetView: View>: UIViewControllerRepresentable {
    var sheetView: SheetView
    @Binding var isPresented: Bool
    let controller = UIViewController.init()
    
    func makeUIViewController(context: Context) -> some UIViewController {
        controller.view.backgroundColor = .clear
        return controller
    }
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        if isPresented {
            let sheetController = CustomHostingController(rootView: sheetView)
            uiViewController.present(sheetController, animated: true) {
                DispatchQueue.main.async {
                    self.isPresented.toggle()
                }
            }
        }
    }
}

class CustomHostingController<Content: View>: UIHostingController<Content> {
    override func viewDidLoad() {
        if let presentationController = presentationController as? UISheetPresentationController {
            presentationController.detents = [.medium()]
        }
    }
}
