# gottagofast
To setup the full development enviroment for a new language
1. Add language to ensure_installed in treesitter plugin
2. Add language to formatters_by_ft in conform plugin 
3. If applicable, add language to linters_by_ft in nvim-lint plugin
4. If applicable, add language to ensure_installed in mason-lsp plugin
5. Configure the language server in nvim-lspconfig plugin 
6. Also add the language formatter and/or linter in ensure_installed in mason-tool-installer plugin
7. Configure any debug adapters in nvim-dap plugin
