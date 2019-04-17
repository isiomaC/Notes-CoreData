//
//  NotesViewController.swift
//  Notes-CoreData
//
//  Created by Anofienam Isioma on 11/04/2019.
//  Copyright © 2019 com.chuck. All rights reserved.
//

import UIKit
import CoreData

class NotesViewController: UIViewController, SendBackParent {
    
    var notesArray = [Note]()
    var cellId = "BCell"
    
    var notesInstance = Notes.sharedInstance
    
    let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var selectedFolder : Folder?  {
        didSet{
            fetchNotesForCategory(parent: selectedFolder!.name!)
        }
    }

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = selectedFolder?.name
        navigationItem.backBarButtonItem?.tintColor = .black
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewNote))
        fetchNotesForCategory(parent: selectedFolder!.name!)
        setUpViewController()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        collectionView.reloadData()
        navigationController?.navigationBar.isHidden = false
    }
    
    @objc func addNewNote(){
        let destinationVC = storyBoard.instantiateViewController(withIdentifier: "detail") as! detailViewController
        destinationVC.delegate = self
        destinationVC.parentFolder = selectedFolder
        destinationVC.notesArray = notesArray
        destinationVC.context = context
        navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    func fetchNotesForCategory(parent: String){
        let request: NSFetchRequest<Note> = Note.fetchRequest()
        request.predicate = NSPredicate(format: "parentFolder.name MATCHES %@", parent)
        do{
            notesInstance.note = try context.fetch(request)
            notesArray = notesInstance.note!
        }catch{
            print("Print Error : \(error)")
        }
    }
    
    func dataSentback(parent: String, notesPassedBack: [Note]) {
        selectedFolder?.name = parent
    }
    
    func saveData(){
        do{
            try context.save()
            print("Context Saved")
        }catch{
            print("error occured when saving this file \(error)")
        }
    }
    
}

extension NotesViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource{
    
    func setUpViewController() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: view.frame.width - CGFloat(10), height: 200)
        //        layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        //        layout.minimumLineSpacing = 40
        
        //        collectionView?.register(BCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.delegate = self
        collectionView?.dataSource = self
        
        collectionView?.backgroundColor = .clear
        collectionView.setCollectionViewLayout(layout, animated: true)
        
        print(collectionView as Any)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return notesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! BCell
        
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .short
        
        let dateString = formatter.string(from: notesArray[indexPath.row].date!)
        let textString = notesArray[indexPath.row].text!
        let titleString = notesArray[indexPath.row].title!
        
        cell.setValues(title: titleString, text: textString, date: dateString)
        
        cell.tag = indexPath.row
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
        let destinationVC = storyBoard.instantiateViewController(withIdentifier: "detail") as! detailViewController
        
        destinationVC.cIndex = indexPath.row
        destinationVC.notesArray = notesArray
        destinationVC.parentFolder = selectedFolder
        destinationVC.context = context
        destinationVC.delegate = self
        
        navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    //        if segue.identifier == "goToDetail" {
    //            if let cell = sender as? UICollectionViewCell{
    //                if let collectionView = cell.superview as? UICollectionView{
    //                    destinationVC.delegate = self
    //                    let indexPaths = collectionView.indexPathsForVisibleItems
    //                    destinationVC.cellValue = notesArray[(indexPaths.last?.row)! ]
    //
    //                    debugPrint(notesArray[collectionView.tag])
    //                }
    //            }
    //        }
}
