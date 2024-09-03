return {
	{
		"fatih/vim-go",
		config = function()
			vim.g.go_highlight_operators =1
			vim.g.go_highlight_function_calls =1
			vim.g.go_highlight_types =1
			vim.g.go_highlight_functions =1
			vim.g.go_highlight_fields =1
			vim.g.go_doc_popup_window = 1
			vim.g.go_echo_command_info = 0
		end,

	},

}

