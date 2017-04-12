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

	@IBAction func changeAvatar(_ sender: UITapGestureRecognizer) {
		guard let senderView = sender.view else { fatalError("Tapped on viewless gesture recognizer?") }
		let controller = UIImagePickerController()
		controller.delegate = self
		choiceIndexUsingActionSheet(title: "", message: "", choices: sourceOptions.map { $0.title }, onSourceView: senderView).then { index in
			sourceOptions[index].action(controller)
			self.present(controller, animated: true, completion: nil)
		}
	}

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

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
		let image = (info[UIImagePickerControllerEditedImage] as? UIImage) ?? (info[UIImagePickerControllerOriginalImage] as? UIImage)
		if let data = image.flatMap({ UIImageJPEGRepresentation($0, 0.8)} ) {			
			api.upload(avatar: data).then {
				self.avatarView.image = image
				self.dismiss(animated: true, completion: nil)
			}.catch { error in
				self.dismiss(animated: true) {
					self.displayInformationAlert(title: "Error", message: error.localizedDescription)
				}
			}
		}
	}

	func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
		dismiss(animated: true, completion: nil)
	}
}
