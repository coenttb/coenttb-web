//
//  File.swift
//
//
//  Created by Coen ten Thije Boonkkamp on 25/07/2024.
//

import Foundation
import CoenttbHTML

public struct PrismJSHead: HTML {
    private let languages: [String]
    private let style_string: String
    private let script_string: String
    
    public init(
        languages: [String] = [],
        style: String = "",
        script: String = ""
    ) {
        self.languages = languages
        self.script_string = script
        self.style_string = style
    }
    
    @HTMLBuilder
    public var body: some HTML {
        Style {
          """
          pre {
            position: relative;
          }

          .line-highlight {
            background-color: rgba(0, 121, 255, 0.1);
            margin-top: 1rem;
            margin-left: -1.5rem;
            position: absolute;
          }

          .highlight-pass .line-highlight {
            background-color: rgba(0, 255, 50, 0.15);
          }

          .highlight-fail .line-highlight {
            background-color: rgba(255, 68, 68, 0.15);
          }

          .highlight-warn .line-highlight {
            background-color: rgba(254, 223, 43, 0.15);
          }

          .language-diff {
            color: #808080;
          }

          .language-diff .token.inserted {
            background-color: #f0fff4;
            color: #22863a;
            margin: -4px;
            padding: 4px;
          }

          .language-diff .token.deleted {
            background-color: #ffeef0;
            color: #b31d28;
            margin: -3px;
            padding: 3px;
          }

          .token.atrule, \
          .token.boolean, \
          .token.constant, \
          .token.directive, \
          .token.directive-name, \
          .token.keyword, \
          .token.other-directive {
            color: #AD3DA4;
          }

          .token.class-name, \
          .token.function {
            color: #4B21B0;
          }

          .token.comment {
            color: #707F8C;
          }
          
          .token.todo {
            font-weight: 700;
          }

          .token.number, \
          .token.string {
            color: #D22E1B;
          }

          .token.placeholder, .token.code-fold {
            background-color: #bbb;
            border-radius: 6px;
            color: #fff;
            margin: -2px;
            padding: 2px;
          }

          .token.placeholder-open, \
          .token.placeholder-close {
            display: none;
          }

          @media (prefers-color-scheme: dark) {
            .line-highlight {
              background-color: rgba(255, 255, 255, 0.1);
            }

            .language-diff .token.inserted {
              background-color: #071c06;
              color: #6fd574;
            }

            .language-diff .token.deleted {
              background-color: #280c0f;
              color: #f95258;
            }

            .token.atrule, \
            .token.boolean, \
            .token.constant, \
            .token.directive, \
            .token.directive-name, \
            .token.keyword, \
            .token.other-directive {
              color: #FF79B2;
            }

            .token.class-name, \
            .token.function {
              color: #DABAFF;
            }

            .token.comment {
              color: #7E8C98;
            }

            .token.number, \
            .token.string {
              color: #FF8170;
            }

            .token.placeholder, .token.code-fold {
              background-color: #87878A;
            }
          }
          """
        }
        
        script(src: "//cdnjs.cloudflare.com/ajax/libs/prism/1.29.0/prism.min.js") /*TO-DO: FIGURE OUT WHY CLOSURE CAN'T BE REMOVED HERE*/ {""}
        script(src: "//cdnjs.cloudflare.com/ajax/libs/prism/1.29.0/plugins/line-highlight/prism-line-highlight.min.js") /*TO-DO: FIGURE OUT WHY CLOSURE CAN'T BE REMOVED HERE*/ {""}
        HTMLForEach(self.languages) { lang in
            script(src: "//cdnjs.cloudflare.com/ajax/libs/prism/1.29.0/components/prism-\(lang).min.js")
        }
        script {
          #"""
          Prism.languages.swift['class-name'] = [
            /\b(_[A-Z]\w*)\b/,
            Prism.languages.swift['class-name']
          ];
          Prism.languages.swift.keyword = [
            /\b(any|macro)\b/,
            /\b((iOS|macOS|tvOS|watchOS|visionOS)(|ApplicationExtension)|swift)\b/,
            Prism.languages.swift.keyword
          ];
          Prism.languages.swift.comment.inside = {
            todo: {
              pattern: /(TODO:)/
            }
          };
          Prism.languages.insertBefore('swift', 'operator', {
            'code-fold': {
              pattern: /…/
            },
          });
          Prism.languages.insertBefore('swift', 'string-literal', {
            'placeholder': {
              pattern: /<#.+?#>/,
              inside: {
                'placeholder-open': {
                  pattern: /<#/
                },
                'placeholder-close': {
                  pattern: /#>/
                },
              }
            },
          });
          """#
        }
    }
}

extension PrismJSHead {
    public struct Language: ExpressibleByStringLiteral, Sendable {
        
        let value: String
        
        public init(stringLiteral value: StringLiteralType) {
            self.value = value
        }
    }
}

extension PrismJSHead.Language {
    public static let markup: Self = "markup"
    public static let html: Self = "html"
    public static let xml: Self = "xml"
    public static let svg: Self = "svg"
    public static let mathml: Self = "mathml"
    public static let ssml: Self = "ssml"
    public static let atom: Self = "atom"
    public static let rss: Self = "rss"
    public static let css: Self = "css"
    public static let clike: Self = "clike"
    public static let javascript: Self = "javascript"
    public static let js: Self = "js"
    public static let abap: Self = "abap"
    public static let abnf: Self = "abnf"
    public static let actionscript: Self = "actionscript"
    public static let ada: Self = "ada"
    public static let agda: Self = "agda"
    public static let al: Self = "al"
    public static let antlr4: Self = "antlr4"
    public static let g4: Self = "g4"
    public static let apacheconf: Self = "apacheconf"
    public static let apex: Self = "apex"
    public static let apl: Self = "apl"
    public static let applescript: Self = "applescript"
    public static let aql: Self = "aql"
    public static let arduino: Self = "arduino"
    public static let ino: Self = "ino"
    public static let arff: Self = "arff"
    public static let armasm: Self = "armasm"
    public static let arm_asm: Self = "arm-asm"
    public static let arturo: Self = "arturo"
    public static let art: Self = "art"
    public static let asciidoc: Self = "asciidoc"
    public static let adoc: Self = "adoc"
    public static let aspnet: Self = "aspnet"
    public static let asm6502: Self = "asm6502"
    public static let asmatmel: Self = "asmatmel"
    public static let autohotkey: Self = "autohotkey"
    public static let autoit: Self = "autoit"
    public static let avisynth: Self = "avisynth"
    public static let avs: Self = "avs"
    public static let avro_idl: Self = "avro-idl"
    public static let avdl: Self = "avdl"
    public static let awk: Self = "awk"
    public static let gawk: Self = "gawk"
    public static let bash: Self = "bash"
    public static let sh: Self = "sh"
    public static let shell: Self = "shell"
    public static let basic: Self = "basic"
    public static let batch: Self = "batch"
    public static let bbcode: Self = "bbcode"
    public static let shortcode: Self = "shortcode"
    public static let bbj: Self = "bbj"
    public static let bicep: Self = "bicep"
    public static let birb: Self = "birb"
    public static let bison: Self = "bison"
    public static let bnf: Self = "bnf"
    public static let rbnf: Self = "rbnf"
    public static let bqn: Self = "bqn"
    public static let brainfuck: Self = "brainfuck"
    public static let brightscript: Self = "brightscript"
    public static let bro: Self = "bro"
    public static let bsl: Self = "bsl"
    public static let oscript: Self = "oscript"
    public static let c: Self = "c"
    public static let csharp: Self = "csharp"
    public static let cs: Self = "cs"
    public static let dotnet: Self = "dotnet"
    public static let cpp: Self = "cpp"
    public static let cfscript: Self = "cfscript"
    public static let cfc: Self = "cfc"
    public static let chaiscript: Self = "chaiscript"
    public static let cil: Self = "cil"
    public static let cilkc: Self = "cilkc"
    public static let cilk_c: Self = "cilk-c"
    public static let cilkcpp: Self = "cilkcpp"
    public static let cilk_cpp: Self = "cilk-cpp"
    public static let cilk: Self = "cilk"
    public static let clojure: Self = "clojure"
    public static let cmake: Self = "cmake"
    public static let cobol: Self = "cobol"
    public static let coffeescript: Self = "coffeescript"
    public static let coffee: Self = "coffee"
    public static let concurnas: Self = "concurnas"
    public static let conc: Self = "conc"
    public static let csp: Self = "csp"
    public static let cooklang: Self = "cooklang"
    public static let coq: Self = "coq"
    public static let crystal: Self = "crystal"
    public static let css_extras: Self = "css-extras"
    public static let csv: Self = "csv"
    public static let cue: Self = "cue"
    public static let cypher: Self = "cypher"
    public static let d: Self = "d"
    public static let dart: Self = "dart"
    public static let dataweave: Self = "dataweave"
    public static let dax: Self = "dax"
    public static let dhall: Self = "dhall"
    public static let diff: Self = "diff"
    public static let django: Self = "django"
    public static let jinja2: Self = "jinja2"
    public static let dns_zone_file: Self = "dns-zone-file"
    public static let dns_zone: Self = "dns-zone"
    public static let docker: Self = "docker"
    public static let dockerfile: Self = "dockerfile"
    public static let dot: Self = "dot"
    public static let gv: Self = "gv"
    public static let ebnf: Self = "ebnf"
    public static let editorconfig: Self = "editorconfig"
    public static let eiffel: Self = "eiffel"
    public static let ejs: Self = "ejs"
    public static let eta: Self = "eta"
    public static let elixir: Self = "elixir"
    public static let elm: Self = "elm"
    public static let etlua: Self = "etlua"
    public static let erb: Self = "erb"
    public static let erlang: Self = "erlang"
    public static let excel_formula: Self = "excel-formula"
    public static let xlsx: Self = "xlsx"
    public static let xls: Self = "xls"
    public static let fsharp: Self = "fsharp"
    public static let factor: Self = "factor"
    public static let `false`: Self = "false"
    public static let firestore_security_rules: Self = "firestore-security-rules"
    public static let flow: Self = "flow"
    public static let fortran: Self = "fortran"
    public static let ftl: Self = "ftl"
    public static let gml: Self = "gml"
}
