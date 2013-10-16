local defaults, db = {
  isEnabled    = true,
  swapMin      = 1,
  swapMax      = 25,
  slotOne      = true,
  slotTwo      = true,
  slotThree    = false,
  slotOneFix   = nil,
  slotTwoFix   = nil,
  slotThreeFix = nil,
}

local frame, swapping = CreateFrame("Frame"), false

frame:SetScript("OnEvent", function(self, event, ...)
  if self[event] then return self[event](self, ...); end
end)

frame:RegisterEvent("ADDON_LOADED")
function frame:ADDON_LOADED(addon)
  if addon:lower() ~= "petswapper" then return end

  PetSwapperDB = setmetatable(PetSwapperDB or {}, {__index = defaults})
  db = PetSwapperDB

  LibStub("tekKonfig-AboutPanel").new("Pet Swapper", "PetSwapper")

  self:UnregisterEvent("ADDON_LOADED")
  self.ADDON_LOADED = nil

  self:RegisterEvent("PLAYER_LOGOUT")
end

function frame:PLAYER_LOGOUT()
  for i,v in pairs(defaults) do if db[i] == v then db[i] = nil end end
end

frame:RegisterEvent("PET_JOURNAL_LIST_UPDATE")
function frame:PET_JOURNAL_LIST_UPDATE()
  if db.isEnabled and not swapping then
    swapping = true
    swapped = { false, false, false }
    for slot = 1, 3 do
      local petGUID, ability1, ability2, ability3, locked = C_PetJournal.GetPetLoadOutInfo(slot)
      if petGUID then
        local _, _, level, _, _, _, _, name = C_PetJournal.GetPetInfoByPetID(petGUID)
        if level < db.swapMin or level >= db.swapMax and ((slot == 1 and db.slotOne) or (slot == 2 and db.slotTwo) or (slot == 3 and db.slotThree)) then
          for index = 1, select(2, C_PetJournal.GetNumPets()) do
            if not swapped[slot] then
              local _petGUID, _, _, _, _level, _favorite, _, _speciesName = C_PetJournal.GetPetInfoByIndex(index)
              if _favorite and _level >= db.swapMin and _level < db.swapMax then
                if _petGUID ~= C_PetJournal.GetPetLoadOutInfo(1) and
                   _petGUID ~= C_PetJournal.GetPetLoadOutInfo(2) and
                   _petGUID ~= C_PetJournal.GetPetLoadOutInfo(3) and not locked then
                  print('Swapping out ' .. name .. ' (' .. level .. ') for ' .. _speciesName .. ' (' .. _level .. ')' ..' in slot ' .. slot .. '.')
                  C_PetJournal.SetPetLoadOutInfo(slot, _petGUID)
                  swapped[slot] = true
                end
              end
            end
          end
        end
      end
    end
    if not db.slotOne   and db.slotOneFix   then C_PetJournal.SetPetLoadOutInfo(1, db.slotOneFix)   end
    if not db.slotTwo   and db.slotTwoFix   then C_PetJournal.SetPetLoadOutInfo(2, db.slotTwoFix)   end
    if not db.slotThree and db.slotThreeFix then C_PetJournal.SetPetLoadOutInfo(3, db.slotThreeFix) end
    swapping = false
  end
end
