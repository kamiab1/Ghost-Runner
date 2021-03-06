//
//  RunVC.swift
//  Ghost Runner
//
//  Created by Kamyab Ayanifard on 2/18/21.
//


import Foundation
import UIKit
import CoreLocation
import MapKit




class RunVC: UIViewController {

    let db = DB()
    let locationManager = CLLocationManager()
    var navigation: Navigator?
    
    // Timers
     var runTimer: Timer?
    
    // calculation
    var runCalculation : RunCalculation?  // initialized in viewDidLoad()
    let CONST_TIME: Double = 2.25//2.0;
    var lastDrawnPolyLine: MKOverlay?
    var ghostList = [GhostRun]()
    var userLocationList = [UserSnapshot]()
    //
    var runToggleState: Int = 0
    var giList: [UIImageView?] = []
    var maxGhosts: Int = 0
       
    // Storyboard Outlets
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var runToggleOutlet: UIButton!
    @IBOutlet weak var topPanel: UIVisualEffectView!
    @IBOutlet weak var cancelButtonOutlet: UIButton!
    @IBOutlet var popupView: UIView!
    @IBOutlet weak var addGhostTable: UITableView!
    @IBOutlet weak var addGhostSymbol: UIButton!
    @IBOutlet weak var headingButton: UIImageView!
    @IBOutlet weak var gi0: UIImageView!
    @IBOutlet weak var gi1: UIImageView!
    @IBOutlet weak var gi2: UIImageView!
    @IBOutlet weak var gi3: UIImageView!
    @IBOutlet weak var gi4: UIImageView!
    @IBOutlet weak var gi5: UIImageView!
    
  

    override func viewDidLoad() {
        super.viewDidLoad()
        navigation = Navigator(currentViewController: self)
        
        setUpDelegate()
        setUpTopPanel()
        setUpLayout()
        initiateMapSetup()

        runCalculation = RunCalculation(opponentList: ghostList)
        
        addToTheListViewOfOpponents()
    }
    
    
    @objc func updateOpponentsLocation()  {
        
        if (isFirstRun()) {return} // i.e NO OPPONENT i.e FIRST RUN

        userLocationList.forEach { (UserSnapshot) in
             let nextCoord = UserSnapshot.snapShot.get2DCordinate()
                UIView.animate(withDuration: CONST_TIME) {
                    UserSnapshot.coordinate.latitude = nextCoord.latitude
                    UserSnapshot.coordinate.longitude = nextCoord.longitude
                }
            
        }
       
    }
    
    @objc func intervalUpdate() {
        let gps = GPS(locationManager: locationManager);
        let usersLocation = runCalculation?.updateOwnGetOpponentsNextLocation(runSnapshot: RunSnapshot(gps: gps))
        userLocationList = usersLocation ?? [UserSnapshot]();
        updateOwnPolyLine()
        updateOpponentsLocation()
    }


    @objc func headingTap() {
        self.mapView.setUserTrackingMode(MKUserTrackingMode.followWithHeading, animated: true)
    }
    
    func addToTheListViewOfOpponents()  { // TODO refactor this later
        
        giList.forEach {gi in
            gi?.image = nil
            gi?.layer.borderColor = UIColor.clear.cgColor
        }
        
        var i = 0
        ghostList.forEach { (ghostRun) in
            
            giList[i]?.image = ghostRun.image
            giList[i]?.layer.borderColor = UIColor.white.cgColor
            
            self.mapView.addAnnotation(ghostRun)
            i += 1
        }
        
        giList.forEach {gi in
            UIView.animate(withDuration: 1) {
                gi?.alpha = 1
            }
        }
        
    }
    

}















// MARK: - ALL IBAction
extension RunVC {
    
    @IBAction func addGhostSymbolPress(_ sender: UIButton) {
        print("IMPLEMENT LATER")
    }
    
    // ONLY FOR DEBUG
    @IBAction func animateOpponent() {
        //beginGhostAnimation();
    }
    
    @IBAction func beginEndToggle(_ sender: UIButton) {
        if runToggleState == 0 {
            runToggleOutlet.setTitle("End Run", for: .normal)
            startRun()
            runToggleState = 1
            runToggleOutlet.backgroundColor = .systemRed
        } else if runToggleState == 1 {
            runToggleOutlet.setTitle("Save Replay?", for: .normal)
            endRun()
            runToggleState = 2
            runToggleOutlet.backgroundColor = .systemPurple
            
            // NOTE: THIS IS TEMPORARY (FOR DEMO); REMOVE BELOW LINE AFTER REPLAYS ARE IMPLEMENTED
            navigation?.goBack()
        } else if runToggleState == 2 {
            // add option to save replay
            print("User wants to save replay")
        } else {
            print("[RunVC: beginEndToggle()] Something went wrong...")
        }
    }
    
    
    @IBAction func backButton(_ sender: UIButton) {
        runTimer?.invalidate()
        runTimer = nil
        navigation?.goBack()
    }
}



