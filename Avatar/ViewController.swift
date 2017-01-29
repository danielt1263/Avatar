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
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	@IBAction func changeAvatar(_ sender: UITapGestureRecognizer) {
		guard let senderView = sender.view else { fatalError("Tapped on viewless gesture recognizer?") }

		getImage(focusView: senderView).then { image -> Promise<UIImage> in
			guard let data = UIImageJPEGRepresentation(image, 0.8) else { throw JPEGRepresentationError.badImage }
			return self.api.upload(avatar: data).then { image }
		}
		.then { image in
			self.avatarView.image = image
		}
		.catch { error in
			guard error is UserInteractionError == false || (error as! UserInteractionError) != .userCanceled else { return }
			let _ = self.displayInformationAlert(title: "Error", message: error.localizedDescription)
		}
	}
	
}

enum JPEGRepresentationError: Error {
	case badImage
}
