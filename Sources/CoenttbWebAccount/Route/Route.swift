//
//  File.swift
//  coenttb-web
//
//  Created by Coen ten Thije Boonkkamp on 07/10/2024.
//

import Foundation
import CasePaths
import URLRouting
import MemberwiseInit
import MacroCodableKit

@CasePathable
public enum Route: Codable, Hashable, Sendable {
    case create(CoenttbWebAccount.Route.Create)
    case delete
    case login
    case logout
    case password(CoenttbWebAccount.Route.Password)
    case emailChange(CoenttbWebAccount.Route.EmailChange)
}

extension CoenttbWebAccount.Route {
    public enum Password: Codable, Hashable, Sendable {
        case reset(CoenttbWebAccount.Route.Password.Reset)
        case change(CoenttbWebAccount.Route.Password.Change)
    }
}

extension CoenttbWebAccount.Route.Password {
    public enum Reset: Codable, Hashable, Sendable {
        case request
        case confirm(CoenttbWebAccount.Route.Password.Reset.Confirm)
    }
    
    public enum Change: Codable, Hashable, Sendable {
        case request
    }
}

extension CoenttbWebAccount.Route.Password.Change {
    public enum Request {}
}

extension CoenttbWebAccount.Route.Password.Reset {
    
    public enum Request {}
    @MemberwiseInit(.public)
    @Codable
    public struct Confirm: Hashable, Sendable {
       @CodingKey("token")
        @Init(default: "")
        public let token: String
        
       @CodingKey("newPassword")
        @Init(default: "")
        public let newPassword: String
    }
}

extension CoenttbWebAccount.Route {
    public enum EmailChange: Codable, Hashable, Sendable {
        case request
        case confirm(EmailChange.Confirm)
    }
}

extension CoenttbWebAccount.Route.EmailChange {
    
    public enum Request {}
    @MemberwiseInit(.public)
    @Codable
    public struct Confirm: Hashable, Sendable {
       @CodingKey("token")
        @Init(default: "")
        public let token: String
    }
}


extension CoenttbWebAccount.Route {
    public enum Create: Codable, Hashable, Sendable {
        case request
        case verify(CoenttbWebAccount.Route.Create.Verify)
    }
}

extension CoenttbWebAccount.Route.Create {
    @MemberwiseInit(.public)
    @Codable
    public struct Verify: Hashable, Sendable {
       @CodingKey("token")
        @Init(default: "")
        public let token: String
        
       @CodingKey("email")
        @Init(default: "")
        public let email: String
    }
}

extension CoenttbWebAccount.Route {
    public struct Router: ParserPrinter {
        
        public init(){}
        
        public var body: some URLRouting.Router<CoenttbWebAccount.Route> {
            OneOf {
                
                URLRouting.Route(.case(CoenttbWebAccount.Route.create)) {
                    Path { "create" }
                    OneOf {
                        URLRouting.Route(.case(CoenttbWebAccount.Route.Create.request)) {
                            Path { "request" }
                        }
                        
                        URLRouting.Route(.case(CoenttbWebAccount.Route.Create.verify)) {
                            Path { "email-verification" }
                            Parse(.memberwise(CoenttbWebAccount.Route.Create.Verify.init)) {
                                Query {
                                    Field(CoenttbWebAccount.Route.Create.Verify.CodingKeys.token.rawValue, .string)
                                    Field(CoenttbWebAccount.Route.Create.Verify.CodingKeys.email.rawValue, .string)
                                }
                            }
                        }
                    }
                }
                
                URLRouting.Route(.case(CoenttbWebAccount.Route.login)) {
                    Path { "login" }
                }
                
                URLRouting.Route(.case(CoenttbWebAccount.Route.logout)) {
                    Path { "logout" }
                }
                
                URLRouting.Route(.case(CoenttbWebAccount.Route.password)) {
                    Path { "password" }
                    OneOf {
                        URLRouting.Route(.case(CoenttbWebAccount.Route.Password.reset)) {
                            Path { "reset" }
                            OneOf {
                                URLRouting.Route(.case(CoenttbWebAccount.Route.Password.Reset.request)) {
                                    Path { "request" }
                                }
                                
                                URLRouting.Route(.case(CoenttbWebAccount.Route.Password.Reset.confirm)) {
                                    Path { "confirm" }
                                    Parse(.memberwise(CoenttbWebAccount.Route.Password.Reset.Confirm.init)) {
                                        Query {
                                            Field(CoenttbWebAccount.Route.Password.Reset.Confirm.CodingKeys.token.rawValue, .string)
                                            Field(CoenttbWebAccount.Route.Password.Reset.Confirm.CodingKeys.newPassword.rawValue, .string)
                                        }
                                    }
                                }
                            }
                        }
                        
                        URLRouting.Route(.case(CoenttbWebAccount.Route.Password.change)) {
                            Path { "change" }
                            URLRouting.Route(.case(CoenttbWebAccount.Route.Password.Change.request)) {
                                Path { "request" }
                            }
                        }
                    }
                }
                
                URLRouting.Route(.case(CoenttbWebAccount.Route.emailChange)) {
                    Path { "email-change" }
                    OneOf {
                        URLRouting.Route(.case(CoenttbWebAccount.Route.EmailChange.request)) {
                            Path { "request" }
                        }
                        
                        URLRouting.Route(.case(CoenttbWebAccount.Route.EmailChange.confirm)) {
                            Path { "confirm" }
                            Parse(.memberwise(CoenttbWebAccount.Route.EmailChange.Confirm.init)) {
                                Query {
                                    Field(CoenttbWebAccount.Route.EmailChange.Confirm.CodingKeys.token.rawValue, .string)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
