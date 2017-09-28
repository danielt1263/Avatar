//
//  ViewController.swift
//  Avatar
//
//  Created by Daniel Tartaglia on 1/27/17.
//  Copyright © 2017 Daniel Tartaglia. MIT License.
//

import UIKit

class ViewController: UIViewController
{
	@IBOutlet weak var avatarView: UIImageView!

	var api: API!
	var imagePickerDelegate: ImagePickerDelegate!

	@IBAction func changeAvatar(_ sender: UITapGestureRecognizer) {
		guard let senderView = sender.view else { fatalError("Tapped on viewless gesture recognizer?") }
		
		imagePickerDelegate = ImagePickerDelegate()
		imagePickerDelegate.promise.then { [unowned self] image -> Promise<UIImage> in
			guard let data = UIImageJPEGRepresentation(image, 0.8) else { throw JPEGRepresentationError.badImage }
			return self.api.upload(avatar: data).then { image }
		}
		.then { [unowned self] image in
			self.avatarView.image = image
		}
		.always { [unowned self] in
			self.dismiss(animated: true, completion: nil)
		}
		.catch { [unowned self] error in
			guard error as? UserInteractionError != .userCanceled else { return }
			self.displayInformationAlert(title: "Error", message: error.localizedDescription)
		}
		
		let controller = UIImagePickerController()
		controller.delegate = imagePickerDelegate
		choiceIndexUsingActionSheet(title: "", message: "", choices: sourceOptions.map { $0.title }, onSourceView: senderView).then { index in
			controller.sourceType = sourceOptions[index].sourceType
			self.present(controller, animated: true, completion: nil)
		}
	}

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

enum JPEGRepresentationError: Error {
	case badImage
}
