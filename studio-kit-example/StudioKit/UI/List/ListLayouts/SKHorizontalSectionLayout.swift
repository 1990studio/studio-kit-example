import UIKit

extension SKList {
    static func createHorizontalScrollingSection(
        width: CGFloat,
        cellHeight: SKListCellHeight = 80,
        cellWidth: CGFloat = 80,
        visibleCells: CGFloat? = nil,
        padding: NSDirectionalEdgeInsets = NSDirectionalEdgeInsets(
            top: 6, leading: 20, bottom: 16, trailing: 20
        ),
        header: SKListHeader.Type? = nil
    ) -> SKListLayoutSection {
        
        let columns: CGFloat = 1
        let spacing: CGFloat = 12
        
        var _cellWidth: CGFloat = cellWidth
        
        if let visibleCells = visibleCells {
            let peakWidth: CGFloat = padding.trailing
            _cellWidth = ((width - padding.leading - (spacing * visibleCells)) / visibleCells) - (peakWidth / visibleCells)
        }
        
        // Dynamic type that can take float,
        let evaluatedCellHeight = cellHeight.evaluate(with: width, cellWidth: _cellWidth, columns: columns, spacing: spacing, padding: padding)
        
        // Items
        let cellSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1 / columns),
            heightDimension: .absolute(evaluatedCellHeight + padding.top + padding.bottom)
        )
        let cell = NSCollectionLayoutItem(layoutSize: cellSize)
        
        
        // Groups
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(evaluatedCellHeight + padding.top + padding.bottom) )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [cell])
        
        group.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: 0,
            bottom: 0,
            trailing: 0)
        group.interItemSpacing = .fixed(0)
        
        
        // Section
        let section = SKListLayoutSection(group: group)
        section.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
        section.interGroupSpacing = spacing
        section.identifier = "HorizontalScrolling"
        section.cellHeight = evaluatedCellHeight
        section.cellWidth = _cellWidth
        section.header = header
        section.padding = padding
        
        if let headerHeight = header?.height {
            section.boundarySupplementaryItems = [
                .init(
                    layoutSize: .init(
                        widthDimension: .absolute(width - padding.leading - padding.trailing),
                        heightDimension: .absolute(headerHeight)
                    ),
                    elementKind: "Header",
                    alignment: .top,
                    absoluteOffset: CGPoint(x: 0, y: 0) // can be zero now that we have adjusted width
                ),
            ]
        }
        
        return section
    }
  }
