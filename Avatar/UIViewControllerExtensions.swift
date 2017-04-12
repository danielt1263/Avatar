//
//  UIViewControllerExtensions.swift
//  Avatar
//
//  Created by Daniel Tartaglia on 1/27/17.
//  Copyright © 2017 Daniel Tartaglia. MIT License.
//

import UIKit


enum UserInteractionError: Error {
	case userCanceled
}

extension UIViewController
{
	func choiceIndexUsingActionSheet(title: String, message: String, choices: [String], onSourceView view: UIView) -> Promise<Int> {
		return Promise(queue: DispatchQueue.main) { fulfill, reject in
			let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

			let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in reject(UserInteractionError.userCanceled) })

			let actions = choices.enumerated().map { offset, element in
				UIAlertAction(title: element, style: .default, handler: { _ in fulfill(offset) })
			}
			
			for action in actions + [cancelAction] {
				alert.addAction(action)
			}
			
			if let popoverPresentationController = alert.popoverPresentationController {
				popoverPresentationController.sourceView = view
				popoverPresentationController.sourceRect = view.bounds
			}
			self.present(alert, animated: true, completion: nil)
		}
	}

	@discardableResult
	func displayInformationAlert(title: String, message: String) -> Promise<Void> {
		return Promise(queue: DispatchQueue.main) { fulfill, _ in
			let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
			alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in fulfill() }))
			self.present(alert, animated: true, completion: nil)
		}
	}
}
