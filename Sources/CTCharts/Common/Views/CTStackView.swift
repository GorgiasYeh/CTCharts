
import UIKit

/// A stack view that supports animating showing/hiding arranged subviews,
/// and has the option of dynamically creating separators when arranged subviews are added.
class CTStackView: UIStackView, CTStylable {

    /// Types of animations that are applied to the stack view.
    ///
    /// - fade: Animate opacity.
    /// - hidden: Animate the isHidden property.
    enum Animation {
        case fade, hidden
    }

    // MARK: Properties

    public var customStyle: CTStyler? {
        didSet { styleChildren() }
    }

    /// The style for the stack view.
    ///
    /// - plain: A normal stack view.
    /// - separated: Creates separators between arranges subview.
    public enum Style {
        case plain, separated
    }

    /// The style of the stack view.
    public let style: Style

    /// Flag determines if the top and bottom separators are shown when the style of the stack view is separated
    public var showsOuterSeparators = true {
        didSet {
            guard style == .separated else { return }
            subviews.first?.removeFromSuperview()
            subviews.last?.removeFromSuperview()
        }
    }

    // MARK: Life Cycle

    /// Create the stack view with a style. A plain style is a typical stack view. A separated
    /// style will automatically create separators between arranged subviews whenever they're
    /// added.
    ///
    /// - Parameter style: The style for the stack view.
    public init(style: Style = .plain) {
        self.style = style
        super.init(frame: .zero)
        if style == .separated { axis = .vertical }
        preservesSuperviewLayoutMargins = true
        styleDidChange()
    }

    @available(*, unavailable)
    public required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    static func vertical() -> CTStackView {
        let stackView = CTStackView()
        stackView.axis = .vertical
        return stackView
    }

    static func horizontal() -> CTStackView {
        let stackView = CTStackView()
        stackView.axis = .horizontal
        return stackView
    }

    // MARK: Methods

    override open func didMoveToSuperview() {
        super.didMoveToSuperview()
        styleDidChange()
    }

    override open func removeFromSuperview() {
        super.removeFromSuperview()
        styleChildren()
    }

    open func styleDidChange() {}

    /// The ordered subviews. When the stack view is a separated style, this will not
    /// include the separators.
    override open var arrangedSubviews: [UIView] {
        switch style {
        case .plain:
            return super.arrangedSubviews
        case .separated:
            return showsOuterSeparators ?
                super.arrangedSubviews.enumerated().filter { $0.0 % 2 != 0 }.map { $0.1 } :    // all odd subviews
                super.arrangedSubviews.enumerated().filter { $0.0 % 2 == 0 }.map { $0.1 }      // all even subviews
        }
    }

    /// Add a subview to the end of the stack view. If the style is separated,
    /// separators will automatically be added.
    ///
    /// - Parameter view: The view to add.
    override open func addArrangedSubview(_ view: UIView) {
        switch style {
        case .plain:
            super.addArrangedSubview(view)
        case .separated:
            let viewsToAdd = makeSeparators(withView: view)
            viewsToAdd.forEach { super.addArrangedSubview($0) }
        }
    }

    /// Add a subview to the end of the stack view. If the style is separated,
    /// separators will automatically be added. Provides the option to animate
    /// showing the new view.
    ///
    /// - Parameters:
    ///   - view: The view to add.
    ///   - animated: Flag that determines if the view should animated on screen.
    open func addArrangedSubview(_ view: UIView, animated: Bool) {
        guard animated else {
            addArrangedSubview(view)
            return
        }

        let viewsToAdd = makeSeparators(withView: view)
        viewsToAdd.forEach {
            $0.isHidden = true
            super.addArrangedSubview($0)
        }
        toggleViews(viewsToAdd, shouldShow: true, animated: animated)
    }

    /// Insert an arranged subview at a particular index in the stack view. If the style is
    /// separated, separators will be automatically added.  Provides the option to animate
    /// showing the new view.
    ///
    /// - Parameters:
    ///   - view: The view to add.
    ///   - stackIndex: Index in the stack view to add the view.
    ///   - animated: Flag that determines if the view should animated on screen.
    open func insertArrangedSubview(_ view: UIView, at stackIndex: Int, animated: Bool) {
        guard animated else {
            insertArrangedSubview(view, at: stackIndex)
            return
        }

        let viewsToAdd = makeSeparators(withView: view)
        for (index, view) in viewsToAdd.enumerated() {
            view.isHidden = true
            super.insertArrangedSubview(view, at: index + stackIndex)
        }
        toggleViews(viewsToAdd, shouldShow: true, animated: animated)
    }

    /// Insert an arranged subview at a particular index in the stack view. If the style is
    /// separated, separators will automatically be added.
    ///
    /// - Parameters:
    ///   - view: The view to add.
    ///   - stackIndex: Index in the stack view to add the view.
    override open func insertArrangedSubview(_ view: UIView, at stackIndex: Int) {
        switch style {
        case .plain:
            super.insertArrangedSubview(view, at: stackIndex)
        case .separated:
            let viewsToAdd = makeSeparators(withView: view)
            for (index, view) in viewsToAdd.enumerated() {
                super.insertArrangedSubview(view, at: index + stackIndex)
            }
        }
    }

    /// Remove an arranged subview from the stack view. If the style is separated,
    /// the separators will be automatically removed.
    ///
    /// - Parameter view: The view to remove.
    override open func removeArrangedSubview(_ view: UIView) {
        switch style {
        case .plain:
            super.removeArrangedSubview(view)
        case .separated:
            let viewsToRemove = getSeparators(withView: view)
            viewsToRemove.forEach { $0.removeFromSuperview() }
        }
    }

    /// Remove an arranged subview from the stack view. If the style is separated,
    /// the separators will be automatically removed. Option to animated the removal of the
    /// view.
    ///
    /// - Parameters:
    ///     - view: The view to remove.
    ///     - animated: Flag that determines if the view removal should be animated.
    open func removeArrangedSubview(_ view: UIView, animated: Bool) {
        let viewsToRemove = getSeparators(withView: view)

        let removeBlock = {
            viewsToRemove.forEach {
                $0.removeFromSuperview()
                $0.isHidden = false
                $0.alpha = 1
            }
        }

        guard UIView.areAnimationsEnabled && animated else {
            removeBlock()
            return
        }

        toggleViews(viewsToRemove, shouldShow: false, animated: animated) { complete in
            guard complete else { return }
            removeBlock()
        }
    }

    /// Batch view plus any needed separators
    private func makeSeparators(withView view: UIView) -> [UIView] {
        switch style {
        case .plain: return [view]
        case .separated:
            var views: [UIView] = []
            if super.arrangedSubviews.isEmpty && showsOuterSeparators {
                views.append(CTSeparatorView())
            } else if !super.arrangedSubviews.isEmpty && !showsOuterSeparators {
                views.append(CTSeparatorView())
            }
            views.append(view)
            if showsOuterSeparators {
                views.append(CTSeparatorView())
            }
            return views
        }
    }

    /// Get the separators included with a view
    private func getSeparators(withView view: UIView) -> [UIView] {
        switch style {
        case .plain:
            return [view]
        case .separated:
            guard let index = subviews.firstIndex(of: view) else { return [] }

            if showsOuterSeparators && index == 0 {
                return Array(subviews[..<3])
            } else if !showsOuterSeparators && index == 0 {
                return [subviews[0]]
            } else {
                return Array(subviews[index - 1 ..< index + 1])
            }
        }
    }

    /// Clear the views in the stack view.
    ///
    /// - Parameter animated: Flag to animate the removal of the views.
    public func clear(animated: Bool = false) {
        let removeViewsBlock = { [weak self] in
            self?.subviews.forEach { $0.removeFromSuperview() }
        }

        guard UIView.areAnimationsEnabled && animated else {
            removeViewsBlock()
            return
        }

        toggleViews(subviews, shouldShow: false, animated: true) { complete in
            guard complete else { return }
            removeViewsBlock()
        }
    }

    /// Hide or show the specified views in the stack view.
    ///
    /// - Parameters:
    ///   - views: The views to hide or show.
    ///   - shouldShow: True if the views should be shown, false to hide them.
    ///   - animated: Animate the visibility of the views.
    ///   - animations: The particular animations to use when toggling the visibility.
    ///   - completion: Block to run when the visibility toggling and any animations are complete.
    func toggleViews(
        _ views: [UIView],
        shouldShow: Bool,
        animated: Bool,
        animations: [Animation] = [.fade, .hidden],
        completion: ((Bool) -> Void)? = nil) {
        views.forEach { guard $0.superview == self else { return } }

        // skip animation
        guard animated else {
            views.forEach { $0.isHidden = !shouldShow }
            return
        }

        var completionWillBeCalled = false

        if animations.contains(.hidden) {
            let filteredViews = views.filter { $0.isHidden == shouldShow } // only animated views that are not yet animated
            filteredViews.forEach { $0.isHidden = shouldShow }

            UIView.animate(withDuration: style().animation.stateChangeDuration, delay: 0, options: .curveEaseOut, animations: {
                filteredViews.forEach { $0.isHidden = !shouldShow }
            }, completion: { complete in
                if !completionWillBeCalled { completion?(complete) }
                completionWillBeCalled = true
            })
        }

        if animations.contains(.fade) {
            let filteredViews = views.filter { $0.alpha == (shouldShow ? 0 : 1) } // only animated views that are not yet animated
            filteredViews.forEach { $0.alpha = shouldShow ? 0 : 1 }

            UIView.animate(withDuration: style().animation.stateChangeDuration, delay: 0, options: .curveEaseOut, animations: {
                filteredViews.forEach { $0.alpha = shouldShow ? 1 : 0 }
            }, completion: { complete in
                if !completionWillBeCalled { completion?(complete) }
                completionWillBeCalled = true
            })
        }
    }
}
