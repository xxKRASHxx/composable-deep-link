import Foundation

public protocol DeepLinkProcessing {
    associatedtype Result
    func handle(url: URL) -> Result?
}
