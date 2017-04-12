//
//  AppDelegate.swift
//  Avatar
//
//  Created by Daniel Tartaglia on 1/27/17.
//  Copyright © 2017 Daniel Tartaglia. MIT License.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?


	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

		if let controller = window?.rootViewController as? ViewController {
			controller.api = MockAPI()
		}

		return true
	}


}


class MockAPI: API {
	func upload(avatar: Data) -> Promise<Void> {
		return Promise { fulfill, reject in
			if self.shouldSucceed {
				fulfill()
			}
			else {
				reject(APIError.failed)
			}
			self.shouldSucceed = !self.shouldSucceed
		}
	}
	
	var shouldSucceed: Bool = true
}

enum APIError: Error {
	case failed
}
