import XCTest
@testable import ComposableDeepLink

final class ComposableDeepLinkTests: XCTestCase {
    
    enum TestResult: Equatable {
        case foo
        case bar
        case biz
        case whatewer(id: String)
    }
    
    func testSyntax() throws {
        let handleCalledExpectation = expectation(description: "root handle called")
        let processor = ComposableDeepLink {
            Handle {
                handleCalledExpectation.fulfill()
                return TestResult.foo
            }
        }
        
        _ = processor.handle(url: URL(string: "example.com")!)
        waitForExpectations(timeout: 1)
    }
    
    func testScheme() {
        let validExpectation1 = expectation(description: "valid scheme first handler called")
        let validExpectation2 = expectation(description: "valid scheme second handler called")
        let validExpectation3 = expectation(description: "second valid scheme called")
        
        let invalidExpectation = expectation(description: "invalid scheme called")
        invalidExpectation.isInverted = true
        
        let processor = ComposableDeepLink {
            Scheme("valid") {
                Handle {
                    validExpectation1.fulfill()
                    return TestResult.foo
                }
                Handle {
                    validExpectation2.fulfill()
                    return TestResult.foo
                }
            }
            Scheme("valid") {
                Handle {
                    validExpectation3.fulfill()
                    return TestResult.foo
                }
            }
            Scheme("invalid") {
                Handle {
                    invalidExpectation.fulfill()
                    return TestResult.foo
                }
            }
        }
        
        _ = processor.handle(url: URL(string: "valid://example.com")!)
        waitForExpectations(timeout: 1)
    }
    
    func testHost() {
        let exampleExpectation = expectation(description: "example handle called")
        let invalidExpectation = expectation(description: "invalid not called")
        invalidExpectation.isInverted = true
        
        let processor = ComposableDeepLink {
            Host("example.com") {
                Handle {
                    exampleExpectation.fulfill()
                    return TestResult.foo
                }
            }
            
            Host("qwerty.com") {
                Handle {
                    invalidExpectation.fulfill()
                    return TestResult.foo
                }
            }
        }
        
        _ = processor.handle(url: URL(string: "schema://example.com")!)
        waitForExpectations(timeout: 1)
    }
    
    func testStaticPath() {
        let exampleExpectation = expectation(description: "example handle called")
        let invalidExpectation = expectation(description: "invalid not called")
        invalidExpectation.isInverted = true
        
        let processor = ComposableDeepLink {
            Path("foo/bar") {
                Handle {
                    exampleExpectation.fulfill()
                    return TestResult.biz
                }
            }
            
            Path("biz") {
                Handle {
                    invalidExpectation.fulfill()
                    return TestResult.biz
                }
            }
        }
        
        _ = processor.handle(url: URL(string: "schema://example.com/foo/bar")!)
        waitForExpectations(timeout: 1)
    }
    
    func testParameterPath() {
        let exampleExpectation1 = expectation(description: "example handle called")
        let exampleExpectation2 = expectation(description: "example handle called")
        
        let processor = ComposableDeepLink {
            Path("/foo/:id/bar") { context in
                Handle<TestResult> {
                    exampleExpectation1.fulfill()
                    return .whatewer(id: context.id ?? "???")
                }
            }
            Path("foo/:id/bar") { context in
                Handle<TestResult> {
                    exampleExpectation2.fulfill()
                    return .whatewer(id: context.id ?? "???")
                }
            }
        }
        
        let result = processor.handle(url: URL(string: "schema://example.com/foo/THIS_IS_ID/bar")!)
        XCTAssertEqual(TestResult.whatewer(id: "THIS_IS_ID"), result)
        waitForExpectations(timeout: 1)
    }
    
    func testFunctionBuilder() {
        
    }
}
