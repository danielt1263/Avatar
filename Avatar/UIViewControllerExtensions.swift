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
	func displayInformationAlert(title: String, message: String, handler: @escaping () -> Void = { }) {
		let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in handler() }))
		present(alert, animated: true, completion: nil)
	}
}
