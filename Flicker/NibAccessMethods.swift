//
//  UITableView+Methods.swift
//  MeetingTracker
//
//  Created by Anders Melen on 10/16/15.
//  Copyright © 2015 GMSW. All rights reserved.
//

import UIKit

extension UITableViewCell {
    class func cellFromNibNamed(_ nibName: String, reuseID: String) -> UITableViewCell? {
        let nibContents = Bundle.main.loadNibNamed(nibName, owner: self, options: nil)
        for tempCell in nibContents! {
            if (tempCell as AnyObject).isKind(of: UITableViewCell.self) && (tempCell as AnyObject).reuseIdentifier == reuseID {
                return tempCell as? UITableViewCell
            }
        }
        
        return nil
    }
}

extension UIView {

    class func viewByTypeFromNibNamed<T>(_ nibName: String) -> T? {
        
        var foundView: T?
        let nibContents = Bundle.main.loadNibNamed(nibName, owner: self, options: nil)
        for tempView in nibContents! {
            if tempView is T {
                assert(foundView == nil, "Found multiple classes within the same nib file. Expected only one! Use the `viewFromNibNamed:nibName:restorationID` method to fix this.")
                foundView = tempView as? T
            }
        }
        
        assert(foundView != nil, "Could not find view in nib file \(nibName) of type \(T.self)")
        
        return foundView
    }
}

extension UIView {
    class func viewFromNibNamed(_ nibName: String, restorationID: String) -> UIView? {
        let nibContents = Bundle.main.loadNibNamed(nibName, owner: self, options: nil)
        for tempView in nibContents! {
            if (tempView as AnyObject).restorationIdentifier == restorationID {
                return tempView as? UIView
            }
        }
        
        return nil
    }
}
