nvim-cmp Lua LaTeX Symbols
================

## Contents

-   <a href="#preview" id="toc-preview">Preview</a>
-   <a href="#introduction" id="toc-introduction">Introduction</a>
-   <a href="#installation" id="toc-installation">Installation</a>
    -   <a href="#packernvim" id="toc-packernvim"><span>packer.nvim</span></a>
-   <a href="#setup" id="toc-setup">Setup</a>
    -   <a href="#only-for-certain-file-types"
        id="toc-only-for-certain-file-types">Only for certain file types</a>
-   <a href="#issues" id="toc-issues">Issues</a>

## Preview

![](media/preview.gif)

## Introduction

nvim-cmp Lua LaTeX Symbols is a completion source for
[nvim-cmp](https://github.com/hrsh7th/nvim-cmp) that provides sources
for LaTeX symbols. This is especially useful for editing
[TeX](#only-for-certain-file-types) file types. It gets them from this
URL:
<https://milde.users.sourceforge.net/LUCR/Math/data/unimathsymbols.txt>.

## Installation

### [packer.nvim](https://github.com/wbthomason/packer.nvim)

``` lua
require "packer".startup(function(use)
    use "amarakon/nvim-cmp-lua-latex-symbols"
end)
```

## Setup

``` lua
require "cmp".setup {
    sources = {
        { name = "lua-latex-symbols" }
    }
}
```

### Only for certain file types

``` lua
-- Only enable `lua-latex-symbols` for `tex` and `plaintex` file types
require "cmp".setup.filetype({ "tex", "plaintex" }, {
    sources = {
        { name = "lua-latex-symbols"}
    }
})
```

## Issues

-   The text file used to parse the symbols is really large. Also, the
    code has to loop through each line of the file, then loop through
    each section, and check if the symbol is valid. This takes a long
    time. I plan to add a cache feature to this plugin in the future.

-   There are certain instances where you will see two different symbols
    with the same name. Most of the time, only the first symbol is
    useful. I plan to remove duplicates in the future.

    ![](media/duplicate.png)
