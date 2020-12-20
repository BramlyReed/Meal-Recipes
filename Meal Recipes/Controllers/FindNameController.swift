//
//  FindNameController.swift
//  Recipes
//
//  Created by Stas on 07.12.2020.
//

import UIKit

class FindNameController: UIViewController, MyTableViewCellDelegate {

    var meals: [Meal] = []
    var mealNames: [String] = []
    var mealId: [String] = []
    var signal = true
    @IBOutlet weak var tableWithNames: UITableView!
    @IBOutlet weak var searchString: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableWithNames.dataSource = self
        tableWithNames.delegate = self
        searchString.delegate = self
        tableWithNames.isHidden = false
        searchString.layer.cornerRadius = 15.0
        searchString.layer.borderWidth = 0.5
    }
    
    // MARK: To hide keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if  touches.first != nil{
                view.endEditing(true)
            }
            super.touchesBegan(touches, with: event)
        }
    // MARK: Seaching recipes with name from seacrhString
    func findnames(){
        if searchString.text != ""{
            self.meals = []
            self.mealNames = []
            self.mealId = []
            var customURL = "https://www.themealdb.com/api/json/v1/1/search.php?s="
            customURL += searchString.text!
            var replacedString = customURL.replacingOccurrences(of: " ", with: "")
            URLSession.shared.dataTask(with: URL(string: replacedString)!, completionHandler: { data, response, error in
                guard let data = data, error == nil else{
                    print("Some error got after request!")
                    return
                }
                // if we got nil result - {"meals":null}
                var resultmeal: Mealdata
                if data.count == 14{
                    DispatchQueue.main.async {
                        self.mealNames.append("Nothing found")
                        self.tableWithNames.reloadData()
                    }
                }
                else{
                    let decoder = JSONDecoder()
                    resultmeal = try! decoder.decode(Mealdata.self, from: data)
                    DispatchQueue.main.async {
                        for item in resultmeal.meals{
                            self.meals.append(item)
                            self.mealId.append(self.meals.last!.id)
                            self.mealNames.append(self.meals.last!.name)
                        }
                        self.tableWithNames.reloadData()
                    }
                }
            }).resume()
        }
    }
    // MARK: show RandomController with choosen recipe's cell
    func showFoundNames(){
        guard let VC = storyboard?.instantiateViewController(identifier: "showController") as? RandomController else { return }
        VC.modalTransitionStyle = .flipHorizontal
        present(VC,animated: true)
    }
}
extension FindNameController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.mealNames.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        self.tableWithNames.isHidden = false
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath) as! TableCell
        cell.settext(name: mealNames[indexPath.item])
        cell.delegate = self
        return cell
    }
}
extension FindNameController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let cell = tableWithNames.cellForRow(at: indexPath) as! TableCell
        if self.mealNames[indexPath.row] != "Nothing found"{
            //saving recipe's id in UserDefaults
            var tmpId = mealId[indexPath.row]
            UserDefaults.standard.setValue(tmpId, forKey: "SavedId")
            showFoundNames()
        }
    }
}
extension FindNameController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if searchString.text!.count != 0{
            findnames()
        }
        return true
    }
}

