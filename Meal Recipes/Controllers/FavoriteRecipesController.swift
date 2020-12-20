//
//  FavoriteRecipesController.swift
//  Recipes
//
//  Created by Stas on 19.12.2020.
//

import UIKit
import RealmSwift
import SDWebImage

class FavoriteRecipesController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let realm = try! Realm()
    var storedObjects: [SavedMeal] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        updateDataFromRealm()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "CCC", bundle: nil), forCellWithReuseIdentifier: "CustomCollectionCell")
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateDataFromRealm), name: NSNotification.Name(rawValue: "load"), object: nil)
    }
    @objc func updateDataFromRealm(){
        let objects = realm.objects(SavedMeal.self)
        if objects.count != 0{
            self.storedObjects = []
            for item in objects{
                self.storedObjects.append(item)
            }
        }
        self.collectionView.reloadData()
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let myObjects = realm.objects(SavedMeal.self)
        //print(myObjects.count)
        return myObjects.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let data = storedObjects[indexPath.item].imageURL
        UserDefaults.standard.setValue( data, forKey: "SavedURL")
        print(data)
                   
        
        var cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCollectionCell", for: indexPath) as! CollectionViewCell
        if self.storedObjects.count != 0 {
            print("I have stored objects: \(storedObjects.count)")
            let url = URL(string: storedObjects[indexPath.item].imageURL)
            cell.imageURL = URL(string: storedObjects[indexPath.row].imageURL)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCollectionCell", for: indexPath) as! CollectionViewCell
        if storedObjects.count != 0{
            guard let VC = storyboard?.instantiateViewController(identifier: "showController") as? RandomController else { return }
            VC.modalTransitionStyle = .flipHorizontal
            var tmpid = storedObjects[indexPath.row].id
            var tmpname = storedObjects[indexPath.row].name
            var tmpurl = storedObjects[indexPath.row].imageURL
            var tmpingredients = storedObjects[indexPath.row].ingredients
            var tmpinstructions = storedObjects[indexPath.row].instructions
            present(VC, animated: true)
            API.getPhoto(photomodel: storedObjects[indexPath.row].imageURL){
                gotPhoto in
                if gotPhoto != nil {
                    DispatchQueue.main.async {
                        VC.imagePlace.image = gotPhoto
                        }
                    }
            }
            VC.storedID = tmpid
            VC.mealName.text = tmpname
            VC.storedURL = tmpurl
            VC.ingredienstLabel.text = tmpingredients
            VC.instructionsLabel.text = tmpinstructions
            VC.multyButton.setTitle("Delete", for: .normal)
            VC.multyButton.setTitleColor(.red, for: .normal)
            VC.multyButton.isHidden = false
            VC.randomButton.isHidden = true
            VC.textButtonChanger = false
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 30) / 3
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        10
    }
    
}

