import Foundation

struct RequestAPI<T: Decodable> {
    let url: URL
    let method: CommandsForHTTP
    let body: Data?
    let headers: [String: String]?
    
    init(url: URL, method: CommandsForHTTP, body: Data? = nil, headers: [String: String]? = nil) {
        self.url = url
        self.method = method
        self.body = body
        self.headers = headers
    }
}
