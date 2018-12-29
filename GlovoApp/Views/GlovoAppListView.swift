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
    
    var allData: [String:[City]] = [:]
    var listcountries: [Country] = []
    var listcities: [City] = []
    
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
    
    public func reloadDatainList(data: Dictionary<String, [City]>, listCountries: Array<Country>) {
        allData = data as [String : [City]]
        listcountries = listCountries
        listView.reloadData()
    }
    
    
    //MARK: UITableView
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let countryCode = listcountries[section]
        let arrayCities = allData[countryCode.code!]
        
        return arrayCities!.count
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return listcountries.count
    }
    
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int)
        -> String? {
            return listcountries.count == 0 ? "" : listcountries[section].name
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : UITableViewCell!
        cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        
        let countryCode = listcountries[indexPath.section]
        listcities = allData[countryCode.code!]!
        let city: City = listcities[indexPath.row]
        
        cell.textLabel?.text = city.name

        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    
}
