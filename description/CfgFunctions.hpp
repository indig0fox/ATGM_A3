class CfgFunctions {
  class ATGM {
    class functions {
      file = "functions";
      class client_briefing{postInit=1;};
      class client_sendMags{postInit=1;};
      class fillMedicalCrate{};
      class fillSupplyCrate{};
      class initAll{preInit=1;};
      class initClient{postInit=1;};
      class initServer{postInit=1;};
      class mortarStrike{};
      class notify{};
      class radioSetup_ACRE2{postInit=1;};
      class radioSetup_TFAR{};
      class server_prepResupply{postInit=1;};
      class server_safeZone{postInit=1;};
    };
  };
  class ATGM_webhooks {
    class functions {
    file = "webhooks";
    class attendanceReport{};
    class init{postInit=1};
    class userEvent{};
    class userKicked{};
    };
  };
};