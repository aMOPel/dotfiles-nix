-- overriding the formatter and linter config to use local versions from node_modules
g.helpers.typescript.useLocalNodeModulesFormatter("biome", "biome")
g.helpers.typescript.useLocalNodeModulesLinter("biome", "biomejs")
