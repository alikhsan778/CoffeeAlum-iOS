//
//  ProfileViewControllerTest.swift
//  CoffeeAlum Gamma
//
//  Created by Trevin Wisaksana on 2/8/17.
//  Copyright © 2017 Trevin Wisaksana. All rights reserved.
//

import XCTest
@testable import CoffeeAlum_Gamma

class PersonalProfileViewControllerUnitTest: XCTestCase {
    
    var personalProfileViewController: PersonalProfileVC!
    
    override func setUp() {
        super.setUp()
        // let label = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    }
    
    func test() {
        let signUpVC = SignUpViewController()
        signUpVC.firabaseDatabaseReference()
        XCTAssert(true)
    }
    
    func testPerformance() {
        measure {
            let signUpVC = SignUpViewController()
            // signUpVC.displayUsefulErrorMessage(errorMessage: "Hello", label: label)
        }
    }
    
    func testAsync() {
        
    }
    
}
