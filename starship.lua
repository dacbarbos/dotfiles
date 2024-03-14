--[[
Clink+Starship integration!
https://chrisant996.github.io/clink/clink.html#starship
# copy THIS.file to %USERPROFILE%\AppData\Local\clink\
--]]
load(io.popen('starship.exe init cmd'):read("*a"))()