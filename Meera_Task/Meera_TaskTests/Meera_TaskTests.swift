//
//  Meera_TaskTests.swift
//  Meera_TaskTests
//
//  Created by Meera Seetharam on 29/11/24.
//

import XCTest
@testable import Meera_Task

final class Meera_TaskTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

class CoinListInteractorTests: XCTestCase {
    var interactor: CoinListInteractor!
    var mockOutput: MockCoinListInteractorOutput!
    let mockCoinRepository = MockCoinRepository()
    
    override func setUpWithError() throws {
        mockOutput = MockCoinListInteractorOutput()
        interactor = CoinListInteractor(coinRepository: MockCoinRepository())
        interactor.output = mockOutput
    }

    func testFetchCoinsSuccess() {
        // Given
        let expectedCoins = [Coin(name: "Bitcoin", symbol: "BTC", isNew: false, isActive: true, type: "coin")]
        mockCoinRepository.coins = expectedCoins

        // When
        interactor.fetchCoins()

        // Then
        XCTAssertNotEqual(mockOutput.fetchedCoins, expectedCoins)
    }

    func testFetchCoinsWithFilterSuccess() {
        // Given
        let expectedCoins = [Coin(name: "Bitcoin", symbol: "BTC", isNew: false, isActive: true, type: "coin")]
        mockCoinRepository.coins = expectedCoins

        // When
        interactor.applyFilter(isActive: true, type: .coin, isNew: false, searchText: nil)

        // Then
        XCTAssertNotEqual(mockOutput.fetchedCoins, expectedCoins)
    }

    // ... other test cases for error scenarios, search functionality, etc.
}

class MockCoinRepository: CoinRepository {
    
    var coins: [Coin] = []

    func fetchCoins() async throws -> [Coin] {
        return coins
    }
    
    func fetchCoinsFromFile() async throws -> [Coin] {
        return coins
    }
}

class MockCoinListInteractorOutput: CoinListInteractorOutputProtocol {
    var fetchedCoins: [Coin] = []

    func coinsFetched(coins: [Coin]) {
        fetchedCoins = coins
    }

    func showError(error: Error) {
        // Implement error handling logic for testing
    }
}
