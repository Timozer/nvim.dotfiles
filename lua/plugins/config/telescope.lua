local M = {}

function M.config()

    local maps = {
        -- Telescope lhsmaps
        {
            mode = "n",
            lhs = "<leader>ff",
            rhs = ":Telescope find_files<cr>",
            options = {
                noremap = true,
            }
        },
        {
            mode = "n",
            lhs = "<leader>fb",
            rhs = ":Telescope buffers<cr>",
            options = {
                noremap = true,
            }
        },
        {
            mode = "n",
            lhs = "<leader>fg",
            rhs = ":Telescope live_grep<cr>",
            options = {
                noremap = true,
            }
        },
        {
            mode = "n",
            lhs = "<leader>fh",
            rhs = ":Telescope help_tags<cr>",
            options = {
                noremap = true,
            }
        },
    }

    require('core').SetKeymaps(maps)

    local actions = require('telescope.actions')

    require('telescope').setup{
        defaults = {
            mappings = {
                i = {
                    ["<C-j>"] = actions.move_selection_next,
                    ["<C-k>"] = actions.move_selection_previous,

                    ["<C-c>"] = actions.close,

                    ["<CR>"] = actions.select_default,
                    ["<C-s>"] = actions.select_horizontal,
                    ["<C-]>"] = actions.select_vertical,

                    ["<PageUp>"] = actions.preview_scrolling_up,
                    ["<PageDown>"] = actions.preview_scrolling_down,

                    ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
                    ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
                    ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
                    ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
                    ["<C-l>"] = actions.complete_tag,
                },

                n = {
                    ["<esc>"] = actions.close,
                    ["<CR>"] = actions.select_default,
                    ["<C-s>"] = actions.select_horizontal,
                    ["<C-]>"] = actions.select_vertical,

                    ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
                    ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
                    ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
                    ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,

                    -- TODO: This would be weird if we switch the ordering.
                    ["j"] = actions.move_selection_next,
                    ["k"] = actions.move_selection_previous,
                    ["H"] = actions.move_to_top,
                    ["M"] = actions.move_to_middle,
                    ["L"] = actions.move_to_bottom,
                    ["gg"] = actions.move_to_top,
                    ["G"] = actions.move_to_bottom,

                    ["<PageUp>"] = actions.preview_scrolling_up,
                    ["<PageDown>"] = actions.preview_scrolling_down,

                    ["?"] = actions.which_key,
                },
            }
        }
    }
return maps

end

return M