//
//  GlovoAppPanelInfoView.swift
//  GlovoApp
//
//  Created by Josue Hernandez Gonzalez on 27/12/2018.
//  Copyright © 2018 Josue Hernandez Gonzalez. All rights reserved.
//

import UIKit

@objc public class GlovoAppPanelInfoView: UIView {

    @IBOutlet var contentView: UIView!
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    public func setupView() {
        GlovoAppBundle.bundle().loadNibNamed("GlovoAppPanelInfoView", owner: self, options: nil)
        contentView.fixInView(self)
    }
    
}

extension UIView
{
    func fixInView(_ container: UIView!) -> Void{
        self.translatesAutoresizingMaskIntoConstraints = false;
        self.frame = container.frame;
        container.addSubview(self);
        NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: container, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: container, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: container, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: container, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
    }
}
