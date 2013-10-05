local frame = CreateFrame("Frame", nil, InterfaceOptionsFramePanelContainer)
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
  
  local slotOne = tekcheck.new(self, nil, "Swap pets in slot one", "TOPLEFT", swapMin, "BOTTOMLEFT", -2, -GAP * 2)
  slotOne.tiptext = "Enable or disable swapping of pets in slot one."
  slotOne:SetChecked(PetSwapperDB.slotOne)
  local checksound = slotOne:GetScript("OnClick")
  slotOne:SetScript("OnClick", function(self)
    checksound(self)
    PetSwapperDB.slotOne = not PetSwapperDB.slotOne
  end)
  
  local slotTwo = tekcheck.new(self, nil, "Swap pets in slot two", "TOPLEFT", slotOne, "BOTTOMLEFT", -2, -GAP)
  slotTwo.tiptext = "Enable or disable swapping of pets in slot two."
  slotTwo:SetChecked(PetSwapperDB.slotTwo)
  local checksound = slotTwo:GetScript("OnClick")
  slotTwo:SetScript("OnClick", function(self)
    checksound(self)
    PetSwapperDB.slotTwo = not PetSwapperDB.slotTwo
  end)
  
  local slotThree = tekcheck.new(self, nil, "Swap pets in slot three", "TOPLEFT", slotTwo, "BOTTOMLEFT", -2, -GAP)
  slotThree.tiptext = "Enable or disable swapping of pets in slot three."
  slotThree:SetChecked(PetSwapperDB.slotThree)
  local checksound = slotThree:GetScript("OnClick")
  slotThree:SetScript("OnClick", function(self)
    checksound(self)
    PetSwapperDB.slotThree = not PetSwapperDB.slotThree
  end)
  
  self:SetScript("OnShow", nil)
end)

InterfaceOptions_AddCategory(frame)
