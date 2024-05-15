# Import the class
import ranger.gui.context

# Or use an array for multiple names
my_keys = ['code', 'readme', 'license', 'git']
ranger.gui.context.CONTEXT_KEYS.extend(my_keys)

# Set them to False
for key in my_keys:
    code = 'ranger.gui.context.Context.' + key + ' = False'
    exec(code)

code_exts = [
    'a'        ,
    'ai'       ,
    'asm'      ,
    'asp'      ,
    'aup'      ,
    'avi'      ,
    'bat'      ,
    'bmp'      ,
    'bz2'      ,
    'c'        ,
    'c++'      ,
    'cab'      ,
    'cbr'      ,
    'cbz'      ,
    'cc'       ,
    'class'    ,
    'clj'      ,
    'cljc'     ,
    'cljs'     ,
    'cmake'    ,
    'coffee'   ,
    'conf'     ,
    'cp'       ,
    'cpio'     ,
    'cpp'      ,
    'cs'       ,
    'css'      ,
    'cue'      ,
    'cvs'      ,
    'cxx'      ,
    'd'        ,
    'dart'     ,
    'db'       ,
    'deb'      ,
    'diff'     ,
    'dll'      ,
    'dump'     ,
    'edn'      ,
    'efi'      ,
    'ejs'      ,
    'elf'      ,
    'elm'      ,
    'erl'      ,
    'ex'       ,
    'exs'      ,
    'eex'      ,
    'f#'       ,
    'fish'     ,
    'flv'      ,
    'fs'       ,
    'fsi'      ,
    'fsscript' ,
    'fsx'      ,
    'gem'      ,
    'go'       ,
    'h'        ,
    'hbs'      ,
    'hrl'      ,
    'hs'       ,
    'htaccess' ,
    'htpasswd' ,
    'htm'      ,
    'html'     ,
    'ico'      ,
    'java'     ,
    'jl'       ,
    'js'       ,
    'json'     ,
    'jsx'      ,
    'key'      ,
    'less'     ,
    'lha'      ,
    'lhs'      ,
    'log'      ,
    'lua'      ,
    'lzh'      ,
    'lzma'     ,
    'ml'       ,
    'mli'      ,
    'msi'      ,
    'mustache' ,
    'o'        ,
    'ogg'      ,
    'php'      ,
    'pl'       ,
    'pm'       ,
    'psb'      ,
    'psd'      ,
    'py'       ,
    'pyc'      ,
    'pyd'      ,
    'pyo'      ,
    'rb'       ,
    'rc'       ,
    'rlib'     ,
    'rom'      ,
    'rpm'      ,
    'rs'       ,
    'rss'      ,
    'rtf'      ,
    's'        ,
    'so'       ,
    'scala'    ,
    'scss'     ,
    'sh'       ,
    'slim'     ,
    'sln'      ,
    'sql'      ,
    'styl'     ,
    'suo'      ,
    't'        ,
    'tgz'      ,
    'ts'       ,
    'twig'     ,
    'vim'      ,
    'vimrc'    ,
    'xbps'     ,
    'xhtml'    ,
    'xls'      ,
    'xlsx'     ,
    'xml'      ,
    'xul'      ,
    'xz'       ,
    'yaml'     ,
    'yml'      ,
]


import ranger.gui.widgets.browsercolumn

OLD_HOOK_BEFORE_DRAWING = ranger.gui.widgets.browsercolumn.hook_before_drawing

def new_hook_before_drawing(fsobject, color_list):
    if fsobject.basename_without_extension and fsobject.extension:
        #readme
        if fsobject.basename_without_extension.lower() == 'readme' \
            and fsobject.extension.lower() in ['md', 'rst']:
            color_list.append('readme')
        #license
        elif fsobject.basename_without_extension.lower() == 'license' \
            or fsobject.extension.lower() in ['lic']:
            color_list.append('license')
        #code
        elif fsobject.extension.lower() in code_exts:
            color_list.append('code')
        #git
        elif 'git' in fsobject.extension.lower():
            color_list.append('git')

    return OLD_HOOK_BEFORE_DRAWING(fsobject, color_list)

ranger.gui.widgets.browsercolumn.hook_before_drawing = new_hook_before_drawing
