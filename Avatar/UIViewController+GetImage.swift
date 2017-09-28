//
//  UIViewController+GetImage.swift
//  Avatar
//
//  Created by Daniel Tartaglia on 1/28/17.
//  Copyright © 2017 Haneke Design. All rights reserved.
//

import UIKit


extension UIViewController
{
	func getImage(focusView: UIView) -> Promise<UIImage> {
		let delegate = ImagePickerDelegate()
		let controller = UIImagePickerController()
		controller.delegate = delegate
		let result = choiceIndexUsingActionSheet(title: "", message: "", choices: sourceOptions.map { $0.title }, onSourceView: focusView).then { (index) -> Promise<UIImage> in
			controller.sourceType = sourceOptions[index].sourceType
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

private let sourceOptions: [(title: String, sourceType: UIImagePickerControllerSourceType)] = {
	var result = [(title: String, sourceType: UIImagePickerControllerSourceType)]()
	if UIImagePickerController.isSourceTypeAvailable(.camera) {
		result.append(("Camera", .camera))
	}
	if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
		result.append(("Photos", .photoLibrary))
	}
	return result
}()
