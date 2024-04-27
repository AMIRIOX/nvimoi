-- open a panel
-- compile: source_file -> executable_file
-- input data set: copy-paste/from-file
-- then execute file & show output (plain text)
-- ask if the output is correct (y/n) (modifying is supported)
-- run loop: offer new data set option
--
-- press <keycode_1> to run a test (compile + open a panel + (show error) + loop {input + exe-output + ask} )
-- press <keycode_2> enter modifying mode: (choose a data set by number + del/rev)
--
-- // wait
-- remember to process program error (infinity output/no output(title: running) ..)
-- compare from file
--
--// TODO
-- changed <m> to "toggle panel with test running again"
-- gotta try to show something on the buffer (and impl input-action)


local api = vim.api
local buf, win, title

local function open_panel()
    local width = api.nvim_get_option('columns')
    local height =api.nvim_get_option('lines')

    local panel_width = math.ceil(width * 0.8)
    local panel_height = math.ceil(height * 0.8 - 4)

    local row = math.ceil((height - panel_height) / 2 - 1)
    local col = math.ceil((width - panel_height) / 2)

    local opts = {
        style = 'minimal',
        relative = 'editor',
        width = panel_width,
        height = panel_height,
        row = row,
        col = col
    }

    win = api.nvim_open_win(buf, true, opts)
end

local function set_mappings()
    local mappings = {
        m = 'test()',
        t = 'close()',
    }

    for k, v in pairs(mappings) do
        api.nvim_set_keymap('n', k, ':lua require"nvimoi".'..v..'<cr>', {
            nowait = true, noremap = true, silent = true
        })
    end
end

local function close()
    api.nvim_win_close(win, true)
end

local function set_file_name(file_name) 
    local idx = file_name:match(".+()%.%w+$")
    if idx then
        return file_name:sub(1, idx - 1)
    else
        return file_name
    end
end
    
local function test()
    local source_path = vim.fn.expand('%:p')
    local file_name = set_file_name(vim.fn.expand('%:t'))
    open_panel()
    local res = vim.fn.systemlist('g++ '..source_path..' -o '..file_name)
    print('g++ '..source_path..' -o '..file_name)
end

local function setup()
    buf = api.nvim_create_buf(false, true)
    api.nvim_buf_set_option(buf, 'bufhidden', 'wipe')
    set_mappings()
end

return {
    open_panel = open_panel,
    test = test,
    close = close,
    set_mappings = set_mappings,
    set_file_name = set_file_name,
    setup = setup
}
