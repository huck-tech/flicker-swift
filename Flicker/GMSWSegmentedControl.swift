//
//  GMSWSegmentedControl.swift
//  Jazz Time
//
//  Created by Anders Melen on 12/8/15.
//  Copyright © 2015 GMSW. All rights reserved.
//

import UIKit
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func >= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l >= r
  default:
    return !(lhs < rhs)
  }
}


protocol GMSWSegmentedControlDelegate {
    func valueDidChange(_ index: Int, item: String)
}

struct GMSWSegmentedControlTheme {
    var highLightColor: UIColor
    var backgroundColor: UIColor
    var seperatorColor: UIColor
    let textColor: UIColor
    var seperatorWidth: Float
    var selectedBarHeight: Float
    var bottomBarHeight: Float
    var textFont : UIFont
    
    init(highLightColor: UIColor, backgroundColor: UIColor, seperatorColor: UIColor, textColor: UIColor, seperatorWidth: Float, selectedBarHeight: Float, bottomBarHeight: Float) {
        self.highLightColor = highLightColor
        self.backgroundColor = backgroundColor
        self.seperatorColor = seperatorColor
        self.textColor = textColor
        self.textFont = UIFont.systemFont(ofSize: 16)
        self.seperatorWidth = seperatorWidth
        self.selectedBarHeight = selectedBarHeight
        self.bottomBarHeight = bottomBarHeight
    }
    
    init(highLightColor: UIColor, backgroundColor: UIColor, seperatorColor: UIColor, textColor: UIColor, textFont: UIFont) {
        self.highLightColor = highLightColor
        self.backgroundColor = backgroundColor
        self.seperatorColor = seperatorColor
        self.textColor = textColor
        self.textFont = textFont
        self.seperatorWidth = 1
        self.selectedBarHeight = 4.0
        self.bottomBarHeight = 2.0
    }
    
    init(highLightColor: UIColor, backgroundColor: UIColor, seperatorColor: UIColor, textColor: UIColor) {
        self.highLightColor = highLightColor
        self.backgroundColor = backgroundColor
        self.seperatorColor = seperatorColor
        self.textColor = textColor
        self.textFont = UIFont.systemFont(ofSize: 16)
        self.seperatorWidth = 1
        self.selectedBarHeight = 4.0
        self.bottomBarHeight = 2.0
    }
}

class GMSWSegmentedControl: UIControl {
    
    var delegate : GMSWSegmentedControlDelegate?
    
    fileprivate var items: [String]
    fileprivate var selectedIndex: Int?
    
    fileprivate var buttonContainer: UIView!
    fileprivate var bottomBar: UIView!
    fileprivate var selectedColorBar: UIView!
    
    fileprivate var buttons : [UIButton]
    fileprivate var seperators: [UIView]
    
    fileprivate var theme: GMSWSegmentedControlTheme
    
    fileprivate var selectedColorBarLeadingConstarint: NSLayoutConstraint?
    
    init(frame: CGRect, items: [String], selectedIndex: Int?, theme: GMSWSegmentedControlTheme) {
        
        self.theme = theme
        
        self.buttons = [UIButton]()
        self.seperators = [UIView]()
        
        assert(items.count > 0, "Is a segment control with no items still a segment control??")
        assert(selectedIndex >= 0 && selectedIndex < (items.count), "Selected index is out of bounds!")
        self.items = items
        self.selectedIndex = selectedIndex
        
        super.init(frame: frame)
        
        // Create View
        self.rebuildView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func rebuildView() {
        
        if self.buttonContainer != nil {
            self.buttonContainer.removeFromSuperview()
        }
        self.buttonContainer = UIView.init(frame: CGRect.zero)
        self.buttonContainer.translatesAutoresizingMaskIntoConstraints = false
        self.buttonContainer.backgroundColor = self.theme.backgroundColor

        if self.bottomBar != nil {
            self.bottomBar.removeFromSuperview()
        }
        self.bottomBar = UIView.init(frame: CGRect.zero)
        self.bottomBar.translatesAutoresizingMaskIntoConstraints = false
        self.bottomBar.backgroundColor = self.theme.seperatorColor

        if self.selectedColorBar != nil {
            self.selectedColorBar.removeFromSuperview()
        }
        self.selectedColorBar = UIView.init(frame: CGRect.zero)
        self.selectedColorBar.translatesAutoresizingMaskIntoConstraints = false
        self.selectedColorBar.backgroundColor = self.theme.highLightColor
        
        // Subviews
        self.addSubview(self.buttonContainer)
        self.addSubview(self.bottomBar)
        self.addSubview(self.selectedColorBar)
        
        // Autolayout Constraints
        let views : [String : UIView] = [
            "container": self.buttonContainer,
            "bottomBar":self.bottomBar]
        var constraints = [NSLayoutConstraint]()
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[container]-0-|", options: [], metrics: nil, views: views)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[bottomBar]-0-|", options: [], metrics: nil, views: views)
        let temp = "V:|-0-[container]-0-[bottomBar(\(self.theme.bottomBarHeight))]-0-|" // DELETE ME
        constraints += NSLayoutConstraint.constraints(withVisualFormat: temp, options: [], metrics: nil, views: views)
        
        NSLayoutConstraint.activate(constraints)
        
        // Create Buttons
        self.createButtonsAndColoredBar()
    }
    
    //MARK: - Getters & Setters
    
    func getTheme() -> GMSWSegmentedControlTheme {
        return self.theme
    }
    
    func setTheme(_ theme: GMSWSegmentedControlTheme) {
        self.theme = theme
        
        self.rebuildView()
    }
    
    func getItems() -> [String] {
        return self.items
    }
    
    func setItems(_ items: [String]) {
        assert(items.count > 0, "Is a segment control with no items still a segment control??")
        assert(self.selectedIndex >= 0 && self.selectedIndex < (self.items.count), "Selected index is out of bounds!")
        self.items = items
        
    }
    
    func getSelectedIndex() -> Int? {
        return self.selectedIndex
    }
    
    func setSelectedIndex(_ index: Int) {
        assert(self.selectedIndex >= 0 && self.selectedIndex < (self.items.count), "Selected index is out of bounds!")
        
        if index != self.selectedIndex {
            self.selectedIndex = index
            
            // Notify Delegate of changes..
            self.delegate?.valueDidChange(self.selectedIndex!, item: self.items[self.selectedIndex!])
            
            // Remove Old constraint
            if self.selectedColorBarLeadingConstarint != nil {
                self.removeConstraint(self.selectedColorBarLeadingConstarint!)
            }
            
            let animationDuration = 0.2
            // Animate Color Changes
            UIView.transition(with: self.buttonContainer, duration: animationDuration, options: UIViewAnimationOptions.transitionCrossDissolve , animations: { () -> Void in
                for i in 0 ..< self.buttons.count {
                    let tempButton = self.buttons[i]
                    let color : UIColor!
                    if i == self.selectedIndex! {
                        color = self.theme.highLightColor
                    } else {
                        color = self.theme.textColor
                    }
                    tempButton.setTitleColor(color, for: UIControlState())
                }
            }, completion: { (finished) -> Void in })
            
            // Animate Constraint Changes
            UIView.animate(withDuration: animationDuration, animations: { () -> Void in
                self.generateLeadingSelectedColorBarConstraint()
                self.addConstraint(self.selectedColorBarLeadingConstarint!)
                self.layoutIfNeeded()
            }, completion: { (finished) -> Void in })
        }
    }
    
    // MARK: - Private
    
    func buttonDidGetPressed(_ sender: UIButton) {
        self.setSelectedIndex(sender.tag)
    }
    
    func generateLeadingSelectedColorBarConstraint() {
        var views : [String : UIView] = ["selectedColorBar":self.selectedColorBar]
        for i in 0 ..< self.seperators.count {
            let seperator = self.seperators[i]
            views["seperator\(i)"] = seperator
        }
        if self.selectedIndex! == 0 {
            self.selectedColorBarLeadingConstarint = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[selectedColorBar]", options: [], metrics: nil, views: views).first
        } else {
            let selectedSeperatorName = "seperator\(self.selectedIndex! - 1)"
            self.selectedColorBarLeadingConstarint = NSLayoutConstraint.constraints(withVisualFormat: "H:[\(selectedSeperatorName)]-0-[selectedColorBar]", options: [], metrics: nil, views: views).first
        }
        
    }
    
    fileprivate func createButtonsAndColoredBar() {
        
        // Remove any existing buttons...
        for subview in self.buttonContainer.subviews {
            subview.removeFromSuperview()
        }
        self.seperators.removeAll()
        self.buttons.removeAll()
        
        var views = [String : UIView]()
        var constraints = [NSLayoutConstraint]()
        var vertialConstraintStrings = [String]()
        var horizontalConstraintString = "H:|"
        for i in 0 ..< self.items.count {
            
            let temp = self.items[i]
            
            // Button View
            let button = UIButton.init(frame: CGRect.zero)
            button.setTitle(temp, for: UIControlState())
            button.translatesAutoresizingMaskIntoConstraints = false
            if self.selectedIndex != nil && i == self.selectedIndex {
                button.setTitleColor(self.theme.highLightColor, for: UIControlState())
            } else {
                button.setTitleColor(self.theme.textColor, for: UIControlState())
            }
            button.titleLabel!.font = self.theme.textFont
            button.titleLabel!.lineBreakMode = .byWordWrapping
            button.titleLabel!.textAlignment = .center
            button.tag = i
            button.addTarget(self, action: #selector(buttonDidGetPressed), for: .touchUpInside)
            self.buttons.append(button)
            self.buttonContainer.addSubview(button)
            
            // View Name
            let buttonViewName = "button\(i)"
            
            // Layout Views
            views[buttonViewName] = button
            
            // Horizontal Constraint String
            horizontalConstraintString += "[\(buttonViewName)"
            if i != 0 {
                // All buttons besides first have equal widths to first..
                horizontalConstraintString += "(==button0)"
            }
            horizontalConstraintString += "]"
            
            
            // Seperator
            if i != (self.items.count - 1) {
                
                let seperator = UIView.init()
                self.seperators.append(seperator)
                seperator.translatesAutoresizingMaskIntoConstraints = false
                seperator.backgroundColor = self.theme.seperatorColor
                self.buttonContainer.addSubview(seperator)
                let seperatorName = "seperator\(i)"
                views["seperator\(i)"] = seperator
                
                // Vertical
                let vertSeperatorConstraint = "V:|[\(seperatorName)]|"
                vertialConstraintStrings.append(vertSeperatorConstraint)
                
                // Horizontal
                let horSeperatorConstraint = "[\(seperatorName)(==\(self.theme.seperatorWidth))]"
                horizontalConstraintString += horSeperatorConstraint
            }
            
            // Vertical Constraint
            let tempVerticalConstraintString = "V:|[\(buttonViewName)]|"
            vertialConstraintStrings.append(tempVerticalConstraintString)
        }
        
        horizontalConstraintString += "|"
        
//        print("Generated Constraint String: " + horizontalConstraintString)

        // Horizontal Constraint
        let horizontalConstraint = NSLayoutConstraint.constraints(withVisualFormat: horizontalConstraintString, options: [], metrics: nil, views: views)
        constraints += horizontalConstraint
        
        for tempVerticalConstraintString in vertialConstraintStrings {
            constraints += NSLayoutConstraint.constraints(withVisualFormat: tempVerticalConstraintString, options: [], metrics: nil, views: views)
        }
        
        if self.selectedIndex != nil {
            // Selected Color Bar
            views["selectedColorBar"] = self.selectedColorBar
            views["container"] = self.buttonContainer
            constraints += NSLayoutConstraint.constraints(withVisualFormat: "[selectedColorBar(==button0)]", options: [], metrics: nil, views: views)
            
            self.generateLeadingSelectedColorBarConstraint()
            
            constraints.append(self.selectedColorBarLeadingConstarint!)
            let temp = "V:[container]-(-\(self.theme.selectedBarHeight - self.theme.bottomBarHeight))-[selectedColorBar]-0-|" // DELETE ME
            constraints += NSLayoutConstraint.constraints(withVisualFormat: temp, options: [], metrics: nil, views: views)
        }
        
        // Active All Constraints!
        NSLayoutConstraint.activate(constraints)
        
    }
}
