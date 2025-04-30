import UIKit

extension SKList {
    static func createGridSection(
        width: CGFloat,
        columns: CGFloat = 1,
        spacing: CGFloat = 12,
        cellHeight: SKListCellHeight = 80,
        padding: NSDirectionalEdgeInsets = NSDirectionalEdgeInsets(
            top: 10,
            leading: 20,
            bottom: 24,
            trailing: 20
        ),
        headerHeight: CGFloat? = nil,
        header: SKListHeader.Type? = nil
    ) -> SKListLayoutSection {
        
        // Dynamic type that can take float,
        let evaluatedCellHeight = cellHeight.evaluate(with: width, columns: columns, spacing: spacing, padding: padding)
        
        // Items
        let cellSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1 / columns),
            heightDimension: .absolute(evaluatedCellHeight))
        let cell = NSCollectionLayoutItem(layoutSize: cellSize)
        
        
        // Groups
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(evaluatedCellHeight))
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [cell])
        
        group.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: 0,
            bottom: 0,
            trailing: 0)
        group.interItemSpacing = .fixed(spacing)
        
        
        // Section
        let section = SKListLayoutSection(group: group)
        section.contentInsets = padding
        section.interGroupSpacing = spacing
        section.width = width
        section.columns = columns
        section.columnSpacing = spacing
        section.header = header
        
        if let headerHeight = header?.height {
            section.boundarySupplementaryItems = [
                .init(
                    layoutSize: .init(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .absolute(headerHeight)
                    ),
                    elementKind: "Header",
                    alignment: .top
                )
            ]
        }
        
        return section
    }
}
