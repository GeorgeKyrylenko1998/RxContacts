//
//  ContactsManager.swift
//  TestAppWithRX
//
//  Created by George Kyrylenko on 09.08.2020.
//  Copyright © 2020 TestApp. All rights reserved.
//

 import Foundation
 import ContactsUI
import RxCocoa
import RxSwift

class ContactsManager {
    
    private var storedContacts: [Contact]?
    let contacts = PublishSubject<[Contact]>()

    func updateContacts(){

        let contactStore = CNContactStore()
        let keysToFetch = [
            CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
            CNContactPhoneNumbersKey,
            CNContactEmailAddressesKey,
            CNContactThumbnailImageDataKey] as [Any]

        var allContainers: [CNContainer] = []
        do {
            allContainers = try contactStore.containers(matching: nil)
        } catch {
            print("Error fetching containers")
        }

        var results: [CNContact] = []

        for container in allContainers {
            let fetchPredicate = CNContact.predicateForContactsInContainer(withIdentifier: container.identifier)

            do {
                let containerResults = try contactStore.unifiedContacts(matching: fetchPredicate, keysToFetch: keysToFetch as! [CNKeyDescriptor])
                results.append(contentsOf: containerResults)
            } catch {
                print("Error fetching containers")
            }
        }
        storedContacts = results.map { (contact) -> Contact in
            return Contact(contact: contact)}.sorted(by: {$0.name < $1.name})
        guard let storedContacts = storedContacts else {return}
        contacts.on(.next(storedContacts))
    }
    
    func searchContacts(by searchString: String?){
        guard let searchString = searchString, !searchString.isEmpty else {
            contacts.on(.next(storedContacts!))
            return
        }
        guard let searchContacts = storedContacts?.filter({ (contact) -> Bool in
            return contact.name.lowercased().contains(searchString) || contact.phoneNumbers?.filter({ (phoneNumber) -> Bool in
                return phoneNumber.lowercased().trimmingCharacters(in: .whitespaces).contains(searchString)
            }).count ?? 0 > 0
        }) else {return}
        contacts.on(.next(searchContacts))
    }
}
