//
//  TableCell.swift
//  Meal Recipes
//
//  Created by Stas on 10.12.2020.
//
import UIKit
import Foundation

protocol MyTableViewCellDelegate: AnyObject {
    func showFoundNames()
}

class TableCell: UITableViewCell {
    
    @IBOutlet weak var someLabel: UILabel!
    weak var delegate: MyTableViewCellDelegate?
    func settext(name: String){
        self.someLabel.text = name
    }
    func showFoundNames(_ sender: Any) {
        delegate?.showFoundNames()
    }
}
