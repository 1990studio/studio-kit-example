# Studio Kit Example

It is written in swift, using a programatic UIKit approach. This means no storyboard is used, but instead a root viewController is initialized from the SceneDelegate. SwiftUI is not currently used but may be introduced in the future as a UI Layer. Please use NSLayoutConstraints as the main layouting mechanism. There is a base UIView called SAView that sets translatesAutoresizingMaskIntoConstraints to false by default to make this even easier to implement.

## Getting started

## Colors

Colors are loosely designed around the core principles of radix colors (https://www.radix-ui.com/colors) and when to use each color. Colors are defined as ColorSets in the assets folder to get out-of-the-box light/dark appearance support.

### Background Colors
| Name                     | Light        | Dark         |
| :----------------        | :----------- | :----------- |
| Root Background          | #000000      | #000000      |
| Primary Background       | #F0F0F0      | #191919      |
| Elevated Background      | #FFFFFF      | #222222      |
| Primary Interactive      | #E0E0E0      | #2A2A2A      |
| Secondary Interactive    | #8D8D8D      | #8D8D8D      |
| Active Interactive       | #000000      | #FFFFFF      |
| Accent                   | #006AFF      | #006AFF      |

### Text Colors
| Name                     | Light        | Dark         |
| :---------------------------        | :----------- | :----------- |
| Primary Text             | #000000      | #FFFFFF      |
| Secondary Text           | #747474      | #AAAAAA      |
| Inactive Text            | #B4B4B4      | #5D5D5D      |
| Destructive Text         | #E5484D      | #E5484D      |
| Active Text              | #FFFFFF      | #000000      |

### Blurs
| Name                     | Light               | Dark                 |
| :----------------        | :-----------        | :-----------         |
| Primary Blur             | #8D8D8D (90%, 30px) | #191919 (95%, 30px)  |
| Interactive Blur         | #E0E0E0 (90%, 30px) | #222222 (95%, 30px)  |

Colors are implemented using the UIColor extension that provides semantic definitions matching the above naming. To force a light or dark appearance for a color simply call .dark()

```swift
let dynamicPrimaryTextColor = .primaryText
let alwaysDarkPrimaryTextColor = .primaryText.dark()
```





