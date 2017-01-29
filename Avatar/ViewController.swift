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
	var imagePickerDelegate: ImagePickerDelegate!
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	@IBAction func changeAvatar(_ sender: UITapGestureRecognizer) {
		guard let senderView = sender.view else { fatalError("Tapped on viewless gesture recognizer?") }
		
		imagePickerDelegate = ImagePickerDelegate()
		imagePickerDelegate.promise.then { [weak self] image in
			if let data = UIImageJPEGRepresentation(image, 0.8) {
				self?.api.upload(avatar: data) { result in
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
		}.catch { [weak self] error in
			self?.dismiss(animated: true, completion: nil)
		}
		
		let controller = UIImagePickerController()
		controller.delegate = imagePickerDelegate
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
