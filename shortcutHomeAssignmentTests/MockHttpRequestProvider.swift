import Foundation
@testable import shortcutHomeAssignment

protocol MockResponseProtocol: URLResponse {
    var statusCode: Int { get set }
}

class MockResponse: URLResponse, MockResponseProtocol {
    var statusCode: Int = 0
}

class MockHttpRequestProvider: shortcutHomeAssignment.HttpRequestProvider {
    func getDataWithURL(url: URL) async throws -> (Data, URLResponse) {
        return (try Data(), URLResponse())
    }
    
    func getDataWithRequest(request: URLRequest) async throws -> (Data, URLResponse) {
        guard let path = Bundle.main.url(forResource: "search_response", withExtension: "json") else {
            throw NetworkError.noData
        }
        
        let data = try Data(contentsOf: path)
        let urlResponse = MockResponse(url: URL(fileURLWithPath: ""), mimeType: "", expectedContentLength: 0, textEncodingName: "")
        urlResponse.statusCode = 200
        return (data, urlResponse)
    }
}
