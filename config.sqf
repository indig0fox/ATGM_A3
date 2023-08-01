ATGM_LOGO_WEB = "https//i.imgur.com/myFyu7c.png";

ATGM_Settings = createHashMapFromArray [
  ["dummySetting", false],
  ["AutoSetupRadios", true],
  ["StandardItems", [
    ["ACE_EntrenchingTool", 2],
    ["ACE_rope6", 2],
    ["ACE_SpareBarrel_Item", 2],
    ["rhs_weap_hk416d145", 2],
    ["rhs_weap_M136", 1]
  ]],
  ["MedicalItems", [
    ["FirstAidKit", 0],
    ["ACE_fieldDressing", 30],
    ["ACE_elasticBandage", 30],
    ["ACE_packingBandage", 30],
    ["ACE_quikclot", 30],
    ["ACE_epinephrine", 20],
    ["ACE_morphine", 20],
    ["ACE_tourniquet", 10],
    ["ACE_splint", 10],
    ["ACE_surgicalKit", 1],
    ["ACE_personalAidKit", 0],
    ["ACE_bloodIV_250", 0],
    ["ACE_bloodIV_500", 25],
    ["ACE_bloodIV", 10],
    ["ACE_plasmaIV_250", 0],
    ["ACE_plasmaIV_500", 0],
    ["ACE_plasmaIV", 0],
    ["ACE_salineIV_250", 0],
    ["ACE_salineIV_500", 0],
    ["ACE_salineIV", 0],
    ["ACE_bodyBag", 3],
    ["ACE_EarPlugs", 2],
    ["ACE_WaterBottle", 0],
    ["ACE_Canteen", 0],
    ["ry_canteen_item", 5]
  ]],
  ["EquipRadios_TFAR", createHashMapFromArray [
    [west, ["TFAR_anprc152", "TFAR_rt1523g"]],
    [east, ["TFAR_fadak", "TFAR_mr3000"]],
    [independent, ["TFAR_anprc148jem", "TFAR_anprc155"]],
    [civilian, ["TFAR_anprc152", "TFAR_rt1523g"]]
  ]],
  ["RadioChannels_TFAR_SR", [
    // channel, freq, name
    [1, RADIO_ALPHA, "ALPHA"],
    [2, RADIO_ALPHA + 0.1, "A-RED"],
    [3, RADIO_ALPHA + 0.2, "A-BLUE"],
    [4, RADIO_BRAVO, "BRAVO"],
    [5, RADIO_BRAVO + 0.1, "B-RED"],
    [6, RADIO_BRAVO + 0.2, "B-BLUE"],
    [7, RADIO_PLATOON, "PLATOON"],
    [8, RADIO_COMPANY, "COMPANY"]
  ]],
  ["RadioChannels_TFAR_LR", [
    // chan number and from defines.hpp
    [1, RADIO_PLATOON, "PLATOON"],
    [2, RADIO_COMPANY, "COMPANY"]
  ]],
  ["EquipRadios_ACRE", createHashMapFromArray [
    [west, ["ACRE_BF888S", "ACRE_PRC152"]],
    [east, ["ACRE_BF888S", "ACRE_PRC148"]],
    [independent, ["ACRE_BF888S", "ACRE_PRC148"]],
    [civilian, ["ACRE_BF888S"]]
  ]],
  ["RadioChannels_ACRE", [
    [1, "GENERAL"],
    [2, "PLATOON"],
    [3, "ALPHA"],
    [4, "BRAVO"],
    [5, "CHARLIE"],
    [6, "AIR"],
    [7, "MEDICAL"],
    [8, "SUPPORT"]
  ]],
  ["BabelLanguages_ACRE", [ // denotes the languages present in mission
    ["en", "English"],
    ["ru", "Russian"],
    ["ab", "Arabic"]
  ]],
  ["BabelSides_ACRE", [ // denotes which languages each side can speak
    [west, ["en"]],
    [east, ["ru"]],
    [independent, ["ab"]],
    [civilian, ["en", "ru", "ab"]]
  ]]
];