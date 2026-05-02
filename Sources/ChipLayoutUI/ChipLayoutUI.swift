// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI

/// A view that arranges its child views in a horizontally wrapping layout,
/// similar to a flow or "chip" layout.
///
/// `ChipLayoutUI` places views in rows, automatically wrapping to the next line
/// when the available horizontal space is exceeded. It supports configurable
/// spacing and horizontal alignment for each row.
///
/// Use this container when displaying collections of small, flexible items
/// such as tags, chips, or badges.
///
/// - Parameters:
///   - alignment: The horizontal alignment of each row. Defaults to `.leading`.
///   - spacing: The spacing between items and rows. Defaults to `10`.
///   - content: A view builder that creates the content of this layout.
///
/// ## Example
/// ```swift
/// ChipLayoutUI {
///     Text("Swift")
///     Text("iOS")
///     Text("SwiftUI")
/// }
/// ```
@available(iOS 16.0, *)
public struct ChipLayoutUI<Content: View>: View {
    private var alignment: Alignment
    private var spacing: CGFloat
    private let content: Content

    /// Creates a chip-based layout container.
    ///
    /// - Parameters:
    ///   - alignment: The horizontal alignment applied to each row of content.
    ///   - spacing: The spacing between elements and rows.
    ///   - content: A view builder that constructs the child views.
    public init(
        alignment: Alignment = .leading,
        spacing: CGFloat = 10,
        @ViewBuilder content: () -> Content
    ) {
        self.alignment = alignment
        self.spacing = spacing
        self.content = content()
    }

    /// The content and behavior of the view.
    public var body: some View {
        ChipLayout(alignment: alignment, spacing: spacing) {
            content
        }
    }
}

@available(iOS 16.0, *)
/// A custom layout that arranges subviews in multiple horizontal rows,
/// wrapping content when it exceeds the available width.
///
/// `ChipLayout` conforms to the ``Layout`` protocol and provides the
/// underlying measurement and placement logic for `ChipLayoutUI`.
///
/// This layout dynamically computes rows based on the proposed width and
/// positions subviews accordingly, applying the specified spacing and alignment.
fileprivate struct ChipLayout: Layout {
    private var alignment: Alignment = .center
    private var spacing: CGFloat = 10

    /// Creates a chip layout with the specified alignment and spacing.
    ///
    /// - Parameters:
    ///   - alignment: The horizontal alignment for each row.
    ///   - spacing: The spacing between items and rows.
    init(alignment: Alignment = .leading, spacing: CGFloat = 10) {
        self.alignment = alignment
        self.spacing = spacing
    }
    
    /// Calculates and returns the size that best fits the proposed size.
    ///
    /// - Parameters:
    ///   - proposal: The proposed size from the parent view.
    ///   - subviews: The subviews to be arranged.
    ///   - cache: A cache for storing intermediate layout data.
    ///
    /// - Returns: The size required to fit all subviews.
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let maxWidth = proposal.width ?? 0
        var height: CGFloat = 0
        
        let rows = generateRows(maxWidth, proposal, subviews)
        
        for (index, row) in rows.enumerated() {
            if index == (rows.count - 1) {
                height += row.maxHeight(proposal)
            } else {
                height += row.maxHeight(proposal) + spacing
            }
        }
        
        return .init(width: maxWidth, height: height)
    }
    
    /// Places subviews within the given bounds.
    ///
    /// - Parameters:
    ///   - bounds: The rectangle in which to place subviews.
    ///   - proposal: The size proposal from the parent.
    ///   - subviews: The subviews to position.
    ///   - cache: A cache for storing intermediate layout data.
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        var origin = bounds.origin
        let maxWidth = bounds.width
        let rows = generateRows(maxWidth, proposal, subviews)
        
        for row in rows {
            /// Calculates the starting X position based on alignment.
            let leading: CGFloat = bounds.maxX - maxWidth
            let trailing = bounds.maxX - (row.reduce(CGFloat.zero) { partialResult, view in
                let width = view.sizeThatFits(proposal).width
                if view == row.last {
                    return partialResult + width
                }
                return partialResult + width + spacing
            })
            let center = (trailing + leading) / 2
            
            origin.x = (alignment == .leading ? leading : alignment == .trailing ? trailing : center)
            
            for view in row {
                let viewSize = view.sizeThatFits(proposal)
                view.place(at: origin, proposal: proposal)
                origin.x += (viewSize.width + spacing)
            }
            
            origin.y += (row.maxHeight(proposal) + spacing)
        }
    }
 
    /// Generates rows of subviews based on the available width.
    ///
    /// - Parameters:
    ///   - maxWidth: The maximum width available for layout.
    ///   - proposal: The proposed size from the parent.
    ///   - subviews: The subviews to arrange.
    ///
    /// - Returns: A two-dimensional array representing rows of subviews.
    func generateRows(_ maxWidth: CGFloat, _ proposal: ProposedViewSize, _ subviews: Subviews) -> [[LayoutSubviews.Element]] {
        var row: [LayoutSubviews.Element] = []
        var rows: [[LayoutSubviews.Element]] = []
        var origin = CGRect.zero.origin
        
        for view in subviews {
            let viewSize = view.sizeThatFits(proposal)
            
            if (origin.x + viewSize.width + spacing) > maxWidth {
                rows.append(row)
                row.removeAll()
                origin.x = 0
                row.append(view)
                origin.x += (viewSize.width + spacing)
            } else {
                row.append(view)
                origin.x += (viewSize.width + spacing)
            }
        }
        
        if !row.isEmpty {
            rows.append(row)
            row.removeAll()
        }
        
        return rows
    }
}

@available(iOS 16.0, *)
/// A helper extension that computes the maximum height among layout subviews.
fileprivate extension [LayoutSubviews.Element] {
    
    /// Returns the maximum height of the subviews for a given size proposal.
    ///
    /// - Parameter proposal: The proposed size used for measurement.
    /// - Returns: The maximum height among all subviews, or `0` if empty.
    func maxHeight(_ proposal: ProposedViewSize) -> CGFloat {
        return self.compactMap { view in
            return view.sizeThatFits(proposal).height
        }.max() ?? 0
    }
}
