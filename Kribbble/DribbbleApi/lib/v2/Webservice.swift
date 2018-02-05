import UIKit

// see v1, v2 done not yet
// dribble-api-v2 TODO:

enum NetworkingErrors: Error {
	case errorParsingJSON
	case noInternetConnection
	case dataReturnedNil
	case returnedError(Error)
	case invalidStatusCode(String)
	case customError(String)
}

enum Response<T> {
	case success(T)
	case failure(NetworkingErrors)
}

struct Resource<A> {
	let url: URL
	let parse: (Data) -> Response<A>
}

extension Resource {
	init(url: URL, parseJSON: @escaping (Data) -> Response<A>) {
		self.url = url
		self.parse = parseJSON
	}
}

final class WebService {
	func load<A>(resource: Resource<A>, completion: @escaping (Response<A>) -> ()) {
		URLSession.shared.dataTask(with: resource.url) { data, rsp, err in
			let result = self.checkForNetworkErrors(data, rsp, err)
			DispatchQueue.main.async {
				switch result {
				case .success(let data):
					completion(resource.parse(data))
				case .failure(let error):
					completion(.failure(error))
				}
			}
			}.resume()
	}
}

extension WebService {
	
	fileprivate func checkForNetworkErrors(_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Response<Data> {
		// Check for errors in responses.
		if let error = error {
			let nsError = error as NSError
			if nsError.domain == NSURLErrorDomain && (nsError.code == NSURLErrorNotConnectedToInternet || nsError.code == NSURLErrorTimedOut) {
				return .failure(.noInternetConnection)
			} else {
				return .failure(.returnedError(error))
			}
		}
		
		if let response = response as? HTTPURLResponse, response.statusCode <= 200 && response.statusCode >= 299 {
			return .failure((.invalidStatusCode("Request returned status code other than 2xx \(response)")))
		}
		
		guard let data = data else { return .failure(.dataReturnedNil) }
		
		return .success(data)
	}
}


