import XCTest
@testable import shortcutHomeAssignment

final class ShortcutHomeAssignmentTests: XCTestCase {

    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
    }
   
    func testShouldReturnComicIfNothingIsProvided() async throws {
        print("this is a test start")
        let httpSession = MockHttpRequestProvider()
        let networkService = shortcutHomeAssignment.Network(httpSession: httpSession)
        let result = try await networkService.postSearchTitle(title: "test")
        XCTAssertTrue(result != nil)
        XCTAssertTrue(result.comicDetails?.title == "Rapid Test Results")
    }
}
