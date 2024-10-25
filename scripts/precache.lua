local AddScriptsFromFolderUtils = {}
local precachedShit = {}

local precacheAsset = function(sprite, sprType)
  if sprite == '' or sprite == nil or sprType == '' or sprType == nil then return end
  if sprite:match('.*%.%.') or sprite:match('%(.-%)') then debugPrint('Warning: '..sprite..' looks like it might contain variables or functions, it might not precache correctly!'); end
  local s, e = pcall(function() (getfenv and getfenv() or _ENV or _G)['precache'..sprType or 'Image'](sprite) end);
  if not s then debugPrint(e); end
end

local precacheFromScript = function(stage)
  if stage == '' or stage == nil then return end
  local file = checkFileExists(stage..'.lua') and getTextFromFile(stage..'.lua') or getTextFromFile(stage);
  for charChange in file:gmatch('triggerEvent%((.-)%)[%s;]') do if charChange:match('\'([^\']+)\'') == 'Change Character' then addCharacterToList(charChange:match('.*, \'([^\']+)\'$'), charChange:gsub('.*\',%s?\'([^\']+)\',.*', '%1')); end end
  for object in file:gmatch('makeLuaSprite%((.-)%)[%s;]') do precacheAsset(object:match('\',%s?\'([^\']+)\''), 'Image'); end
  for animedObj in file:gmatch('makeAnimatedLuaSprite%((.-)%)[%s;]') do precacheAsset(animedObj:match('\',%s?\'([^\']+)\''), 'Image'); end
  for graphic in file:gmatch('loadGraphic%((.-)%)[%s;]') do precacheAsset(graphic:match('\',%s?\'([^\']+)\''), 'Image'); end
  for sound in file:gmatch('playSound%((.-)%)[%s;]') do precacheAsset(sound:match('\'(.-)\''), 'Sound'); end
  for music in file:gmatch('playMusic%((.-)%)[%s;]') do precacheAsset(music:match('\'(.-)\''), 'Music'); end
end

AddScriptsFromFolderUtils.addScriptsFromFolder = function(folder, allowPrint)
  local allowPrint = allowPrint or false
  local dirFolder = directoryFileList('mods/'..currentModDirectory..(folder == '' or folder == nil and '' or '/'..folder) or 'mods'..(folder == '' or folder == nil and '' or '/'..folder));
  for index, stages in pairs(dirFolder) do
    if stages:match('%.lua$') then
      local file = stages:sub(1, -5);
      local dir = (folder == '' or folder == nil and '' or folder..'/')..file
      precacheFromScript(dir);
      addLuaScript(dir);
      table.insert(precachedShit, {file, dir});
      if allowPrint then debugPrint('['..file..','..dir..'] - Script added and cached its contents!'); end
    end
  end
end

return {AddScriptsFromFolderUtils, precachedShit}