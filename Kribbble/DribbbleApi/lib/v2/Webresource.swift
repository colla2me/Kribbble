import Foundation

fileprivate let decoder = JSONDecoder()

func parseShots(with url: URL) -> Resource<[Shot]> {
	let parse = Resource<[Shot]>(url: url, parseJSON: { data in
		do {
			let model = try decoder.decode([Shot].self, from: data)
			return .success(model)
		} catch {
			return .failure(.errorParsingJSON)
		}
	})
	return parse
}
