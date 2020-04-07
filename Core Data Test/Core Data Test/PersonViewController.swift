//
//  PersonViewController.swift
//  Core Data Test
//


import UIKit
import CoreData

class PersonViewController: UIViewController ,UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    // coredata object
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var personManagedObject : Person! = nil
    var entity : NSEntityDescription! = nil
    
    func update(){
        
        personManagedObject.name = nameTextField.text
        personManagedObject.phone = phoneTextField.text
        personManagedObject.address = addressTextField.text
        personManagedObject.image = nameTextField.text
        personManagedObject.url = urlTextField.text
        
        do {
            try context.save()
        } catch {
            print("cannot save teh record")
        }
        saveImage(imageName: personManagedObject.image!)
    }
    @IBOutlet weak var titleLabel: UILabel!
    
    func save(){
        
        entity = NSEntityDescription.entity(forEntityName: "Person", in: context)
        personManagedObject = Person(context: context)
        
        personManagedObject.name = nameTextField.text
        personManagedObject.phone = phoneTextField.text
        personManagedObject.address = addressTextField.text
        personManagedObject.image = nameTextField.text
        personManagedObject.url = urlTextField.text
        
        do {
            try context.save()
        } catch {
            print("cannot save teh record")
        }
        saveImage(imageName: personManagedObject.image!)
        
    }
    
    
    // Outlets and Action
    
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var phoneTextField: UITextField!
    
    @IBOutlet weak var addressTextField: UITextField!
    
    @IBOutlet weak var pickedImage: UIImageView!
    
    var imageController = UIImagePickerController()
    @IBAction func selectImage(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            imageController.sourceType = .savedPhotosAlbum
            imageController.allowsEditing = false
            
            present(imageController,animated: true, completion: nil)
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        self.pickedImage.image = image
        print("Name",pickedImage?.description as Any)
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func saveImage(imageName: String) {
        
        //create an instance of the FileManager
        let fileManager = FileManager.default
        //get the image path
        let imagePath = (NSSearchPathForDirectoriesInDomains(
        .documentDirectory,
        .userDomainMask, true)[0] as NSString) .appendingPathComponent(imageName)
        let image = pickedImage.image!
        //get the PNG data for this image
        let data = image.pngData()
        //store it in the document directory
        fileManager.createFile(atPath: imagePath as String, contents: data, attributes: nil)
    }
    
    func getImage(imageName: String)
    {
        let fileManager = FileManager.default
        let imagePath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask,true)[0] as NSString).appendingPathComponent(imageName)
        if fileManager.fileExists(atPath: imagePath){
            pickedImage.image = UIImage(contentsOfFile: imagePath)
        }else{
            print("No image!")
        }
    }
    @IBOutlet weak var urlTextField: UITextField!
    
    @IBOutlet weak var pickBt: UIButton!
    
    @IBOutlet weak var donebt: UIButton!
    @IBAction func doneAction(_ sender: Any) {
        
        if personManagedObject != nil{update()}
        else{save()}
        
        navigationController?.popViewController(animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if personManagedObject != nil{
            nameTextField.text = personManagedObject.name
            phoneTextField.text = personManagedObject.phone
            addressTextField.text = personManagedObject.address
            //imageTextField.text = personManagedObject.n
            if personManagedObject.image != nil{
                getImage(imageName: personManagedObject.image!)
                titleLabel.text = "Update Person"
            }
            urlTextField.text = personManagedObject.url
        }else{titleLabel.text = "Add Person"}
        imageController.delegate = self
        
        pickBt.backgroundColor = .clear
        pickBt.layer.cornerRadius = 8
        pickBt.layer.borderWidth = 1
        pickBt.layer.borderColor = UIColor.black.cgColor
        
        donebt.backgroundColor = .clear
        donebt.layer.cornerRadius = 8
        donebt.layer.borderWidth = 1
        donebt.layer.borderColor = UIColor.black.cgColor
    }
    


}
