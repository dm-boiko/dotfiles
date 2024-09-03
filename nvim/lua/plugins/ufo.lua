return {
	{
		"kevinhwang91/nvim-ufo",
		event = { "BufReadPost", "BufNewFile" },
		dependencies = { "kevinhwang91/promise-async", event = "BufReadPost" },
		opts = {
			open_fold_hl_timeout = 400,
		},
		keys = {
			--   { "fd", "zd", desc = "Delete fold under cursor" },
			--   { "fo", "zo", desc = "Open fold under cursor" },
			--   { "fO", "zO", desc = "Open all folds under cursor" },
			--   { "fc", "zC", desc = "Close all folds under cursor" },
			--   { "fa", "za", desc = "Toggle fold under cursor" },
			--   { "fA", "zA", desc = "Toggle all folds under cursor" },
			--   { "fv", "zv", desc = "Show cursor line" },
			{
				"zM",
				function()
					require("ufo").closeAllFolds()
				end,
				desc = "Close all folds",
			},
			--   {
			-- 	"fR",
			-- 	function()
			-- 	  require("ufo").openAllFolds()
			-- 	end,
			-- 	desc = "Open all folds",
			--   },
			--   { "fm", "zm", desc = "Fold more" },
			--   { "fr", "zr", desc = "Fold less" },
			--   { "fx", "zx", desc = "Update folds" },
			--   { "fz", "zz", desc = "Center this line" },
			--   { "ft", "zt", desc = "Top this line" },
			--   { "fb", "zb", desc = "Bottom this line" },
			--   { "fg", "zg", desc = "Add word to spell list" },
			--   { "fw", "zw", desc = "Mark word as bad/misspelling" },
			--   { "fe", "ze", desc = "Right this line" },
			--   { "fE", "zE", desc = "Delete all folds in current buffer" },
			--   { "fs", "zs", desc = "Left this line" },
			--   { "fH", "zH", desc = "Half screen to the left" },
			--   { "fL", "zL", desc = "Half screen to the right" },
		},
	}
}
