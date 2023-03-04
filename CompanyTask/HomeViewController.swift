//
//  HomeViewController.swift
//  CompanyTask
//
//  Created by Mac on 13/12/1944 Saka.
//

import UIKit
import GoogleMaps
class HomeViewController: UIViewController{
    @IBOutlet weak var mapView: UIView!
    @IBOutlet weak var usersCollectionView: UICollectionView!
    @IBOutlet weak var populationTableView: UITableView!
   var jsonDecoder : JSONDecoder?
    var users = [Users]()
    var population = [Datum]()
    @IBOutlet weak var myView: UIView!
       let locationManager = CLLocationManager()
        override func viewDidLoad() {
        super.viewDidLoad()

        usersCollectionView.dataSource = self
        usersCollectionView.delegate = self
        populationTableView.dataSource = self
        populationTableView.delegate = self
         jesonSerallization()
         registernib()
        jsonPassingDecoder()
        self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }
    func registernib(){
    let uiNibName = UINib(nibName: "UsersCollectionViewCell", bundle: nil)
        self.usersCollectionView.register(uiNibName, forCellWithReuseIdentifier: "UsersCollectionViewCell")
        let uinibName = UINib(nibName: "PopulationTableViewCell", bundle: nil)
        self.populationTableView.register(uinibName, forCellReuseIdentifier: "PopulationTableViewCell")
    }
    
  func jesonSerallization(){
  let urlString = "https://gorest.co.in/public/v2/users"
  let url = URL(string: urlString)
        var request = URLRequest(url: url!)
  request.httpMethod = "GET"
  let session = URLSession(configuration: .default)
        let dataTask = session.dataTask(with: request) { data, response, error in
        print(data)
        print(response)
            if(error == nil){
                do{
    let getJSONObject = try JSONSerialization.jsonObject(with:(data!)) as! [[String:Any]]
    for eachObject in getJSONObject {
       let id = eachObject["id"] as! Int
       let name = eachObject["name"] as! String
       let gender = eachObject["gender"] as! String
        
       let newObject = Users(id: id, name: name, gender: gender)
        self.users.append(newObject)
                    }
                }catch{
                 print(error)
                }
            }
    DispatchQueue.main.async {
        self.usersCollectionView.reloadData()
            }
        }
      dataTask.resume()
    }
func jsonPassingDecoder(){
    
    let urlString = "https://datausa.io/api/data?drilldowns=Nation&measures=Population"
    let url = URL(string: urlString)
    let request = URLRequest(url: url!)
        URLSession.shared.dataTask(with: request) { data, response, error in
            print(data)
            print(response)
    if(error == nil){
                do{
    self.jsonDecoder = JSONDecoder()
    let jsonResponse = try self.jsonDecoder?.decode(Populations.self, from: data!)
                    self.population = jsonResponse!.data

            }catch{
              print(error)
            }
            }
            DispatchQueue.main.async {
        self.populationTableView.reloadData()
            }
        }
        .resume()
    }
func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.showCurrentLocationOnMap()
        self.locationManager.stopUpdatingLocation()
    }
func showCurrentLocationOnMap(){
    let camera = GMSCameraPosition.camera(withLatitude: (locationManager.location?.coordinate.latitude)!, longitude: (locationManager.location?.coordinate.longitude)!, zoom: 14)
        let mapView =  GMSMapView.map(withFrame: CGRect(x: 0,y: 0,width: self.myView.frame.size.width,height: self.myView.frame.size.height), camera: camera)
        mapView.settings.myLocationButton = true
        mapView.isMyLocationEnabled = true
        let marker = GMSMarker()
       
        let markerImage = UIImage(named: "bike3")!
        //creating a marker view
        let markerView = UIImageView(image: markerImage)
        marker.iconView = markerView
        marker.map = mapView
    //comment this line if you don't wish to put a callout bubble
     mapView.selectedMarker = marker
               marker.position = camera.target
               marker.snippet = "Users Current Location"
               self.myView.addSubview(mapView)
                        
}
    }

  extension HomeViewController :UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return users.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let usersCollectionViewCell = self.usersCollectionView.dequeueReusableCell(withReuseIdentifier: "UsersCollectionViewCell", for: indexPath) as! UsersCollectionViewCell
        let userObject = users[indexPath.row]
        usersCollectionViewCell.idLLabel.text = String(userObject.id)
        usersCollectionViewCell.nameLabel.text = userObject.name
        usersCollectionViewCell.genderLabel.text = userObject.gender
        usersCollectionViewCell.layer.borderWidth = 2
        usersCollectionViewCell.layer.borderColor = .init(red: 0, green: 0, blue: 0, alpha: 1)
        return usersCollectionViewCell
        
    }
}
extension HomeViewController : UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height:110)
        
    }
   
}

extension HomeViewController : UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return population.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let populationTableViewCell = self.populationTableView.dequeueReusableCell(withIdentifier: "PopulationTableViewCell", for: indexPath) as! PopulationTableViewCell
        let newObject = population[indexPath.row]
    populationTableViewCell.populationLabel.text = String(newObject.population)
    populationTableViewCell.yearLabel.text = String(newObject.year)
    return populationTableViewCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 105.0
    }

}
          
