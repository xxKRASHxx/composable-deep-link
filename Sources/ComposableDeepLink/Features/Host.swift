import Foundation

public struct Host<Processing: DeepLinkProcessing>: DeepLinkProcessing {
    
    let host: String
    private let processors: any Sequence<Processing>
    
    public init(
        _ host: String,
        @ArrayBuilder<Processing> processors: () -> any Sequence<Processing>
    ) {
        self.host = host
        self.processors = processors()
    }
    
    public func handle(url: URL) -> Processing.Result? {
        guard url.host == host else { return nil }
        return processors
            .compactMap { processor in processor.handle(url: url) }
            .first
    }
}
