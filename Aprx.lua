-- gg.TYPE_DWORD ( int ) = 4
-- gg.TYPE_FLOAT ( float ) = 16
-- gg.TYPE_DOUBLE ( double ) = 64
-- gg.TYPE_BYTE ( bool ) = 1
-- gg.TYPE_QWORD ( long ) = 32
-- gg.refineNumber(999, 16) = value + type
-- gg.getResults(99)
-- gg.clearResults()
-- gg.editAll(9999,16) = value + type
-- public class
-- public float
----
local PASSCODE = "1430"
local MAX_TRIES = 3

function passcodeLogin()
    for i = 1, MAX_TRIES do
        local input = gg.prompt({"Code:"}, nil, {"number"})
        if not input then
            gg.alert("Cancelled")
            os.exit()
        end
        if tostring(input[1]) == PASSCODE then
            gg.toast("✔️")
            return true
        else
            gg.alert("⚠️ (" .. i .. "/" .. MAX_TRIES .. ")")
        end
    end
    gg.alert("🚫🚫🚫")
    os.exit()
end
passcodeLogin()
----
local version = 3
local whatsNew=[[
━━━━━━━━━━━━━━━━━━━━━━━━━━━
⌅  Script Version 3
⌅  Field Offset Version 4
⌅  Current Game Version 0.9.42
⌅  Update Sys Source: GitHub.com
⌅  Experimental
━━━━━━━━━━━━━━━━━━━━━━━━━━━
⌂  17 Nov, 2025 12:07 AM
 ChangeLog:
  ∷  Bypass Electric car speed limitor  
___________________________________________
≔  globalmetadata.dat   
≔  ilbil2cpp.so
≔  dump.cs
≔  unity
≔  APEX racer x64
]]
----
gg.alert(whatsNew)
----
function selectMode()
    local mode = gg.choice(
        {"Field Offset Finder", "APEX Racer", "Quick HP & Rpm Tuning", "OFF", "Exit"},
        nil,
        "Select Mode"
    )

    if mode == nil or mode == 5 then
        gg.toast("Exiting")
        gg.setVisible(true)
        os.exit()  
    end

    return mode
end
userMode = selectMode()

----
function HideIcon()
    gg.setVisible(false)
    while true do
        if gg.isVisible(true) then
            gg.setVisible(false)
            selectMode()
            break
        end
        gg.sleep(100)
    end
end
----
function HideIcon2()
    gg.setVisible(false)
    while true do
        if gg.isVisible(true) then
            gg.setVisible(false)
            mainMenu()
            break
        end
        gg.sleep(100)
    end
end
----
local function ViewSavelist()
    if type(Savelist) ~= "table" or #Savelist == 0 then
        gg.toast("SaveList Empty")
        mainMenu()
        return
    end
    local listStrings = {}
    for i, v in ipairs(Savelist) do
        local name = tostring(v.name or ("Entry " .. i))
        local value = tostring(v.value or "")
        listStrings[i] = name .. " = " .. value
    end
    listStrings[#listStrings + 1] = "Back"
    local choice = gg.choice(listStrings, nil, "List:")
    if not choice or choice == #listStrings then 
        mainMenu()
        return
    end
    local selected = Savelist[choice]
    if type(selected) ~= "table" then
        gg.toast("Err")
        mainMenu()
        return
    end
    if not selected.results then
        gg.toast("Err" .. tostring(selected.name or choice))
        mainMenu()
        return
    end
    if selected.flags == nil then
        gg.toast("Err" .. tostring(selected.name or choice))
        mainMenu()
        return
    end
    local inputValue = gg.prompt(
        {":".. tostring(selected.name or (":".. choice))},
        {tostring(selected.value or ":")},
        {selected.flags}
    )
    if not inputValue then 
        mainMenu()  
        return 
    end
    local newNum = tonumber(inputValue[1])
    if newNum == nil then
        gg.toast("Err")
        mainMenu()
        return
    end
    selected.value = newNum
    gg.loadResults(selected.results)
    gg.getResults(gg.getResultsCount())
    gg.editAll(selected.value, selected.flags)
    gg.clearResults()
    gg.toast(":" .. tostring(selected.name or ("Entry " .. choice)))
    mainMenu()
end
----
function ViewSearch()
    local cnt = gg.getResultsCount()
    if cnt == 0 then
        gg.toast("No Search Results.")
        return
    end
    local take = math.min(20, cnt)
    local res = gg.getResults(take)
    local list = {}
    for i, v in ipairs(res) do
        list[i] = string.format("0x%X | %s | %s", v.address, tostring(v.flags), tostring(v.value))
    end
    list[#list + 1] = "Load All Results"
    list[#list + 1] = "Clear Results"
    list[#list + 1] = "Back"
    local choice = gg.choice(list, nil, "View Search ("..take.."/"..cnt..")")
    if choice == nil then return end
    if choice == #list - 2 then
        gg.toast("Results Already Available")
    elseif choice == #list - 1 then
        gg.clearResults()
        gg.toast("Results Cleared")
    mainMenu()
        return
    end
end
----
function GoBackToSelectMode()
    userMode = selectMode()  
    if userMode == 1 then
        gg.toast("V4 Field Offset Selected Tap Game Guardian (If it didn't show) then Sx")
        UI()
    elseif userMode == 2 then
        gg.toast("APEX Racer Selected")
        mainMenu()
    elseif userMode == 3 then
        gg.toast("T&N Selected")
        menu2()
    elseif userMode == 4 then 
        gg.toast("Tap GG Icon Again To Show")
    else
        gg.toast("Exiting")
        os.exit()
    end
end
----
function mainMenu()
    local menu = gg.multiChoice({
        "Performance",
        "Parts",
        "Player",
        "Dealership",
        "Inventory",
        "Vehicle Codes",
        "Crates",
        "Free Parts Shop",
        "EV Limitor Bypass",
        "Edit Save List",
        "OFF",
        "Return To Select Mode"
    }, nil, "APEX Racer")

    if menu == nil then return end

    if menu[1] then PerformanceMenu() end
    if menu[2] then HiddenPartsMenu() end
    if menu[3] then PlayerMenu() end
    if menu[4] then DealershipMenu() end
    if menu[5] then InvT() end
    if menu[6] then VC() end
    if menu[7] then CrateOB() end
    if menu[8] then FSH() end
    if menu[9] then EvBypass() end
    if menu[10] then ViewSavelist() end
    if menu[11] then HideIcon2() end
    if menu[12] then GoBackToSelectMode() end
end
----
function PerformanceMenu()
  local choice = gg.choice({
    "TurboPSI",
    "ShiftSpeed",
    "TyreGrip",
    "EcuRpm",
    "ChassisWeight",
    "Back"
  }, nil, "Performance Tune Up")

  if choice == nil then
    mainMenu()
    return
  end
  if choice == 1 then cheat_1() end
  if choice == 2 then cheat_2() end
  if choice == 3 then cheat_3() end
  if choice == 4 then cheat_4() end
  if choice == 5 then cheat_5() end
  if choice == 6 then mainMenu() end
end
----
function HiddenPartsMenu()
  local choice = gg.choice({
    "Accessory",
    "Exhaust",
    "Kit",
    "Livery",
    "Neon",
    "Paint",
    "Rim",
    "Spoiler",
    "TyreDesign",
    "WindowTint",
    "Engine",
    "Turbo",
    "Transmission",
    "ShowMore",
    "Back"
  }, nil, "Make Unavailable Parts Appear In PartShop")
----
  if choice == nil then
    mainMenu()
  end
----  
  if choice == 1 then cheat_6() end
  if choice == 2 then cheat_7() end
  if choice == 3 then cheat_8() end
  if choice == 4 then cheat_9() end
  if choice == 5 then cheat_10() end
  if choice == 6 then cheat_11() end
  if choice == 7 then cheat_12() end
  if choice == 8 then cheat_13() end
  if choice == 9 then cheat_14() end
  if choice == 10 then cheat_15() end
  if choice == 11 then cheat_16() end
  if choice == 12 then cheat_17() end
  if choice == 13 then cheat_18() end
  if choice == 14 then cheat_19() end
  if choice == 15 then mainMenu() end
end
----
function PlayerMenu()
    local choice = gg.choice({
        "Level",
        "See All Events",
        "Back"
    }, nil, "Player")
    
    if choice == 1 then cheat_20() end
  if choice == 2 then cheat_21() end
  if choice == 3 then mainMenu() end
end
 ----
 function DealershipMenu()
    local choice = gg.choice({
        "Buy All Vehicles For 1$" ,
        "Get Any Vehicle",
        "Make Locked Vehicles Unlocked",
        "Back",
    }, nil, "Dealership")
    
  if choice == 1 then cheat_all1() end
  if choice == 2 then cheat_23() end
  if choice == 3 then cheat_24() end
  if choice == 4 then mainMenu() end
end
 ----
 function InvT()
     local choice = gg.choice({
        "Inventory Part Owned Increase",
        "Workshop Part Owned Increase",
        "Back"
    }, nil, "Inventory")
    
  if choice == 1 then cheat_all2() end
  if choice== 2 then cheat_25() end
  if choice == 3 then mainMenu() end
end
 ----  
  function CrateOB()
  local choice = gg.choice({
  "Get Only Common",
  "Get Only Uncommon",
  "Get Only Rare",
  "Get Only Epic",
  "Get Only Legendary",
  "Get Only Diamond",
  "Get Only Contraband",
  "Buy Crates For Free",
  "Back"
  }, nil, "🎲 Drop Chance % Changer")

if choice == nil then
    mainMenu()
  end
  
 if choice == 1 then CrateOb1() end
 if choice == 2 then CrateOb2() end
 if choice == 3 then CrateOb3() end
 if choice == 4 then CrateOb4() end
 if choice == 5 then CrateOb5() end
 if choice == 6 then CrateOb6() end
 if choice == 7 then CrateOb7() end
 if choice == 8 then CrateOb8() end
 if choice == 9 then mainMenu() end
 end
 ----  
function FSH()
  local choice = gg.choice({
  "FreeShop",
  "Back"
  }, nil, "Fpsh")

if choice == nil then
    mainMenu()
  end  
    
 if choice == 1 then FreeShopParts() end
 if choice == 2 then mainMenu() end
end
----
  function EvBypass()
  local choice = gg.choice({
  "Remove Limitor",
  "Back"
  }, nil, "EV")

if choice == nil then
    mainMenu()
  end  
    
 if choice == 1 then BypassEletricCarTopSpeed() end
 if choice == 2 then mainMenu() end
end

----  
function cheat_1()
    gg.setVisible(false)  

    valueFromClass("InductionObject", "0x70", false, false, gg.TYPE_DWORD)
    local currentResults = gg.getResults(9999)
    
    if #currentResults == 0 then
        gg.alert("Err")
        gg.setVisible(true)
        mainMenu()
        return
    end

    local choices = {}
    for i, v in ipairs(currentResults) do
        choices[i] = string.format("0x%X | %s", v.address, tostring(v.value))
    end

    local selection = gg.choice(choices, nil, "TurboPSI")
    if not selection then
        gg.setVisible(true)
        mainMenu()
        return
    end

    local selectedResult = currentResults[selection]

    gg.clearResults()
    gg.loadResults({{address = selectedResult.address, flags = selectedResult.flags, value = selectedResult.value}})

    local inputValue = gg.prompt(
        {"0x" .. string.format("%X", selectedResult.address)},
        {selectedResult.value},
        {"number"}
    )
    if not inputValue then
        gg.setVisible(true)
        mainMenu()
        return
    end

    local valueToEdit = tonumber(inputValue[1])
    if not valueToEdit then
        gg.toast("Err")
        gg.setVisible(true)
        mainMenu()
        return
    end

    gg.setValues({{address = selectedResult.address, value = valueToEdit, flags = selectedResult.flags}})
    
    Savelist = Savelist or {}
    table.insert(Savelist, {
        name = "VehicleTurboPSI",
        value = valueToEdit,
        flags = selectedResult.flags,
        results = {selectedResult}
    })

    gg.clearResults()
    gg.toast("0x" .. string.format("%X", selectedResult.address) .. "VehicleTurboPSI")

    gg.setVisible(true)  
    mainMenu()
end
----
function cheat_2()
     gg.setVisible(false)

    valueFromClass("BoltOnObject", "0x68", false, false, gg.TYPE_DWORD)
    local currentResults = gg.getResults(9999)
    
    if #currentResults == 0 then
        gg.alert("Err")
        gg.setVisible(true)
        mainMenu()
        return
    end

    local choices = {}
    for i, v in ipairs(currentResults) do
        choices[i] = string.format("0x%X | %s", v.address, tostring(v.value))
    end

    local selection = gg.choice(choices, nil, "ShifTimes")
    if not selection then
        gg.setVisible(true)
        mainMenu()
        return
    end

    local selectedResult = currentResults[selection]

    gg.clearResults()
    gg.loadResults({{address = selectedResult.address, flags = selectedResult.flags, value = selectedResult.value}})

    local inputValue = gg.prompt(
        {"0x" .. string.format("%X", selectedResult.address)},
        {selectedResult.value},
        {"number"}
    )
    if not inputValue then
        gg.setVisible(true)
        mainMenu()
        return
    end

    local valueToEdit = tonumber(inputValue[1])
    if not valueToEdit then
        gg.toast("Err")
        gg.setVisible(true)
        mainMenu()
        return
    end

    gg.setValues({{address = selectedResult.address, value = valueToEdit, flags = selectedResult.flags}})
    
    Savelist = Savelist or {}
    table.insert(Savelist, {
        name = "VehicleShifTime",
        value = valueToEdit,
        flags = selectedResult.flags,
        results = {selectedResult}
    })

    gg.clearResults()
    gg.toast("0x" .. string.format("%X", selectedResult.address) .. "VehicleShifTime")

    gg.setVisible(true)
    mainMenu()
end
----
function cheat_3()
   gg.setVisible(false)

    valueFromClass("BoltOnObject", "0x4C", false, false, gg.TYPE_DWORD)
    local currentResults = gg.getResults(9999)
    
    if #currentResults == 0 then
        gg.alert("Err")
        gg.setVisible(true)
        mainMenu()
        return
    end

    local choices = {}
    for i, v in ipairs(currentResults) do
        choices[i] = string.format("0x%X | %s", v.address, tostring(v.value))
    end

    local selection = gg.choice(choices, nil, "TyreGrip")
    if not selection then
        gg.setVisible(true)
        mainMenu()
        return
    end

    local selectedResult = currentResults[selection]

    gg.clearResults()
    gg.loadResults({{address = selectedResult.address, flags = selectedResult.flags, value = selectedResult.value}})

    local inputValue = gg.prompt(
        {"0x" .. string.format("%X", selectedResult.address)},
        {selectedResult.value},
        {"number"}
    )
    if not inputValue then
        gg.setVisible(true)
        mainMenu()
        return
    end

    local valueToEdit = tonumber(inputValue[1])
    if not valueToEdit then
        gg.toast("Err")
        gg.setVisible(true)
        mainMenu()
        return
    end

    gg.setValues({{address = selectedResult.address, value = valueToEdit, flags = selectedResult.flags}})
    
    Savelist = Savelist or {}
    table.insert(Savelist, {
        name = "VehicleTyreGrip",
        value = valueToEdit,
        flags = selectedResult.flags,
        results = {selectedResult}
    })

    gg.clearResults()
    gg.toast("0x" .. string.format("%X", selectedResult.address) .. "VehicleTyreGrip")

    gg.setVisible(true)  
    mainMenu()  
end
----
function cheat_4()
   gg.setVisible(false)

    valueFromClass("BoltOnObject", "0x64", false, false, gg.TYPE_DWORD)
    local currentResults = gg.getResults(9999)
    
    if #currentResults == 0 then
        gg.alert("Err")
        gg.setVisible(true)
        mainMenu()
        return
    end

    local choices = {}
    for i, v in ipairs(currentResults) do
        choices[i] = string.format("0x%X | %s", v.address, tostring(v.value))
    end

    local selection = gg.choice(choices, nil, "ECU")
    if not selection then
        gg.setVisible(true)
        mainMenu()
        return
    end

    local selectedResult = currentResults[selection]

    gg.clearResults()
    gg.loadResults({{address = selectedResult.address, flags = selectedResult.flags, value = selectedResult.value}})

    local inputValue = gg.prompt(
        {"0x" .. string.format("%X", selectedResult.address)},
        {selectedResult.value},
        {"number"}
    )
    if not inputValue then
        gg.setVisible(true)
        mainMenu()
        return
    end

    local valueToEdit = tonumber(inputValue[1])
    if not valueToEdit then
        gg.toast("Err")
        gg.setVisible(true)
        mainMenu()
        return
    end

    gg.setValues({{address = selectedResult.address, value = valueToEdit, flags = selectedResult.flags}})
    
    Savelist = Savelist or {}
    table.insert(Savelist, {
        name = "VehicleECURpm",
        value = valueToEdit,
        flags = selectedResult.flags,
        results = {selectedResult}
    })

    gg.clearResults()
    gg.toast("0x" .. string.format("%X", selectedResult.address) .. "VehicleECURpm")

    gg.setVisible(true)  
    mainMenu()  
end
----
function cheat_5()
gg.setVisible(false)

    valueFromClass("BoltOnObject", "0x6C", false, false, gg.TYPE_DWORD)
    local currentResults = gg.getResults(9999)
    
    if #currentResults == 0 then
        gg.alert("Err")
        gg.setVisible(true)
        mainMenu()
        return
    end

    local choices = {}
    for i, v in ipairs(currentResults) do
        choices[i] = string.format("0x%X | %s", v.address, tostring(v.value))
    end

    local selection = gg.choice(choices, nil, "Weight")
    if not selection then
        gg.setVisible(true)
        mainMenu()
        return
    end

    local selectedResult = currentResults[selection]

    gg.clearResults()
    gg.loadResults({{address = selectedResult.address, flags = selectedResult.flags, value = selectedResult.value}})

    local inputValue = gg.prompt(
        {"0x" .. string.format("%X", selectedResult.address)},
        {selectedResult.value},
        {"number"}
    )
    if not inputValue then
        gg.setVisible(true)
        mainMenu()
        return
    end

    local valueToEdit = tonumber(inputValue[1])
    if not valueToEdit then
        gg.toast("Err")
        gg.setVisible(true)
        mainMenu()
        return
    end

    gg.setValues({{address = selectedResult.address, value = valueToEdit, flags = selectedResult.flags}})
    
    Savelist = Savelist or {}
    table.insert(Savelist, {
        name = "VehicleWeight",
        value = valueToEdit,
        flags = selectedResult.flags,
        results = {selectedResult}
    })

    gg.clearResults()
    gg.toast("0x" .. string.format("%X", selectedResult.address) .. "VehicleWeight")

    gg.setVisible(true)
    mainMenu()
end
----
function cheat_6()
   valueFromClass("AccessoryObject", "0xE9", false, false, gg.TYPE_BYTE)
   gg.refineNumber(0, gg.TYPE_BYTE)
   gg.getResults(9999)
   gg.editAll(1, gg.TYPE_BYTE)
   gg.clearResults() 
end
----
function cheat_7()
   valueFromClass("ExhaustTipInfo", "0x44", false, false, gg.TYPE_BYTE)
   gg.getResults(9999)
   gg.editAll(1,  gg.TYPE_BYTE)
   gg.clearResults()   
end
----
function cheat_8()
   valueFromClass("KitObject", "0xD8", false, false, gg.TYPE_BYTE)
   gg.refineNumber(0, gg.TYPE_BYTE)
   gg.getResults(9999)
   gg.editAll(1,  gg.TYPE_BYTE)
   gg.clearResults()   
end
----
function cheat_9()
   valueFromClass("LiveryInfo", "0x44", false, false,  gg.TYPE_BYTE)
   gg.refineNumber(0, gg.TYPE_BYTE)
   gg.getResults(9999)
   gg.editAll(1,  gg.TYPE_BYTE)
   gg.clearResults()  
end
----
function cheat_10()
   valueFromClass("NeonObject", "0x38", false, false,  gg.TYPE_BYTE)
   gg.refineNumber(0, gg.TYPE_BYTE)
   gg.getResults(9999)
   gg.editAll(1,  gg.TYPE_BYTE)
   gg.clearResults()   
end
----
function cheat_11()
   valueFromClass("PaintObject", "0x28", false, false,  gg.TYPE_BYTE)
   gg.refineNumber(0, gg.TYPE_BYTE)
   gg.getResults(9999)
   gg.editAll(1,  gg.TYPE_BYTE)
   gg.clearResults()  
end
----
function cheat_12()
   valueFromClass("RimObject", "0x71", false, false,  gg.TYPE_BYTE)
   gg.refineNumber(0, gg.TYPE_BYTE)
   gg.getResults(9999)
   gg.editAll(1,  gg.TYPE_BYTE)
   gg.clearResults()  
end
----
function cheat_13()
   valueFromClass("SpoilerInfo", "0x38", false, false,  gg.TYPE_BYTE)
   gg.refineNumber(0, gg.TYPE_BYTE)
   gg.getResults(9999)
   gg.editAll(1,  gg.TYPE_BYTE)
   gg.clearResults()   
end
----
function cheat_14()
   valueFromClass("TireDesignObject", "0x21", false, false,  gg.TYPE_BYTE)
   gg.refineNumber(0, gg.TYPE_BYTE)
   gg.getResults(9999)
   gg.editAll(1,  gg.TYPE_BYTE)
   gg.clearResults()   
end
----
function cheat_15()
   valueFromClass("WindowTintObject", "0x29", false, false,  gg.TYPE_BYTE)
   gg.refineNumber(0, gg.TYPE_BYTE)
   gg.getResults(9999)
   gg.editAll(1,  gg.TYPE_BYTE)
   gg.clearResults()   
end
----
function cheat_16()
   valueFromClass("EngineObject", "0x48", false, false,  gg.TYPE_BYTE)
   gg.refineNumber(0, gg.TYPE_BYTE)
   gg.getResults(9999)
   gg.editAll(1,  gg.TYPE_BYTE)
   gg.clearResults()   
end
----
function cheat_17()
   valueFromClass("InductionObject", "0x54", false, false,  gg.TYPE_BYTE)
   gg.refineNumber(0, gg.TYPE_BYTE)
   gg.getResults(9999)
   gg.editAll(1,  gg.TYPE_BYTE)
   gg.clearResults()   
end
----
function cheat_18()
   valueFromClass("TranObject", "0x44", false, false,  gg.TYPE_BYTE)
   gg.refineNumber(0, gg.TYPE_BYTE)
   gg.getResults(9999)
   gg.editAll(1,  gg.TYPE_BYTE)
   gg.clearResults()   
end
----
function cheat_19()
   valueFromClass("BoltOnObject", "0x28", false, false,  gg.TYPE_BYTE)
   gg.refineNumber(0, gg.TYPE_BYTE)
   gg.getResults(9999)
   gg.editAll(1,  gg.TYPE_BYTE)
   gg.clearResults()   
end
----
function cheat_20()
gg.alert("Play one of the races when done")
   valueFromClass("EventObject", "0xA8", false, false,  gg.TYPE_DWORD)
   gg.getResults(9999)
   gg.editAll(2000000000,  gg.TYPE_DWORD)
   gg.clearResults()   
end
----
function cheat_21()
   valueFromClass("EventSeriesObject", "0x40", false, false,  gg.TYPE_BYTE)
   gg.refineNumber(0, gg.TYPE_BYTE)
   gg.getResults(9999)
   gg.editAll(1,  gg.TYPE_BYTE)
   gg.clearResults()  
end
----
function cheat_all1()
    local offsets = { "0x48", "0x4C" } 
    for _, off in ipairs(offsets) do
        valueFromClass("VehicleInfo", off, false, false, gg.TYPE_DWORD)
        local results = gg.getResults(9999)
        if #results > 0 then
            gg.editAll(1, gg.TYPE_DWORD)
        end
        gg.clearResults()
    end    
end
----
function cheat_23()
gg.alert("Goto Dealership")
    valueFromClass("VehicleInfo", "0x28", false, false, gg.TYPE_DWORD)
    gg.refineNumber(542, gg.TYPE_DWORD)
    local results = gg.getResults(9999)
    if #results == 0 then
        gg.toast("")
        return
    end
        gg.alert("INFO: You'll see Vehicle = 542 Tap back then find 🇩🇪 Flag car at D Tier 159 Rating ⭐⭐⭐⭐ Star 2.5L twin turbo Inline -4 after you found it click it and goto savelist here you'll see 542 again tap it and refine From 1 - 629 (check vehicles code if you want a specific vehicle) Once you've refined click any vehicle next to the 159 rating car then click back the 159 rating car now you'll see it change repeat this to get any vehicle")
    local valueToEdit = 542
    gg.setValues(results)
    Savelist = Savelist or {}
    table.insert(Savelist, {
        name = "VehicleCode",
        value = valueToEdit,
        flags = results[1].flags,
        results = results
    })
    gg.clearResults()
    gg.toast("VaL" .. #results .. "VaL")
    ViewSavelist()
end
----
function cheat_24()
   valueFromClass("VehicleInfo", "0x50", false, false,  gg.TYPE_BYTE)
   gg.refineNumber(0, gg.TYPE_BYTE)
   gg.getResults(9999)
   gg.editAll(1,  gg.TYPE_BYTE)
   gg.clearResults()
end
----
function cheat_all2()
   local classes = {
      "InventorySlot",
      "MiscSlot",
      "SpoilerSlot",
      "ExhaustTipSlot",
      "WindowTintSlot",
      "TireDesignSlot",
      "PaintSlot",
      "LiverySlot",
   }
   for i, className in ipairs(classes) do
      valueFromClass(className, "0x28", false, false, gg.TYPE_DWORD)
      gg.getResults(9999)
      gg.editAll(15000, gg.TYPE_DWORD)
      gg.clearResults()
   end  
end
----
function cheat_25()
   valueFromClass("InventoryPart", "0x18", false, false,  gg.TYPE_DWORD)  
   gg.getResults(9999)
   gg.editAll(25000,  gg.TYPE_DWORD)
   gg.clearResults()
end
----
function VC()
    gg.alert("Unfinished")

    gg.alert([[
1 Nissan Orange GTR35 
2 Honda Civic Ek9
3 Mazda-3
4 Mazda RX-7
5 Honda NSX
6 Nissan Silvia 13
7 Nissan GTR34
8 Mustang Boss 429
9 Honda S2000
10 Honda NSX-R GT
11 Toyota Supra Mk4
12 Toyota GR68
13 BMW M3 E46
14 Miata
15 Z Tune GTR34
16 Audi R8 V10 Grey Logo
17 Lamborghini Aventador Orange one
18 Nissan 240sx
19 Toyota Supra MK5
20 Subaru WRX STI Orange
21 Mitsubishi EVO 9
22 Mercedes G63
23 Jaguar F-TyF-Type
24 Bugatti Chiron Sport Edition Noire
25 Ferrari F40 LM Barchetta 
26 RWB Porsche 993 Rotana
27 Ford Focus 
28 Chiron 2016 
29 Half Black Bugatti Chiron
30 HKS CTS 230R
31 Nissan Silvia 15
32 Nissan 350z
33 Dodge Charger 
34 Dodge Challenger
35 Nissan Altezza
36 Mitsubishi Eclipse
37 Smokey Nagata V12 Toyota Supra MK4
38 Porsche 959
39 Porsche 930 Turbo
40 Porsche 991.2 GT3RS
41 Porsche 991.2 GT2RS
42 Nissan 350z Convertible
43 Nissan Silvia S15 Varietta
44 Aston Martin DBS Superleggera ODMS edition
45 M3 E46 GTR
46 Chevrolet Corvette C5 
47 BMW E30 M3
48 Veilside Mazda RX-7
49 Nissan R32
50 Lotus Exige
51 Lamborghini Huracan
52 Lamborghini Huarcan EVO Spider
53 Lamborghini Huarcan EVO Spider (With Roof)
54 Bugatti Chiron Sport 2018
55 Bugatti Chiron 2017
56 LightBlue Bugatti
57 Bugatti Chiron Super Sport 300+
58 Mansory Bugatti?
59 Bugatti Chiron Pur Sport 
60 Bronze Bugatti
61 Bugatti Chiron PurSport Hermes Edition  
62 Hennesy Venom GT
63 Saleen S7
64 Ford GT Heritage Edition
65 Bugatti Chiron Profilee
66 Ford Mustang Dark Horse?
67 Ford Mustang GT FastBack
68 For Mustang Boss 302
69 Chevrolet Corvette C8
70 Dodge Viper SRT GTS
71 Dodge Viper GTS R 
72 Chevrolet Camaro SS
73 Dodge Viper SRT GT3R
74 Chevrolet Corvette C8.R
75 Subrau wrx
76 Dodge Charger Blue Bird
77 ol chevy
78 dodge Daytona no livery
79 Pagani Zonda
80 Pagani Zonda Cinque
81 Hp Barchetta Zonda
82 Koeniggsegg Agera R
83 Koeniggsegg ONE:1
84 old dodge with stripe
85 Zonda R Pagani
86 Nissan 370z
87 Chevy impala
88 Chevy Camaro SS?
89 Mansory Ferrari sf90
90 Mercedes slr
91 918 Porsche
92 a golf?
93 Vq?
94 McLaren speedtail
95 white Mercedes slr
96 mustang dark horse
97 Audi r8
98 Aventador s
99 Aventador sv
100 Aventador svj
101 Aventador Ultimae
102 old bmw e
103 Lamborghini Murci
104 Lamborghini Murci with rear bumper
105 Murci sv
106 orange murci
107 Yaris I think
108 some Korean car
109 very old blue Chevy truck
110 old orange Japan truck 
111 dodge ram my pu
112 old Japan truck but white
113 tall American jeep
114 dodge jeep trackhawk or grandch
115 older dodge ram ig
116 dont know wtf this is
117 Mercedes g wagon 
118 Toyota suv
119 2 colored old American car
120 another Subrau wrx 
121 mitchbishi
122 temu japan g wagon
123 Acura NSX 
124 Audi r8 v10
125 Audi r8 v10 roadster
126 a mazzerati 
127 Yellow Bugatti Divo
128 Koenigsegg jesko
129 old Porsche 
130 old Porsche with body kit 
131 Lamborghini contact modern
132 McLaren senna
133 senna gtr
134 Lamborghini technia
135 Lamborghini sian
136 Mansory Bugatti Chiron
137 6x6 Japan jeep
138 toy Mercedes g wagan
139 6x6 Dodge RAM
140 america car idk
141 some hummer type
142 ford gt
143 venom F5
144 a American supercar
145 long america jeep
146 america old car dodge or Chevy or Camaro 
147 Cadillac sedan 
148 delorean
149 a American hypercar 
150 ssc tuatara striker
151 ford raptor 
152 ford raptor abit longer 
153 a bently coupe 
154 rolls Royce cull suv
155 some England sports car 
156 mazzerati supercar
157
158
159
160
161
162
163
164
165
166
167
168
169
170
171
172
173
174
175
176
177
178
179
180
181
182
183
184
185
186
187
188 Purple Mclaren P1
189
190
191
192
193
194
195
196
197
198
199
200
201
202
203
204
205
206
207
208
209
210
211
212
213
214
215 Dakar 911
216
217
218
219
220
221
222
223 003s
224 Blue Long Car
225 Red Small Car
226
227
228
229
230
231
232
233
234
235
236
237
238
239
240
241 Police C7 Corvette
242 Green Ferrari
243
244
245
246
247
248
249 Green Ferrari Open Roof
250
251 Lexus LFA
252 Lexus LFA Nurburgring 
253
254
255
256
257 Empty Bed RAM Dev Car
258
259 Ascended Rally Porsche
260 Green F1
261
262
263
264 Enzo FXX With black line
265
266
267
268
269
270
271
272
273
274
275
276
277
278 787B
279
280
281 Sesto Elemento
282 Sesto Elemento_2
283 Mercedes CLK Spoiler
284 La Ferrari
285 La Ferrari FXX-K
286 La Ferrari FXX-K Evo
287 CLK No Spoiler
288 Yellow LaFerrari
289 La Ferrari FXX-K (Lower Class?)
290 Mercedes AMG Green
291 Normal AMG One
292 Red AMG One
293 Nala's NSX
294 Ford GT Heritage Edition
295 Hennesy Venom F5 (No Spoiler)
296 
297 Saleen S7 Again?
298 SSC Tuatara Striker
299 Orange S15 Special No Logo
300 Advan R32 No Logo
301 Tag Team Event AE86
302 Calsonic GT-R 34
303 Custom Livery M3 E46
304 Tag Team Event S2K Miata
305 Special Honda Ek9
306 Purple NSX
307 Tag Team CTR-3 Evo
308 Special Evo9 Pink
309 Rainbow Porsche Black
310
311 No Livery EB110 Ascended
312 Marti Blue Bugatti
313 Sauber C9
314 Porsche 917K
315 Porsche 917LH
316 Theree Wheel Achievement Car
317 Lamborghini Egoista
318 Solus GT Mclaren
319 Yeah Nah Achievement Car
320 Audi R10 TDI 
321 Mercedes CLK GTR Race Version
322 Porsche 935/77
323 Mercedes Steirling Moss
324 AE86 Initial D
325 Toyota Velfire Looking Thing?
326 Toyota Velfire Looking Thing Race Version (Van Man Event)
327 Half Cut Car
328 Rolls Royce Boat Tail
329 Maybach Excelero 
330 Ford GT MK2
331 Ferrari 330P4
332 Nissan 400R 
333 Peel P50
334 Alfa Romeo 159
335 Lamborghini Murcielago Toy Car
336 AE86 Toy Car
337 Ferrari 812 TDF
338 Ferrari 812
339  
340
341 Bugatti Veyron
342 Lamborghini Diablo SV
343 Bugatti Centodieci
344 Bugatti Divo
345 Bugatti Atlantic Concept
346 Nissan Stagea Wagon
347 Nissan GT-T R34 Wagon
348 Bugatti Bolide
349 Bugatti EB110
350 Nissan R92CP
351 Tesla S
352 Ferrari Purosangue
353 Bentley Bentayga
354 Porsche Cayenne 
355 Mclaren 765LT
356 Nissan GT R31
357 Toyota Race Car White, 787 Event
358 
359 Maserati MC12 
360 Maserati MC12 Corsa
361 Toyota MR2 
362 Ferrari F50
363 F50 LM
364 
365 Volvo 850 Wagon 
366 Mitsubushi 2000GT
367 Dodge Charger Police
368 GTR-33 LM
369 Cien Concept
370 Zenvo TSR S
371 Apollo Intensa Emzione
372 Huayra Concept
373
374 Police Toyota
375 Nissan GT-R 34 Police
376 Nissan GT-R 35 Police
377 Tokyo Police Truck
378 Tesla Roadster
379 Tytan Tesla Roadster
380 Nissan Integra R 
381 
382 Carrera GT
383 Hennesy Venom F5 USA Spoiler
384 Lamborghini Police Sian
385 Bugatti Chiron 2018 Police
386 Nissan GT-R35 Police
387 Police Carrera GT
388 Hennesy Venom F5 Police
389 BMW M5cs
390 Dodge Challenger 170
391 Kei Truck 
392 Tesla Roadster Engine Swap
393 Mazda MX5 Miata Open Roof
394 Mazda MX5 Miata Close Roof
395 Nissan 
396 Mad Max Car
397 panthera
398
399
400 Subaru 
401 Mazda Furei
402 concept Porsche 
403
404
405
406
407
408
409 Buggy
410
411
412 Weird Korean Car
413
414
415
416
417
418
419
420
421
422
423
424
425
426
427
428
429
430
431
432
433
434
435
436 Bugatti Tourbillion
437
438
439
440
441
442
443
444 Jeep Toy
445
446
447
448
449
450
451
452
453
454
455
456
457
458 Calender ZR1
459
460
461
462
463
464
465
466
467
468
469
470
471
472
473
474
475
476
477
478
479
480
481
482
483
484
485 BYD Seagull
486 Japan caar
487 Honda Civic EG6
488 Cayman S
489 BMW M3 G81 CS Touring
490 Lancer Evolution Wagon
491 Jaguar XJS 
492 Jaguar TWR Supercat
493 Jaguar XJS220
494 Audi Quattro
495 Jaguar TYPE00 Concept
496 Saab 900 Turbo 16S
497 Cgevrolet Camaro SS
498 El Camino SS
499 S14 Bosscat Tokyo Event
500 Lamborghini Tractor
501 Porsche Cayman GT4RS
502 Lamborghini Murcielago Roadster 
503 Lamborghini Diablo 
504 Alfa Romeo 33 Stradale 
505 mazzerati extrema
506 kimera
507 Pininfarina B95 
508 Fiat 5000 Multipla Event Race Car
509 Rileys Custom 350z
510 Uncle Joe's C2
511 Mclaren Artura Spyder
512 some smol England car
513 Pininfarina Battista
514 Bentley Continental GT
515 Hennesy Venom GT Police Car
516 Mercedes C63 Estate E Performance 
517 Wolkswagen Golf W12
518 Tesla Cybertruck
519 Hyundai Ionic 5N
520 Maybach S680
521 Lamborghini Diablo GT2
522 Peugot 9X8
523 Ford GT Mark 4
524 Porsche 935 2nd Gen
525 KTM X Bow Race car 
526 Hyundai Insteroid
527 AMC AMX 3 
528 BMW M4 GTR 
529 Nissan 400Z Race Car
530 Lamborghini Diablo GT1
531 Camaro sport 
532 Special Rolls Royce
533
534
535
536
537
538
539
540
541
542
543
544
545
546
547 Toyota Celica
548 Tesla Toy Truck
549 Lexus LC500
550 Mitsuoka Orochi
551 F1 Racing Car
552 Chrysler 300C
553 Opel Calibra 
554 Lamborghini Gallardo SuperLegarra
555 Porsche 963 RSP
556 Lotus Type 72 
557 Lexus IS500
558 Alfa Romeo Brerra
559 Toyota GT-One
560 Porsche 911GT1 Evo
561 Aston Martin Valkyrie LM
562 Fiat 500
563 Subaru WRX STI BugEye
564 BMW I8 
565 Falcon F7
566 Old German Mercedes 
567 modified old German Mercedes 
568 america suv
569 slightly bigger American suv
570 japan racecar
571 Porsche Carrera
572 Hyundai ev
573 Japan sedan 
574 Chevy truck with apex logo
575 old Chevy 
576 white ford raptor truck
577 Lamborghini Gallardo concept
578 Chevy truck
579 apex cola NPC VanTruck
580 ford Silverado?
581 Aston Martin Valhalla 
582 yellow Porsche 
583 red Porsche no wing
584 Japan car
585 Bugatti broudilian 
586 Koenigsegg cc850
587 Porsche mission r
588 noble
589 Italian ev
590 Japan car
591 Japan car
592 de tomosa p900
593 Koenigsegg cc prototype 
594 Cadillac 
595 Audi RS idk
596 Ultima rs
597 Lamborghini fenomeno
598 Lamborghini revention
599
600
601
602
603
604
605
606
607
608
609
610
611
612
613
614
615
616
617
618 
619
620
621
622
623
624
625
626
627
628
629
-- End of 0.9.42 Vehicles --
]])
end

----
function FreeShopParts()
gg.alert("This Will take time everything will cost 1$ cash in parts shop")
valueFromClass("EngineObject", "0x4C", false, false,  gg.TYPE_DWORD)  
   gg.getResults(9999)
   gg.editAll(1,  gg.TYPE_DWORD)
   gg.clearResults()
valueFromClass("InductionObject", "0x50", false, false,  gg.TYPE_DWORD)  
   gg.getResults(9999)
   gg.editAll(1,  gg.TYPE_DWORD)
   gg.clearResults()
valueFromClass("TranObject", "0x40", false, false,  gg.TYPE_DWORD)  
   gg.getResults(9999)
   gg.editAll(1,  gg.TYPE_DWORD)
   gg.clearResults()
valueFromClass("BoltOnObject", "0x38", false, false,  gg.TYPE_DWORD)  
   gg.getResults(9999)
   gg.editAll(1,  gg.TYPE_DWORD)
   gg.clearResults()
valueFromClass("AccessoryObject", "0xEC", false, false,  gg.TYPE_DWORD)  
   gg.getResults(9999)
   gg.editAll(1,  gg.TYPE_DWORD)
   gg.clearResults()
valueFromClass("AccessoryObject", "0xEC", false, false,  gg.TYPE_DWORD)  
   gg.getResults(9999)
   gg.editAll(1,  gg.TYPE_DWORD)
   gg.clearResults()
valueFromClass("ExhaustTipInfo", "0x40", false, false,  gg.TYPE_DWORD)  
   gg.getResults(9999)
   gg.editAll(1,  gg.TYPE_DWORD)
   gg.clearResults()   
valueFromClass("KitObject", "0x64", false, false,  gg.TYPE_DWORD)  
   gg.getResults(9999)
   gg.editAll(1,  gg.TYPE_DWORD)
   gg.clearResults()      
valueFromClass("LiveryInfo", "0x40", false, false,  gg.TYPE_DWORD)  
   gg.getResults(9999)
   gg.editAll(1,  gg.TYPE_DWORD)
   gg.clearResults()         
valueFromClass("PaintObject", "0x2C", false, false,  gg.TYPE_DWORD)  
   gg.getResults(9999)
   gg.editAll(1,  gg.TYPE_DWORD)
   gg.clearResults()      
valueFromClass("RimObject", "0x74", false, false,  gg.TYPE_DWORD)  
   gg.getResults(9999)
   gg.editAll(1,  gg.TYPE_DWORD)
   gg.clearResults()  
valueFromClass("SpoilerInfo", "0x3C", false, false,  gg.TYPE_DWORD)  
   gg.getResults(9999)
   gg.editAll(1,  gg.TYPE_DWORD)
   gg.clearResults() 
valueFromClass("TireDesignObject", "0x24", false, false,  gg.TYPE_DWORD)  
   gg.getResults(9999)
   gg.editAll(1,  gg.TYPE_DWORD)
   gg.clearResults()                       
valueFromClass("WindowTintObject", "0x2C", false, false,  gg.TYPE_DWORD)  
   gg.getResults(9999)
   gg.editAll(1,  gg.TYPE_DWORD)
   gg.clearResults()                  
valueFromClass("TireDesignObject", "0x24", false, false,  gg.TYPE_DWORD)  
   gg.getResults(9999)
   gg.editAll(1,  gg.TYPE_DWORD)
   gg.clearResults()                
   gg.alert("Finished")  
end
----
function CrateOb1()
gg.alert("This may take time⌛")
valueFromClass("CrateObject", "0x160", false, false,  gg.TYPE_DWORD)  
   gg.getResults(9999)
   gg.editAll(0,  gg.TYPE_DWORD)
   gg.clearResults()
   valueFromClass("CrateObject", "0x164", false, false,  gg.TYPE_DWORD)  
   gg.getResults(9999)
   gg.editAll(0,  gg.TYPE_DWORD)
   gg.clearResults()
   valueFromClass("CrateObject", "0x168", false, false,  gg.TYPE_DWORD)  
   gg.getResults(9999)
   gg.editAll(0,  gg.TYPE_DWORD)
   gg.clearResults()
   valueFromClass("CrateObject", "0x16C", false, false,  gg.TYPE_DWORD)  
   gg.getResults(9999)
   gg.editAll(0,  gg.TYPE_DWORD)
   gg.clearResults()
   valueFromClass("CrateObject", "0x170", false, false,  gg.TYPE_DWORD)  
   gg.getResults(9999)
   gg.editAll(0,  gg.TYPE_DWORD)
   gg.clearResults()
   valueFromClass("CrateObject", "0x174", false, false,  gg.TYPE_DWORD)  
   gg.getResults(9999)
   gg.editAll(0,  gg.TYPE_DWORD)
   gg.clearResults()
valueFromClass("CrateObject", "0x15C", false, false,  gg.TYPE_DWORD)  
   gg.getResults(9999)
   gg.editAll(696969,  gg.TYPE_DWORD)
   gg.clearResults()
gg.alert("Done")  
end
----
function CrateOb2()
gg.alert("This may take time⌛")
valueFromClass("CrateObject", "0x164", false, false,  gg.TYPE_DWORD)  
   gg.getResults(9999)
   gg.editAll(0,  gg.TYPE_DWORD)
   gg.clearResults()
   valueFromClass("CrateObject", "0x168", false, false,  gg.TYPE_DWORD)  
   gg.getResults(9999)
   gg.editAll(0,  gg.TYPE_DWORD)
   gg.clearResults()
   valueFromClass("CrateObject", "0x16C", false, false,  gg.TYPE_DWORD)  
   gg.getResults(9999)
   gg.editAll(0,  gg.TYPE_DWORD)
   gg.clearResults()
   valueFromClass("CrateObject", "0x170", false, false,  gg.TYPE_DWORD)  
   gg.getResults(9999)
   gg.editAll(0,  gg.TYPE_DWORD)
   gg.clearResults()
   valueFromClass("CrateObject", "0x174", false, false,  gg.TYPE_DWORD)  
   gg.getResults(9999)
   gg.editAll(0,  gg.TYPE_DWORD)
   gg.clearResults()
valueFromClass("CrateObject", "0x15C", false, false,  gg.TYPE_DWORD)  
   gg.getResults(9999)
   gg.editAll(0,  gg.TYPE_DWORD)
   gg.clearResults()
valueFromClass("CrateObject", "0x160", false, false,  gg.TYPE_DWORD)  
   gg.getResults(9999)
   gg.editAll(696969,  gg.TYPE_DWORD)
   gg.clearResults()
   gg.alert("Done")  
end
----
function CrateOb3()
gg.alert("This may take time⌛")
   valueFromClass("CrateObject", "0x168", false, false,  gg.TYPE_DWORD)  
   gg.getResults(9999)
   gg.editAll(0,  gg.TYPE_DWORD)
   gg.clearResults()
   valueFromClass("CrateObject", "0x16C", false, false,  gg.TYPE_DWORD)  
   gg.getResults(9999)
   gg.editAll(0,  gg.TYPE_DWORD)
   gg.clearResults()
   valueFromClass("CrateObject", "0x170", false, false,  gg.TYPE_DWORD)  
   gg.getResults(9999)
   gg.editAll(0,  gg.TYPE_DWORD)
   gg.clearResults()
   valueFromClass("CrateObject", "0x174", false, false,  gg.TYPE_DWORD)  
   gg.getResults(9999)
   gg.editAll(0,  gg.TYPE_DWORD)
   gg.clearResults()
valueFromClass("CrateObject", "0x15C", false, false,  gg.TYPE_DWORD)  
   gg.getResults(9999)
   gg.editAll(0,  gg.TYPE_DWORD)
   gg.clearResults()
valueFromClass("CrateObject", "0x160", false, false,  gg.TYPE_DWORD)  
   gg.getResults(9999)
   gg.editAll(0,  gg.TYPE_DWORD)
   gg.clearResults()
valueFromClass("CrateObject", "0x164", false, false,  gg.TYPE_DWORD)  
   gg.getResults(9999)
   gg.editAll(696969,  gg.TYPE_DWORD)
   gg.clearResults()
   gg.alert("Done")  
end
----
function CrateOb4()
gg.alert("This may take time⌛")
valueFromClass("CrateObject", "0x16C", false, false,  gg.TYPE_DWORD)  
   gg.getResults(9999)
   gg.editAll(0,  gg.TYPE_DWORD)
   gg.clearResults()
   valueFromClass("CrateObject", "0x170", false, false,  gg.TYPE_DWORD)  
   gg.getResults(9999)
   gg.editAll(0,  gg.TYPE_DWORD)
   gg.clearResults()
   valueFromClass("CrateObject", "0x174", false, false,  gg.TYPE_DWORD)  
   gg.getResults(9999)
   gg.editAll(0,  gg.TYPE_DWORD)
   gg.clearResults()
valueFromClass("CrateObject", "0x15C", false, false,  gg.TYPE_DWORD)  
   gg.getResults(9999)
   gg.editAll(0,  gg.TYPE_DWORD)
   gg.clearResults()
valueFromClass("CrateObject", "0x160", false, false,  gg.TYPE_DWORD)  
   gg.getResults(9999)
   gg.editAll(0,  gg.TYPE_DWORD)
   gg.clearResults()
valueFromClass("CrateObject", "0x164", false, false,  gg.TYPE_DWORD)  
   gg.getResults(9999)
   gg.editAll(0,  gg.TYPE_DWORD)
   gg.clearResults()
valueFromClass("CrateObject", "0x168", false, false,  gg.TYPE_DWORD)  
   gg.getResults(9999)
   gg.editAll(696969,  gg.TYPE_DWORD)
   gg.clearResults()
   gg.alert("Done")  
end
----
function CrateOb5()
gg.alert("This may take time⌛")
   gg.clearResults()
   valueFromClass("CrateObject", "0x170", false, false,  gg.TYPE_DWORD)  
   gg.getResults(9999)
   gg.editAll(0,  gg.TYPE_DWORD)
   gg.clearResults()
   valueFromClass("CrateObject", "0x174", false, false,  gg.TYPE_DWORD)  
   gg.getResults(9999)
   gg.editAll(0,  gg.TYPE_DWORD)
   gg.clearResults()
valueFromClass("CrateObject", "0x15C", false, false,  gg.TYPE_DWORD)  
   gg.getResults(9999)
   gg.editAll(0,  gg.TYPE_DWORD)
   gg.clearResults()
valueFromClass("CrateObject", "0x160", false, false,  gg.TYPE_DWORD)  
   gg.getResults(9999)
   gg.editAll(0,  gg.TYPE_DWORD)
   gg.clearResults()
valueFromClass("CrateObject", "0x164", false, false,  gg.TYPE_DWORD)  
   gg.getResults(9999)
   gg.editAll(0,  gg.TYPE_DWORD)
   gg.clearResults()
valueFromClass("CrateObject", "0x168", false, false,  gg.TYPE_DWORD)  
   gg.getResults(9999)
   gg.editAll(0,  gg.TYPE_DWORD)
   gg.clearResults()
valueFromClass("CrateObject", "0x16C", false, false,  gg.TYPE_DWORD)  
   gg.getResults(9999)
   gg.editAll(696969,  gg.TYPE_DWORD)
   gg.clearResults()
   gg.alert("Done")  
end
----
function CrateOb6()
gg.alert("This may take time⌛")
valueFromClass("CrateObject", "0x174", false, false,  gg.TYPE_DWORD)  
   gg.getResults(9999)
   gg.editAll(0,  gg.TYPE_DWORD)
   gg.clearResults()
valueFromClass("CrateObject", "0x15C", false, false,  gg.TYPE_DWORD)  
   gg.getResults(9999)
   gg.editAll(0,  gg.TYPE_DWORD)
   gg.clearResults()
valueFromClass("CrateObject", "0x160", false, false,  gg.TYPE_DWORD)  
   gg.getResults(9999)
   gg.editAll(0,  gg.TYPE_DWORD)
   gg.clearResults()
valueFromClass("CrateObject", "0x164", false, false,  gg.TYPE_DWORD)  
   gg.getResults(9999)
   gg.editAll(0,  gg.TYPE_DWORD)
   gg.clearResults()
valueFromClass("CrateObject", "0x168", false, false,  gg.TYPE_DWORD)  
   gg.getResults(9999)
   gg.editAll(0,  gg.TYPE_DWORD)
   gg.clearResults()
valueFromClass("CrateObject", "0x16C", false, false,  gg.TYPE_DWORD)  
   gg.getResults(9999)
   gg.editAll(0,  gg.TYPE_DWORD)
   gg.clearResults()
valueFromClass("CrateObject", "0x170", false, false,  gg.TYPE_DWORD)  
   gg.getResults(9999)
   gg.editAll(696969,  gg.TYPE_DWORD)
   gg.clearResults()
   gg.alert("Done")  
end
----
function CrateOb7()
gg.alert("This may take time⌛")
valueFromClass("CrateObject", "0x15C", false, false,  gg.TYPE_DWORD)  
   gg.getResults(9999)
   gg.editAll(0,  gg.TYPE_DWORD)
   gg.clearResults()
valueFromClass("CrateObject", "0x160", false, false,  gg.TYPE_DWORD)  
   gg.getResults(9999)
   gg.editAll(0,  gg.TYPE_DWORD)
   gg.clearResults()
valueFromClass("CrateObject", "0x164", false, false,  gg.TYPE_DWORD)  
   gg.getResults(9999)
   gg.editAll(0,  gg.TYPE_DWORD)
   gg.clearResults()
valueFromClass("CrateObject", "0x168", false, false,  gg.TYPE_DWORD)  
   gg.getResults(9999)
   gg.editAll(0,  gg.TYPE_DWORD)
   gg.clearResults()
valueFromClass("CrateObject", "0x16C", false, false,  gg.TYPE_DWORD)  
   gg.getResults(9999)
   gg.editAll(0,  gg.TYPE_DWORD)
   gg.clearResults()
valueFromClass("CrateObject", "0x170", false, false,  gg.TYPE_DWORD)  
   gg.getResults(9999)
   gg.editAll(0,  gg.TYPE_DWORD)
   gg.clearResults()
valueFromClass("CrateObject", "0x174", false, false,  gg.TYPE_DWORD)  
   gg.getResults(9999)
   gg.editAll(696969,  gg.TYPE_DWORD)
   gg.clearResults()
   gg.alert("Done")  
end
----
function CrateOb8()
gg.alert("when you go to another load screen it will reset so re run this if you don't wanna spend a single gold")
valueFromClass("CrateObject", "0x174", false, false,  gg.TYPE_DWORD)  
   gg.getResults(9999)
   gg.editAll(0,  gg.TYPE_DWORD)
   gg.clearResults()
end
----
function BypassEletricCarTopSpeed()
   valueFromClass("EngineObject", "0x74", false, false,  gg.TYPE_DWORD)  
   gg.getResults(9999)
   gg.editAll(10000000,  gg.TYPE_DWORD)
   gg.clearResults()
end
----




































































































































































































































































































































































































































































































































































































































































----
Results = {}
function valueFromClass(class, offset, tryHard, bit32, valueType, SearchMode)
   if not SearchMode then
      SearchMode = { [1] = 'Class', [2] = 0x0 }
   end

   if SearchMode[1] == "Class" then
      SearchTypeSelection = 1
      Get_second_feild_offset = {}
      Get_second_feild_offset[1] = "0x0"
   elseif SearchMode[1] == "Struct" then
      SearchTypeSelection = 2
      Get_second_feild_offset = {}
      Get_second_feild_offset[1] = SearchMode[2]
   elseif SearchMode[1] == "ChildClass" then
      SearchTypeSelection = 3
      Get_second_feild_offset = {}
      Get_second_feild_offset[1] = SearchMode[2]
   end



   Get_user_input = {}
   Get_user_input[1] = class
   Get_user_input[2] = offset
   Get_user_input[3] = tryHard
   Get_user_input[4] = bit32


   if (valueType == gg.TYPE_BYTE or valueType == gg.TYPE_DWORD or valueType == gg.TYPE_QWORD or valueType == gg.TYPE_FLOAT or valueType == gg.TYPE_DOUBLE) then
      Get_user_type = valueType
   elseif (valueType == "Vector2") then
      Get_user_type = 6
   elseif (valueType == "Vector2Int") then
      Get_user_type = 7
   elseif (valueType == "Vector3") then
      Get_user_type = 8
   elseif (valueType == "Vector3Int") then
      Get_user_type = 9
   elseif (valueType == "Vector4") then
      Get_user_type = 10
   elseif (valueType == "Vector4Int") then
      Get_user_type = 11
   elseif (valueType == "String") then
      Get_user_type = 12
   elseif (valueType == "Bounds") then
      Get_user_type = 13
   elseif (valueType == "BoundsInt") then
      Get_user_type = 14
   elseif (valueType == "Matrix2x3") then
      Get_user_type = 15
   elseif (valueType == "Matrix4x4") then
      Get_user_type = 16
   elseif (valueType == "Color") then
      Get_user_type = 17
   elseif (valueType == "Color32") then
      Get_user_type = 18
   elseif (valueType == "Quaternion") then
      Get_user_type = 19
   end
   start()
   if error ~= 'fail' then
      local LatestValuesOfResult = gg.getValues(Results)
      for index, value in ipairs(Results) do
         Results[index].value = LatestValuesOfResult[index].value
      end

      return Results
   else
      return {}
   end
end

function loopCheck()
   if userMode == 1 then
      UI()
   elseif error == 5 then
      stopClose()
   end
end

function found_(message)
   if error == 1 then
      found2(message)
   elseif error == 2 then
      found3(message)
   elseif error == 3 then
      found4(message)
   else
      found(message)
   end
end

function found(message)
   if count == 0 then
      gg.clearResults()
      first_error = message
      error = 1
      second_start()
   end
end

function found2(message)
   if count == 0 then
      gg.clearResults()
      second_error = message
      error = 2
      third_start()
   end
end

function found3(message)
   if count == 0 then
      gg.clearResults()
      third_error = message
      error = 3
      fourth_start()
   end
end

function found4(message)
   if count == 0 then
      error = 'fail'
      gg.clearResults()
      gg.alert("")
      gg.setVisible(true)
      loopCheck()
   end
end

function SearchTypeChooser()
   local MenuItems
   MenuItems = {}
   for index, value in ipairs(SearchType) do
      MenuItems[index] = value['topic']
   end

   :: repeatMenu ::
   Menu = gg.choice(MenuItems, 0, "Please select The Search Type")
   if Menu == nil then
      gg.alert("i Error : Please Select An Option i")
      goto repeatMenu
   end

   SearchTypeSelection = Menu
end

function user_input_taker()
   SearchType = {
      [1] = {
         ['topic'] = 'Class Search',
         ['name'] = 'Class Name',
         ['offset'] = 'Field Offset',
      },
      [2] = {
         ['topic'] = 'Struct Search',
         ['name'] = 'Struct Container Class Name',
         ['offset'] = 'Struct Offset inside Container Class',
         ['offsetSecond'] = 'Input Struct Field Offset : ',
      },
      [3] = {
         ['topic'] = 'Child Class Search',
         ['name'] = 'Container Class Name',
         ['offset'] = 'Child Class Offset inside Container Class',
         ['offsetSecond'] = 'Input Child Class Field Offset : ',
      }
   }

   ::stort::
   if userMode == 1 then
      if Get_user_input == nil then
         default1 = "VehicleInfo"
         default2 = "0x28"
         default3 = false
         if (gg.getTargetInfo().x64) then
            default4 = false
         else
            default4 = true
         end
         SearchTypeSelection = 1
         default5 = false
         default7 = false
      else
         default1 = Get_user_input[1]
         default2 = Get_user_input[2]
         default3 = Get_user_input[3]
         default4 = Get_user_input[4]
         default5 = Get_user_input[6]
         default7 = Get_user_input[7]
      end
      if SearchTypeSelection == 1 then
         Get_user_input = gg.prompt(
    { "Script By: https://t.me/Hackers_House_YT\n\nScript Mode : " ..
      SearchType[SearchTypeSelection]['topic'] .. "\n\n " ..
      SearchType[SearchTypeSelection]['name'] .. " : ",
      SearchType[SearchTypeSelection]['offset'] .. " : ",
      "Try Harder --(decreases accuracy)",
      "Try For 32 bit",
      'Change Search Mode',
      'Give names and save',
      'Custom Load (Load multiple With names)',
      'Go Back to Select Mode' },
    { default1, default2, default3, default4, false, default5, default7, false },
    { "text", "text", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox" }
)


      else
         Get_user_input = gg.prompt(
            { "Script By: https://t.me/Hackers_House_YT\n\nScript Mode : " ..
            SearchType[SearchTypeSelection]['topic'] .. "\n\n " .. SearchType[SearchTypeSelection]['name'] .. " : ",
               SearchType[SearchTypeSelection]['offset'] .. " : ", "Try Harder --(decreases accuracy)", "Try For 32 bit",
               'Change Search Mode', 'Give names and save', },
            { default1, default2, default3, default4, false, default5 },
            { "text", "text", "checkbox", "checkbox", "checkbox", "checkbox" })
         Get_user_input[7] = false
      end

      if Get_user_input ~= nil then
         if Get_user_input[8] == true then
            GoBackToSelectMode()
            return
         end
         if Get_user_input[7] then
            Get_user_input[2] = 0x0
            ::CustomInput::
            CustomLoadData = gg.prompt({
               'Input The code from DUMP.CS file\nCopy from the class/struct name files and feilds\nproperties and methods not required ' })

            if CustomLoadData == nil then
               gg.alert("iPlease dont leave the input emptyi")
               goto CustomInput
            end
         end


         if Get_user_input[5] == true then
            SearchTypeChooser()
            goto stort
         end
         if (Get_user_input[1] == "") or (Get_user_input[2] == "") then
            gg.alert("i Don't Leave Input Blanki")
            goto stort
         end
      else
         gg.alert("i Error : Try again i")
         goto stort
      end





      ::UserTypeChooser::
      if Get_user_input[7] then
         Get_user_type = 20
      else
         Get_user_type = gg.choice(
            { "1. Byte / Boolean", "2. Dword / 32 bit Int", "3. Qword / 64 bit Int", "4. Float", "5. Double",
               "6. Vector2",
               "7. Vector2Int", "8. Vector3", "9. Vector3Int", "10. Vector4", "11. Vector4Int", "12. String",
               "13. Bounds",
               "14. BoundsInt", "15. Matrix2x3", "16. Matrix4x4", "17. Color", "18. Color32", "19. Quaternion",
               "+ Add Custom + " }, nil,
            "Script By: https://t.me/Hackers_House_YT\n\ni Choose The Output Type i")
      end


      if (Get_user_type == nil) then
         gg.alert("i Please select a type i")
         goto UserTypeChooser
      end
      if Get_user_type == 1 then
         Get_user_type = gg.TYPE_BYTE
      elseif Get_user_type == 2 then
         Get_user_type = gg.TYPE_DWORD
      elseif Get_user_type == 3 then
         Get_user_type = gg.TYPE_QWORD
      elseif Get_user_type == 4 then
         Get_user_type = gg.TYPE_FLOAT
      elseif Get_user_type == 5 then
         Get_user_type = gg.TYPE_DOUBLE
      end
      if Get_user_type ~= gg.TYPE_BYTE then
         local hex_values = {}
         if Get_user_input[7] then
            Get_user_input[2] = tostring(Get_user_input[2])
         end
         for hex in Get_user_input[2]:gmatch("0x%x+") do
            table.insert(hex_values, hex)
         end

         if Get_user_input[7] then
            Get_user_input[2] = string.format("0x%X", tonumber(Get_user_input[2]))
         end


         for i, v in ipairs(hex_values) do
            if (v % 4) ~= 0 then
               gg.alert("iHex Offset Must Be An Multiple OF 4i")
               goto stort
            end
         end
      end

      if Get_user_type ~= 20 or SearchTypeSelection == 3 then
         :: SearchType ::
         if (SearchTypeSelection == 2 or SearchTypeSelection == 3) then
            if Get_second_feild_offset == nil then
               defaultSecondOffset = "0xBC"
            else
               defaultSecondOffset = Get_second_feild_offset[1]
            end
            Get_second_feild_offset = gg.prompt(
               { "Script By: https://t.me/Hackers_House_YT\n\n" .. SearchType[SearchTypeSelection]['offsetSecond'] },
               { defaultSecondOffset })

            if Get_second_feild_offset == nil or Get_second_feild_offset[1] == "" then
               gg.alert("i Error : Dont leave the input empty i")
               goto SearchType
            end
         end


         if (SearchTypeSelection == 2 or SearchTypeSelection == 3) then
            local hexx_values = {}
            for hex in Get_second_feild_offset[1]:gmatch("0x%x+") do
               table.insert(hexx_values, hex)
            end

            for i, v in ipairs(hexx_values) do
               if (v % 4) ~= 0 then
                  gg.alert("iHex Offset Must Be An Multiple OF 4i")
                  goto SearchType
               end
            end
         end
      else
         Get_second_feild_offset = {}
         Get_second_feild_offset[1] = "0x0"
      end

      if Get_user_type == 20 then
         if not Get_user_input[7] then
            CustomTypeData = gg.prompt({
               'Input The code from DUMP.CS file\nCopy from the class/struct name files and feilds\nproperties and methods not required ' })
         end
      end
   end
   error = 0
end

function O_initial_search()
   gg.setVisible(false)
   gg.toast("[1/2]")
   user_input = ":" .. Get_user_input[1]
   if Get_user_input[3] then
      offst = 25
   else
      offst = 0
   end
end

function O_dinitial_search()
   if error > 1 then
      gg.setRanges(gg.REGION_C_ALLOC)
   else
      gg.setRanges(gg.REGION_OTHER)
   end
   gg.searchNumber(user_input, gg.TYPE_BYTE)
   count = gg.getResultsCount()
   if count == 0 then
      found_("O_dinitial_search")
      return 0
   end
   Refiner = gg.getResults(1)
   gg.refineNumber(Refiner[1].value, gg.TYPE_BYTE)
   count = gg.getResultsCount()
   if count == 0 then
      found_("O_dinitial_search")
      return 0
   end
   val = gg.getResults(count)
end

function CA_pointer_search()
   gg.clearResults()
   gg.setRanges(gg.REGION_C_ALLOC | gg.REGION_OTHER | gg.REGION_ANONYMOUS)
   gg.loadResults(val)
   gg.searchPointer(offst)
   count = gg.getResultsCount()
   if count == 0 then
      found_("CA_pointer_search")
      return 0
   end
   val = gg.getResults(count)
end

function CA_apply_offset()
   if Get_user_input[4] then
      tanker = 0xfffffffffffffff8
   else
      tanker = 0xfffffffffffffff0
   end
   local copy = false
   local l = val

   for i, v in ipairs(l) do
      v.address = v.address + tanker
      if copy then v.name = v.name .. ' #2' end
   end
   val = gg.getValues(l)
end

function CA2_apply_offset()
   if Get_user_input[4] then
      tanker = 0xfffffffffffffff8
   else
      tanker = 0xfffffffffffffff0
   end
   local copy = false
   local l = val
   for i, v in ipairs(l) do
      v.address = v.address + tanker
      if copy then v.name = v.name .. ' #2' end
   end
   val = gg.getValues(l)
end

function Q_apply_fix()
   gg.setRanges(gg.REGION_ANONYMOUS)
   gg.loadResults(val)
   count = gg.getResultsCount()
   if count == 0 then
      found_("Q_apply_fix")
      return 0
   end
   yy = gg.getResults(1000)
   gg.clearResults()
   i = 1
   c = 1
   s = {}
   while (i - 1) < count do
      yy[i].address = yy[i].address + 0xb400000000000000
      gg.searchNumber(yy[i].address, gg.TYPE_QWORD)
      cnt = gg.getResultsCount()
      if 0 < cnt then
         bytr = gg.getResults(cnt)
         n = 1
         while (n - 1) < cnt do
            s[c] = {}
            s[c].address = bytr[n].address
            s[c].flags = 32
            n = n + 1
            c = c + 1
         end
      end
      gg.clearResults()
      i = i + 1
   end
   val = gg.getValues(s)
end

function A_base_value()
   gg.setRanges(gg.REGION_ANONYMOUS)
   gg.loadResults(val)
   gg.searchPointer(offst)
   count = gg.getResultsCount()
   if count == 0 then
      found_("A_base_value")
      return 0
   end
   val = gg.getResults(count)
end

function A_base_accuracy()
   gg.setRanges(gg.REGION_ANONYMOUS | gg.REGION_C_ALLOC)
   gg.loadResults(val)
   gg.searchPointer(offst)
   count = gg.getResultsCount()
   if count == 0 then
      found_("A_base_accuracy")
      return 0
   end
   kol = gg.getResults(count)
   i = 1
   h = {}
   while (i - 1) < count do
      h[i] = {}
      h[i].address = kol[i].value
      h[i].flags = 32
      i = i + 1
   end
   val = gg.getValues(h)
end

function IsComplexTypeChoosen()
   local Output
   Output = {}
   if (Get_user_type == gg.TYPE_BYTE or Get_user_type == gg.TYPE_DWORD or Get_user_type == gg.TYPE_QWORD or Get_user_type == gg.TYPE_FLOAT or Get_user_type == gg.TYPE_DOUBLE) then
      Output['IsComplex'] = false
   elseif (Get_user_type == 6) then
      Output['IsComplex'] = true
      Output['FeildHandler'] = "Vector2"
   elseif (Get_user_type == 7) then
      Output['IsComplex'] = true
      Output['FeildHandler'] = "Vector2Int"
   elseif (Get_user_type == 8) then
      Output['IsComplex'] = true
      Output['FeildHandler'] = "Vector3"
   elseif (Get_user_type == 9) then
      Output['IsComplex'] = true
      Output['FeildHandler'] = "Vector3Int"
   elseif (Get_user_type == 10) then
      Output['IsComplex'] = true
      Output['FeildHandler'] = "Vector4"
   elseif (Get_user_type == 11) then
      Output['IsComplex'] = true
      Output['FeildHandler'] = "Vector4Int"
   elseif (Get_user_type == 12) then
      Output['IsComplex'] = true
      Output['FeildHandler'] = "String"
   elseif (Get_user_type == 13) then
      Output['IsComplex'] = true
      Output['FeildHandler'] = "Bounds"
   elseif (Get_user_type == 14) then
      Output['IsComplex'] = true
      Output['FeildHandler'] = "BoundsInt"
   elseif (Get_user_type == 15) then
      Output['IsComplex'] = true
      Output['FeildHandler'] = "Matrix2x3"
   elseif (Get_user_type == 16) then
      Output['IsComplex'] = true
      Output['FeildHandler'] = "Matrix4x4"
   elseif (Get_user_type == 17) then
      Output['IsComplex'] = true
      Output['FeildHandler'] = "Color"
   elseif (Get_user_type == 18) then
      Output['IsComplex'] = true
      Output['FeildHandler'] = "Color32"
   elseif (Get_user_type == 19) then
      Output['IsComplex'] = true
      Output['FeildHandler'] = "Quaternion"
   elseif (Get_user_type == 20) then
      Output['IsComplex'] = true
      Output['FeildHandler'] = "CustomFeild"
   end

   return Output
end

function A_user_given_offset()
   local old_save_list = val
   local uniqueTable = {} 
   local addressSet = {}  

   for _, item in ipairs(old_save_list) do
      if not addressSet[item.address] then
         table.insert(uniqueTable, item)
         addressSet[item.address] = true
      end
   end

   old_save_list = uniqueTable
 
   local finalResults = {}
   local finalResultIndex = 1
   local hex_values = {}
   local hexx_values = {}
   local complex_loaded_list = {}
   local TempComplexTypeStore = IsComplexTypeChoosen()
   if Get_user_input[7] then
      Get_user_input[2] = tostring(Get_user_input[2])
   end

   for hex in Get_user_input[2]:gmatch("0x%x+") do
      table.insert(hex_values, hex)
   end
   if Get_user_input[7] then
      Get_user_input[2] = '0x0'
   end


   for i, v in ipairs(old_save_list) do
      for index, value in ipairs(hex_values) do
         if Get_user_input[7] then
            value = 0
         end

         finalResults[finalResultIndex] = {}
         finalResults[finalResultIndex].address = v.address + value
         if (SearchTypeSelection == 1) then
            if (TempComplexTypeStore['IsComplex']) then
               local ComplexTypeRefrence = { ['address'] = v.address + value }
               local TempSingleTypeLoad = ComplexFeildsHandlers[TempComplexTypeStore['FeildHandler']](
                  ComplexTypeRefrence)

               for i = 1, #TempSingleTypeLoad do
                  complex_loaded_list[#complex_loaded_list + 1] = TempSingleTypeLoad[i]
               end
            else
               finalResults[finalResultIndex].flags = Get_user_type
            end
         else
            if Get_user_input[4] then
               finalResults[finalResultIndex].flags = gg.TYPE_DWORD
            else
               finalResults[finalResultIndex].flags = gg.TYPE_QWORD
            end
         end
         finalResultIndex = finalResultIndex + 1
      end
   end
   if (SearchTypeSelection == 1) then
      if (TempComplexTypeStore['IsComplex']) then
         finalResults = gg.getValues(complex_loaded_list)
         Results = complex_loaded_list
         if SearchTypeSelection == 1 then
            if Get_user_input[6] then
               gg.addListItems(complex_loaded_list)
            end
         end
      else
         finalResults = gg.getValues(finalResults)
         Results = finalResults
      end
   end


   if (SearchTypeSelection == 2) then
      for hex in Get_second_feild_offset[1]:gmatch("0x%x+") do
         table.insert(hexx_values, hex)
      end

      local structValues = {}
      local structValueIndex = 1;


      for i, v in ipairs(finalResults) do
         for index, value in ipairs(hexx_values) do
            if value == "0x0" then
               value = 0
            end
            if Get_user_input[7] then
               value = 0
            end

            structValues[structValueIndex] = {}
            structValues[structValueIndex].address = v.address + value
            if (TempComplexTypeStore['IsComplex']) then
               local ComplexTypeRefrence = { ['address'] = v.address + value }
               local TempSingleTypeLoad = ComplexFeildsHandlers[TempComplexTypeStore['FeildHandler']](
                  ComplexTypeRefrence)

               for i = 1, #TempSingleTypeLoad do
                  complex_loaded_list[#complex_loaded_list + 1] = TempSingleTypeLoad[i]
               end
            else
               structValues[structValueIndex].flags = Get_user_type
            end

            structValueIndex = structValueIndex + 1
         end
      end

      gg.clearResults()

      if (TempComplexTypeStore['IsComplex']) then
         structValues = gg.getValues(complex_loaded_list)
         Results = complex_loaded_list
         if SearchTypeSelection == 2 then
            if Get_user_input[6] then
               gg.addListItems(complex_loaded_list)
            end
         end
      else
         structValues = gg.getValues(structValues)
         Results = structValues
      end



      gg.loadResults(structValues)
   elseif (SearchTypeSelection == 3) then

      finalResults = gg.getValues(finalResults)
      for hex in Get_second_feild_offset[1]:gmatch("0x%x+") do
         table.insert(hexx_values, hex)
      end



      local childClassValues = {}
      local childClassIndex = 1;

      for i, v in ipairs(finalResults) do
         for index, value in ipairs(hexx_values) do
            if value == "0x0" then
               value = 0
            end
            childClassValues[childClassIndex] = {}
            childClassValues[childClassIndex].address = v.value + value


            if (TempComplexTypeStore['IsComplex']) then
               local ComplexTypeRefrence = { ['address'] = v.value + value }
               local TempSingleTypeLoad = ComplexFeildsHandlers[TempComplexTypeStore['FeildHandler']](
                  ComplexTypeRefrence)

               for i = 1, #TempSingleTypeLoad do
                  complex_loaded_list[#complex_loaded_list + 1] = TempSingleTypeLoad[i]
               end
            else
               childClassValues[childClassIndex].flags = Get_user_type
            end



            childClassIndex = childClassIndex + 1
         end
      end

      gg.clearResults()
      if (TempComplexTypeStore['IsComplex']) then
         childClassValues = gg.getValues(complex_loaded_list)
         Results = complex_loaded_list
         if SearchTypeSelection == 3 then
            if Get_user_input[6] then
               gg.addListItems(complex_loaded_list)
            end
         end
      else
         childClassValues = gg.getValues(childClassValues)
         Results = childClassValues
      end
      gg.loadResults(childClassValues)
   else
      gg.clearResults()
      gg.loadResults(finalResults)
   end

   count = gg.getResultsCount()
   if count == 0 then
      found_("A_user_given_offset")
      return 0
   end
   gg.setVisible(true)
end

function parseClass(input)
   local classAccess, classType, className = input:match("(%w+) (class) (%w+)")
   if not type then
      classAccess, classType, className = input:match("(%w+) (struct) (%w+)")
   end

   if Get_user_input[7] then
      classType = "struct"
   end
   local fields = {}

   local pattern = "(%w+) (%w+); // (0x%x+)"

   for type, name, offset in input:gmatch(pattern) do
      type = type:match("^%s*(.-)%s*$")
      table.insert(fields, { visibility = visibility, name = name, type = type, offset = offset })
   end

   return { classAccess = classAccess, classType = classType, className = className, fields = fields }
end
function GetHandler(Input)
   for index, value in ipairs(Input['fields']) do
      if Input['fields'][index]['type'] == 'int' then
         Input['fields'][index]['handler'] = 'BasicType'
         Input['fields'][index]['BasicType'] = gg.TYPE_DWORD
         Input['fields'][index]['Name'] = "(int, 32 bit, signed)"
      elseif Input['fields'][index]['type'] == 'uint' then
         Input['fields'][index]['handler'] = 'BasicType'
         Input['fields'][index]['BasicType'] = gg.TYPE_DWORD
         Input['fields'][index]['Name'] = "(int, 32 bit, unsigned)"
      elseif Input['fields'][index]['type'] == 'short' then
         Input['fields'][index]['handler'] = 'BasicType'
         Input['fields'][index]['BasicType'] = gg.TYPE_WORD
         Input['fields'][index]['Name'] = "(short, 16 bit, signed)"
      elseif Input['fields'][index]['type'] == 'ushort' then
         Input['fields'][index]['handler'] = 'BasicType'
         Input['fields'][index]['BasicType'] = gg.TYPE_WORD
         Input['fields'][index]['Name'] = "(short, 16 bit, unsigned)"
      elseif Input['fields'][index]['type'] == 'bool' then
         Input['fields'][index]['handler'] = 'BasicType'
         Input['fields'][index]['BasicType'] = gg.TYPE_BYTE
         Input['fields'][index]['Name'] = "(bool, 8 bit, unsigned)"
      elseif Input['fields'][index]['type'] == 'byte' then
         Input['fields'][index]['handler'] = 'BasicType'
         Input['fields'][index]['BasicType'] = gg.TYPE_BYTE
         Input['fields'][index]['Name'] = "(byte, 8 bit, unsigned)"
      elseif Input['fields'][index]['type'] == 'ubyte' then
         Input['fields'][index]['handler'] = 'BasicType'
         Input['fields'][index]['BasicType'] = gg.TYPE_BYTE
         Input['fields'][index]['Name'] = "(byte, 8 bit, signed)"
      elseif Input['fields'][index]['type'] == 'float' then
         Input['fields'][index]['handler'] = 'BasicType'
         Input['fields'][index]['BasicType'] = gg.TYPE_FLOAT
         Input['fields'][index]['Name'] = "(Float, 32 bit)"
      elseif Input['fields'][index]['type'] == 'double' then
         Input['fields'][index]['handler'] = 'BasicType'
         Input['fields'][index]['BasicType'] = gg.TYPE_DOUBLE
         Input['fields'][index]['Name'] = "(Double, 32 bit)"
      elseif Input['fields'][index]['type'] == 'Vector2' then
         Input['fields'][index]['handler'] = 'Vector2'
      elseif Input['fields'][index]['type'] == 'Vector2Int' then
         Input['fields'][index]['handler'] = 'Vector2Int'
      elseif Input['fields'][index]['type'] == 'Vector3' then
         Input['fields'][index]['handler'] = 'Vector3'
      elseif Input['fields'][index]['type'] == 'Vector3Int' then
         Input['fields'][index]['handler'] = 'Vector3Int'
      elseif Input['fields'][index]['type'] == 'Vector4' then
         Input['fields'][index]['handler'] = 'Vector4'
      elseif Input['fields'][index]['type'] == 'Vector4Int' then
         Input['fields'][index]['handler'] = 'Vector4Int'
      elseif Input['fields'][index]['type'] == 'Bounds' then
         Input['fields'][index]['handler'] = 'Bounds'
      elseif Input['fields'][index]['type'] == 'BoundsInt' then
         Input['fields'][index]['handler'] = 'BoundsInt'
      elseif Input['fields'][index]['type'] == 'Matrix2x3' then
         Input['fields'][index]['handler'] = 'Matrix2x3'
      elseif Input['fields'][index]['type'] == 'Matrix4x4' then
         Input['fields'][index]['handler'] = 'Matrix4x4'
      elseif Input['fields'][index]['type'] == 'Color' then
         Input['fields'][index]['handler'] = 'Color'
      elseif Input['fields'][index]['type'] == 'Color32' then
         Input['fields'][index]['handler'] = 'Color32'
      elseif Input['fields'][index]['type'] == 'Quaternion' then
         Input['fields'][index]['handler'] = 'Quaternion'
      elseif Input['fields'][index]['type'] == 'string' then
         Input['fields'][index]['handler'] = 'String'
      else
         if Get_user_input[4] then
            Input['fields'][index]['handler'] = 'BasicType'
            Input['fields'][index]['BasicType'] = gg.TYPE_DWORD
            Input['fields'][index]['Name'] = "(Unidentified : Pointer if class, first value if struct)"
         else
            Input['fields'][index]['handler'] = 'BasicType'
            Input['fields'][index]['BasicType'] = gg.TYPE_QWORD
            Input['fields'][index]['Name'] = "(Unidentified : Pointer if class, first value if struct)"
         end
      end
   end

   return Input
end

function start()
   user_input_taker()
   O_initial_search()
   O_dinitial_search()
   if error > 0 then
      return 0
   end
   CA_pointer_search()
   if error > 0 then
      return 0
   end
   CA_apply_offset()
   if error > 0 then
      return 0
   end
   A_base_value()
   if error > 0 then
      return 0
   end
   if offst == 0 then
      A_base_accuracy()
   end
   if error > 0 then
      return 0
   end
   A_user_given_offset()
   if error > 0 then
      return 0
   end
   loopCheck()
   if error > 0 then
      return 0
   end
end

function second_start()
   gg.toast("")
   O_dinitial_search()
   if error > 1 then
      return 0
   end
   CA_pointer_search()
   if error > 1 then
      return 0
   end
   CA_apply_offset()
   if error > 1 then
      return 0
   end
   Q_apply_fix()
   if error > 1 then
      return 0
   end
   if offst == 0 then
      A_base_accuracy()
   end
   if error > 1 then
      return 0
   end
   A_user_given_offset()
   if error > 1 then
      return 0
   end
   loopCheck()
   if error > 1 then
      return 0
   end
end

function third_start()
   gg.toast("")
   O_dinitial_search()
   if error > 2 then
      return 0
   end
   CA_pointer_search()
   if error > 2 then
      return 0
   end
   if offst == 0 then
      CA2_apply_offset()
   end
   if error > 2 then
      return 0
   end
   A_base_value()
   if error > 2 then
      return 0
   end
   if offst == 0 then
      A_base_accuracy()
   end
   if error > 2 then
      return 0
   end
   A_user_given_offset()
   if error > 2 then
      return 0
   end
   loopCheck()
   if error > 2 then
      return 0
   end
end

function fourth_start()
   gg.toast("")
   O_dinitial_search()
   CA_pointer_search()
   CA2_apply_offset()
   Q_apply_fix()
   if offst == 0 then
      A_base_accuracy()
   end
   A_user_given_offset()
   loopCheck()
end




ComplexFeildsHandlers = {
   ['BasicType'] = function(Input)
      local Output = {}
      Output[1] = {}
      Output[1].address = Input.address
      Output[1].flags = Input['BasicType']
      Output[1].name = Input['Name']
      if Input['name'] ~= nil then
         Output[1].name = Input['name'] .. "  " .. Output[1].name
      end
      return Output
   end,
   ['Vector2'] = function(Input)
      local Output = {}
      Output[1] = {}
      Output[1].address = Input.address
      Output[1].flags = gg.TYPE_FLOAT
      Output[1].name = " (Vector2 : X)"

      Output[2] = {}
      Output[2].address = Input.address + 0x4
      Output[2].flags = gg.TYPE_FLOAT
      Output[2].name = " (Vector2 : Y)"

      if Input['name'] ~= nil then
         Output[1].name = Input['name'] .. "  " .. Output[1].name
         Output[2].name = Input['name'] .. "  " .. Output[2].name
      end

      return Output
   end,
   ['Vector2Int'] = function(Input)
      local Output = {}
      Output[1] = {}
      Output[1].address = Input.address
      Output[1].flags = gg.TYPE_DWORD
      Output[1].name = " (Vector2Int : X)"

      Output[2] = {}
      Output[2].address = Input.address + 0x4
      Output[2].flags = gg.TYPE_DWORD
      Output[2].name = " (Vector2Int : Y)"

      if Input['name'] ~= nil then
         Output[1].name = Input['name'] .. "  " .. Output[1].name
         Output[2].name = Input['name'] .. "  " .. Output[2].name
      end

      return Output
   end,
   ['Vector3'] = function(Input)
      local Output = {}
      Output[1] = {}
      Output[1].address = Input.address
      Output[1].flags = gg.TYPE_FLOAT
      Output[1].name = " (Vector3 : X)"

      Output[2] = {}
      Output[2].address = Input.address + 0x4
      Output[2].flags = gg.TYPE_FLOAT
      Output[2].name = " (Vector3 : Y)"

      Output[3] = {}
      Output[3].address = Input.address + 0x8
      Output[3].flags = gg.TYPE_FLOAT
      Output[3].name = " (Vector3 : Z)"

      if Input['name'] ~= nil then
         Output[1].name = Input['name'] .. "  " .. Output[1].name
         Output[2].name = Input['name'] .. "  " .. Output[2].name
         Output[3].name = Input['name'] .. "  " .. Output[3].name
      end

      return Output
   end,
   ['Vector3Int'] = function(Input)
      local Output = {}
      Output[1] = {}
      Output[1].address = Input.address
      Output[1].flags = gg.TYPE_DWORD
      Output[1].name = " (Vector3Int : X)"

      Output[2] = {}
      Output[2].address = Input.address + 0x4
      Output[2].flags = gg.TYPE_DWORD
      Output[2].name = " (Vector3Int : Y)"

      Output[3] = {}
      Output[3].address = Input.address + 0x8
      Output[3].flags = gg.TYPE_DWORD
      Output[3].name = " (Vector3Int : Z)"

      if Input['name'] ~= nil then
         Output[1].name = Input['name'] .. "  " .. Output[1].name
         Output[2].name = Input['name'] .. "  " .. Output[2].name
         Output[3].name = Input['name'] .. "  " .. Output[3].name
      end

      return Output
   end,
   ['Vector4'] = function(Input)
      local Output = {}
      Output[1] = {}
      Output[1].address = Input.address
      Output[1].flags = gg.TYPE_FLOAT
      Output[1].name = " (Vector4 : X)"

      Output[2] = {}
      Output[2].address = Input.address + 0x4
      Output[2].flags = gg.TYPE_FLOAT
      Output[2].name = " (Vector4 : Y)"

      Output[3] = {}
      Output[3].address = Input.address + 0x8
      Output[3].flags = gg.TYPE_FLOAT
      Output[3].name = " (Vector4 : Z)"

      Output[4] = {}
      Output[4].address = Input.address + 0xC
      Output[4].flags = gg.TYPE_FLOAT
      Output[4].name = " (Vector4 : W)"

      if Input['name'] ~= nil then
         Output[1].name = Input['name'] .. "  " .. Output[1].name
         Output[2].name = Input['name'] .. "  " .. Output[2].name
         Output[3].name = Input['name'] .. "  " .. Output[3].name
         Output[4].name = Input['name'] .. "  " .. Output[4].name
      end

      return Output
   end,
   ['Vector4Int'] = function(Input)
      local Output = {}
      Output[1] = {}
      Output[1].address = Input.address
      Output[1].flags = gg.TYPE_DWORD
      Output[1].name = " (Vector4Int : X)"

      Output[2] = {}
      Output[2].address = Input.address + 0x4
      Output[2].flags = gg.TYPE_DWORD
      Output[2].name = " (Vector4Int : Y)"

      Output[3] = {}
      Output[3].address = Input.address + 0x8
      Output[3].flags = gg.TYPE_DWORD
      Output[3].name = " (Vector4Int : Z)"

      Output[4] = {}
      Output[4].address = Input.address + 0xC
      Output[4].flags = gg.TYPE_DWORD
      Output[4].name = " (Vector4Int : W)"

      if Input['name'] ~= nil then
         Output[1].name = Input['name'] .. "  " .. Output[1].name
         Output[2].name = Input['name'] .. "  " .. Output[2].name
         Output[3].name = Input['name'] .. "  " .. Output[3].name
         Output[4].name = Input['name'] .. "  " .. Output[4].name
      end
      return Output
   end,
   ['Bounds'] = function(Input)
      local Output = {}
      local TempSingleTypeLoad = ComplexFeildsHandlers.Vector3(Input)
      for i = 1, #TempSingleTypeLoad do
         TempSingleTypeLoad[i].name = "Bounds : m_Center " .. TempSingleTypeLoad[i].name
         Output[#Output + 1] = TempSingleTypeLoad[i]
      end

      local TempSingleTypeLoad = ComplexFeildsHandlers.Vector3({ ['address'] = Input.address + 0xC })
      for i = 1, #TempSingleTypeLoad do
         TempSingleTypeLoad[i].name = "Bounds : m_Extents " .. TempSingleTypeLoad[i].name
         Output[#Output + 1] = TempSingleTypeLoad[i]
      end

      return Output
   end,
   ['BoundsInt'] = function(Input)
      local Output = {}
      local TempSingleTypeLoad = ComplexFeildsHandlers.Vector3Int(Input)
      for i = 1, #TempSingleTypeLoad do
         TempSingleTypeLoad[i].name = "BoundsInt : m_Center " .. TempSingleTypeLoad[i].name
         Output[#Output + 1] = TempSingleTypeLoad[i]
      end

      local TempSingleTypeLoad = ComplexFeildsHandlers.Vector3Int({ ['address'] = Input.address + 0xC })
      for i = 1, #TempSingleTypeLoad do
         TempSingleTypeLoad[i].name = "BoundsInt : m_Extents " .. TempSingleTypeLoad[i].name
         Output[#Output + 1] = TempSingleTypeLoad[i]
      end

      return Output
   end,
   ['Matrix2x3'] = function(Input)
      local Output = {}
      Output[1] = {}
      Output[1].address = Input.address
      Output[1].flags = gg.TYPE_FLOAT
      Output[1].name = " (Matrix2x3 : m00)"

      Output[2] = {}
      Output[2].address = Input.address + 0x4
      Output[2].flags = gg.TYPE_FLOAT
      Output[2].name = " (Matrix2x3 : m01)"

      Output[3] = {}
      Output[3].address = Input.address + 0x8
      Output[3].flags = gg.TYPE_FLOAT
      Output[3].name = " (Matrix2x3 : m02)"

      Output[4] = {}
      Output[4].address = Input.address + 0xC
      Output[4].flags = gg.TYPE_FLOAT
      Output[4].name = " (Matrix2x3 : m10)"

      Output[5] = {}
      Output[5].address = Input.address + 0x10
      Output[5].flags = gg.TYPE_FLOAT
      Output[5].name = " (Matrix2x3 : m11)"

      Output[6] = {}
      Output[6].address = Input.address + 0x14
      Output[6].flags = gg.TYPE_FLOAT
      Output[6].name = " (Matrix2x3 : m12)"

      if Input['name'] ~= nil then
         Output[1].name = Input['name'] .. "  " .. Output[1].name
         Output[2].name = Input['name'] .. "  " .. Output[2].name
         Output[3].name = Input['name'] .. "  " .. Output[3].name
         Output[4].name = Input['name'] .. "  " .. Output[4].name
         Output[5].name = Input['name'] .. "  " .. Output[5].name
         Output[6].name = Input['name'] .. "  " .. Output[6].name
      end
      return Output
   end,
   ['Matrix4x4'] = function(Input)
      local Output = {}
      Output[1] = {}
      Output[1].address = Input.address
      Output[1].flags = gg.TYPE_FLOAT
      Output[1].name = " (Matrix4x4 : m00)"

      Output[2] = {}
      Output[2].address = Input.address + 0x4
      Output[2].flags = gg.TYPE_FLOAT
      Output[2].name = " (Matrix4x4 : m10)"

      Output[3] = {}
      Output[3].address = Input.address + 0x8
      Output[3].flags = gg.TYPE_FLOAT
      Output[3].name = " (Matrix4x4 : m20)"

      Output[4] = {}
      Output[4].address = Input.address + 0xC
      Output[4].flags = gg.TYPE_FLOAT
      Output[4].name = " (Matrix4x4 : m30)"

      Output[5] = {}
      Output[5].address = Input.address + 0x10
      Output[5].flags = gg.TYPE_FLOAT
      Output[5].name = " (Matrix4x4 : m01)"

      Output[6] = {}
      Output[6].address = Input.address + 0x14
      Output[6].flags = gg.TYPE_FLOAT
      Output[6].name = " (Matrix4x4 : m11)"

      Output[7] = {}
      Output[7].address = Input.address + 0x18
      Output[7].flags = gg.TYPE_FLOAT
      Output[7].name = " (Matrix4x4 : m21)"

      Output[8] = {}
      Output[8].address = Input.address + 0x1C
      Output[8].flags = gg.TYPE_FLOAT
      Output[8].name = " (Matrix4x4 : m31)"

      Output[9] = {}
      Output[9].address = Input.address + 0x20
      Output[9].flags = gg.TYPE_FLOAT
      Output[9].name = " (Matrix4x4 : m02)"

      Output[10] = {}
      Output[10].address = Input.address + 0x24
      Output[10].flags = gg.TYPE_FLOAT
      Output[10].name = " (Matrix4x4 : m12)"

      Output[11] = {}
      Output[11].address = Input.address + 0x28
      Output[11].flags = gg.TYPE_FLOAT
      Output[11].name = " (Matrix4x4 : m22)"

      Output[12] = {}
      Output[12].address = Input.address + 0x2C
      Output[12].flags = gg.TYPE_FLOAT
      Output[12].name = " (Matrix4x4 : m32)"

      Output[13] = {}
      Output[13].address = Input.address + 0x30
      Output[13].flags = gg.TYPE_FLOAT
      Output[13].name = " (Matrix4x4 : m03)"

      Output[14] = {}
      Output[14].address = Input.address + 0x34
      Output[14].flags = gg.TYPE_FLOAT
      Output[14].name = " (Matrix4x4 : m13)"

      Output[15] = {}
      Output[15].address = Input.address + 0x38
      Output[15].flags = gg.TYPE_FLOAT
      Output[15].name = " (Matrix4x4 : m23)"

      Output[16] = {}
      Output[16].address = Input.address + 0x3C
      Output[16].flags = gg.TYPE_FLOAT
      Output[16].name = " (Matrix4x4 : m33)"

      if Input['name'] ~= nil then
         Output[1].name = Input['name'] .. "  " .. Output[1].name
         Output[2].name = Input['name'] .. "  " .. Output[2].name
         Output[3].name = Input['name'] .. "  " .. Output[3].name
         Output[4].name = Input['name'] .. "  " .. Output[4].name
         Output[5].name = Input['name'] .. "  " .. Output[5].name
         Output[6].name = Input['name'] .. "  " .. Output[6].name
         Output[7].name = Input['name'] .. "  " .. Output[7].name
         Output[8].name = Input['name'] .. "  " .. Output[8].name
         Output[9].name = Input['name'] .. "  " .. Output[9].name
         Output[10].name = Input['name'] .. "  " .. Output[10].name
         Output[11].name = Input['name'] .. "  " .. Output[11].name
         Output[12].name = Input['name'] .. "  " .. Output[12].name
         Output[13].name = Input['name'] .. "  " .. Output[13].name
         Output[14].name = Input['name'] .. "  " .. Output[14].name
         Output[15].name = Input['name'] .. "  " .. Output[15].name
         Output[16].name = Input['name'] .. "  " .. Output[16].name
      end

      return Output
   end,
   ['Color'] = function(Input)
      local Output = {}
      Output[1] = {}
      Output[1].address = Input.address
      Output[1].flags = gg.TYPE_FLOAT
      Output[1].name = " (Color : Red)"

      Output[2] = {}
      Output[2].address = Input.address + 0x4
      Output[2].flags = gg.TYPE_FLOAT
      Output[2].name = " (Color : Blue)"

      Output[3] = {}
      Output[3].address = Input.address + 0x8
      Output[3].flags = gg.TYPE_FLOAT
      Output[3].name = " (Color : Green)"

      Output[4] = {}
      Output[4].address = Input.address + 0xC
      Output[4].flags = gg.TYPE_FLOAT
      Output[4].name = " (Color : Opacity)"

      if Input['name'] ~= nil then
         Output[1].name = Input['name'] .. "  " .. Output[1].name
         Output[2].name = Input['name'] .. "  " .. Output[2].name
         Output[3].name = Input['name'] .. "  " .. Output[3].name
         Output[4].name = Input['name'] .. "  " .. Output[4].name
      end
      return Output
   end,
   ['Color32'] = function(Input)
      local Output = {}
      Output[1] = {}
      Output[1].address = Input.address
      Output[1].flags = gg.TYPE_BYTE
      Output[1].name = " (Color32 : Red)"

      Output[2] = {}
      Output[2].address = Input.address + 0x1
      Output[2].flags = gg.TYPE_BYTE
      Output[2].name = " (Color32 : Blue)"

      Output[3] = {}
      Output[3].address = Input.address + 0x2
      Output[3].flags = gg.TYPE_BYTE
      Output[3].name = " (Color32 : Green)"

      Output[4] = {}
      Output[4].address = Input.address + 0x3
      Output[4].flags = gg.TYPE_BYTE
      Output[4].name = " (Color32 : Opacity)"


      if Input['name'] ~= nil then
         Output[1].name = Input['name'] .. "  " .. Output[1].name
         Output[2].name = Input['name'] .. "  " .. Output[2].name
         Output[3].name = Input['name'] .. "  " .. Output[3].name
         Output[4].name = Input['name'] .. "  " .. Output[4].name
      end
      return Output
   end,
   ['Quaternion'] = function(Input)
      local Output = {}
      Output[1] = {}
      Output[1].address = Input.address
      Output[1].flags = gg.TYPE_FLOAT
      Output[1].name = " (Quaternion : X)"

      Output[2] = {}
      Output[2].address = Input.address + 0x4
      Output[2].flags = gg.TYPE_FLOAT
      Output[2].name = " (Quaternion : Y)"

      Output[3] = {}
      Output[3].address = Input.address + 0x8
      Output[3].flags = gg.TYPE_FLOAT
      Output[3].name = " (Quaternion : Z)"

      Output[4] = {}
      Output[4].address = Input.address + 0xC
      Output[4].flags = gg.TYPE_FLOAT
      Output[4].name = " (Quaternion : W)"


      if Input['name'] ~= nil then
         Output[1].name = Input['name'] .. "  " .. Output[1].name
         Output[2].name = Input['name'] .. "  " .. Output[2].name
         Output[3].name = Input['name'] .. "  " .. Output[3].name
         Output[4].name = Input['name'] .. "  " .. Output[4].name
      end
      return Output
   end,
   ['String'] = function(Input)
      local flags
      if Get_user_input[4] then
         flags = gg.TYPE_DWORD
      else
         flags = gg.TYPE_QWORD
      end

      Input.flags = flags

      local TableList = {}
      TableList[1] = Input

      Input = gg.getValues(TableList)[1]
      local Output = {}
      local offset
      if Get_user_input[4] then
         offset = 0x8
      else
         offset = 0x10
      end
      StringLength = gg.getValues({ [1] = { ['address'] = Input.value + offset, ['flags'] = gg.TYPE_DWORD } })

      if StringLength[1].value < 0 then
         StringLength[1].value = 0
      elseif StringLength[1].value > 1000 then
         StringLength[1].value = 1000
      end

      for i = 1, StringLength[1].value * 2 + 1 do
         if i == 1 then
            Output[i] = { ['address'] = Input.value + offset, ['flags'] = gg.TYPE_DWORD }
         else
            Output[i] = {}
            Output[i].flags = gg.TYPE_BYTE
            Output[i].address = Input.value + offset + 0x3 + (i - 0x1)
         end
      end

      Output = gg.getValues(Output)


      FullString = ''

      for i = 1, #Output do
         local currentChar

         if Output[i].value < 0 or Output[i].value > 255 then
            currentChar = '*Invalid char*'
         else
            currentChar = string.char(Output[i].value)
         end
         if i ~= 1 then
            FullString = FullString .. currentChar
            Output[i].name = ' (String : Char no ' .. i - 1 .. ', Char : ' .. currentChar .. ')'
         end
      end
      Output[1].name = ' (Int :String length : ' .. Output[1].value .. ', Full string : ' .. FullString .. ')';

      return Output
   end,
   ['CustomFeild'] = function(Input)
      local complex_loaded_list = {}
      local PointerValue
      if Get_user_input[4] then
         PointerValue = gg.getValues({ [1] = { ['address'] = Input.address, ['flags'] = gg.TYPE_DWORD } })
      else
         PointerValue = gg.getValues({ [1] = { ['address'] = Input.address, ['flags'] = gg.TYPE_QWORD } })
      end

      if Get_user_input[7] then
         ClassParsedInTable = parseClass(tostring(CustomLoadData))
         ParsedClassWithHandlers = GetHandler(ClassParsedInTable)
      else
         ClassParsedInTable = parseClass(tostring(CustomTypeData))
         ParsedClassWithHandlers = GetHandler(ClassParsedInTable)
      end
      for index, value in ipairs(ParsedClassWithHandlers['fields']) do
         if ParsedClassWithHandlers['classType'] == 'class' then
            if Get_user_input[4] then
               ParsedClassWithHandlers['fields'][index].address = PointerValue[1].value +
                   ParsedClassWithHandlers['fields'][index].offset
            else
               ParsedClassWithHandlers['fields'][index].address = PointerValue[1].value +
                   ParsedClassWithHandlers['fields'][index].offset
            end
         else
            if ParsedClassWithHandlers['fields'][index].offset == "0x0" then
               ParsedClassWithHandlers['fields'][index].offset = 0
            else
            end
            ParsedClassWithHandlers['fields'][index].address = Input.address +
                ParsedClassWithHandlers['fields'][index].offset
         end
         local TempSingleTypeLoad = ComplexFeildsHandlers[ParsedClassWithHandlers['fields'][index].handler](
            ParsedClassWithHandlers['fields'][index])

         for i = 1, #TempSingleTypeLoad do
            complex_loaded_list[#complex_loaded_list + 1] = TempSingleTypeLoad[i]
         end
      end

      return complex_loaded_list
   end

}
----
function UI()
   gg.showUiButton()
   while true do
      if gg.isClickedUiButton() then
         start()
      end
   end
end

function stopClose()
   while true do
      mainMenu()
      gg.setVisible(false)
      while gg.isVisible() == false do
      end
   end
end
----
Savelist = Savelist or {} 
function menu2()
    local menu = gg.multiChoice({
        "Tune Hp & Rpm",
        "SaveList",
        "Go Back To Select Mode"
    }, nil, "T&N")

    if not menu then
        gg.toast("Exiting")
        os.exit()
    end

    if menu[1] then Edit_Both() end
    if menu[2] then ViewSavelist2() end
    if menu[3] then GoBackToSelectMode() end
end
----
function Edit_Both()
    gg.alert("Equip  ECU - INFINI-ZX")
    gg.setRanges(gg.REGION_ANONYMOUS)
    gg.searchNumber("255;2500", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1)
    local results = gg.getResults(99999)

    local hpResults = {}
    local rpmResults = {}

    for i, v in ipairs(results) do
        if v.value == 255 then
            v.name = "HP"
            table.insert(hpResults, v)
        elseif v.value == 2500 then
            v.name = "RPM"
            table.insert(rpmResults, v)
        end
    end

    if #hpResults == 0 then
        gg.toast("No HP")
        return menu2()
    end

    if #rpmResults == 0 then
        gg.toast("No RPM")
        return menu2()
    end

    local values = gg.prompt(
        {"New Hp", "New RPM"},
        {"", ""},
        {"number", "number"}
    )

    if not values or values[1] == "" or values[2] == "" then
        gg.toast("Cancelled")
        return menu2()
    end

    for i, v in ipairs(hpResults) do v.value = values[1] end
    for i, v in ipairs(rpmResults) do v.value = values[2] end

    gg.setValues(hpResults)
    gg.setValues(rpmResults)

    table.insert(Savelist, {name="ECUHP", value=values[1], results=hpResults, flags=gg.TYPE_DWORD})
    table.insert(Savelist, {name="ECURPM", value=values[2], results=rpmResults, flags=gg.TYPE_DWORD})

    gg.toast("Hp & RPM Added In SaveList")
    return menu2()
end

function ViewSavelist2()
    if type(Savelist) ~= "table" or #Savelist == 0 then
        gg.toast("SaveList Empty")
        return menu2()
    end

    local listStrings = {}
    for i, v in ipairs(Savelist) do
        local name = tostring(v.name or ("Entry " .. i))
        local value = tostring(v.value or "")
        listStrings[i] = name .. " = " .. value
    end
    listStrings[#listStrings + 1] = "Back"

    local choice = gg.choice(listStrings, nil, "Savelist")
    if not choice or choice == #listStrings then 
        return menu2()
    end

    local selected = Savelist[choice]
    if type(selected) ~= "table" or not selected.results or selected.flags == nil then
        gg.toast("Err")
        return menu2()
    end

    local inputValue = gg.prompt(
        {"StaT".. tostring(selected.name)},
        {tostring(selected.value)},
        {selected.flags}
    )
    if not inputValue then 
        return menu2()  
    end

    local newNum = tonumber(inputValue[1])
    if newNum == nil then
        gg.toast("Err")
        return menu2()
    end

    selected.value = newNum

    gg.loadResults(selected.results)
    gg.editAll(selected.value, selected.flags)
    gg.clearResults()
    gg.toast("StaT" .. tostring(selected.name))
    return menu2()
end
----
----

local isMenuOpen = false
local lastMenu = "selectMode" 

while true do
    if gg.isVisible(true) then
        gg.setVisible(false)
        if not isMenuOpen then
            isMenuOpen = true

            if lastMenu == "selectMode" then
                userMode = selectMode()

                if userMode == 1 then
                    gg.toast("V4 Field Offset Selected Tap Game Guardian (If it didn't show) then Sx")
                    lastMenu = "selectMode"
                    UI()

                elseif userMode == 2 then
                    gg.toast("APEX Racer Selected")
                    lastMenu = "selectMode"
                    mainMenu()

                elseif userMode == 3 then
                    gg.toast("T&N Selected")
                    lastMenu = "selectMode"
                    menu2()

                elseif userMode == 4 then
                    gg.toast("Tap GG Icon Again To Show")
                    HideIcon()
                    
                elseif userMode == 5 then
                    gg.toast("Exiting")
                    os.exit()
                end

            elseif lastMenu == "selectMode" then
                selectMode()

            elseif lastMenu == "selectMode" then
                selectMode()

            elseif lastMenu == "selectMode" then
                selectMode()

            elseif lastMenu == "selectMode" then
                selectMode()

            else
                selectMode()
            end

            isMenuOpen = false
        end
    end
    gg.sleep(150)
end
