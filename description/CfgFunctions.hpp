class CfgFunctions {
  class ATGM {
    class functions {
      file = "functions";
      class allInit{preInit=1;};
      class radioSetup_ACRE2{postInit=1;};
      class radioSetup_TFAR{};
      class clientInit{postInit=1;};
      class client_briefing{postInit=1;};
      class client_sendMags{postInit=1;};
      class server_prepResupply{postInit=1;};
      class fillSupplyCrate{};
      class fillMedicalCrate{};
      class mortarStrike{};
      class notify{};
    };
  };
};