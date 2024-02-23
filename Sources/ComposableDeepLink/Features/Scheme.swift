import Foundation

public struct Scheme<Processing: DeepLinkProcessing>: DeepLinkProcessing {
    
    let scheme: String
    private let processors: any Sequence<Processing>
    
    public init(
        _ scheme: String,
        @ArrayBuilder<Processing> processors: () -> any Sequence<Processing>
    ) {
        self.scheme = scheme
        self.processors = processors()
    }
    
    public func handle(url: URL) -> Processing.Result? {
        guard url.scheme == scheme else { return nil }
        return processors
            .compactMap { processor in processor.handle(url: url) }
            .first
    }
}
