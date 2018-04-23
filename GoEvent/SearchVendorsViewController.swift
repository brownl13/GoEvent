//
//  SearchVendorsViewController.swift
//  GoEvent
//
//  Created by Ziyin Zhang on 4/22/18.
//  Copyright © 2018 Logan. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

protocol Resource {
}

struct PhotographerArray: Codable {
    let photographers: [Photographer]
}

struct Photographer: Codable, Resource {
    var name: String
    var location: Location
    var website: String
    var about: String
    var services: [Service]
}

struct DJArray: Codable {
    let djs: [DJ]
}

struct DJ: Codable, Resource {
    var name: String
    var location: Location
    var website: String
    var about: String
    var services: [Service]
}

struct FloristArray: Codable {
    let florists: [Florist]
}

struct Florist: Codable, Resource {
    var name: String
    var location: Location
    var website: String
    var about: String
    var services: [Service]
}

struct ReceptionArray: Codable {
    let receptions: [Reception]
}

struct Reception: Codable, Resource {
    var name: String
    var location: Location
    var website: String
    var about: String
    var services: [Service]
}

struct BeautyArray: Codable {
    let beauty: [Beauty]
}

struct Beauty: Codable, Resource {
    var name: String
    var location: Location
    var website: String
    var about: String
    var services: [Service]
}

struct Location: Codable {
    let address: String
    let city: String
    let state: String
    let zipcode: String
}

struct Price: Codable {
    var option: String
    var price: Double
}

struct Service: Codable {
    var category: String
    var prices: [Price]
    var details: String
}

class SearchVendorsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, CLLocationManagerDelegate {
    
    @IBOutlet weak var categoryField: UITextField!
    @IBOutlet weak var distanceInMile: UITextField!
    @IBOutlet weak var vendorMapView: MKMapView!
    
    @IBOutlet weak var searchButton: UIButton!
    let categories = ["Photographer", "DJ", "Reception", "Beauty", "Florist"]
    var pickerView = UIPickerView()
    
    
    var arrayFoundNames: [String] = ["One", "Two"]
    var arrayFoundWebsites: [String] = ["One", "Two"]
    var arrayFoundAbouts: [String] = ["About", "About"]
    var arrayFoundMiles: [Double] = [1.0, 2.0]
    var arrayFoundLocations: [String] = ["N/A", "N/A"]
    var arrayFoundPrices: [Double] = [0.0, 0.0]
    
    var mapAnnotations = [BaseAnnotation]()
    
    @IBOutlet weak var myCollectionView: UICollectionView!
    @IBOutlet weak var labelListOfVenders: UILabel!
    let locationManager = CLLocationManager()
    var myCoordinate = CLLocation(latitude: 0.0, longitude: 0.0)
    var foundCoordinate = CLLocation(latitude: 0.0, longitude: 0.0)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Hide Navigation Bar on First View Controller
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        
        //For Custom CollectionView
        myCollectionView.delegate = self
        myCollectionView.dataSource = self
        myCollectionView.isHidden = true    //At Start, hide it.
        labelListOfVenders.isHidden = true
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        categoryField.inputView = pickerView
        //categoryField.textAlignment = .center
        //categoryField.placeholder = "Select vendor category"
        categoryField.text = "Photographer"     //Defaults
        
        //distanceInMile.placeholder = "In Mile"
        //areaCode.placeholder = "Zip Code"
        //searchButton.isEnabled = false
        distanceInMile.text = "50"
        searchButton.layer.cornerRadius = 5
    }
    
    
    //Show Navigation Bar when user click to go to another View Controller
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    //Send Info Over to the next View Controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destination = segue.destination as? ShowDetailsViewController {
            let cell = sender as! UICollectionViewCell
            if let indexPath = myCollectionView?.indexPath(for: cell)?.row {
                //destination.videoId = myVideoData[indexPath - 1].videoId
                destination.vendorName = arrayFoundNames[indexPath]
                destination.website = arrayFoundWebsites[indexPath]
                destination.about = arrayFoundAbouts[indexPath]
                destination.address = arrayFoundLocations[indexPath]
                destination.cost = arrayFoundPrices[indexPath]
                destination.category = self.categoryField.text
            }
        }
    }
    
    //If User Allow Location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("User's Location = \(locValue.latitude) \(locValue.longitude)")
        myCoordinate = CLLocation(latitude: locValue.latitude, longitude: locValue.longitude)
    }
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //searchButton.isEnabled = true
        categoryField.text = categories[row]
        categoryField.resignFirstResponder()
    }
    
    @IBAction func searchButtonTapped(_ sender: UIButton) {
        
        //Clear array before loading new data
        arrayFoundNames.removeAll()
        arrayFoundWebsites.removeAll()
        arrayFoundAbouts.removeAll()
        arrayFoundMiles.removeAll()
        arrayFoundLocations.removeAll()
        arrayFoundPrices.removeAll()
        labelListOfVenders.isHidden = false
        
        
        var filePath = ""
        var address = ""
        var vendorName = ""
        
        if (categoryField.text == "Photographer") {
            filePath = "json_files/photographer"
        } else if (categoryField.text == "DJ") {
            filePath = "json_files/dj"
        } else if (categoryField.text == "Reception") {
            filePath = "json_files/reception"
        } else if (categoryField.text == "Beauty") {
            filePath = "json_files/beauty"
        } else {
            filePath = "json_files/florist"
        }
        
        let path = Bundle.main.path(forResource: filePath, ofType: "json")
        let url = URL(fileURLWithPath: path!)
        
        do{
            self.mapAnnotations.removeAll()
            let dispatchGroup = DispatchGroup()
            let data = try Data(contentsOf: url)
            
            if (categoryField.text == "Photographer") {
                removeAllAnnotationsOnMap()
                let listOfPhotographers = try JSONDecoder().decode(PhotographerArray.self, from: data)
                for i in listOfPhotographers.photographers {
                    arrayFoundNames.append(i.name) //Store Name of Vendor
                    arrayFoundWebsites.append(i.website)
                    arrayFoundAbouts.append(i.about)
                    arrayFoundMiles.append(1)   //Default
                    vendorName = i.name
                    address = i.location.address + ", " + i.location.city + ", " + i.location.state + " " + i.location.zipcode
                    arrayFoundLocations.append(address)
                    arrayFoundPrices.append(i.services[0].prices[0].price)
                    dispatchGroup.enter()
                    getAddressCoordinates(addrs: address, name: vendorName, resource: i) { [weak self] (annotation) in
                        self?.mapAnnotations.append(annotation)
                        dispatchGroup.leave()
                    }
                }
            } else if (categoryField.text == "DJ") {
                removeAllAnnotationsOnMap()
                let listOfDJS = try JSONDecoder().decode(DJArray.self, from: data)
                for i in listOfDJS.djs {
                    arrayFoundNames.append(i.name) //Store Name of Vendor
                    arrayFoundWebsites.append(i.website)
                    arrayFoundAbouts.append(i.about)
                    arrayFoundMiles.append(1)   //Default
                    vendorName = i.name
                    address = i.location.address + ", " + i.location.city + ", " + i.location.state + " " + i.location.zipcode
                    arrayFoundLocations.append(address)
                    arrayFoundPrices.append(i.services[0].prices[0].price)
                    dispatchGroup.enter()
                    getAddressCoordinates(addrs: address, name: vendorName, resource: i) { [weak self] (annotation) in
                        self?.mapAnnotations.append(annotation)
                        dispatchGroup.leave()
                    }
                }
            } else if (categoryField.text == "Reception") {
                removeAllAnnotationsOnMap()
                let listOfReception = try JSONDecoder().decode(ReceptionArray.self, from: data)
                for i in listOfReception.receptions {
                    arrayFoundNames.append(i.name) //Store Name of Vendor
                    arrayFoundWebsites.append(i.website)
                    arrayFoundAbouts.append(i.about)
                    arrayFoundMiles.append(1)   //Default
                    vendorName = i.name
                    address = i.location.address + ", " + i.location.city + ", " + i.location.state + " " + i.location.zipcode
                    arrayFoundLocations.append(address)
                    arrayFoundPrices.append(i.services[0].prices[0].price)
                    dispatchGroup.enter()
                    getAddressCoordinates(addrs: address, name: vendorName, resource: i) { [weak self] (annotation) in
                        self?.mapAnnotations.append(annotation)
                        dispatchGroup.leave()
                    }
                }
            } else if (categoryField.text == "Beauty") {
                removeAllAnnotationsOnMap()
                let listOfBeauty = try JSONDecoder().decode(BeautyArray.self, from: data)
                for i in listOfBeauty.beauty {
                    arrayFoundNames.append(i.name) //Store Name of Vendor
                    arrayFoundWebsites.append(i.website)
                    arrayFoundAbouts.append(i.about)
                    arrayFoundMiles.append(1)   //Default
                    vendorName = i.name
                    address = i.location.address + ", " + i.location.city + ", " + i.location.state + " " + i.location.zipcode
                    arrayFoundLocations.append(address)
                    arrayFoundPrices.append(i.services[0].prices[0].price)
                    dispatchGroup.enter()
                    getAddressCoordinates(addrs: address, name: vendorName, resource: i) { [weak self] (annotation) in
                        self?.mapAnnotations.append(annotation)
                        dispatchGroup.leave()
                    }
                }
            } else {
                removeAllAnnotationsOnMap()
                let listOfFlorists = try JSONDecoder().decode(FloristArray.self, from: data)
                for i in listOfFlorists.florists {
                    arrayFoundNames.append(i.name) //Store Name of Vendor
                    arrayFoundWebsites.append(i.website)
                    arrayFoundAbouts.append(i.about)
                    arrayFoundMiles.append(1)   //Default
                    vendorName = i.name
                    address = i.location.address + ", " + i.location.city + ", " + i.location.state + " " + i.location.zipcode
                    arrayFoundLocations.append(address)
                    arrayFoundPrices.append(i.services[0].prices[0].price)
                    dispatchGroup.enter()
                    getAddressCoordinates(addrs: address, name: vendorName, resource: i) { [weak self] (annotation) in
                        self?.mapAnnotations.append(annotation)
                        dispatchGroup.leave()
                    }
                }
            }
            
            
            //Show Results Base on Filter
            dispatchGroup.notify(queue: DispatchQueue.main) {
                
                var x: Int = 0
                while (x < self.mapAnnotations.count) {
                    
                    let foundLocation: CLLocation = CLLocation(latitude: self.mapAnnotations[x].coordinate.latitude, longitude: self.mapAnnotations[x].coordinate.longitude)
                    let getDistance = self.calculateDistance(currentLocation: self.myCoordinate, foundLocation: foundLocation)
                    
                    //Found Vender is out of Range => Remove from mapAnnoation
                    let specifiedDistance: Double = Double(self.distanceInMile.text!)!
                    if getDistance > specifiedDistance {
                        self.mapAnnotations.remove(at: x)
                        self.arrayFoundNames.remove(at: x)
                        self.arrayFoundWebsites.remove(at: x)
                        self.arrayFoundAbouts.remove(at: x)
                        self.arrayFoundMiles.remove(at: x)
                        self.arrayFoundLocations.remove(at: x)
                        self.arrayFoundPrices.remove(at: x)
                    } else {
                        self.arrayFoundMiles[x] = getDistance
                    }
                    x += 1
                }
                
                //Reset Found Places
                if (self.categoryField.text == "Photographer") {
                    self.labelListOfVenders.text = "List of Photographers: " + String(self.mapAnnotations.count) + " Found"
                    
                  
                    
                } else if (self.categoryField.text == "DJ") {
                    self.labelListOfVenders.text = "List of DJs: " + String(self.mapAnnotations.count) + " Found"
                } else if (self.categoryField.text == "Reception") {
                    self.labelListOfVenders.text = "List of Receptions: " + String(self.mapAnnotations.count) + " Found"
                } else if (self.categoryField.text == "Beauty") {
                    self.labelListOfVenders.text = "List of Beauty: " + String(self.mapAnnotations.count) + " Found"
                } else {
                    self.labelListOfVenders.text = "List of Florists: " + String(self.mapAnnotations.count) + " Found"
                }
                
                
                //Reload Table View
                self.myCollectionView.isHidden = false
                if(self.arrayFoundNames.count == 0) {
                    self.arrayFoundNames.append("No Result Found")
                }
                self.reloadCollectionView()
                
                
                
                //Show Annotations
                self.vendorMapView.addAnnotations(self.mapAnnotations)
                self.vendorMapView.showAnnotations(self.vendorMapView.annotations, animated: true)
                
                
            }
            
        }catch let jsonErr {
            print("Error decoding JSON file", jsonErr)
        }
        
        
        
        
    }
    
    func calculateDistance(currentLocation: CLLocation, foundLocation: CLLocation) -> Double {
        
        //User Location
        let myLocation = CLLocation(latitude: myCoordinate.coordinate.latitude, longitude: myCoordinate.coordinate.longitude)
        
        //Found Location
        let foundLocation = CLLocation(latitude: foundLocation.coordinate.latitude, longitude: foundLocation.coordinate.longitude)
        
        //Calculate Distance from Meter to Miles
        let distance = (myLocation.distance(from: foundLocation) / 1609.344) / 1000
        
        return distance
    }
    
    
    //Reload data
    func reloadCollectionView() {
        DispatchQueue.main.async{
            self.myCollectionView?.reloadData()
        }
    }
    
    func removeAllAnnotationsOnMap() {
        //Remove annotations on the map
        let annotations = self.vendorMapView.annotations
        self.vendorMapView.removeAnnotations(annotations)
    }
    
    @objc
    func annotationButtonTouched(sender: UIButton) {
        
    }
    
    func getAddressCoordinates(addrs: String, name: String, resource: Resource, completion: ((BaseAnnotation) -> Void)?) {
        let geocoder = CLGeocoder()
        var coordinates: CLLocationCoordinate2D?
        geocoder.geocodeAddressString(addrs, completionHandler: {(placemarks, error) -> Void in
            if((error) != nil){
                print("Error", error ?? "")
            }
            if let placemark = placemarks?.first {
                coordinates = placemark.location!.coordinate
                
                //Get area coordinates
                let latitude = coordinates?.latitude
                let longitude = coordinates?.longitude
                
                
                //Create annotation
                let annotation = BaseAnnotation(with: name, subtitle: addrs, coordinate: CLLocationCoordinate2DMake(latitude!, longitude!), resource: resource)
                
                if let callback = completion {
                    callback(annotation)
                }
            }
        })
    }
    
    //For Custom Collection View
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayFoundNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        //Name
        let name = arrayFoundNames[indexPath.row]
        let labelName = cell.viewWithTag(1) as! UILabel
        labelName.translatesAutoresizingMaskIntoConstraints = false
        labelName.text = name
        
        //Distance
        let distance = String(format: "%.2f", arrayFoundMiles[indexPath.row])
        let labelDistance = cell.viewWithTag(2) as! UILabel
        labelDistance.translatesAutoresizingMaskIntoConstraints = false
        labelDistance.text = "Distance: " + distance + " Miles"
        
        
        return cell
        
    }
    
    //UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        //Image Height = 112 +  Margin Bottom: 10 + Line Separator: 10
        return CGSize(width: view.frame.width, height: 50)
    }
    
    //Spaces between Cells
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
    
}//End of class

extension SearchVendorsViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var annotationView: MKAnnotationView?
        if !annotation.isKind(of: MKUserLocation.self) {
            if annotation.isKind(of: BaseAnnotation.self) {
                annotationView = BaseAnnotation.annotationView(for: mapView, with: annotation)
                let rightButton = UIButton(type: .detailDisclosure)
                rightButton.addTarget(self, action: #selector(SearchVendorsViewController.annotationButtonTouched(sender:)), for: .touchUpInside)
                rightButton.imageView?.contentMode = .scaleAspectFit
                annotationView?.rightCalloutAccessoryView = rightButton
            }
        }
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if let baseView = view.annotation as? BaseAnnotation, baseView.isKind(of: BaseAnnotation.self) {
            
            if let detailViewController = self.storyboard?.instantiateViewController(withIdentifier: "VendorDetails") as? ShowDetailsViewController {
                detailViewController.vendorName = baseView.title
                detailViewController.website = baseView.subtitle
                navigationController?.pushViewController(detailViewController, animated: true)
                
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
/*
extension SearchVendorsViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        var annotationView: MKAnnotationView?
        
        if !annotation.isKind(of: MKUserLocation.self) {
            if annotation.isKind(of: BaseAnnotation.self) {
                annotationView = BaseAnnotation.annotationView(for: mapView, with: annotation)
                let rightButton = UIButton(type: .detailDisclosure)
                rightButton.addTarget(self, action: #selector(SearchVendorsViewController.annotationButtonTouched(sender:)), for: .touchUpInside)
                rightButton.imageView?.contentMode = .scaleAspectFit
                annotationView?.rightCalloutAccessoryView = rightButton
            }
        }
        return annotationView
    }
    
    
    //When User Click on Annotation
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if let baseView = view.annotation as? BaseAnnotation, baseView.isKind(of: BaseAnnotation.self) {
            
            if let detailViewController = self.storyboard?.instantiateViewController(withIdentifier: "VendorDetails") as? ShowDetailsViewController {
                detailViewController.vendorName = baseView.title
                detailViewController.website = baseView.subtitle
                navigationController?.pushViewController(detailViewController, animated: true)
                
            }
            
            /*
             let msg = "\(baseView.dj!.location.address) \(baseView.dj!.location.city), \(baseView.dj!.location.state)" + " \n \(baseView.dj!.location.phone)"
             let alert = UIAlertController(title: baseView.title, message: msg, preferredStyle: .alert)
             
             let close = UIAlertAction(title: "OK", style: .default, handler: nil)
             
             alert.addAction(close)
             
             present(alert, animated: true, completion: nil)
             */
        }
    }
    
}*/

