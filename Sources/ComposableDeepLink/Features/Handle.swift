import Foundation

public struct Handle<Result>: DeepLinkProcessing {
    
    private let handler: () -> Result?
    
    public init(_ handler: @escaping () -> Result?) {
        self.handler = handler
    }
    
    public func handle(url: URL) -> Result? {
        handler()
    }
}
