//
//  CategoryVC.swift
//  KeepSecret
//
//  Created by Michael Tanious on 4/10/17.
//  Copyright © 2017 winmacworldIOS. All rights reserved.
//

import UIKit
import CoreData


class CategoryVC: UIViewController, UITableViewDelegate, UITableViewDataSource , NSFetchedResultsControllerDelegate, UITabBarDelegate {
    
    
    // UI Outlets
    @IBOutlet weak var categoryTableView: UITableView!
    @IBOutlet weak var tabBar: UITabBar!
    
    @IBOutlet weak var segmant: UISegmentedControl!
    // Variables
    var controller : NSFetchedResultsController<Category>!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Delegate
        categoryTableView.delegate = self
        categoryTableView.dataSource = self
        tabBar.delegate = self
        
        // Check if it is first launch and create defaults
        firstLaunch ()
        
        
        // Attempt Fetch exexution
        attemptFetch()
        
        
        
        
        
        
        
    }
    
    
    
    // tab bar item selected
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
        // setting tab bar item is selected
        if item.title! == "Web" {
            performSegue(withIdentifier: "ShowWebVC", sender: item)
            
        }
        // Favorits tab bar item is selected
        if item.title! == "Favorites" {
            performSegue(withIdentifier: "ShowSecretVC", sender: item)
            
        }
        
        if item.title! == "Pictures" {
            performSegue(withIdentifier: "ShowSecretPictureLibraryVC", sender: item)
            
        }
        
        
        
        
        
    }
    
    
    // prepare for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowEditNewCategoryVC" {
            if let des = segue.destination as? CategoryDetailVC {
                if let item = sender as? Category {
                    des.categoryToEdit = item
                }
            }
        }
            if segue.identifier == "ShowSecretVC" {
                if let des = segue.destination as? SecretVC {
                    if let item = sender as? UITabBarItem {
                        if item.title! == "Favorites" {
                        des.isFavoritMode = true
                        }
                    }
                }
        }
        
        
        
        
        if segue.identifier == "ShowSecretVC" {
            if let des = segue.destination as? SecretVC {
                if let item = sender as? Category {
                    des.categoryToShow = item
                }
            }
            
        }
        
    }
    
    // implement categoryTableView protocols
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if let sections = controller.sections {
            return sections.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = controller.sections {
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
        }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = categoryTableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
        configureCell(cell: cell, indexPath: indexPath)
        
        
        return cell
    }
    
    func configureCell(cell: CategoryCell, indexPath: IndexPath) {
        let item = controller.object(at: indexPath)
        cell.configureCell(item: item)
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let objs = controller.fetchedObjects , objs.count > 0 {
            let item = objs[indexPath.row]
            
           // Change the value of lastusedate to current date
            item.lastusedate = NSDate()
            ad.saveContext()
           
            performSegue(withIdentifier: "ShowSecretVC", sender: item)
        }
        
    }
    
    
    // tap to eddit cell
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        
        if let objs = controller.fetchedObjects , objs.count > 0 {
            let item = objs[indexPath.row]
            
            performSegue(withIdentifier: "ShowEditNewCategoryVC", sender: item)
        }
        
        
    }
    
    
    // swipe to delete cell
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let objs = controller.fetchedObjects , objs.count > 0 {
                let item = objs[indexPath.row]
                context.delete(item)
                ad.saveContext()
                
            }
            
        }
    }
    
    func attemptFetch() {
        let fetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
       let nameSort = NSSortDescriptor(key: "name", ascending: true, selector: #selector(NSString.localizedCaseInsensitiveCompare(_:)))
        let dateSort = NSSortDescriptor(key: "created", ascending: false)
        let lastusedate = NSSortDescriptor(key: "lastusedate", ascending: false)
        if segmant.selectedSegmentIndex == 0 {
            fetchRequest.sortDescriptors = [lastusedate]
        } else if segmant.selectedSegmentIndex == 1 {
            fetchRequest.sortDescriptors = [nameSort]
        } else if segmant.selectedSegmentIndex == 2 {
            fetchRequest.sortDescriptors = [dateSort]
        }
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        controller.delegate = self
        self.controller = controller
        
        do {
            try controller.performFetch()
        } catch {
            let error = error as NSError
            print("\(error)")
        }
        
        
        
    }
    
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        categoryTableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        categoryTableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch (type) {
            
        case.insert:
            if let indexPath = newIndexPath {
                categoryTableView.insertRows(at: [indexPath], with: .fade)
            }
            break
        case.delete:
            if let indexPath = indexPath {
                categoryTableView.deleteRows(at: [indexPath], with: .fade)
            }
            break
        case.update:
            if let indexPath = indexPath {
                let cell = categoryTableView.cellForRow(at: indexPath) as! CategoryCell
                configureCell(cell: cell, indexPath: indexPath)
            }
            break
        case.move:
            if let indexPath = indexPath {
                categoryTableView.deleteRows(at: [indexPath], with: .fade)
            }
            if let indexPath = newIndexPath {
                categoryTableView.insertRows(at: [indexPath], with: .fade)
            }
            break
            
        }
    }
    
    // First launch
    
    func firstLaunch () {
        
        if let firstLaunch = UserDefaults.standard.value(forKey: "firstLaunch") as? String {
            if firstLaunch == "NotfirstLaunch" {
                // not first lunch
                print("Not First Launch")
            }
            
        } else {
            
            // generate defaults coreData
            print("First Launch")
            //            let item = Category(context: context)
            //            item.name = "Emails"
            //            item.image = UIImage(named: "imagePick")
            //
            //            let item2 = Category(context: context)
            //            item2.name = "Banks"
            //            item2.image = UIImage(named: "imagePick")
            //
            //            let item3 = Category(context: context)
            //            item3.name = "Web Sites"
            //            item3.image = UIImage(named: "imagePick")
            //
            //            ad.saveContext()
            
            
            
            let categoryitem = Category(context: context)
            
            categoryitem.name = "Email"
            categoryitem.image = UIImage(named: "imagePick")
            categoryitem.lastusedate = NSDate()
            categoryitem.details = "Write Note"
            
            
            
            
            
            let secretitem = Secret(context: context)
            secretitem.name = "gmail1"
            secretitem.email = "michsedki@gmail.com"
            secretitem.website = "gmail.com"
            secretitem.username = "Michsedki"
            secretitem.password1 = "12345"
            secretitem.password2 = "000001"
            secretitem.phonenumber = "8184428169"
            secretitem.zipcode = "94080"
            secretitem.pinnumber = "33333"
            secretitem.securityquestion = "who are you?"
            secretitem.questionanswer = "i am"
            secretitem.image1 = UIImage(named: "imagePick")
            secretitem.image2 = UIImage(named: "imagePick")
            secretitem.lastusedate = NSDate()
            secretitem.accountnumber = "1234567890"
            secretitem.isfavorit = false
            secretitem.toCategory = categoryitem
            
            
            
            
            
            let secretitem2 = Secret(context: context)
            secretitem2.name = "gmail2"
            secretitem2.email = "michsedki@gmail.com"
            secretitem2.website = "gmail.com"
            secretitem2.username = "Michsedki"
            secretitem2.password1 = "12345"
            secretitem2.password2 = "000001"
            secretitem2.phonenumber = "8184428169"
            secretitem2.zipcode = "94080"
            secretitem2.pinnumber = "33333"
            secretitem2.securityquestion = "who are you?"
            secretitem2.questionanswer = "i am"
            secretitem2.image1 = UIImage(named: "imagePick")
            secretitem2.image2 = UIImage(named: "imagePick")
            secretitem2.lastusedate = NSDate()
            secretitem2.accountnumber = "1234567890"
            secretitem2.isfavorit = false
            secretitem2.toCategory = categoryitem
            
            
            
            
            let secretitem3 = Secret(context: context)
            secretitem3.name = "gmail3"
            secretitem3.email = "michsedki@gmail.com"
            secretitem3.website = "gmail.com"
            secretitem3.username = "Michsedki"
            secretitem3.password1 = "12345"
            secretitem3.password2 = "000001"
            secretitem3.phonenumber = "8184428169"
            secretitem3.zipcode = "94080"
            secretitem3.pinnumber = "33333"
            secretitem3.securityquestion = "who are you?"
            secretitem3.questionanswer = "i am"
            secretitem3.image1 = UIImage(named: "imagePick")
            secretitem3.image2 = UIImage(named: "imagePick")
            secretitem3.lastusedate = NSDate()
            secretitem3.accountnumber = "1234567890"
            secretitem3.isfavorit = true
            secretitem3.toCategory = categoryitem
            
            
            ad.saveContext()
            
            
            
            
            
            
            
            
            
            UserDefaults.standard.set("NotfirstLaunch", forKey: "firstLaunch")}
    }
    
    
    // UI Action
    
    @IBAction func segmantChanged(_ sender: Any) {
        attemptFetch()
        categoryTableView.reloadData()
        
    }
}



extension UIViewController {
    func hideKeyboardOnTap(_ selector: Selector) {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: selector)
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
    }
    
}

extension UIImage {
    enum JPEGQuality: CGFloat {
        case lowest = 0
        case low = 0.25
        case medium = 0.5
        case high = 0.75
        case highest = 1
    }
    
    var png: Data? {return UIImagePNGRepresentation(self) }
    func jpeg(_ quality: JPEGQuality) -> UIImage? {
        
        let image = UIImage(data: UIImageJPEGRepresentation(self, quality.rawValue)!)
        return image
    }
    
    func compressTo(_ expectedSizeInMb:Float) -> UIImage? {
        let sizeInBytes = expectedSizeInMb * 1024 * 1024
        var needCompress:Bool = true
        var imgData:Data?
        var compressingValue:CGFloat = 1.0
        while (needCompress) {
            if let data:Data = UIImageJPEGRepresentation(self, compressingValue) {
                if data.count < Int(sizeInBytes) {
                    needCompress = false
                    imgData = data
                } else {
                    compressingValue -= 0.1
                }
            }
        }
        
        if let data = imgData {
            return UIImage(data: data)
        }
        return nil
    }
    
    
}




