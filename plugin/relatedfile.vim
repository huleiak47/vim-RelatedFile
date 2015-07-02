"==================================================
" File:         relatedfile.vim
" Brief:        Open related file of current file.
" Authors:      Hulei <huleiak47@gmail.com>,
" Last Change   2015-07-02
" Version:      1.1
"
" Usage:        use command :OpenRelatedFile<CR> or map it.
" Options:      g:relatedfile_user_dict
"==================================================

if exists("g:relatedfile_loaded") || !has("python")
    finish
endif

let g:relatedfile_loaded = 1

let g:relatedfile_dict = { ".c" : [".h"],  ".cpp" : [".hpp", ".hxx", ".h++", ".h"], ".cxx" : [".hxx", ".hpp", ".h++", ".h"], ".c++" : [".h++", ".hxx", ".hpp", ".h"], ".h" : [".c", ".cpp", ".cxx", ".c++"], ".hpp" : [".cpp", ".cxx", ".c++", ".c"], ".hxx" : [".cxx", ".cpp", ".c++", ".c"], ".h++" : [".c++", ".cxx", ".cpp", ".c"] }

if exists('g:relatedfile_user_dict')
    call extend(g:relatedfile_dict, g:relatedfile_user_dict)
endif

python << PYEOF

import vim
from os import path

def open_related_file():
    rf_dict = vim.eval("g:relatedfile_dict")
    fname = vim.eval("expand('%')")
    sua = vim.eval("&sua")
    vim.command("setl sua=")
    try:
        dir = path.dirname(fname)
        base, ext = path.splitext(path.basename(fname))
        relatedexts = rf_dict.get(ext.lower())
        if not relatedexts:
            return
        files = []
        for rext in relatedexts:
            # find file in 'path'
            ret = vim.eval('findfile("%s%s")' % (base, rext))
            if ret:
                if ret.startswith("\\") and not path.isfile(ret):
                    # on Windows no root in path, maybe a bug
                    ret = vim.eval("pwd")[:2] + ret
                vim.command("edit " + ret.replace(" ", r"\ "))
                return
    finally:
        vim.command("setl sua=" + sua)



PYEOF

command! OpenRelatedFile python open_related_file() 
