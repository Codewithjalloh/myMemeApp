//
//  MemeTableViewCell.swift
//  MemeMe 2.0
//
//  Created by jalloh on 08/06/2016.
//  Copyright © 2016 CWJ. All rights reserved.
//

import UIKit


class MemeTableViewCell: UITableViewCell {
    
    
    //MARK: Outlets
    @IBOutlet weak var memeImageView: UIImageView!
    @IBOutlet weak var memeText: UILabel!

    @IBOutlet weak var topText: UILabel!
    @IBOutlet weak var bottomText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
