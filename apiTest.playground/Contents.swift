import UIKit

struct MusicData: Codable {
    let resultCount: Int
    let results: [Music]
}

// 실제 우리가 사용하게될 음악(Music) 모델 구조체
// (서버에서 가져온 데이터만 표시해주면 되기 때문에 일반적으로 구조체로 만듦)

struct Music: Codable {
    let songName: String?
    let artistName: String?
    let albumName: String?
    let previewUrl: String?
    let imageUrl: String?
    private let releaseDate: String?
    
    // 네트워크에서 주는 이름을 변환하는 방법 (원시값)
    // (서버: trackName ===> songName)
    enum CodingKeys: String, CodingKey {
        case songName = "trackName"
        case artistName
        case albumName = "collectionName"
        case previewUrl
        case imageUrl = "artworkUrl100"
        case releaseDate
    }
}


func getMethod(completionHandeler: @escaping ([Music]?) -> Void) {
    //리턴 타입이 Void 일수 밖에 없는이유 : Music데이터를 전달하는거에 떄라서 함수를 실행시키기 때문에.
    
    // URL구조체 만들기
    guard let url = URL(string: "https://itunes.apple.com/search?media=music&term=My+Way") else {
        print("Error: cannot create URL")
        //nil을 전달하며, 함수를 실행시킨다.
        completionHandeler(nil)
        return
    }
    
    // URL요청 생성
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    
    
    // 요청을 가지고 작업세션시작
    URLSession.shared.dataTask(with: request) { data, response, error in
        // 에러가 없어야 넘어감
        guard error == nil else {
            print("Error: error calling GET")
            print(error!)
            completionHandeler(nil)
            return
        }
        // 옵셔널 바인딩
        guard let safeData = data else { //Json의 형태로 올것
            print("Error: Did not receive data")
            completionHandeler(nil)
            return
        }
        // HTTP 200번대 정상코드인 경우만 다음 코드로 넘어감
        guard let response = response as? HTTPURLResponse, (200 ..< 299) ~= response.statusCode else {
            print("Error: HTTP request failed")
            completionHandeler(nil)
            return
        }
        
        do {
            //SafeData를 가지고 클래스나 구조체로 변형 시켜줘야 한다.
            let decoder = JSONDecoder() //Json디코딩을 위한 디고더 생성
            
            //Decodable을 채택한 타입 이어야 한다.(메타 타입의 형태, 타입 인스턴스의 형태여야한다.)
            //하나의 인스턴스가 아닌 공통적인 타입으로 넣어줘야함.
            let musicArray = try decoder.decode(MusicData.self, from: safeData)
            completionHandeler(musicArray.results)
        } catch {
            
        }
        
    }.resume()     // 시작
}

// getMethod실행 시키고, 전달된 파라미터 출력
getMethod { musicArray in
    dump(musicArray)
}
