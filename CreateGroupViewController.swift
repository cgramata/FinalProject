//
//  CreateGroupViewController.swift
//  FinalProject
//
//  Created by Carl Gramata on 3/5/16.
//  Copyright © 2016 Carl Gramata. All rights reserved.
//

import UIKit


//global variable for groupnName storage to be used later
var groupName:String = ""

class CreateGroupViewController: UIViewController {
    
    @IBOutlet weak var groupNameCreateInput: UITextField!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    //hides the keyboard after use
    @IBAction func groupNameCreateText(sender: UITextField) {
        sender.resignFirstResponder();
    }
    
    
    
    //segues into a dynamic cell view
    @IBAction func nextButtonCreate(sender: UIButton) {
        var  name = ""
        
        name = groupNameCreateInput.text!
        
        //if groupNameCreateInput is empty it will pop a warning
        if name == "" {
            let message = "No name detected, PLEASE FILL IN!"
            
            let title = "Invalid Entry: Description"
            let alertController =
            UIAlertController(title: title,message: message,preferredStyle: .Alert)
            
            // Create the action.
            let cancelAction =
            UIAlertAction(title: "OK",style: .Cancel,handler: nil)
            alertController.addAction(cancelAction)
            presentViewController(alertController,animated: true,completion: nil)
            
        } else {
            groupName = name
        }
    }

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
