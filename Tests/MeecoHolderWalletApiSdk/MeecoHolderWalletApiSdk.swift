import MeecoHolderWalletApiSdk
import OpenAPIURLSession
import XCTest

final class MeecoHolderWalletApiSdkTest: XCTestCase {
  var client: MeecoHolderWalletApiSdk!

  override func setUp() {
    assert(client == nil)
    client = MeecoHolderWalletApiSdk(transport: URLSessionTransport(), serverURL: URL(string: "http://holder-wallet-dev.svx.internal")!)
  }

  func testClient() async throws {
       XCTAssertNotNil(client, "Client should not be nil after setup")
  }
}
