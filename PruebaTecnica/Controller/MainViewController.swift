//
//  MainViewController.swift
//  PruebaTecnica
//
//  Created by AdrianArias on 31/05/23.
//

import UIKit
import WebKit
import Network

class MainViewController: UIViewController {
    
    @IBOutlet weak var banksTableView: UITableView!
    
    var banks = [BankModel]()
    let bankViewModel = BankViewModel()
    var exists = false
    var bankName: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Bancos"
        loadData()
        
        validate()
        
        banksTableView.delegate = self
        banksTableView.dataSource = self
        
        banksTableView.register(UINib(nibName: "BankTableViewCell", bundle: nil), forCellReuseIdentifier: "BankCell")
        banksTableView.separatorStyle = .singleLine
        banksTableView.separatorInset = UIEdgeInsets(top: 0, left: 300, bottom: 0, right: 11);
        DataOrigin()
    }
    
    
    override func viewDidLayoutSubviews() {
        banksTableView.frame = banksTableView.frame.inset(by: UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8))
    }
    
    
    func validate(){
        
        if banks.count > 0 {
            //print("Obteniendo datos desde la API...")
            exists = true
            loadData()
        }else{
            //print("Obteniendo datos desde la API...")
            exists = false
            loadDataAPI()
        }
    }
    
    func loadDataAPI(){
        bankViewModel.GetAllAPI { bank, error in
            if let bank = bank{
                self.banks = bank
                self.save(banks: self.banks)
                DispatchQueue.main.async {
                    self.banksTableView.reloadData()
                    
                }
            } else if let error = error{
                fatalError("error al obtener los datos \(error)")
            }
        }
    }
    
    func loadData(){
        banks = bankViewModel.GetAllCoreData()
    }
    
    func save(banks: [BankModel]){
        for i in 0..<banks.count{
            bankViewModel.AddCoreData(bank: banks[i])
        }
    }
    
    func obtenerImagenDesdeURL(url: URL, completado: @escaping (UIImage?) -> Void) {
        URLSession.shared.dataTask(with: url) { (data, respuesta, error) in
            guard let data = data, error == nil else {
                completado(nil)
                return
            }
            
            let imagen = UIImage(data: data)
            completado(imagen)
        }.resume()
    }
    
     func DataOrigin() {
        if exists{
            let alert = UIAlertController(title: "", message: "Datos obtenidos de la BD", preferredStyle: .alert)
            let ok = UIAlertAction(title: "Ok", style: .default)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        }else{
            let alert = UIAlertController(title: "", message: "Obteniendo datos de la API", preferredStyle: .alert)
            let ok = UIAlertAction(title: "Ok", style: .default)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        }
    }
}



extension MainViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return banks.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "BankCell", for: indexPath) as! BankTableViewCell
        cell.layer.cornerRadius = 20
        cell.layer.borderWidth = 0.75
        cell.layer.borderColor = UIColor.gray.cgColor
        cell.nameLabel.text = banks[indexPath.row].bankName
        cell.descriptionLabel.text = banks[indexPath.row].description
        cell.ageLabel.text = "Edad:  \(String(describing: banks[indexPath.row].age))  años"
        let urlString = banks[indexPath.row].url
        
        if banks[indexPath.row].image != nil{
            cell.bankImage.image = UIImage(data: banks[indexPath.row].image!)
        }else{
            if let url = URL(string: urlString){
                obtenerImagenDesdeURL(url: url) { imagen in
                    if let imagen = imagen {
                        DispatchQueue.main.async {
                            cell.bankImage.image = imagen
                        }
                    }else{
                        print("No se pudo obtener la imagen")
                    }
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.bankName = self.banks[indexPath.row].bankName
        self.performSegue(withIdentifier: "PageSegue", sender: self)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "PageSegue"{
            let webPageViewController = segue.destination as! WebPageViewController
            webPageViewController.bankName = self.bankName
        }
    }
}
