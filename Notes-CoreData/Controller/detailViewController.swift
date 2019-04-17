//
//  detailViewController.swift
//  Notes-CoreData
//
//  Created by Anofienam Isioma on 11/04/2019.
//  Copyright © 2019 com.chuck. All rights reserved.
//

import UIKit
import CoreData

protocol SendBackParent{
    func dataSentback(parent: String, notesPassedBack: [Note])
}

class detailViewController: UIViewController, UITextViewDelegate {

    var cIndex : Int?
    var notesArray: [Note] = []
    
    var parentFolder: Folder? //Passed only when a new value is needed to be created
    
    var newCellValue: Note?
    
    var newText: String?
    var newTitle: String?
    
    @IBOutlet weak var displayTitle: UITextField!
    @IBOutlet weak var displayText: UITextView!
    
    var delegate: SendBackParent?
    
    var context: NSManagedObjectContext?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        displayText.delegate = self
        navigationController?.hidesBarsOnSwipe = true
        navigationItem.rightBarButtonItems = [UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonClicked)), UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(trashButtonClicked)) ]
        instantiateView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        instantiateView()
    }
    
    func instantiateView(){
        if let ind = cIndex{
            displayText.text = notesArray[ind].text
            displayTitle.text = notesArray[ind].title
            
        }
        
        displayTitle.addTarget(self, action: #selector(textFieldDidChange), for: UIControl.Event.editingChanged )
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(endEditing))
        tapGesture.numberOfTapsRequired = 2
        displayTitle.addGestureRecognizer(tapGesture)
    }
    
    //Function to check Back Bar Button item pressed
    override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
        
        if parent == nil {
            if cIndex == nil{
                if let val = newCellValue, let parentVal = val.parentFolder {
                    delegate?.dataSentback(parent: parentVal.name!, notesPassedBack: notesArray)
                }
                
            }else{
                delegate?.dataSentback(parent: notesArray[cIndex!].parentFolder!.name!, notesPassedBack: notesArray)
                
            }
            debugPrint("Back Button pressed.")
        }
    }
    
    //#########################################
    //Make file save when you finish typing or if you use the button, use SVProgressHUD
    
    func textViewDidChange(_ textView: UITextView) {
        newText = displayText.text
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n"){
            view.endEditing(true)
            return false
        }else{
            return true
        }
    }
    
    @objc func textFieldDidChange(){
        newTitle = displayTitle.text
    }
    
    @objc func saveButtonClicked(){
        
        if cIndex == nil{
            if newText == "" || newText == nil || newTitle == nil || newTitle == ""{
                print("EnTer Valid notes")
            }else{
                newCellValue = Note(context: context!)
                newCellValue?.text = newText
                newCellValue?.title = newTitle
                newCellValue?.parentFolder = parentFolder
                newCellValue?.date = Date()
                notesArray.append(newCellValue!)
                print(newCellValue!)
                saveData()
            }
            
        }else{
            if let ind = cIndex{
                if newText == "" || newText == nil || newTitle == nil || newTitle == ""{
                     print("\(newText) or \(newTitle) is empty")
                }else{
                    notesArray[ind].setValue(newTitle, forKey: "title")
                    notesArray[ind].setValue(newText, forKey: "text")
                    notesArray[ind].setValue(Date(), forKey: "date")
                    notesArray[ind].setValue(parentFolder, forKey: "parentFolder")
                    saveData()
                }
            }
        }
    }
    
    @objc func trashButtonClicked(){
        do{
            if let ind = cIndex{
                context?.delete(notesArray[ind])
                notesArray.remove(at: ind)
                
                try context?.save()
            }
        }catch{
            print("Error occured while deleteing \(error)")
        }
    }
    
    func saveData(){
        do{
            try context?.save()
            print("Context Saved")
        }catch{
            print("error occured when saving this file \(error)")
        }
    }
    
    @objc func endEditing(){
        view.endEditing(true)
    }
    
}


