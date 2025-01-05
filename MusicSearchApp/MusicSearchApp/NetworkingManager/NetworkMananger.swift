//
//  NetworkMananger.swift
//  MusicSearchApp
//
//  Created by 진욱의 Macintosh on 1/2/25.
//

import Foundation

//일반적으로 NetworkMananger는 전체적으로 사용하기 때문에 Singleton 패턴으로 설계한다.

//MARK: - 네트워크에서 발생할수 있는 에러 정의

enum NetworkError: Error { //에러 프로토콜을 정의 해준다.
    //네트워킹 에러, 데이터 에러, 파싱에러
    case networkingError
    case dataError
    case parseError
}

class NetworkMananger {
    
    //shared - 데이터 영역에 존재하게 됨
    //NetworkMananger() -  heap영역, 단 한개만 존재하게 된다/
    static let shared = NetworkMananger()
    //외부에서 NetworkMananger의 인스턴스 생성을 방지한다.
    private init() {}
    
    //데이터를 담는 배열의 설정
    // typealias를 통해서 에러 타입을 치환 시킴.
    typealias NetworkCompletion = (Result<[Music], NetworkError>) -> Void
    
    func fetchMusic(searchTerm: String, completion: @escaping NetworkCompletion) {
        let urlString = "\(MusicApi.requestURL)\(MusicApi.mediaParam)&term=\(searchTerm)"
        print(urlString)
        
        performRequest(with: urlString) { result in
            completion(result)
        }
    }
 
    private func performRequest(with urlString: String, completion: @escaping NetworkCompletion) {
        guard let url = URL(string: urlString) else {return}
        
        let session = URLSession(configuration: .default)
        
        let task = session.dataTask(with: url) { (data, response, error)in
            if error != nil {
                print(error!)
                //에러가 발생한다면.
                completion(.failure(.networkingError))
                return
            }
            guard let safeData = data else {
                completion(.failure(.dataError))
                return
            }
            if let musics = self.parseJSON(safeData) {
                print("parseJSON 성공")
                //성공기 데이터를 [Music]아레이에 담음
                completion(.success(musics))
            }else{
                print("parseJSON 실패")
                completion(.failure(.parseError))
            }
        }
        task.resume()
    }
    
    //JSON데이터를 분석하는 함수
    private func parseJSON(_ musicData: Data) -> [Music]? {
        do{
            //데이터 분석 성공시, 만들어놓은 구조체, 클래스로 변환시켜주는 객체
            let musicData = try JSONDecoder().decode(MusicData.self, from: musicData)
            return musicData.results
        } catch {
            print("")
           return nil
        }
    }
}
