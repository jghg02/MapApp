//
//  GlovoAppListView.swift
//  GlovoApp
//
//  Created by Josue Hernandez Gonzalez on 27/12/2018.
//  Copyright © 2018 Josue Hernandez Gonzalez. All rights reserved.
//

import UIKit

@objc public class GlovoAppListView: UIView, UITableViewDelegate, UITableViewDataSource{

    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var listView: UITableView!
    
    let animals: [String] = ["Horse", "Cow", "Camel", "Sheep", "Goat"]

    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    public func setupView() {
        GlovoAppBundle.bundle().loadNibNamed("GlovoAppListView", owner: self, options: nil)
        contentView.fixInView(self)
    }
    
    
    //MARK: UITableView
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.animals.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : UITableViewCell!
        cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        
        cell.textLabel?.text = self.animals[indexPath.row]
        
        return cell
    }
}
