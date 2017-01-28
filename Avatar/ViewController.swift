//
//  ViewController.swift
//  Avatar
//
//  Created by Daniel Tartaglia on 1/27/17.
//  Copyright © 2017 Haneke Design. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
	@IBOutlet weak var avatarView: UIImageView!

	var api: API!

	@IBAction func changeAvatar(_ sender: UITapGestureRecognizer) {
		let controller = UIImagePickerController()
		controller.delegate = self
		let cameraAction: UIAlertAction? = !UIImagePickerController.isSourceTypeAvailable(.camera) ? nil : UIAlertAction(title: "Camera", style: .default) { _ in
			controller.sourceType = .camera
			self.present(controller, animated: true, completion: nil)
		}
		let photobinAction: UIAlertAction? = !UIImagePickerController.isSourceTypeAvailable(.photoLibrary) ? nil : UIAlertAction(title: "Photos", style: .default) { _ in
			controller.sourceType = .photoLibrary
			self.present(controller, animated: true, completion: nil)
		}
		let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

		let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
		if let cameraAction = cameraAction {
			alert.addAction(cameraAction)
		}
		if let photobinAction = photobinAction {
			alert.addAction(photobinAction)
		}
		alert.addAction(cancelAction)
		if let popoverPresentationController = alert.popoverPresentationController,
			let view = sender.view {
			popoverPresentationController.sourceView = view
			popoverPresentationController.sourceRect = view.bounds
		}
		present(alert, animated: true, completion: nil)
	}

}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
		let image = (info[UIImagePickerControllerEditedImage] as? UIImage) ?? (info[UIImagePickerControllerOriginalImage] as? UIImage)
		if let data = image.flatMap({ UIImageJPEGRepresentation($0, 0.8)} ) {
			api.upload(avatar: data) { [weak self] result in
				switch result {
				case .success:
					self?.avatarView.image = image
					self?.dismiss(animated: true, completion: nil)
				case .failure(let error):
					self?.dismiss(animated: true) {
						let _ = self?.displayInformationAlert(title: "Error", message: error.localizedDescription)
					}
				}
			}
		}
	}

	func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
		dismiss(animated: true, completion: nil)
	}
}
