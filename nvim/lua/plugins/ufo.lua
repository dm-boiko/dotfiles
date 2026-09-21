return {
	{
		"kevinhwang91/nvim-ufo",
		event = { "BufReadPost", "BufNewFile" },
		dependencies = { "kevinhwang91/promise-async", event = "BufReadPost" },
		opts = { open_fold_hl_timeout = 400 },
		keys = {
			{ "zM", function() require("ufo").closeAllFolds() end, desc = "Close all folds" },
		},
	}
}
