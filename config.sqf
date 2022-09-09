ATGM_LOGO_WEB = "https//i.imgur.com/myFyu7c.png";

ATGM_Settings = createHashMapFromArray [
  ["dummySetting", false],
  ["AutotuneRadios", true],
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
  ["RadioChannels_SR", [
    // chan number and interval above squad frequency
    [1, 0, "SQUAD"],
    [2, 0.1, "Red"],
    [3, 0.2, "Blue"],
    [4, 0.3, "Green"]
  ]],
  ["RadioChannels_LR", [
    // chan number and from defines.hpp
    [1, RADIO_PLATOON, "Platoon"],
    [2, RADIO_SUPPORT0, "Support"],
    [3, RADIO_COMPANY, "Company"]
  ]],
  ["RadioChannels_Support", [
    [1, RADIO_SUPPORT1, "1st support"],
    [2, RADIO_SUPPORT2, "2nd support"],
    [3, RADIO_SUPPORT3, "3rd support"],
    [4, RADIO_SUPPORT4, "4th support"],
    [5, RADIO_CONVOY, "Convoy"]
  ]]
];