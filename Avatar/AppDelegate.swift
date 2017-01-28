//
//  AppDelegate.swift
//  Avatar
//
//  Created by Daniel Tartaglia on 1/27/17.
//  Copyright © 2017 Haneke Design. All rights reserved.
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
	func upload(avatar: Data, completion: @escaping (Result<Void>) -> Void) {
		if shouldSucceed {
			completion(.success())
		}
		else {
			completion(.failure(APIError.failed))
		}
		shouldSucceed = !shouldSucceed
	}

	var shouldSucceed: Bool = true
}

enum APIError: Error {
	case failed
}
