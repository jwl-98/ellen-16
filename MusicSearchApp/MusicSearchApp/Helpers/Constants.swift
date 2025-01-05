//
//  Constants.swift
//  MusicSearchApp
//
//  Created by 진욱의 Macintosh on 1/2/25.
//

import UIKit

//MARK: - Name Space만들기

public enum MusicApi {
    //검색을 위한 url 설정해놓기
    //enum의 경우는 다른 코드를 작성해줄 필요가없음
    static let requestURL = "https://itunes.apple.com/search?"
    static let mediaParam = "media=music"
}
