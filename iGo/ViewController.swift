//
//  ViewController.swift
//  iGo
//
//  Created by Mavin Sao on 22/12/21.
//

import UIKit
import GoogleMaps
import Alamofire
import SwiftyJSON

class ViewController: UIViewController {

    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var searchTextField: UITextField!
    var allPitch : [Pitch] = []
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view
        self.collectionView.backgroundView?.backgroundColor = UIColor.clear
        self.collectionView.backgroundColor = UIColor.clear
        self.collectionView.register(UINib(nibName: "PitchCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PitchCell")
        loadPitch()
        // 1
          locationManager.delegate = self

          // 2
          if CLLocationManager.locationServicesEnabled() {
            // 3
            locationManager.requestLocation()

            // 4
            mapView.isMyLocationEnabled = true
            mapView.settings.myLocationButton = true
          } else {
            // 5
            locationManager.requestWhenInUseAuthorization()
          }
        
        locationManager.startUpdatingLocation()
        loadMarker()
        
        self.searchTextField.delegate = self

    }
    
    func loadMarker(){
        // Creates a marker in the center of the map.
        
        for pitch in allPitch {
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: pitch.lat, longitude: pitch.long)
            marker.icon = UIImage(named: "pitch")
            marker.title = pitch.name
            marker.snippet = pitch.location
            marker.map = mapView
        }
        
       
    }
    
    func getRoute(destinationLat: Double, destinationLong: Double){
        // MARK: Request for response from the google
        // MARK: Create URL

        guard let currentLocation = locationManager.location?.coordinate else {
            print("no location")
            return
        }


        // MARK: Create source location and destination location so that you can pass it to the URL
        let sourceLocation = "\(currentLocation.latitude),\(currentLocation.longitude)"
        let destinationLocation = "\(destinationLat),\(destinationLong)"

        print(sourceLocation,destinationLocation)
        
        if let urlDestination = URL.init(string: "https://www.google.co.in/maps/dir/?api=1&destination=\(destinationLat),\(destinationLong)&directionsmode=driving") {UIApplication.shared.open(urlDestination)
         }

//        let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(sourceLocation)&destination=\(destinationLocation)&mode=driving&key=AIzaSyBnQ3xSR8QsOzEazpTTbWwISqbUS9VDSSg"
//
//        AF.request(url).responseJSON { (reseponse) in
//                    guard let data = reseponse.data else {
//                        print("not reachable")
//                        return
//                    }
//
//                    do {
//                        let jsonData = try JSON(data: data)
//                        let routes = jsonData["routes"].arrayValue
//                        let messge = jsonData["error_message"].stringValue
//                        print(messge)
//                        print(routes)
//
//                        for route in routes {
//                            let overview_polyline = route["overview_polyline"].dictionary
//                            let points = overview_polyline?["points"]?.string
//                            let path = GMSPath.init(fromEncodedPath: points ?? "")
//                            let polyline = GMSPolyline.init(path: path)
//                            polyline.strokeColor = .systemBlue
//                            polyline.strokeWidth = 5
//                            polyline.map = self.mapView
//                        }
//                    }
//                     catch let error {
//                        print(error.localizedDescription)
//                    }
//                }
    }
    
    

    func loadPitch(){
        allPitch.append(Pitch(name: "Rooy7", location: "ផ្លូវលេខ ៥៩៨, រាជធានី​ភ្នំពេញ", lat: 11.583742075131106, long: 104.88738852804477, phone: "+85566858687"))
        allPitch.append(Pitch(name: "មជ្ឈមណ្ឌលកីឡា ព្រីមៀម", location: "ផ្លូវលេខ ៣៤៥, រាជធានី​ភ្នំពេញ", lat: 11.587256255615653, long: 104.89783110495318, phone: "+85515347347"))
        allPitch.append(Pitch(name: "The Blue Sports Center", location: "ផ្លូវលេខ ១៩៨៦, រាជធានី​ភ្នំពេញ", lat: 11.584157516294116, long: 104.88172438364062, phone: "+85516860860"))
    }
    
    
    func openGoogleMap(lat:Double,long: Double) {

          if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {  //if phone has an app

              if let url = URL(string: "comgooglemaps-x-callback://?saddr=&daddr=\(lat),\(lat)&directionsmode=driving") {
                        UIApplication.shared.open(url, options: [:])
               }}
          else {
                 //Open in browser
                if let urlDestination = URL.init(string: "https://www.google.co.in/maps/dir/?saddr=&daddr=\(lat),\(long)&directionsmode=driving") {
                                   UIApplication.shared.open(urlDestination)
                               }
                    }

            }
    

}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        allPitch.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        print(indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "PitchCell", for: indexPath) as! PitchCollectionViewCell
        cell.config(pitch: self.allPitch[indexPath.row])
        cell.btnGoTapped = {_ in
            print("tap \(indexPath.row)")
            self.getRoute(destinationLat: self.allPitch[indexPath.row].lat, destinationLong: self.allPitch[indexPath.row].long)
        }
        return cell
        
        
    }
}

extension ViewController: UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

         textField.resignFirstResponder()
         return true
     }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("work")
    }
}

// MARK: - CLLocationManagerDelegate
//1
extension ViewController: CLLocationManagerDelegate {
  // 2
  func locationManager(
    _ manager: CLLocationManager,
    didChangeAuthorization status: CLAuthorizationStatus
  ) {
    // 3
    guard status == .authorizedWhenInUse else {
      return
    }
    // 4
    locationManager.requestLocation()

    //5
    mapView.isMyLocationEnabled = true
    mapView.settings.myLocationButton = true
  }

  // 6
  func locationManager(
    _ manager: CLLocationManager,
    didUpdateLocations locations: [CLLocation]) {
    guard let location = locations.first else {
      return
    }
    // 7
    let camera = GMSCameraPosition(
      target: location.coordinate,
      zoom: 15,
      bearing: 0,
      viewingAngle: 0)
   mapView.animate(to: camera)
  manager.stopUpdatingLocation()
  }

  // 8
  func locationManager(
    _ manager: CLLocationManager,
    didFailWithError error: Error
  ) {
    print(error)
  }
}
