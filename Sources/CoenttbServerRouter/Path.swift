//
//  File.swift
//  coenttb-web
//
//  Created by Coen ten Thije Boonkkamp on 13/12/2024.
//

import Dependencies
import Foundation
import URLRouting

extension Path<PathBuilder.Component<String>> {
    
    nonisolated(unsafe)
    public static let well_known: Path<PathBuilder.Component<String>> = Path {
        ".well-known"
    }
    
    nonisolated(unsafe)
    public static let appleAppSiteAssociation: Path<PathBuilder.Component<String>> = Path {
        ".well-known/apple-app-site-association"
    }
    
    nonisolated(unsafe)
    public static let readmeMd: Path<PathBuilder.Component<String>> = Path {
        "README.md"
    }
    
    nonisolated(unsafe)
    public static let licenseTxt: Path<PathBuilder.Component<String>> = Path {
        "LICENSE.txt"
    }
    
    nonisolated(unsafe)
    public static let changelogMd: Path<PathBuilder.Component<String>> = Path {
        "CHANGELOG.md"
    }
    
    // SEO and Social Media Integration Files
    nonisolated(unsafe)
    public static let openSearchXml: Path<PathBuilder.Component<String>> = Path {
        "opensearch.xml"
    }
    
    nonisolated(unsafe)
    public static let rssXml: Path<PathBuilder.Component<String>> = Path {
        "rss.xml"
    }
    
    nonisolated(unsafe)
    public static let atomXml: Path<PathBuilder.Component<String>> = Path {
        "atom.xml"
    }
    
    nonisolated(unsafe)
    public static let faviconIco: Path<PathBuilder.Component<String>> = Path {
        "favicon.ico"
    }
    
    nonisolated(unsafe)
    public static let ogImage: Path<PathBuilder.Component<String>> = Path {
        "og-image.jpg"
    }
    
    nonisolated(unsafe)
    public static let robotsTxt: Path<PathBuilder.Component<String>> = Path {
        "robots.txt"
    }
    
    nonisolated(unsafe)
    public static let sitemapXml: Path<PathBuilder.Component<String>> = Path {
        "sitemap.xml"
    }
    
    nonisolated(unsafe)
    public static let documentation: Path<PathBuilder.Component<String>> = Path {
        "documentation".slug()
    }
    
    nonisolated(unsafe)
    public static let assets: Path<PathBuilder.Component<String>> = Path {
        "assets".slug()
    }
    nonisolated(unsafe)
    public static let css: Path<PathBuilder.Component<String>> = Path {
        "css".slug()
    }
    nonisolated(unsafe)
    public static let scss: Path<PathBuilder.Component<String>> = Path {
        "scss".slug()
    }
    nonisolated(unsafe)
    public static let bootstrap: Path<PathBuilder.Component<String>> = Path {
        "bootstrap".slug()
    }
    nonisolated(unsafe)
    public static let js: Path<PathBuilder.Component<String>> = Path {
        "js".slug()
    }
    
    nonisolated(unsafe)
    public static let file: Path<PathBuilder.Component<String>> = Path {
        "file".slug()
    }
    
    nonisolated(unsafe)
    public static let favicon: Path<PathBuilder.Component<String>> = Path {
        "favicon".slug()
    }
    
    nonisolated(unsafe)
    public static let logo: Path<PathBuilder.Component<String>> = Path {
        "logo".slug()
    }
    
    nonisolated(unsafe)
    public static let image: Path<PathBuilder.Component<String>> = Path {
        "img".slug()
    }
    
    nonisolated(unsafe)
    public static let img: Path<PathBuilder.Component<String>> = .image
    
    nonisolated(unsafe)
    public static let apple_developer_merchantid_domain_association: Path<PathBuilder.Component<String>> = Path {
        "apple-developer-merchantid-domain-association"
    }
    
    nonisolated(unsafe)
    public static let manifestJson: Path<PathBuilder.Component<String>> = Path {
        "manifest.json"
    }
    
    nonisolated(unsafe)
    public static let humansTxt: Path<PathBuilder.Component<String>> = Path {
        "humans.txt"
    }
    
    nonisolated(unsafe)
    public static let crossdomainXml: Path<PathBuilder.Component<String>> = Path {
        "crossdomain.xml"
    }
    
    nonisolated(unsafe)
    public static let api: Path<PathBuilder.Component<String>> = Path {
        "api".slug()
    }
    
    nonisolated(unsafe)
    public static let graphql: Path<PathBuilder.Component<String>> = Path {
        "graphql".slug()
    }
    
    nonisolated(unsafe)
    public static let opensearchXml: Path<PathBuilder.Component<String>> = Path {
        "opensearch.xml"
    }
    
    nonisolated(unsafe)
    public static let browserconfigXml: Path<PathBuilder.Component<String>> = Path {
        "browserconfig.xml"
    }
    
    nonisolated(unsafe)
    public static let siteVerification: Path<PathBuilder.Component<String>> = Path {
        "site-verification".slug()
    }
    
    nonisolated(unsafe)
    public static let error404: Path<PathBuilder.Component<String>> = Path {
        "404".slug()
    }
    
    nonisolated(unsafe)
    public static let error500: Path<PathBuilder.Component<String>> = Path {
        "500".slug()
    }
}
