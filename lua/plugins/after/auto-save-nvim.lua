return {
	"Pocco81/auto-save.nvim",
	config = function()
		 require("auto-save").setup {
			enabled = true, -- start auto-save when the plugin is loaded (i.e. when your package manager loads it)
			execution_message = {
				message = function() -- message to print on save
					return ("AutoSave: saved at " .. vim.fn.strftime("%H:%M:%S"))
				end,
				-- message = nil,
				dim = 0.18, -- dim the color of `message`
				cleaning_interval = 1250, -- (milliseconds) automatically clean MsgArea after displaying `message`. See :h MsgArea
			},
			trigger_events = {"InsertLeave", "TextChanged"}, -- vim events that trigger auto-save. See :h events
			-- function that determines whether to save the current buffer or not
			-- return true: if buffer is ok to be saved
			-- return false: if it's not ok to be saved
			condition = function(buf)
				local fn = vim.fn
				local utils = require("auto-save.utils.data")
				-- local function is_good_filetype()
				-- 	if vim.fn.expand('%') == "Table of contents (VimTeX)" or not vim.fn.filereadable(vim.api.nvim_buf_get_name(0)) then -- this is bad
				-- 		return false
				-- 	elseif vim.bo.filetype() == "markdown" or
				-- 		vim.bo.filetype() == "tex" then
				-- 		return true
				-- 	end
				--
				-- 	return false
				-- end
				local function is_good_filetype()
					local filetype =  vim.api.nvim_buf_get_option(buf, 'filetype') -- why is this deprecated, the other one crashes the editor
						return filetype == "tex" or filetype == "markdown"
				end

				return fn.getbufvar(buf, "&modifiable") == 1 and
					(vim.api.nvim_get_mode().mode ~= 'i' or vim.api.nvim_get_mode().mode ~= 'ic') and
					utils.not_in(fn.getbufvar(buf, "&filetype"), {}) and
					is_good_filetype()
			end,
			write_all_buffers = false, -- write all buffers when the current one meets `condition`
			debounce_delay = 1000, -- saves the file at most every `debounce_delay` milliseconds
			callbacks = { -- functions to be executed at different intervals
				enabling = nil, -- ran when enabling auto-save
				disabling = nil, -- ran when disabling auto-save
				before_asserting_save = nil, -- ran before checking `condition`
				before_saving = nil, -- ran before doing the actual save
				after_saving = nil -- ran after doing the actual save
			}
		}

		-- vim.api.nvim_set_keymap("n", "<leader>n", ":ASToggle<CR>", {"Toggle auto-save"})
	end,
}
