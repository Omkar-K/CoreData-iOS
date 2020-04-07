//
//  PeopleTableViewController.swift
//  Core Data Test
//


import UIKit
import CoreData

class PeopleTableViewController: UITableViewController, NSFetchedResultsControllerDelegate, UISearchBarDelegate, UISearchDisplayDelegate{
    
    // Code Data Objects
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var personManagedObject : Person! = nil
    var entity : NSEntityDescription! = nil
    var frc : NSFetchedResultsController<NSFetchRequestResult>! = nil
    var itemName: [NSManagedObject] = []
    let backgroundImage = UIImageView(image: UIImage(named: "sbg.jpg"))
    func makeRequest() -> NSFetchRequest<NSFetchRequestResult>{
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Person")
        let sorter    = NSSortDescriptor(key: "name", ascending: true)
        request.sortDescriptors = [sorter]
        
        return request
        
    }
    //custom makeRequest function for handling search
    func makesearchRequest(searchText: String) -> NSFetchRequest<NSFetchRequestResult>{
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Person")
        var predicate: NSPredicate = NSPredicate()
        predicate = NSPredicate(format: "name contains[c] '\(searchText)'")
        let appDeligate = UIApplication.shared.delegate as! AppDelegate
        let context = appDeligate.persistentContainer.viewContext
        let sorter    = NSSortDescriptor(key: "name", ascending: true)
        request.sortDescriptors = [sorter]
        request.predicate = predicate
        
        return request
        
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        frc = NSFetchedResultsController(fetchRequest: makeRequest(), managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        frc.delegate = self
        
        do {
            try frc.performFetch()
            try print(frc.performFetch())
        } catch{
            print("cannot perform fetch")
        }
        
        self.title = "Student List"
        backgroundImage.contentMode = .scaleAspectFill
        tableView.backgroundView = backgroundImage
        
        setupElements()
        
        searchBar.placeholder = "Search Students"
        searchBar.delegate = self
    }
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    // MARK: - Table view data sourcem

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return frc.sections![section].numberOfObjects
    }

 
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        personManagedObject = (frc.object(at: indexPath) as! Person)

        // Configure the cell...
        cell.textLabel?.text = personManagedObject.name
        cell.detailTextLabel?.text = personManagedObject.phone

        let imagePath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(personManagedObject.image!)
        
        cell.imageView?.image = UIImage(contentsOfFile: imagePath);
        cell.backgroundColor = UIColor(white: 1, alpha: 0.5)
        return cell
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            personManagedObject = frc.object(at: indexPath) as! Person
            context.delete(personManagedObject)
        }
        do{try context.save()}
        catch{}
        
        do{try frc.performFetch()}
        catch{}
        
        tableView.reloadData()
    }
    

    
    @IBAction func editAction(_ sender: UIBarButtonItem) {
        self.tableView.isEditing = !self.tableView.isEditing
        sender.title = (self.tableView.isEditing) ? "Done" : "Edit"
    }
    
    //Search function
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText != ""
        {
            //passing the search text to fetch relevent data
            frc = NSFetchedResultsController(fetchRequest: makesearchRequest(searchText: searchText) , managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            do{
                 try frc.performFetch()
            }
            catch{
                print("Cound not fetch data")
            }
            tableView.reloadData()
        }
        else{
            //This will generate the full list when search is cancelled
           
            frc = NSFetchedResultsController(fetchRequest: makeRequest(), managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            
            do {
                try frc.performFetch()
            } catch{
                print("cannot perform fetch")
            }
            tableView.reloadData()
        }
    }
   

   
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "cellSegue"{
            
            // Get the new view controller using segue.destination.
            let vc = segue.destination as! PersonViewController
        
            let indexPath = self.tableView.indexPath(for: sender as! UITableViewCell)
            personManagedObject = frc.object(at: indexPath!) as! Person
            
            // Pass the selected object to the new view controller.
            vc.personManagedObject = personManagedObject
        }
    }
    

}

//Adding constraints to the table view
extension PeopleTableViewController{
    
    func setupElements(){
        //view.addSubview(tableView)
        
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor ).isActive = true
    }
}
