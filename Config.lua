local frame = CreateFrame("Frame", "PSConfig", InterfaceOptionsFramePanelContainer)
frame.name = "Pet Swapper"
frame:Hide()

frame:SetScript("OnShow", function(self)
  local GAP, EDGEGAP = 8, 16
  local tekcheck = LibStub("tekKonfig-Checkbox")
  local tekslide = LibStub("tekKonfig-Slider")

  local title, subtitle = LibStub("tekKonfig-Heading").new(self, "Pet Swapper", "Control how your battle pets are swapped between battles.")

  local isEnabled = tekcheck.new(self, nil, "Enable pet swapping?", "TOPLEFT", subtitle, "BOTTOMLEFT", -2, -GAP)
  isEnabled.tiptext = "Enable or disable swapping."
  isEnabled:SetChecked(PetSwapperDB.isEnabled)
  local checksound = isEnabled:GetScript("OnClick")
  isEnabled:SetScript("OnClick", function(self)
    checksound(self)
    PetSwapperDB.isEnabled = not PetSwapperDB.isEnabled
  end)
  
  local swapMin = tekslide.new(self, "Minimum Level", 1, 25, "TOPLEFT", isEnabled, "BOTTOMLEFT", -2, -GAP)
  swapMin.tiptext = "Minimum pet level to keep in swapped slots."
  swapMin:SetValue(PetSwapperDB.swapMin)
  swapMin.val = swapMin:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
  swapMin.val:SetPoint("TOP", swapMin, "BOTTOM", 0, 3)
  swapMin.val:SetFormattedText("%.0f", swapMin:GetValue())
  swapMin:SetScript("OnValueChanged", function(self)
    swapMin.val:SetFormattedText("%.0f", swapMin:GetValue())
    PetSwapperDB.swapMin = swapMin:GetValue()
  end)
  
  local swapMax = tekslide.new(self, "Maximum Level", 1, 25, "TOPLEFT", swapMin, "TOPRIGHT", 20, 11)
  swapMax.tiptext = "Maximum pet level to keep in swapped slots."
  swapMax:SetValue(PetSwapperDB.swapMax)
  swapMax.val = swapMax:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
  swapMax.val:SetPoint("TOP", swapMax, "BOTTOM", 0, 3)
  swapMax.val:SetFormattedText("%.0f", swapMax:GetValue())
  swapMax:SetScript("OnValueChanged", function(self)
    swapMax.val:SetFormattedText("%.0f", swapMax:GetValue())
    PetSwapperDB.swapMax = swapMax:GetValue()
  end)
  
  local slotOne = tekcheck.new(self, nil, "Auto-swap pets in slot one", "TOPLEFT", swapMin, "BOTTOMLEFT", -2, -GAP * 2)
  slotOne.tiptext = "Enable or disable swapping of pets in slot one."
  slotOne:SetChecked(PetSwapperDB.slotOne)
  local checksound = slotOne:GetScript("OnClick")
  slotOne:SetScript("OnClick", function(self)
    checksound(self)
    PetSwapperDB.slotOne = not PetSwapperDB.slotOne
  end)
  
  local slotTwo = tekcheck.new(self, nil, "Auto-swap pets in slot two", "TOPLEFT", slotOne, "BOTTOMLEFT", -2, -GAP)
  slotTwo.tiptext = "Enable or disable swapping of pets in slot two."
  slotTwo:SetChecked(PetSwapperDB.slotTwo)
  local checksound = slotTwo:GetScript("OnClick")
  slotTwo:SetScript("OnClick", function(self)
    checksound(self)
    PetSwapperDB.slotTwo = not PetSwapperDB.slotTwo
  end)
  
  local slotThree = tekcheck.new(self, nil, "Auto-swap pets in slot three", "TOPLEFT", slotTwo, "BOTTOMLEFT", -2, -GAP)
  slotThree.tiptext = "Enable or disable swapping of pets in slot three."
  slotThree:SetChecked(PetSwapperDB.slotThree)
  local checksound = slotThree:GetScript("OnClick")
  slotThree:SetScript("OnClick", function(self)
    checksound(self)
    PetSwapperDB.slotThree = not PetSwapperDB.slotThree
  end)

  function labelForPet(customName, speciesName, level)
    if customName then
      return customName .. " (" .. level .. " " .. speciesName ..")"
    else
      return speciesName .. " (" .. level ..")"
    end
  end

  local slotOneDropDown = CreateFrame("FRAME", "PSConfigSlotOneFixDropDown", self, "UIDropDownMenuTemplate")
  slotOneDropDown:SetPoint("LEFT", slotOne, "RIGHT", 200, 0)

  function slotOneDropDown:SetValue(newValue, label)
    PetSwapperDB.slotOneFix = newValue
    UIDropDownMenu_SetSelectedValue(slotOneDropDown, newValue)
    UIDropDownMenu_SetText(slotOneDropDown, label)
  end
  UIDropDownMenu_SetWidth(slotOneDropDown, 200)
  UIDropDownMenu_SetText(slotOneDropDown, "Choose pet for slot one...")
  UIDropDownMenu_Initialize(slotOneDropDown, function(self, level, menuList)
    local selected, info = UIDropDownMenu_GetSelectedValue(slotOneDropDown) or PetSwapperDB.slotOneFix, UIDropDownMenu_CreateInfo()    
    info.text = "None..."
    info.value = nil
    info.arg1 = nil
    info.arg2 = "None..."
    info.checked = selected == nil
    info.func = self.SetValue
    UIDropDownMenu_AddButton(info)
    for index = 1, select(2, C_PetJournal.GetNumPets()) do
      local petGUID, _, _, customName, level, favorite, _, speciesName = C_PetJournal.GetPetInfoByIndex(index)
      local label = labelForPet(customName, speciesName, level)
      if petGUID == selected then UIDropDownMenu_SetText(slotOneDropDown, label) end
      if favorite and level == 25 then
        info.text = label
        info.value = petGUID
        info.arg1 = petGUID
        info.arg2 = label
        info.checked = petGUID == selected
        info.func = self.SetValue
        UIDropDownMenu_AddButton(info)
      end
    end
  end)
  
  local slotTwoDropDown = CreateFrame("FRAME", "PSConfigSlotTwoFixDropDown", self, "UIDropDownMenuTemplate")
  slotTwoDropDown:SetPoint("LEFT", slotTwo, "RIGHT", 200, 0)

  function slotTwoDropDown:SetValue(newValue, label)
    PetSwapperDB.slotTwoFix = newValue
    UIDropDownMenu_SetSelectedValue(slotTwoDropDown, newValue)
    UIDropDownMenu_SetText(slotTwoDropDown, label)
  end
  UIDropDownMenu_SetWidth(slotTwoDropDown, 200)
  UIDropDownMenu_SetText(slotTwoDropDown, "Choose pet for slot two...")
  UIDropDownMenu_Initialize(slotTwoDropDown, function(self, level, menuList)
    local selected, info = UIDropDownMenu_GetSelectedValue(slotTwoDropDown) or PetSwapperDB.slotTwoFix, UIDropDownMenu_CreateInfo()    
    info.text = "None..."
    info.value = nil
    info.arg1 = nil
    info.arg2 = "None..."
    info.checked = selected == nil
    info.func = self.SetValue
    UIDropDownMenu_AddButton(info)
    for index = 1, select(2, C_PetJournal.GetNumPets()) do
      local petGUID, _, _, customName, level, favorite, _, speciesName = C_PetJournal.GetPetInfoByIndex(index)
      local label = labelForPet(customName, speciesName, level)
      if petGUID == selected then UIDropDownMenu_SetText(slotTwoDropDown, label) end
      if favorite and level == 25 then
        info.text = label
        info.value = petGUID
        info.arg1 = petGUID
        info.arg2 = label
        info.checked = petGUID == selected
        info.func = self.SetValue
        UIDropDownMenu_AddButton(info)
      end
    end
  end)
  
  local slotThreeDropDown = CreateFrame("FRAME", "PSConfigSlotThreeFixDropDown", self, "UIDropDownMenuTemplate")
  slotThreeDropDown:SetPoint("LEFT", slotThree, "RIGHT", 200, 0)

  function slotThreeDropDown:SetValue(newValue, label)
    PetSwapperDB.slotThreeFix = newValue
    UIDropDownMenu_SetSelectedValue(slotThreeDropDown, newValue)
    UIDropDownMenu_SetText(slotThreeDropDown, label)
  end
  UIDropDownMenu_SetWidth(slotThreeDropDown, 200)
  UIDropDownMenu_SetText(slotThreeDropDown, "Choose pet for slot three...")
  UIDropDownMenu_Initialize(slotThreeDropDown, function(self, level, menuList)
    local selected, info = UIDropDownMenu_GetSelectedValue(slotThreeDropDown) or PetSwapperDB.slotThreeFix, UIDropDownMenu_CreateInfo()    
    info.text = "None..."
    info.value = nil
    info.arg1 = nil
    info.arg2 = "None..."
    info.checked = selected == nil
    info.func = self.SetValue
    UIDropDownMenu_AddButton(info)
    for index = 1, select(2, C_PetJournal.GetNumPets()) do
      local petGUID, _, _, customName, level, favorite, _, speciesName = C_PetJournal.GetPetInfoByIndex(index)
      local label = labelForPet(customName, speciesName, level)
      if petGUID == selected then UIDropDownMenu_SetText(slotThreeDropDown, label) end
      if favorite and level == 25 then
        info.text = label
        info.value = petGUID
        info.arg1 = petGUID
        info.arg2 = label
        info.checked = petGUID == selected
        info.func = self.SetValue
        UIDropDownMenu_AddButton(info)
      end
    end
  end)

  self:SetScript("OnShow", nil)
end)

InterfaceOptions_AddCategory(frame)
