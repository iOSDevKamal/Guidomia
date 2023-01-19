//
//  CarViewModel.swift
//  Guidomia
//
//  Created by Kamal Trapasiya on 2023-01-19.
//

import UIKit
import CoreData

class CarViewModel: NSObject, ObservableObject {
    
    @Published var carArr: [Car] = []
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override init() {
        super.init()
        getData()
    }
    
    //MARK: Getting data from database
    func getData() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Car")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request) as! [Car]
            if !result.isEmpty {
                carArr = result
            }
            else {
                parseJSON()
            }
        } catch {
            print(error)
        }
    }
    
    //MARK: Reading data from JSON file
    func parseJSON() {
        do {
            if let bundlePath = Bundle.main.path(forResource: "car_list",
                                                 ofType: "json"), let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
                do {
                    guard let jsonArr = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [[String:Any]] else { return }
                    saveData(jsonArr: jsonArr)
                }
                catch {
                    print(error)
                }
            }
        } catch {
            print(error)
        }
    }
    
    //MARK: Saving data to Core Data
    func saveData(jsonArr: [[String:Any]]) {
        let entity = NSEntityDescription.entity(forEntityName: "Car", in: context)
        for dict in jsonArr {
            let car = Car(entity: entity!, insertInto: context)
            if let make = dict["make"] as? String {
                car.make = make
            }
            if let model = dict["model"] as? String {
                car.model = model
            }
            if let marketPrice = dict["marketPrice"] as? Double {
                car.marketPrice = marketPrice
            }
            if let customerPrice = dict["customerPrice"] as? Double {
                car.customerPrice = customerPrice
            }
            if let rating = dict["rating"] as? Double {
                car.rating = rating
            }
            if let prosList = dict["prosList"] as? NSObject {
                car.prosList = prosList
            }
            if let consList = dict["consList"] as? NSObject {
                car.consList = consList
            }
        }
        DispatchQueue.main.async {
            do {
                try self.context.save()
                self.getData()
            }
            catch {
                print(error)
            }
        }
    }
}
