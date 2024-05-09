<h1 align="center"> MeecoHolderWalletApiSdk </h1>

Provides a Swift-friendly API into the API for Meeco Holder Wallet API

## Introduction

The Holder Wallet API (the service) provides an interface for managing (personal) digital wallets inside an SVX tenant environment. It facilitates a range of operations including key management, DID management, and credential issuance (receiving) and credential presentation (presenting). The goal is to provide flexibility on how the component is integrated, be it with a mobile or web application, or with a third party service.

All cryptographic keys are managed by the service (often referred to as custodial key management) in a secure manner and can be used to control identifers (i.e. DIDs), as well as perform key binding in credentials.

The service facilitates receiving and presenting credentials in accordance to leading standards and specifications in the space. The main focus is on the family of OpenID4VC standards, JWT based credential formats and (optionally) DIDs.

One instance of the service is able to manage multiple wallets, each of which is a collection of keys, DIDs and associated credentials. This service operates in a trusted environment where its client applications are expected to be trusted as well.

## Wallet Management

It is possible to identify a wallet using an external identifier that matches the client application's user identifier. When providing an external identifier to the create wallet operation, it first searches if an existing wallet exists and returns a reference instead of creating a new instance.

## Key Management

Keys to perform various cryptographic operations are managed within the service and private keys never leave the service.

The following operations are supported:

- Create a new key
- Delete an existing key
- Get a key
- Import an existing key
- Sign
- Sign JWT
- Encrypt JWE
- Decrypt JWE

The service supports the following algorithms as defined in RFC7518:

- ES256

Keys are stored currently stored in a DB (e.g. Postgres). We plan to add integration with HSM services in the future.

## DID Management

Each wallet is able to manage one or more DIDs. The supported DID methods can be found [here](https://docs.meeco.me/guides/api-guides/dids/did-methods). A DID is typically used as a key binding mechanism in a verifiable credential. The key binding takes place in the issuance process and proof is provided during the presentation process.

## Credential Management

The wallet supports the following credential life cycle operations:

- Receive a credential
- Present a credential
- Import an existing credential

Receiving a credential from an issuer typically involves key binding, which is a process where the service provides a public key or DID to the issuer alongside proof that is controls the key material. When this is completed, the credential, signed by the issuer, is stored in the wallet with a reference to the `kid`.
Presenting a credential to a verifier involves sending the credential, alongside proof of the key binding, to the verifier.

Note that not all credential formats are supported. Please refer to the section on Supported Standards for more information on the different formats that are currently supported.

## SVX Integration

The service is integrated with SVX Platform, which provides a range of services, including:

- DID operations (create, get)
- Credential operations (verify)
- Secure data storage (store credentials)

All wallets belong to one tenant and receive a DID from the SVX Platform where they are registered as end-users. The DID is used to identify the wallet in the SVX Platform.

Every wallet instance uses its registered DID to authenticate with the SVX Platform. This enables the service to perform operations and store data for each user in its own context. For performance reasons, access tokens are cached for a limited amount of time (this can be configured).

## Supported Standards and Specifications

The Wallet provides support for a variety of specifications and standards with the aim of achieving interoperablity with the wider ecosystem. What follows is a list of the supported specifications and standards grouped per logical domain.

**Cryptographic Keys**

- `JWK`: [RFC7517](https://datatracker.ietf.org/doc/html/rfc7517)
- `JWA`: [RFC7518](https://datatracker.ietf.org/doc/html/rfc7518)
- `JWE`: [RFC7516](https://datatracker.ietf.org/doc/html/rfc7516)
- `JOSE`: [JOSE IANA registry](https://www.iana.org/assignments/jose/jose.xhtml)

**Credential formats**:

- `jwt_vc_json`: [W3C Verifiable Credentials](https://www.w3.org/TR/vc-data-model/)
- `vc+sd-jwt`: [IETF SD-JWT VC](https://datatracker.ietf.org/doc/draft-ietf-oauth-sd-jwt-vc/)

**Key Discovery**

- `/.well-known/jwt-vc-issuer` (IETF SD-JWT VC)

**Credential issuance**:

- OpenID 4 Verifiable Credential Issuance (draft 13) [(WG Draft)](https://openid.net/specs/openid-4-verifiable-credential-issuance-1_0.html) [(Editors Draft)](https://openid.github.io/OpenID4VCI/openid-4-verifiable-credential-issuance-wg-draft.html)
  - Pre-Authorized Code flow
  - Authorization Code flow
- [RFC9126 Pushed Authorization Request](https://www.rfc-editor.org/info/rfc9126)

**Credential Presentation**

- OpenID 4 Verifiable Presentation [(WG Draft)](https://openid.net/specs/openid-4-verifiable-presentations-1_0.html)

## Authentication and Authorization

The service doesn't provide authentication or authorization out-of-the-box. It is up to the client to provide this and the service as such is expected to run inside a secure environment and not directly exposed to the outside world.

A few examples of how the service can be deployed are:

- Behind an API gateway (e.g. AWS API Gateway, Azure API Management, Krakend)
- Behind a Backend For Frontend service facing the outside world

## Deployment

The service can be deployed on-premises or in a cloud environment. It relies on following services:

- Postgres (application database; keys, dids, credential metadata)
- SVX API
- Redis (access tokens)

## Installation

### Requirements

**Apple Platforms**

- Xcode 15.0.1 or later
- Swift 5.9 or later
- iOS 17.0 / watchOS 10.0 / tvOS 17.0 / macOS 14.0 / visionOS 1.0 or later deployment targets

**Linux**

- Ubuntu 20.04 or later
- Swift 5.9 or later

### Swift Package Manager

Swift Package Manager is Apple's decentralized dependency manager to integrate libraries to your Swift projects. It is now fully integrated with Xcode 11.

To integrate **MeecoHolderWalletApiSdk** into your project using SPM, specify it in your Package.swift file:

```swift

  import PackageDescription

  let package = Package(
      name: "MyAppClient",
          platforms: [
          .macOS(.v10_15), // Specify minimum platform version here
      ],
      dependencies: [
              .package(url: "https://github.com/Meeco/holder-wallet-api-sdk-swift", from: "0.0.1-beta.1"),
          ],
      targets: [
          // Targets are the basic building blocks of a package, defining a module or a test suite.
          // Targets can depend on other targets in this package and products from dependencies.
          .executableTarget(
              name: "MyAppExecutable",
              dependencies: [
                          .product(name: "MeecoHolderWalletApiSdk", package: "meeco-holder-wallet-api-sdk-swift")
                      ]
          ),
      ]
  )
```

If this is for an Xcode project simply import the repo at:

```
https://github.com/Meeco/holder-wallet-api-sdk-swift
```

## Example Usage

```swift
import Foundation
import OpenAPIURLSession
import MeecoHolderWalletApiSdk

do {
    let client = Client(
        serverURL: try Foundation.URL(
            validatingOpenAPIServerURL: "https://api.holderwallet.com"
        ),
        transport: URLSessionTransport()
    )

    let response = try await client.AppController_getVersion()
    print(try response.ok.body.json)
} catch {
    print("An error occurred: \(error)")
}

## Documentation

_Coming Soon!_

## Roadmap

_Coming Soon!_

- [ ] Coming Soon

## License

This code is distributed under the MIT license. See the [LICENSE](LICENSE) file for more info.
```
