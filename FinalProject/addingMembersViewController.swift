//
//  addingMembersViewController.swift
//  FinalProject
//
//  Created by Carl Gramata on 3/6/16.
//  Copyright © 2016 Carl Gramata. All rights reserved.
//

import UIKit
import Contacts



class addingMembersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //list of the group names
    var listOfGroupNames:[String] = []
    //[groupName:ListOfContact]
    //var groups = [String:AnyObject]() //NSUserDefaults does this for me already
    //([Name:PhoneNumber], " ", " ")
    var listOfContacts = [[String:String]]()
    //[Name:PhoneNumber]
    var actualContact = [String:String]()
    
    
    var contactStore = CNContactStore()
    
    @IBOutlet weak var tableView: UITableView!
    
    var myContacts = [CNContact]()
    
    //requests to access contact list
    func requestForAccess(completionHandler: (accessGranted: Bool) -> Void) {
        let authorizationStatus = CNContactStore.authorizationStatusForEntityType(.Contacts)
        
        switch authorizationStatus {
        case .Authorized:
            completionHandler(accessGranted: true)
            
        case .Denied, .NotDetermined:
            self.contactStore.requestAccessForEntityType(.Contacts, completionHandler: { (access, accessError) -> Void in
                if access {
                    completionHandler(accessGranted: access)
                }
                else {
                    if authorizationStatus == .Denied {
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            let message = "\(accessError!.localizedDescription)\n\nPlease allow the app to access your contacts through the Settings."
                            self.showMessage(message)
                        })
                    }
                }
            })
            
        default:
            completionHandler(accessGranted: false)
        }
    }
    
    
    //message that shows if access denied, tells the user to set in the settings
    func showMessage(message: String) {
        let alert = UIAlertController(title: "MyContacts", message: message, preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert.addAction(okAction)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        requestForAccess { (accessGranted) -> Void in
            if accessGranted {
                // Fetch contacts from address book
                let keysToFetch = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactEmailAddressesKey, CNContactPhoneNumbersKey]
                let containerId = CNContactStore().defaultContainerIdentifier()
                let predicate: NSPredicate = CNContact.predicateForContactsInContainerWithIdentifier(containerId)
                do {
                    self.myContacts = try CNContactStore().unifiedContactsMatchingPredicate(predicate, keysToFetch: keysToFetch)
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.tableView.reloadData()
                    })
                } catch _ {
                    print("Error retrieving contacts")
                }
            }
        }

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    //sets the table up and populates with the contacts
    //also preps for the checking option
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell")!
        
        let contact = myContacts[indexPath.row]
        
        cell.textLabel!.text = contact.givenName + " " + contact.familyName
        
        
        var cellString = ""
        for cellNumber in contact.phoneNumbers {
            if cellNumber.label == CNLabelPhoneNumberMobile {
                let numberString = cellNumber.value as! CNPhoneNumber
                cellString = numberString.stringValue
            }
        }
        
        cell.detailTextLabel!.text = cellString
        
        
       /*if cell.selected {
            cell.selected = false
            if cell.accessoryType == UITableViewCellAccessoryType.None {
                cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            } else {
                cell.accessoryType = UITableViewCellAccessoryType.None
            }
        }*/
        
        return cell
    }
    
    
    //implements the multiple checking option
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        
        if cell!.selected {
            cell!.selected = false
            if cell!.accessoryType == UITableViewCellAccessoryType.None {
                cell!.accessoryType = UITableViewCellAccessoryType.Checkmark
                actualContact[cell!.textLabel!.text!] = cell!.detailTextLabel!.text //creates dictionary [Name:PhoneNumber]
                listOfContacts.append(actualContact) //appends the dictionary to a list
            } else {
                cell!.accessoryType = UITableViewCellAccessoryType.None
            }
        }
    
    }
    
    
    //need to revisit to think about the listOfGroup problem
    @IBAction func doneSelectingMembers(sender: UIBarButtonItem) {
        
        if listOfContacts[0].count == 0 {
            let message = "No members detected, PLEASE CHOOSE MEMBERS!"
            
            let title = "No One Was Chosen :("
            let alertController =
            UIAlertController(title: title,message: message,preferredStyle: .Alert)
            
            // Create the action.
            let cancelAction =
            UIAlertAction(title: "OK",style: .Cancel,handler: nil)
            alertController.addAction(cancelAction)
            presentViewController(alertController,animated: true,completion: nil)
            
        } else {
            listOfGroupNames.append(groupName)
            let prep = NSUserDefaults.standardUserDefaults()
            
            prep.setValue(listOfContacts[0], forKey: groupName)
            prep.setValue(listOfGroupNames, forKey: "ListOfGroupNames")
          
        }
        
        
        
    }
    
    //returns the same number of cells as contacts
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myContacts.count
    }

}
