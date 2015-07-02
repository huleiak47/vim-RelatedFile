vim-RelatedFile
===============

Open related file of current file.

Use command `:OpenRelatedFile<CR>` to open related file. The default map is
between C/C++ header files and source files. You can customize it by adding
a dict `g:relatedfile_user_dict` to the .vimrc file. For example:

```
let g:relatedfile_user_dict = {".md" : [".html"], ".html" : [".md"]}
```
