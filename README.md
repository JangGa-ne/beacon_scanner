<h1>iOS 비콘 모니터링 및 배터리 효율 최적화 코드</h1>

<h2>1. Info.plist 설정</h2>
<p>앱이 위치 서비스를 <code>항상(always)</code> 사용할 수 있도록 권한 요청과 백그라운드 위치 업데이트 모드를 활성화합니다.</p>
<ul>
  <li><code>NSLocationAlwaysAndWhenInUseUsageDescription</code>와 <code>NSLocationWhenInUseUsageDescription</code>를 설정하여 위치 권한 요청 시 사용자에게 이유를 알립니다.</li>
  <li><code>UIBackgroundModes</code>의 <code>location</code> 항목을 추가해 앱이 백그라운드에서도 위치 서비스를 사용할 수 있도록 허용합니다.</li>
</ul>

<h2>2. AppDelegate에서 위치 관리자 설정 및 비콘 모니터링 시작</h2>
<p>앱 실행 시 <code>CLLocationManager</code>를 초기화하고, 비콘 모니터링을 시작합니다.</p>
<ul>
  <li><code>requestAlwaysAuthorization()</code>를 호출해 항상 위치 권한을 요청합니다.</li>
  <li><code>allowsBackgroundLocationUpdates = true</code>로 백그라운드 위치 업데이트를 허용합니다.</li>
  <li><code>pausesLocationUpdatesAutomatically = true</code>로 iOS가 자동으로 위치 업데이트를 일시정지 하게 하여 배터리 효율을 높입니다.</li>
  <li><code>CLBeaconRegion</code>을 정의하고 <code>startMonitoring(for:)</code>로 비콘 영역 모니터링을 시작합니다.</li>
</ul>

<h2>3. CLLocationManagerDelegate 메서드</h2>
<ul>
  <li><code>didEnterRegion</code>와 <code>didExitRegion</code>에서 비콘 영역 진입 및 이탈 이벤트를 처리합니다.</li>
  <li>비콘 영역 진입 시 앱이 백그라운드 혹은 suspended 상태에서도 iOS가 앱을 깨워 지정된 작업(예: 출석 체크 API 호출)을 수행할 수 있게 합니다.</li>
  <li><code>didDetermineState</code>는 현재 비콘 영역 상태(내부/외부/알 수 없음)를 판단할 수 있게 해줍니다.</li>
  <li><code>locationManagerDidChangeAuthorization</code>에서 위치 권한 변경을 감지하여 적절히 대응합니다.</li>
  <li><code>monitoringDidFailFor</code>에서 모니터링 에러를 확인하고 로그를 남깁니다.</li>
</ul>

<h2>4. ViewController에서 실제 비콘 랭잉 및 출석 체크 처리</h2>
<ul>
  <li>앱이 포그라운드에 있을 때 비콘 랭잉(거리 측정)을 수행하고, 실제 출석 체크 로직을 처리합니다.</li>
  <li>비콘 영역 진입 시 <code>checkAttendance(status:)</code> 함수에서 서버 API로 출석 상태를 전송합니다.</li>
  <li>Alamofire를 활용해 네트워크 통신을 간결하게 처리하며, 성공 및 실패를 로그로 출력합니다.</li>
</ul>

<h2>5. 배터리 최적화를 위한 주요 포인트</h2>
<ul>
  <li><code>pausesLocationUpdatesAutomatically = true</code> 설정으로 iOS가 불필요할 때 자동으로 위치 업데이트를 멈춰 배터리를 절약합니다.</li>
  <li>비콘 <strong>모니터링</strong>은 백그라운드에서 적은 배터리를 소모하며 작동하므로 영역 진입/이탈 감지에 적합합니다.</li>
  <li>비콘 <strong>랭잉</strong>(거리 측정)은 배터리를 많이 소모하므로 꼭 필요한 경우에만 사용하고, 가능한 백그라운드에서는 피합니다.</li>
  <li>앱이 suspended 상태에 있어도 비콘 모니터링 덕분에 iOS가 이벤트 발생 시 앱을 깨워 작업 수행이 가능합니다.</li>
  <li>단, 사용자가 앱을 강제 종료(force quit)하면 백그라운드 위치 업데이트 및 비콘 모니터링이 작동하지 않습니다.</li>
</ul>

<h2>결론</h2>
<p>이 코드는 iOS의 비콘 모니터링 기능을 활용해 배터리 효율적으로 위치 기반 출석 체크를 구현하는 예제입니다. <br />
백그라운드 및 suspended 상태에서 앱이 깨워질 수 있도록 하고, 불필요한 위치 업데이트를 줄여 배터리 소모를 최소화합니다.</p>
