//
//  AppColors.swift
//  harvest
//
//  Created by Kristian Wagner on 2025-01-15.
//

import UIKit

enum AppColors {
    /// Provides type-safe access to colors in asset catalog
    static var rootBackground: UIColor {
        return UIColor(named: "Colors/1-AppBackground")!
    }
    static var primaryBackground: UIColor {
        return UIColor(named: "Colors/2-PrimaryBackground")!
    }
    static var elevatedBackground: UIColor {
        return UIColor(named: "Colors/3-ElevatedBackground")!
    }
    static var primaryInteractive: UIColor {
        return UIColor(named: "Colors/4-PrimaryInteractive")!
    }
    static var secondaryInteractive: UIColor {
        return UIColor(named: "Colors/5-SecondaryInteractive")!
    }
    static var accent: UIColor {
        return UIColor(named: "Colors/6-Accent")!
    }
    static var active: UIColor {
        return UIColor(named: "Colors/7-Active")!
    }
    static var primaryBorder: UIColor {
        return UIColor(named: "Colors/8-PrimaryBorder")!
    }
    static var primaryBlur: UIColor {
        return UIColor(named: "Colors/9-PrimaryBlur")!
    }
    static var overlayDim: UIColor {
        return UIColor(named: "Colors/10-OverlayDim")!
    }
    static var primaryText: UIColor {
        return UIColor(named: "TextColors/1-PrimaryText")!
    }
    static var secondaryText: UIColor {
        return UIColor(named: "TextColors/2-SecondaryText")!
    }
    static var destructiveText: UIColor {
        return UIColor(named: "TextColors/3-DestructiveText")!
    }
    static var inactiveText: UIColor {
        return UIColor(named: "TextColors/4-InactiveText")!
    }
    static var activeText: UIColor {
        return UIColor(named: "TextColors/5-ActiveText")!
    }
}

// MARK: - Color Extension for Semantic Usage
extension UIColor {
    static var rootBackground: UIColor {
        return AppColors.rootBackground
    }
    
    static var primaryBackground: UIColor {
        return AppColors.primaryBackground
    }
    
    static var elevatedBackground: UIColor {
        return AppColors.elevatedBackground
    }
    
    static var primaryInteractive: UIColor {
        return AppColors.primaryInteractive
    }
    
    static var secondaryInteractive: UIColor {
        return AppColors.secondaryInteractive
    }
    
    static var accent: UIColor {
        return AppColors.accent
    }
    
    static var active: UIColor {
        return AppColors.active
    }
    
    static var primaryBorder: UIColor {
        return AppColors.primaryBorder
    }
    
    static var primaryBlur: UIColor {
        return AppColors.primaryBlur
    }
    
    static var primaryText: UIColor {
        return AppColors.primaryText
    }
    
    static var overlayDim: UIColor {
        return AppColors.overlayDim
    }
    
    static var secondaryText: UIColor {
        return AppColors.secondaryText
    }
    
    static var destructiveText: UIColor {
        return AppColors.destructiveText
    }
    
    static var inactiveText: UIColor {
        return AppColors.inactiveText
    }
    
    static var activeText: UIColor {
        return AppColors.activeText
    }
        
    public func dark() -> UIColor {
        return self.resolvedColor(with: .init(userInterfaceStyle: .dark))
    }
    
    public func alpha(_ alpha: CGFloat) -> UIColor {
        return self.withAlphaComponent(alpha)
    }
    
    public func cgColor() -> CGColor {
        return self.cgColor
    }
}
