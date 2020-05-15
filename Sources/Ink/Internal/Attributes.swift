import Foundation

public typealias Attributes = [NSAttributedString.Key: Any]

public struct AttributesModifier {
    public var target: Modifier.Target
    public var attributes: Attributes

    public init(target: Modifier.Target, attributes: Attributes) {
        self.target = target
        self.attributes = attributes
    }
}

internal struct AttributesModifierCollection {
    private var modifiers: [Modifier.Target : [AttributesModifier]]

    init(modifiers: [AttributesModifier]) {
        self.modifiers = Dictionary(grouping: modifiers, by: { $0.target })
    }

    func applyModifiers(for target: Modifier.Target,
                        using closure: (AttributesModifier) -> Void) {
        modifiers[target]?.forEach(closure)
    }

    mutating func insert(_ modifier: AttributesModifier) {
        modifiers[modifier.target, default: []].append(modifier)
    }
}

internal protocol AttributesConvertible {}

extension AttributesConvertible where Self: Modifiable {
    func attributes(rawString: Substring,
                    applyingModifiers modifiers: AttributesModifierCollection) -> Attributes {
        var attributes = Attributes()
        modifiers.applyModifiers(for: modifierTarget) { modifier in
            attributes = modifier.attributes
        }
        return attributes
    }
}
