//
//  Contact.swift
//  TestAppWithRX
//
//  Created by George Kyrylenko on 09.08.2020.
//  Copyright © 2020 TestApp. All rights reserved.
//

import Foundation
import ContactsUI

class Contact{
    private(set) var name: String
    private(set) var phoneNumbers: [String]?
    
    init(contact: CNContact) {
        name = "\(contact.givenName) \(contact.familyName)"
        phoneNumbers = contact.phoneNumbers.compactMap({ (phoneNumber) -> String in
            return phoneNumber.value.stringValue
        })
    }
}
