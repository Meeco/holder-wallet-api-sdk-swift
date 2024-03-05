import Foundation
import OpenAPIRuntime


public struct MeecoHolderWalletApiSdk {

  private static let serverURL = try! Servers.server1()


  private let underlyingClient: any APIProtocol
  private init(underlyingClient: any APIProtocol) {
    self.underlyingClient = underlyingClient
  }

  public init(
    transport: any ClientTransport,
    serverURL: URL? = nil
  ) {
    self.init(
      underlyingClient: Client(
        serverURL: serverURL ?? Self.serverURL,
        transport: transport
      )
    )
  }
}
