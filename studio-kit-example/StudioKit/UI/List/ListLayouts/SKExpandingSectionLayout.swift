import UIKit

extension SKList {
    static func createExpandingSection(
        width: CGFloat,
        spacing: CGFloat = 10,
        estimatedHeight: CGFloat = 100,
        padding: NSDirectionalEdgeInsets = NSDirectionalEdgeInsets(
            top: 10,
            leading: 20,
            bottom: 24,
            trailing: 20
        ),
        header: SKListHeader.Type? = nil
    ) -> SKListLayoutSection {
        
        // Items
        let cellSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(estimatedHeight)
        )
        let cell = NSCollectionLayoutItem(layoutSize: cellSize)
        
        // Groups
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(estimatedHeight))
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
