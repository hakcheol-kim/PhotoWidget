# PhotoWidget

## 요구사항
* 언어: Swift
* OS: Deployment Target iOS 16.0
* 아키텍처: 자유
* UI 프레임워크: UIKit 또는 SwiftUI
* 라이브러리 사용 자유
* 사용하신 라이브러리에 대한 질의가 있을 수 있습니다.
* 작업 과정을 git을 사용해 기록
* 디자인은 평가 요소에 포함되지 않습니다.

## 이미지 캐쉬
- 파일 위치: Common/ImageCacheManager
* 메모리캐쉬 > 디스크 캐쉬 > 통신 으로 구현 
* 메모리에 없으면 파일매니저에서 찾는다.
  + 파일 매니저에 있으면 메모리에 올리고 Image return Data
  + 파일 매니저에도 없으면 통신 요청 후 디스크저장, 메모리에도 올림
  
## 통신 설명
* Router enum type는 Routable 프로토콜을 구현한다.
* ApiClient는 Router를 받아 실제 api서버에 데이터 요청 
* concurrency로 async awit 사용함 
   
