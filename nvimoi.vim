if exists('g:loaded_nvimoi.vim') | finish | endif

let s:save_cpo = &cpo
set cpo&vim

command! oitest lua require'nvimoi'.test()

let &cpo = s:save_cpo
unlet s:save_cpo

let g:loaded_nvimoi = 1
