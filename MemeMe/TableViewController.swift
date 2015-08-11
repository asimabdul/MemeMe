//
//  TableViewController.swift
//  MemeMe
//
//  Created by Asim Abdul on 8/10/15.
//  Copyright (c) 2015 AsimAbdul. All rights reserved.
//

import Foundation
import UIKit

class TableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var sentMemes = [Meme]()
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let controller = self.tabBarController as! TabBarController
        self.sentMemes = controller.sentMemesGlobal
        return self.sentMemes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MemeCell") as! UITableViewCell
        let currentMeme = self.sentMemes[indexPath.row]
        
        cell.imageView?.image = currentMeme.image
        return cell
    }
    
    
    
}
