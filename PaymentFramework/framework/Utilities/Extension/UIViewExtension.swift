//
//  UIViewExtension.swift
//  CardPaymentApp
//
//  Created by Exaltare Technologies Pvt LTd. on 10/03/22.
//

import UIKit


struct UIViewEdge: OptionSet {
    var rawValue: Int
    init(rawValue: Int) {
        self.rawValue = rawValue
    }
    
    static let top = UIViewEdge(rawValue: 1 << 0)
    static let bottom = UIViewEdge(rawValue: 1 << 1)
    static let leading = UIViewEdge(rawValue: 1 << 2)
    static let trailing = UIViewEdge(rawValue: 1 << 3)
    static let left = UIViewEdge(rawValue: 1 << 4)
    static let right = UIViewEdge(rawValue: 1 << 5)
    static let allLaunguageDirectional: UIViewEdge = [.top, .bottom, .leading, .trailing]
    static let allFixed: UIViewEdge = [.top, .bottom, .left, .right]
}

//MARK: - UIView Extension
extension UIView {
    /// add constrin perticular view (top , bottom, leading, trailing)  if selected choice for your
    func superviewConnectConstraints(insets: UIEdgeInsets = UIEdgeInsets.zero, edges: UIViewEdge = .allLaunguageDirectional, useMargins: Bool = true, relation: NSLayoutConstraint.Relation = .equal) -> [NSLayoutConstraint] {
        var constraints: [NSLayoutConstraint] = []
        if edges.contains(.top) {
            constraints.append(NSLayoutConstraint(item: self, attribute: .top, relatedBy: relation, toItem: superview, attribute: (useMargins ? .topMargin : .top), multiplier: 1, constant: insets.top))
        }
        if edges.contains(.bottom) {
            constraints.append(NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: relation, toItem: superview, attribute: (useMargins ? .bottomMargin : .bottom), multiplier: 1, constant: insets.bottom))
        }
        if edges.contains(.leading) {
            constraints.append(NSLayoutConstraint(item: self, attribute: .leading, relatedBy: relation, toItem: superview, attribute: (useMargins ? .leadingMargin : .leading), multiplier: 1, constant: insets.left))
        }
        if edges.contains(.trailing) {
            constraints.append(NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: relation, toItem: superview, attribute: (useMargins ? .trailingMargin : .trailing), multiplier: 1, constant: insets.right))
        }
        if edges.contains(.left) {
            constraints.append(NSLayoutConstraint(item: self, attribute: .left, relatedBy: relation, toItem: superview, attribute: (useMargins ? .leftMargin : .left), multiplier: 1, constant: insets.left))
        }
        if edges.contains(.right) {
            constraints.append(NSLayoutConstraint(item: self, attribute: .right, relatedBy: relation, toItem: superview, attribute: (useMargins ? .rightMargin : .right), multiplier: 1, constant: insets.right))
        }
        return constraints
    }
    
    ///add Shadow for view 
    func addShadow(color:UIColor,radius:CGFloat){
        self.layer.shadowOffset = .zero
        self.layer.shadowOpacity = 0.4
        self.layer.shadowColor = color.cgColor
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: layer.cornerRadius).cgPath
        self.layer.shadowRadius = radius
    }
}


