import UIKit

class SKHorizontalScrollListCell: SKListCell, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var collectionView: UICollectionView!
    var items: [SKListItemData] = []
    var reuseIdForCell: ((_ event: SKCellEvent) -> String)?
    var cellForIndexPath: ((_ event: SKCellEvent) -> SKListCell.Type)?
    var configureCellForReuse: ((_ event: SKCellEvent) -> Void)?
    var onCellTap: ((_ event: SKCellTapEvent) -> Void)?
    var cellsToRegister: [SKListCell.Type]?
    var cellHeight: CGFloat?
    var cellWidth: CGFloat?
    var sections: [SKListSection] = []
    var section: Int = 0
    var flowLayout: UICollectionViewFlowLayout!
    var collectionViewHeightConstraint: NSLayoutConstraint?
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // Set up the inner collection view (horizontal)
        flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.sectionInset = .zero
        flowLayout.minimumLineSpacing = 12
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = .clear
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        
        contentView.addSubview(collectionView)
        
        collectionViewHeightConstraint = collectionView.heightAnchor.constraint(equalToConstant: 100)
        collectionViewHeightConstraint?.isActive = true
        
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            collectionView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: contentView.rightAnchor)
        ])
    }
    
    func setupViews() {
        backgroundColor = .red
    }
    
    func configure(for section: Int, sections: [SKListSection], cellsToRegister: [SKListCell.Type]?) {
        
        let cellHeight = sections[section].layout?.cellHeight ?? 60
        
        self.section = section
        self.sections = sections
        self.cellsToRegister = cellsToRegister
        
        self.items = sections[section].items
        self.reuseIdForCell = sections[section].reuseIdForCell
        self.cellForIndexPath = sections[section].cellForIndexPath
        
        self.configureCellForReuse = sections[section].configureCellForReuse
        self.cellWidth = sections[section].layout?.cellWidth
        self.cellHeight = cellHeight
        
        // Always register base cell
        collectionView.register(SKListCell.self, forCellWithReuseIdentifier: SKListCell.reuseIdentifier)
        
        for cell in (cellsToRegister ?? []) {
            collectionView.register(cell.self, forCellWithReuseIdentifier: cell.reuseIdentifier)
            
            // Auto register placeholder cells
            if let placeholderCell = cell.placeholderCell {
                collectionView.register(placeholderCell.self, forCellWithReuseIdentifier: placeholderCell.reuseIdentifier)
            }
            
        }
        
        // Set inset padding based on section layout
        let leadingPadding = sections[section].layout?.padding?.leading ?? 20
        let trailingPadding = sections[section].layout?.padding?.trailing ?? 20
        let topPadding = sections[section].layout?.padding?.top ?? 20
        let bottomPadding = sections[section].layout?.padding?.bottom ?? 20
        let totalHeight = cellHeight + topPadding + bottomPadding
        collectionView.contentInset = UIEdgeInsets(top: topPadding, left: leadingPadding, bottom: bottomPadding, right: trailingPadding)
        collectionViewHeightConstraint?.constant = totalHeight
        flowLayout.itemSize = CGSize(width: cellWidth ?? 140, height: cellHeight)
        flowLayout.invalidateLayout()
        
        collectionView.reloadData()
    }
    
    override func configure() {}
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var reuseIdentifier = SKListCell.reuseIdentifier
        
        let itemData = indexPath.row < items.count ? items[indexPath.row] : nil
        
        if let reuseIdForCell = reuseIdForCell {
            reuseIdentifier = reuseIdForCell(.init(indexPath: indexPath, data: itemData))
        }
        
        if let cellForIndexPath = cellForIndexPath {
            let cellType = cellForIndexPath(.init(indexPath: indexPath, data: itemData))
            
            // Use backup cell if dummy data
            if let placeholderCell = cellType.placeholderCell, itemData is SKListDummyData {
                reuseIdentifier = placeholderCell.reuseIdentifier
            } else {
                reuseIdentifier = cellType.reuseIdentifier
            }
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! SKListCell
        
        let layoutAttributes = collectionView.layoutAttributesForItem(at: indexPath)
        if let cellWidth = layoutAttributes?.frame.width {
            cell.width = cellWidth
        }
        
        if let configureCellForReuse = configureCellForReuse {
            configureCellForReuse(.init(cell:cell, indexPath: indexPath, data: itemData))
        }
        
        cell.configure()
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! SKListCell
        let cellData = sections[safe: section]?.items[safe: indexPath.row]
        onCellTap?(.init(cell: cell, indexPath: IndexPath(row: indexPath.row, section: section), data: cellData))
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let listCell = cell as? SKListCell {
            listCell.willDisplay()
        }
    }
    
}
