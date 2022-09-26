import Foundation

protocol HttpRequestProvider {
    func getDataWithURL(url: URL) async throws -> (Data, URLResponse)
    func getDataWithRequest(request: URLRequest) async throws -> (Data, URLResponse)
}
