//: Playground - noun: a place where people can play

import Foundation

//: We have been tasked with finding the best movie and saving it.

//: Here is the Movie class and the API we have been given.
struct Movie: Equatable {
	let name: String
	let rating: Int

	static func ==(lhs: Movie, rhs: Movie) -> Bool {
		return lhs.name == rhs.name && lhs.rating == rhs.rating
	}
}

protocol API {
	func queryMovies(_ query: String) throws -> [Movie]
	func store(movie: Movie) throws -> URL
}

//: `queryMovies` and `store(movie:)` are synchronous, blocking methods so our solution looks like this:

class MovieHelper {
	
	var api: API!
	
	func saveBestMovie(query: String) throws -> URL? {
		let movies = try api.queryMovies(query)
		let best = movies.max(by: { $0.rating < $1.rating })
		guard let movie = best else { return nil }
		let saved = try api.store(movie: movie)
		return saved
	}
}

//: Notice how clean and obvious this code is. One thing leads to another. If the query fails our function will bail out without trying to execute the other lines.

//: But we live in an asynchronous world. Our caller can't sit around a wait for the movie to be found and saved. So we are given an async API

protocol API2 {
	func queryMovies(_ query: String, callback: @escaping ([Movie]?, Error?) -> Void)
	func store(movie: Movie, callback: @escaping (URL?, Error?) -> Void)
}

class MovieHelper2 {
	
	var api: API2!
	
	func saveBestMovie(query: String, callback: @escaping (URL?, Error?) -> Void) {
		api.queryMovies(query) { (movies, error) in
			if let movies = movies {
				if let best = movies.max(by: { $0.rating < $1.rating }) {
					self.api.store(movie: best) { saved, error in
						if let saved = saved {
							callback(saved, nil)
						}
						else {
							callback(nil, error ?? NSError(domain: "API", code: -1, userInfo: nil))
						}
					}
				} else {
					callback(nil, nil)
				}
			}
			else {
				callback(nil, error ?? NSError(domain: "API", code: -1, userInfo: nil))
			}
		}
	}
}

//: What a complex mess!


//: Using Promises, we can make an extension on our API:

extension API2 {
	func queryMovies(_ query: String) -> Promise<[Movie]> {
		let result = Promise<[Movie]>()
		queryMovies(query) { (movies, error) in
			if let movies = movies {
				result.fulfill(movies)
			}
			else {
				result.reject(error ?? NSError(domain: "API", code: -1, userInfo: nil))
			}
		}
		return result
	}
	
	func store(movie: Movie) -> Promise<URL> {
		let result = Promise<URL>()
		store(movie: movie) { (url, error) in
			if let url = url {
				result.fulfill(url)
			}
			else {
				result.reject(error ?? NSError(domain: "API", code: -1, userInfo: nil))
			}
		}
		return result
	}
}

//: And use it like this:

class MovieHelper3 {
	
	var api: API2!
	
	func saveBestMovie(query: String) -> Promise<URL?> {
		let movies = api.queryMovies(query)
		let best = movies.then { $0.max(by: { $0.rating < $1.rating }) }
		let saved = best.then { best -> Promise<URL?> in
			guard let movie = best else { return Promise<URL?>(value: nil) }
			return self.api.store(movie: movie).then { Optional.some($0) }
		}
		return saved
	}
}

//: Isn't this better? We are back to clean and obvious code. And just like in our synchronous version, if our query fails, and error will be passed out through the promise without executing the rest of the method.
