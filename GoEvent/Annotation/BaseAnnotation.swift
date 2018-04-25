//
//  BaseAnnotation.swift
//  GoEvent
//
//  Created by Ziyin Zhang on 4/22/18.
//  Copyright © 2018 Logan. All rights reserved.
//

import UIKit
import MapKit

class BaseAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    
    var title: String?
    var subtitle: String?
    
    var dj: DJ?
    var florist: Florist?
    var photographer: Photographer?
    var reception: Reception?
    var beauty: Beauty?
    
    init(with title: String, subtitle: String?, coordinate: CLLocationCoordinate2D, resource: Resource) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
        
        if resource is DJ {
            self.dj = resource as? DJ
        } else if resource is Florist {
            self.florist = resource as? Florist
        } else if resource is Photographer {
            self.photographer = resource as? Photographer
        } else if resource is Reception {
            self.reception = resource as? Reception
        } else if resource is Beauty {
            self.beauty = resource as? Beauty
        }
    }
    init(with annotation: MKAnnotation) {
        if let t = annotation.title {
            self.title = t
        }
        if let s = annotation.subtitle {
            self.subtitle = s
        }
        self.coordinate = annotation.coordinate
    }
    
    class func annotationView(for mapView: MKMapView, with annotation: MKAnnotation) -> MKAnnotationView {
        if let reusedAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: NSStringFromClass(BaseAnnotation.self)) {
            return reusedAnnotationView
        } else {
            let newAnnotation = MKPinAnnotationView(annotation: annotation, reuseIdentifier: NSStringFromClass(BaseAnnotation.self))
            newAnnotation.pinTintColor = MKPinAnnotationView.purplePinColor()
            newAnnotation.animatesDrop = true
            newAnnotation.canShowCallout = true
            return newAnnotation
        }
    }
}
