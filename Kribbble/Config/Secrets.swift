public enum Secrets {
		
	public enum Api {
		public static let base = "https://api.dribbble.com"
		public static let oAuthAuthorization = "https://dribbble.com/oauth/authorize"
		public static let oAuthToken = "https://dribbble.com/oauth/token"
	}
	
	public enum BasicHTTPAuth {
		public static let username = "usr"
		public static let password = "pswd"
	}
	
	public enum Dribbble {
		public static let clientId = "your_client_id"
		public static let clientSecret = "your_client_secret"
		public static let clientAccessToken = "your_access_token"
		public static let redirectURI = "https://dribbble.com"
	}
}
