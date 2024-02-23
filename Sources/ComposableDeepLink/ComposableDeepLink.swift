import Foundation

typealias DeepLink = ComposableDeepLink

public struct ComposableDeepLink<Processing: DeepLinkProcessing>: DeepLinkProcessing {
    
    private let processors: any Sequence<Processing>
    
    init(@ArrayBuilder<Processing> processors: () -> any Sequence<Processing>) {
        self.processors = processors()
    }
    
    public func handle(url: URL) -> Processing.Result? {
        processors
            .compactMap { processor in processor.handle(url: url) }
            .first
    }
}
