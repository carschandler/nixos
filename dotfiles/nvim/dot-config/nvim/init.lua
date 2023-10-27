vim.g.mapleader = ';'

-- Classic vim options
require('user/options')

-- Start Lazy and load plugins
require('user/launch_lazy')

-- Non-plugin keymaps
require('user/keymaps')

-- Note: the leader key must be mapped before Lazy is launched, so user/keymaps
-- needs to be loaded before user/launch_lazy (or the leader could be set in its
-- own module or right here in the init.lua... because of this, we cannot set
-- plugin-dependent keymaps inside user/keymaps, and instead these occur inside
-- the config function of the module for that plugin

-- On WSL, we need to set up the system clipboard copy/paste functions
if not vim.g.vscode then
  if os.getenv('WSL_DISTRO_NAME') ~= nil then
    require('user/wsl')
  end
end
