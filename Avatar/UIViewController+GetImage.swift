//
//  UIViewController+GetImage.swift
//  Avatar
//
//  Created by Daniel Tartaglia on 1/28/17.
//  Copyright © 2017 Daniel Tartaglia. MIT License.
//

import UIKit


class ImagePickerDelegate: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
	let promise = Promise<UIImage>()
	
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
