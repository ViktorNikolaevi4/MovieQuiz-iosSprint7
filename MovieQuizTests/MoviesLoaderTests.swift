//
//  MoviesLoaderTests.swift
//  MovieQuizTests
//
//  Created by Виктор Корольков on 22.08.2023.
//

import Foundation

import XCTest
@testable import MovieQuiz

class MoviesLoader: XCTestCase {
    func testSuccessLoading() throws {
        let loader = MoviesLoader()
        
        let expectation = expectation(description: "Loading expectation")
        
        loader.loadMovies { result in
                // Then
                switch result {
                case .success(let movies):
                    // сравниваем данные с тем, что мы предполагали
                    expectation.fulfill()
                case .failure(_):
                    // мы не ожидаем, что пришла ошибка; если она появится, надо будет провалить тест
                    XCTFail("Unexpected failure") // эта функция проваливает тест
                }
            }
           
           waitForExpectations(timeout: 1)
        
    }
    
    func testFailureLoading() throws {
            let stubNetworkClient = StubNetworkClient(emulateError: false)
        let loader = MoviesLoader(networkClient: stubNetworkClient)
        
        let expectation = expectation(description: "Loading expectation")
            
            loader.loadMovies { result in
                // Then
                switch result {
                case .success(let movies):
                    // давайте проверим, что пришло, например, два фильма — ведь в тестовых данных их всего два
                    XCTAssertEqual(movies.items.count, 2)
                    expectation.fulfill()
                case .failure(_):
                    XCTFail("Unexpected failure")
                }
            }
            
            waitForExpectations(timeout: 1)
    }
}
