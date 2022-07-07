
import UIKit

/// A value that scales with the current content size category.
struct CTAccessibleValue<Container> {

    /// The value before scaling for the content size category.
    internal private(set) var rawValue: CGFloat {
        didSet { apply() }
    }

    /// The value after scaling for the content size category.
    var scaledValue: CGFloat { return rawValue.scaled() }

    private var keyPath: KeyPath<Container, CGFloat>
    private let applyScaledValue: (_ scaledValue: CGFloat) -> Void

    init(container: Container, keyPath: KeyPath<Container, CGFloat>, apply: @escaping (_ scaledValue: CGFloat) -> Void) {
        self.keyPath = keyPath
        rawValue = container[keyPath: keyPath]
        self.applyScaledValue = apply
    }

    /// Update the raw value with a new container. Will use the existing keypath to set the raw value.
    mutating func update(withContainer container: Container) {
        rawValue = container[keyPath: keyPath]
    }

    /// Update the raw value with a new container and keypath to access the raw value.
    mutating func update(withContainer container: Container, keyPath: KeyPath<Container, CGFloat>) {
        self.keyPath = keyPath
        rawValue = container[keyPath: keyPath]
    }

    /// Apply the scaled value.
    func apply() {
        self.applyScaledValue(scaledValue)
    }
}
