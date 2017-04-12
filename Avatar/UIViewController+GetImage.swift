//
//  UIViewController+GetImage.swift
//  Avatar
//
//  Created by Daniel Tartaglia on 1/28/17.
//  Copyright © 2017 Daniel Tartaglia. MIT License.
//

import UIKit


extension UIViewController
{
	func getImage(focusView: UIView) -> Promise<UIImage> {
		let delegate = ImagePickerDelegate()
		let controller = UIImagePickerController()
		controller.delegate = delegate
		let result = choiceIndexUsingActionSheet(title: "", message: "", choices: sourceOptions.map { $0.title }, onSourceView: focusView).then { (index) -> Promise<UIImage> in
			sourceOptions[index].action(controller)
			self.present(controller, animated: true, completion: nil)
			return delegate.promise
		}
		.always {
			self.dismiss(animated: true, completion: nil)
			delegate.retainer = nil
		}
		return result
	}
}

class ImagePickerDelegate: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
	var retainer: ImagePickerDelegate!
	let promise = Promise<UIImage>()
	
	override init() {
		super.init()
		retainer = self
	}

	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
		if let image = (info[UIImagePickerControllerEditedImage] as? UIImage) ?? (info[UIImagePickerControllerOriginalImage] as? UIImage) {
			promise.fulfill(image)
		}
		else {
			promise.reject(UIImagePickerControllerError.missingImage)
		}
	}
	
	func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
		promise.reject(UserInteractionError.userCanceled)
	}
}

enum UIImagePickerControllerError: Error {
	case missingImage
}

private let sourceOptions = { () -> [(title: String, action: (UIImagePickerController) -> Void)] in
	var result = [(title: String, action: (UIImagePickerController) -> Void)]()
	if UIImagePickerController.isSourceTypeAvailable(.camera) {
		result.append(("Camera", { $0.sourceType = .camera }))
	}
	if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
		result.append(("Photos", { $0.sourceType = .photoLibrary }))
	}
	return result
}()
