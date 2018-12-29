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
    
    @IBOutlet weak var countryNameLabel: UILabel!
    @IBOutlet weak var countryCodeLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var lenguageLabel: UILabel!
    @IBOutlet weak var codeLabel: UILabel!
    @IBOutlet weak var timeZoneLabel: UILabel!
    
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
    
    public func populateView(data: City?) {
        countryNameLabel.text = data?.name
        countryCodeLabel.text = data?.country_code
        currencyLabel.text = data?.currency
        lenguageLabel.text = data?.language_code
        codeLabel.text = data?.code
        timeZoneLabel.text = data?.time_zone
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
