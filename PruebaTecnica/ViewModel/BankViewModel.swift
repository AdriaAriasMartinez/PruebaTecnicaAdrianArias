//
//  BankViewModel.swift
//  PruebaTecnica
//
//  Created by AdrianArias on 31/05/23.
//

import Foundation
import CoreData
import UIKit


class BankViewModel{
    
    private let url = URL(string: "https://dev.obtenmas.com/catom/api/challenge/banks")
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    func GetAllAPI(result: @escaping([BankModel]?, Error?)->Void){
        let decoder = JSONDecoder()
        let urlSession = URLSession.shared
        urlSession.dataTask(with: url!) { data, response, error in
            if let error = error{
                result(nil, error)
                fatalError("Error al obtener datos \(error)")
            }
            if let data = data {
                let bank = try! decoder.decode([BankModel].self, from: data)
                result(bank, nil)
            }
        }.resume()
    }
    
    func AddCoreData(bank: BankModel){
        
        do{
            
            let context = appDelegate.persistentContainer.viewContext
            let entidad = NSEntityDescription.entity(forEntityName: "Bank", in: context)
            let bankCoreData = NSManagedObject(entity: entidad!, insertInto: context)
            let imageData = try Data(contentsOf: URL(string: bank.url)!)
            //print(imageData)
            
            bankCoreData.setValue(imageData, forKey: "image")
            bankCoreData.setValue(bank.bankName, forKey: "bankName")
            bankCoreData.setValue(bank.description, forKey: "bankDescription")
            bankCoreData.setValue(bank.age, forKey: "age")
            bankCoreData.setValue(bank.url, forKey: "url")
            
            try context.save()
            //print("Guardado")
            
        }catch let error{
            fatalError("Error al agregar elemento \(error)")
        }
    }
    
    func GetAllCoreData() -> [BankModel]{
        
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Bank")
        var banksArray  = [BankModel]()
        do{
            
            let banks = try context.fetch(request)
            for objBank in  banks as! [NSManagedObject]{
                
                var bank = BankModel()
                bank.bankName = objBank.value(forKey: "bankName") as! String
                bank.description = objBank.value(forKey: "bankDescription") as! String
                bank.age = objBank.value(forKey: "age") as! Int
                bank.url = objBank.value(forKey: "url") as! String
                bank.image = objBank.value(forKey: "image") as? Data
                
                banksArray.append(bank)
            }
            
        }catch let error{
            fatalError("Error al obtener los datos de la BD \(error)")
        }
        return banksArray
    }
}
