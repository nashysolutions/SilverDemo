<p align="center">
    <img src="Logo.png" width="480" max-width="90%" alt="Sheet" />
</p>

<p align="center">
    <a href="https://img.shields.io/badge/carthage-compatible-brightgreen.svg">
        <img src="https://img.shields.io/badge/carthage-compatible-brightgreen.svg" alt="Carthage"/>
    </a>
    <a href="https://swift.org/blog/swift-5-released/">
        <img src="https://img.shields.io/badge/swift-5.0-orange.svg" alt="Swift"/>
  </a>
</p>

<p align="center">
    <a href="https://developer.apple.com/icloud/cloudkit/">
        <img src="https://user-images.githubusercontent.com/51816980/60072085-46887980-9714-11e9-923f-bf573d41f1cb.gif" alt="Preview"/>
  </a>
</p>

## Usage

### Account Inspection

```swift
CurrentUser.account { [weak self] (result) in
    switch result {
    case .success(let status):
        DispatchQueue.main.async { self?.handle(success: status) }
    case .failure(let error):
        DispatchQueue.main.async { self?.handle(error: error) }
    }
}

func handle(success status: AccountStatus) {
    switch status {
    case .available:
    case .couldNotDetermine(let message):
    case .noAccount(let message):
    case .restricted(let message):
    }
}

func handle(error: CloudError?) {
    guard let error = error else {
        unexpected(unexpectedErrorMessage)
        return
    }
    switch error {
    case .incompatibleVersion(let message):
    case .networkFailure(let message, let seconds): // delay before retry
    case .notAuthenticated(let message):
    case .operationCancelled(let message):
    case .requestRateLimited(let message, let seconds):  // delay before retry
    case .serverResponseLost(let message):
    case .serviceUnavailable(let message, let seconds):
    default:
        unexpected(unexpectedErrorMessage)
    }
}
```

> No network activity occurs. Random `CKError` instances are generated locally. Errors descriptions are available via [Xcode Quick Help](https://developer.apple.com/library/archive/documentation/Xcode/Reference/xcode_markup_formatting_ref/SymbolDocumentation.html).

### Social Visibility

```swift
CurrentUser.discoverability { (result) in
    switch result {
    case .success(let status):
        DispatchQueue.main.async { self.handle(success: status) }
    case .failure(let error):
        DispatchQueue.main.async { self.handle(error: error) }
    }
}

func handle(success status: ApplicationPermissionStatus) {
    switch status {
    case .granted:
    case .couldNotComplete(let message):
    case .denied(let message):
    }
}

private func handle(error: CloudError?) {
    guard let error = error else {
        unexpected(unexpectedErrorMessage)
        return
    }
    switch error {
    case .incompatibleVersion(let message):
    case .networkFailure(let message, let seconds): // delay before retry
    case .operationCancelled(let message):
    case .requestRateLimited(let message, let seconds): // delay before retry
    case .serverResponseLost(let message):
    case .serviceUnavailable(let message, let seconds): // delay before retry
    default:
        unexpected(unexpectedErrorMessage)
    }
}
```

> No network activity occurs. Random `CKError` instances are generated locally. Errors descriptions are available via [Xcode Quick Help](https://developer.apple.com/library/archive/documentation/Xcode/Reference/xcode_markup_formatting_ref/SymbolDocumentation.html).

## Acknowledgement

Shoutout to [CrunchyBagel](https://crunchybagel.com/simulating-cloudkit-errors/) for providing the random error generator. Many thanks.
