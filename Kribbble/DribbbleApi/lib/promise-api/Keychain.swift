import Security
import Foundation

public final class Keychain {
	private var keyPrefix = "com.kribbble.keychain"
	
	public init() {}
	
	public init(keyPrefix: String) {
		self.keyPrefix = keyPrefix
	}
	
	@discardableResult
	public func set(_ value: String, forKey key: String) -> Bool {
		guard let value = value.data(using: String.Encoding.utf8) else {
			return false
		}
		
		let _ = remove(forKey: key)
		
		let query: [String: Any] = [
			kSecClass as String: kSecClassGenericPassword,
			kSecAttrAccount as String: keyWithPrefix(key),
			kSecValueData as String: value,
			kSecAttrAccessible as String: kSecAttrAccessibleAlways
		]
		
		return SecItemAdd(query as CFDictionary, nil) == noErr
	}
	
	public func get(forKey key: String) -> String? {
		let query: [String: Any] = [
			kSecClass as String: kSecClassGenericPassword,
			kSecAttrAccount as String: keyWithPrefix(key),
			kSecReturnData as String: kCFBooleanTrue,
			kSecMatchLimit as String: kSecMatchLimitOne
		]
		
		var result: AnyObject?
		
		let status = withUnsafeMutablePointer(to: &result) {
			SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0))
		}
		
		guard let data = result as? Data, status == noErr, let value = NSString(data: data, encoding: String.Encoding.utf8.rawValue) as String? else { return nil }
		
		return value
	}
	
	public func remove(forKey key: String) -> Bool {
		let query: [String: Any] = [
			kSecClass as String: kSecClassGenericPassword,
			kSecAttrAccount as String: keyWithPrefix(key),
			kSecAttrSynchronizable as String: kSecAttrSynchronizableAny
		]
		return SecItemDelete(query as CFDictionary) == noErr
	}
	
	private func keyWithPrefix(_ key: String) -> String {
		return "\(keyPrefix)\(key)"
	}
}
