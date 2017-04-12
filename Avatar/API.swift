//
//  API.swift
//  Avatar
//
//  Created by Daniel Tartaglia on 1/27/17.
//  Copyright © 2017 Daniel Tartaglia. MIT License.
//

import Foundation


protocol API
{
	func upload(avatar: Data) -> Promise<Void>
}
