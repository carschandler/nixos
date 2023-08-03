require('user/options')
require('user/keybinds')
require('user/launch_lazy')

if os.getenv('WSL_DISTRO_NAME') ~= nil then
  require('user/wsl_clipboard')
end
