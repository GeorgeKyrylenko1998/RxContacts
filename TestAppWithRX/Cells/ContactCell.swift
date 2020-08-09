//
//  ContactCell.swift
//  TestAppWithRX
//
//  Created by George Kyrylenko on 09.08.2020.
//  Copyright © 2020 TestApp. All rights reserved.
//

import UIKit

class ContactCell: UITableViewCell {

    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var phoneNumberLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
