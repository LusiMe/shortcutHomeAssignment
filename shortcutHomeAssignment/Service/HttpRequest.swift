import Foundation

class HttpRequest: HttpRequestProvider {
    func getDataWithURL(url: URL) async throws -> (Data, URLResponse) {
        return try await URLSession.shared.data(from: url)
    }
    
    func getDataWithRequest(request: URLRequest) async throws -> (Data, URLResponse) {
        return try await URLSession.shared.data(for: request)
    }
}
