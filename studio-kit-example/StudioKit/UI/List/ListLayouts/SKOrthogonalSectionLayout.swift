import UIKit

extension SKList {
    static func createOrthogonalScrollingSection(
        spacing: CGFloat = 10,
        itemHeight: CGFloat = 194,
        itemWidth: CGFloat = 140,
        padding: NSDirectionalEdgeInsets = NSDirectionalEdgeInsets(
            top: 10,
            leading: 20,
            bottom: 20,
            trailing: 20
        ),
        headerHeight: CGFloat? = nil
    ) -> SKListLayoutSection {
        
        // Items
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .estimated(itemWidth),
            heightDimension: .estimated(itemHeight)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        // Groups
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .estimated(itemWidth),
            heightDimension: .estimated(itemHeight))
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: 0,
            bottom: 0,
            trailing: 0)
        
        
        // Section
        let section = SKListLayoutSection(group: group)
        section.contentInsets = padding
        section.orthogonalScrollingBehavior = .groupPaging
        section.interGroupSpacing = spacing
        
        if let headerHeight = headerHeight {
            section.boundarySupplementaryItems = [
                .init(
                    layoutSize: .init(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .absolute(headerHeight)
                    ),
                    elementKind: "Header",
                    alignment: .top
                ),
            ]
        }
        
        return section
    }
}
