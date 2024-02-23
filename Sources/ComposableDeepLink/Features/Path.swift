import Foundation

public struct Path<Processing: DeepLinkProcessing>: DeepLinkProcessing {
    
    let path: Raw
    
    private let processors: (Context) -> any Sequence<Processing>
    
    public init(
        _ path: Raw,
        @ArrayBuilder<Processing> _ processors: @escaping () -> any Sequence<Processing>
    ) {
        self.path = path
        self.processors = { param in processors() }
    }
    
    public init(
        _ path: Raw,
        @ArrayBuilder<Processing> processors: @escaping (Context) -> any Sequence<Processing>
    ) {
        self.path = path
        self.processors = processors
    }
    
    public func handle(url: URL) -> Processing.Result? {
        do {
            let urlParams = try path.components.regex()
            guard let match = url.path().firstMatch(of: urlParams) else { return nil }
            return processors(
                Context(
                    raw: zip(path.arguments, match.output.dropFirst().map(\.value))
                        .reduce(into: [:]) { (result, zip) in
                            let (argument, value) = zip
                            result[argument] = value.map(String.init(describing:))
                        }
                )
            )
            .compactMap { processor in processor.handle(url: url) }
            .first
        } catch {
            assertionFailure("Was unable to create path regexp for URL: \(url.absoluteString)")
            return nil
        }
    }
}

extension Path.Raw {
    public enum Component {
        case plain(String)
        case argument(String)
    }
}

extension Path {
    public struct Raw: RawRepresentable, ExpressibleByStringLiteral {
        
        public let rawValue: String
        
        public init(rawValue: RawValue) {
            self.rawValue = rawValue
        }
        
        public init(stringLiteral value: String) {
            self.rawValue = value
        }
    
        var components: [Component] {
            rawValue
                .components(separatedBy: "/")
                .map(String.init(describing:))
                .filter { !$0.isEmpty }
                .map { rawComponent in rawComponent.hasPrefix(":")
                    ? .argument(String(rawComponent.dropFirst()))
                    : .plain(rawComponent)
                }
        }

        var arguments: Set<String> {
            Set(
                components.compactMap { component in
                    switch component {
                    case let .argument(value): return value
                    case .plain: return nil
                    }
                }
            )
        }
    }
}

extension Path {
    
    @dynamicMemberLookup
    public struct Context {
        
        let raw: [String : String]
        
        public subscript(dynamicMember member: String) -> String? {
            return raw[member]
        }
    }
}

extension Array {
    func regex<Processing: DeepLinkProcessing>() throws -> Regex<AnyRegexOutput> where Element == Path<Processing>.Raw.Component {
        let string = reduce("^/?") { result, component in
            switch component {
            case let .plain(component):
                return "\(result)/\(component)"
                
            case let .argument(key):
                return "\(result)/(?<\(key)>[^/]+)"
            }
        }
        
        return try Regex(string)
    }
}
