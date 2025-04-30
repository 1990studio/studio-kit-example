# Studio Kit Example

This is a simple example of one of the components from StudioKit - a ui and utility library made by 1990 Studio. For full access or any questions, please contact kristian@1990.studio.

## Getting started

Simply clone the repo and start the simulator. You will see a simple representation of the SKList, one of the core list components in StudioKit. It represents the core principles: creating components that neatly wrap the performance and depth of UIKit and offer simple and efficient ui api.

```swift
let list = SKList(
            registerCells: [
                SKRowListCell.self,
                SKGridListCell.self,
            ],
            sections: [
                .init(
                    id: "1",
                    title: "Section 1",
                    items: SKList.createDummyData(for: 3),
                    layout: SKList.createGridSection(
                        width: self.view.frame.width,
                        columns: 1,
                        header: SKListHeader.self
                    ),
                    cellForIndexPath: { event in
                        return SKRowListCell.self
                    }
                ),
                .init(
                    id: "2",
                    title: "Section 2",
                    items: SKList.createDummyData(for: 5),
                    layout: SKList.createHorizontalScrollingSection(
                        width: self.view.frame.width,
                        cellHeight: SKGridListCell.cellHeight,
                        visibleCells: 3,
                        header: SKListHeader.self
                    ),
                    cellForIndexPath: { event in
                        return SKGridListCell.self
                    }
                ),
                .init(
                    id: "3",
                    title: "Section 3",
                    items: SKList.createDummyData(for: 7),
                    layout: SKList.createGridSection(
                        width: self.view.frame.width,
                        columns: 2,
                        header: SKListHeader.self
                    ),
                    cellForIndexPath: { event in
                        return SKRowListCell.self
                    }
                ),
                .init(
                    id: "4",
                    title: "Section 4",
                    items: SKList.createDummyData(for: 5),
                    layout: SKList.createHorizontalScrollingSection(
                        width: self.view.frame.width,
                        cellHeight: SKGridListCell.cellHeight,
                        visibleCells: 2,
                        header: SKListHeader.self
                    ),
                    cellForIndexPath: { event in
                        return SKGridListCell.self
                    }
                ),
                .init(
                    id: "5",
                    title: "Section 5",
                    items: SKList.createDummyData(for: 100),
                    layout: SKList.createGridSection(
                        width: self.view.frame.width,
                        columns: 1,
                        header: SKListHeader.self
                    ),
                    cellForIndexPath: { event in
                        return SKRowListCell.self
                    }
                ),
            ]
        )
```





