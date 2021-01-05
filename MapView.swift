//
//  MapView.swift
//  BucketList
//
//  Created by Jacob on 11/15/20.
//  Copyright © 2020 Jacob. All rights reserved.
//

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    @Binding var centerCoordinate: CLLocationCoordinate2D
    @Binding var selectedPlace: MKPointAnnotation?
    @Binding var showingPlaceDetails: Bool
    
    var annotations: [MKPointAnnotation]
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        return mapView
    }

    func updateUIView(_ view: MKMapView, context: Context) {
        if annotations.count != view.annotations.count {
            view.removeAnnotations(view.annotations)
            view.addAnnotations(annotations)
        }
        
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView

        init(_ parent: MapView) {
            self.parent = parent
        }
        
        func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
            parent.centerCoordinate = mapView.centerCoordinate
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            //unique identifier for view reuse
            let identifier = "Placemark"
            
            //attempt to find a cell we can recycle
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            
            if annotationView == nil {
                //make a new view, none to recycle
                annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                
                //allow this view to display pop-up info
                annotationView?.canShowCallout = true
                
                //attach an information UIButton to the view
                annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            } else {
                //there is already a view we can recycle, give new annotation to it
                annotationView?.annotation = annotation
            }
            
            return annotationView
        }
        
        func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
            guard let placemark = view.annotation as? MKPointAnnotation else { return }
            
            parent.selectedPlace = placemark
            parent.showingPlaceDetails = true
            
        }
        
    }
}
