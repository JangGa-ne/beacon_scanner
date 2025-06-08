import UIKit
import CoreLocation

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var locationManager: CLLocationManager!
    var beaconRegion: CLBeaconRegion!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setupLocationManager()
        startMonitoringBeacon()
        return true
    }

    func setupLocationManager() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = true  // 배터리 절약용 자동일시정지
    }

    func startMonitoringBeacon() {
        // UUID, Major, Minor는 실제 사용하는 비콘 정보로 교체하세요
        let uuid = UUID(uuidString: "YOUR-BEACON-UUID-HERE")!
        beaconRegion = CLBeaconRegion(proximityUUID: uuid, identifier: "MyBeaconRegion")
        beaconRegion.notifyEntryStateOnDisplay = true
        beaconRegion.notifyOnEntry = true
        beaconRegion.notifyOnExit = true

        locationManager.startMonitoring(for: beaconRegion)
        // Ranging은 백그라운드에서 배터리 소모가 많으므로 필요 시만 활성화
        // locationManager.startRangingBeacons(in: beaconRegion)
    }
}

// CLLocationManagerDelegate 분리
extension AppDelegate: CLLocationManagerDelegate {

    // 비콘 영역 진입 감지
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        if region.identifier == beaconRegion.identifier {
            print("비콘 영역에 들어옴 - 앱 깨우기 및 작업 시작 가능")
            // 백그라운드 작업 처리, 예: 서버에 출석체크 요청 등
        }
    }

    // 비콘 영역 이탈 감지
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        if region.identifier == beaconRegion.identifier {
            print("비콘 영역에서 나감")
        }
    }

    func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
        switch state {
        case .inside:
            print("현재 비콘 영역 내부")
        case .outside:
            print("현재 비콘 영역 외부")
        case .unknown:
            print("비콘 영역 상태 알 수 없음")
        @unknown default:
            break
        }
    }

    // 권한 변경 처리
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways:
            print("항상 위치 권한 허용됨")
        case .authorizedWhenInUse:
            print("앱 사용 중 위치 권한 허용됨")
        case .denied, .restricted:
            print("위치 권한 거부됨")
        case .notDetermined:
            print("위치 권한 요청 필요")
        @unknown default:
            break
        }
    }

    // 에러 처리
    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        print("비콘 모니터링 실패: \(error.localizedDescription)")
    }
}
