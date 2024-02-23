import Foundation

@resultBuilder
public struct ArrayBuilder<T> {

    public typealias Component = [T]
    public typealias Expression = T

    public static func buildExpression(_ element: Expression) -> Component {
        [element]
    }

    public static func buildOptional(_ component: Component?) -> Component {
        guard let component = component else { return [] }
        return component
    }

    public static func buildEither(first component: Component) -> Component {
        component
    }

    public static func buildEither(second component: Component) -> Component {
        component
    }

    public static func buildArray(_ components: [Component]) -> Component {
        Array(components.joined())
    }

    public static func buildBlock(_ components: Component...) -> Component {
        Array(components.joined())
    }
}
