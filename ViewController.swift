import UIKit
import CoreLocation
import Alamofire

class ViewController: UIViewController {

    var locationManager: CLLocationManager!
    var beaconRegion: CLBeaconRegion!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLocationManager()
        startMonitoringBeacon()
    }

    func setupLocationManager() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = true
    }

    func startMonitoringBeacon() {
        let uuid = UUID(uuidString: "YOUR-BEACON-UUID-HERE")!
        beaconRegion = CLBeaconRegion(proximityUUID: uuid, identifier: "MyBeaconRegion")
        beaconRegion.notifyEntryStateOnDisplay = true
        beaconRegion.notifyOnEntry = true
        beaconRegion.notifyOnExit = true

        locationManager.startMonitoring(for: beaconRegion)
    }

    func checkAttendance(status: String) {
        let parameters: Parameters = [
            "check_status": status,
            "timestamp": ISO8601DateFormatter().string(from: Date())
            // 추가 파라미터들...
        ]

        Alamofire.request("https://yourserver.com/check_in", method: .post, parameters: parameters)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    print("출석 체크 성공:", value)
                case .failure(let error):
                    print("출석 체크 실패:", error)
                }
            }
    }
}

extension ViewController: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        if region.identifier == beaconRegion.identifier {
            print("비콘 영역 진입 - 출석 체크")
            checkAttendance(status: "Normal")
        }
    }

    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        if region.identifier == beaconRegion.identifier {
            print("비콘 영역 이탈")
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("위치 에러:", error.localizedDescription)
    }
}
