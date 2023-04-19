# Sourcery Support

## DocumentUI+SwiftLangUI as template engine for [Sourcery](https://github.com/Everything-as-UI/Sourcery)

### Usage

1. Install Sourcery from https://github.com/Everything-as-UI/Sourcery;
2. Clone this repository;
3. Copy `SourceryTemplateEngine` folder to your project;
4. Add your templates to `SourceryTemplateEngine/SwiftTemplate/{version}/Templates` based on `SwiftLangUI` or another third-party code generation library that you can add to `SourceryTemplateEngine/SwiftTemplate/{version}/Package.swift`;
4. Run command:
    `sourcery --output {output-path} --templates {path-to-templates} --sources {path-to-sources} --buildPath SourceryTemplateEngine --cacheBasePath SourceryTemplateEngine/SwiftTemplate/{version}/.cache`
