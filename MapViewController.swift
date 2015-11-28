//
//  MapViewController.swift
//  Feed Me
//
/*
* Copyright (c) 2015 Razeware LLC
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
*/

import UIKit

class MapViewController: UIViewController,CLLocationManagerDelegate {
  
  @IBOutlet weak var mapView: GMSMapView!
  @IBOutlet weak var mapCenterPinImage: UIImageView!
  @IBOutlet weak var addressLabel: UILabel!

  var searchedTypes = ["grocery_or_supermarket"]
  let locationManager = CLLocationManager()
  let dataProvider = GoogleDataProvider()
  let searchRadius: Double = 1000
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    locationManager.delegate = self
    locationManager.requestWhenInUseAuthorization()
    
    mapView.delegate = self
    
    locationManager.startUpdatingLocation()
    mapView.myLocationEnabled = true
    mapView.settings.myLocationButton = true
  }
  
  
  func reverseGeocodeCoordinate(coordinate: CLLocationCoordinate2D) {
    let geocoder = GMSGeocoder()
    
    geocoder.reverseGeocodeCoordinate(coordinate) { response , error in
      self.addressLabel.unlock()
      if let address = response?.firstResult() {
        let lines = address.lines as! [String]
        self.addressLabel.text = lines.joinWithSeparator("\n")
        
//        let labelHeight = self.addressLabel.intrinsicContentSize().height
//        self.mapView.padding = UIEdgeInsets(top: self.topLayoutGuide.length, left: 0, bottom: labelHeight, right: 0)
//        
//        UIView.animateWithDuration(0.25) {
//          self.pinImageVerticalConstraint.constant = ((labelHeight - self.topLayoutGuide.length) * 0.5)
//          self.view.layoutIfNeeded()
//        }
      }
    }
  }
  
  func fetchNearbyPlaces(coordinate: CLLocationCoordinate2D) {
    mapView.clear()
    dataProvider.fetchPlacesNearCoordinate(coordinate, radius:searchRadius, types: searchedTypes) { places in
      for place: GooglePlace in places {
        let marker = PlaceMarker(place: place)
        marker.map = self.mapView
        //print("111")
      }
    }
  }
    
  @IBAction func refreshPlaces(sender: AnyObject) {
    fetchNearbyPlaces(mapView.camera.target)
  }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        print("111")
        if status == .AuthorizedWhenInUse {
            locationManager.startUpdatingLocation()
            mapView.myLocationEnabled = true
            mapView.settings.myLocationButton = true
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
            locationManager.stopUpdatingLocation()
            fetchNearbyPlaces(location.coordinate)
        }
    }

  
}


//// MARK: - CLLocationManagerDelegate
//extension MapViewController: CLLocationManagerDelegate {
//  }

// MARK: - GMSMapViewDelegate
extension MapViewController: GMSMapViewDelegate {
  func mapView(mapView: GMSMapView!, idleAtCameraPosition position: GMSCameraPosition!) {
    reverseGeocodeCoordinate(position.target)
  }
  
  func mapView(mapView: GMSMapView!, willMove gesture: Bool) {
    addressLabel.lock()
    
    if (gesture) {
      mapCenterPinImage.fadeIn(0.25)
      mapView.selectedMarker = nil
    }
  }
  
  func mapView(mapView: GMSMapView!, markerInfoContents marker: GMSMarker!) -> UIView! {
    let placeMarker = marker as! PlaceMarker
    
    if let infoView = UIView.viewFromNibName("MarkerInfoView") as? MarkerInfoView {
      infoView.nameLabel.text = placeMarker.place.name
      
      if let photo = placeMarker.place.photo {
        infoView.placePhoto.image = photo
      } else {
        infoView.placePhoto.image = UIImage(named: "generic")
      }
      
      return infoView
    } else {
      return nil
    }
  }
  
  func mapView(mapView: GMSMapView!, didTapMarker marker: GMSMarker!) -> Bool {
    mapCenterPinImage.fadeOut(0.25)
    return false
  }
  
  func didTapMyLocationButtonForMapView(mapView: GMSMapView!) -> Bool {
    mapCenterPinImage.fadeIn(0.25)
    mapView.selectedMarker = nil
    return false
  }
}