"==================================================
" File:         relatedfile.vim
" Brief:        Open related file of current file.
" Authors:      Hulei <huleiak47@gmail.com>,
" Last Change:  2014-12-01 12:38:26
" Version:      1.0
"
" Usage:        use command :OpenRelatedFile<CR> or map it.
" Options:      g:relatedfile_user_dict
"==================================================

if exists("g:relatedfile_loaded") || !has("python")
    finish
endif

let g:relatedfile_loaded = 1

let g:relatedfile_dict = { ".c" : [".h", ".hpp", ".hxx", ".h++"],  ".cpp" : [".hpp", ".hxx", ".h++", ".h"], ".cxx" : [".hxx", ".hpp", ".h++", ".h"], ".c++" : [".h++", ".hxx", ".hpp", ".h"], ".h" : [".c", ".cpp", ".cxx", ".c++"], ".hpp" : [".cpp", ".cxx", ".c++", ".c"], ".hxx" : [".cxx", ".cpp", ".c++", ".c"], ".h++" : [".c++", ".cxx", ".cpp", ".c"] }

if exists('g:relatedfile_user_dict')
    call extend(g:relatedfile_dict, g:relatedfile_user_dict)
endif

python << PYEOF

import vim
from os import path

def open_related_file():
    rf_dict = vim.eval("g:relatedfile_dict")
    fname = vim.eval("expand('%:p')")
    dir = path.dirname(fname)
    base, ext = path.splitext(path.basename(fname))
    relatedexts = rf_dict.get(ext.lower())
    if not relatedexts:
        return
    files = []
    for f in os.listdir(dir):
        fp = path.join(dir, f)
        fbase, fext = path.splitext(f)
        if path.isfile(fp) and fbase == base and fext.lower() in relatedexts:
            files.append((relatedexts.index(fext.lower()), fp))
    if files:
        files.sort()
        vim.command("edit " + files[0][1].replace(" ", r"\ "))



PYEOF

command! OpenRelatedFile python open_related_file() 
