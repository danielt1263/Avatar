//
//  UIViewControllerExtensions.swift
//  Avatar
//
//  Created by Daniel Tartaglia on 1/27/17.
//  Copyright © 2017 Daniel Tartaglia. MIT License.
//

import UIKit


extension UIViewController
{
	@discardableResult
	func displayInformationAlert(title: String, message: String) -> Promise<Void> {
		return Promise(queue: DispatchQueue.main) { fulfill, _ in
			let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
			alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in fulfill() }))
			self.present(alert, animated: true, completion: nil)
		}
	}
}
