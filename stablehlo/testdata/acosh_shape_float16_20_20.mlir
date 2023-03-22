// RUN: stablehlo-translate --deserialize %s.0_9_0.bc | stablehlo-opt -inline | stablehlo-translate --interpret
// RUN: diff <(stablehlo-translate --deserialize %s.0_9_0.bc | stablehlo-opt) <(stablehlo-opt %s)
// RUN: diff <(stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = call @inputs() : () -> tensor<20x20xf16>
    %1 = call @expected() : () -> tensor<20x20xf16>
    %2 = stablehlo.constant dense<-1.000000e+00> : tensor<20x20xf16>
    %3 = stablehlo.compare  LT, %0, %2 : (tensor<20x20xf16>, tensor<20x20xf16>) -> tensor<20x20xi1>
    %4 = stablehlo.constant dense<0x7E00> : tensor<20x20xf16>
    %5 = stablehlo.constant dense<6.550400e+04> : tensor<20x20xf16>
    %6 = stablehlo.constant dense<2.558750e+02> : tensor<20x20xf16>
    %7 = stablehlo.compare  GE, %0, %6 : (tensor<20x20xf16>, tensor<20x20xf16>) -> tensor<20x20xi1>
    %8 = stablehlo.log %0 : tensor<20x20xf16>
    %9 = stablehlo.constant dense<2.000000e+00> : tensor<20x20xf16>
    %10 = stablehlo.constant dense<6.933590e-01> : tensor<20x20xf16>
    %11 = stablehlo.add %8, %10 : tensor<20x20xf16>
    %12 = stablehlo.constant dense<1.000000e+00> : tensor<20x20xf16>
    %13 = stablehlo.add %12, %0 : tensor<20x20xf16>
    %14 = stablehlo.constant dense<-1.000000e+00> : tensor<20x20xf16>
    %15 = stablehlo.add %14, %0 : tensor<20x20xf16>
    %16 = stablehlo.multiply %13, %15 : tensor<20x20xf16>
    %17 = stablehlo.sqrt %16 : tensor<20x20xf16>
    %18 = stablehlo.add %0, %17 : tensor<20x20xf16>
    %19 = stablehlo.log %18 : tensor<20x20xf16>
    %20 = stablehlo.select %7, %11, %19 : tensor<20x20xi1>, tensor<20x20xf16>
    %21 = stablehlo.select %3, %4, %20 : tensor<20x20xi1>, tensor<20x20xf16>
    %22 = stablehlo.custom_call @check.eq(%21, %1) : (tensor<20x20xf16>, tensor<20x20xf16>) -> tensor<i1>
    return %22 : tensor<i1>
  }
  func.func private @inputs() -> tensor<20x20xf16> {
    %0 = stablehlo.constant dense<"0xA2447DB7AF3686BE5EC512284D4062342640A6C12ABE54B82644CCBC8D40A43F1A43A947C6C595340A414045A7345C3D0D3D913D03C607C51ABC7447F134B531DFC0A6C663C139B57DBCC5B5A3354939A53CF8B959C5593DD5BC0E3E77BC9CBA5E43553D5ABFFEB5FBBF4E4107BFA2C0BEB2AE38BD3F38B545083DC115B091C000C129446B42A8B1BB3828C1C2C442BEF6B253C217390A3ED4B4D2BEDF3CF4B889C2573D00BC0B44D8C15E42DA4287BFA1C7E147264443C2EFC24E3BEC3DED376E2EFCC1E2C0FB42B945A4BEE243EB42E4B97FC0CF4211C13BBD54B975C445C23644E24200C5EDC2D8C1D0BE50C00D4264AD64C1F13FC2BC774673BF584395BD34B9233F51C0BE4575C0D345DA43773D7C4360444A3D24BE82C27C48634544B43FBC96C8B841423ECFC291C0D4BE8A3E3B3E4DBC2A4243465644F2C212404DBA383B2A3A56B0EFA48243443E9EBE994197C569430C46604112C621404D2A6D403DBF4342BDBB7B2B89C4D844C144CCC115C3E0BF3140473FBF3112BC7B46CDB8FABA2642CE419D3D063DE6C28F3D673C582AA03CFF414B41C23F084454C2933ABD46D82C05BCECC094BF403F1B414D42C1B8554139B874C09D3F69C56F1EC2BC712CD34053C6B22072C2E0360640A0C17D3C06B2804015C06F466525E62C003214C60F437CB923C11A44F6B9EEBB3B383B3F2CC34542E2C3C9BEAABBCB415CB1363920BC46C573C2033FCE3C6B405FBC87C7DE3D0C35E4BF2F29B739D0343BBBE8B6A4BD01BC0BC580BB25BE66C2ABC8CEBD3B2D08C641B796C203C6493A32B48B45AFBA8AB608BC134501C3ECB2853E093ECF4430C73B2E4AC16B3F0E41B940383E54C313BEEFBF763F802A7F44B3C179C26EBBF8391FC436B97C43D83967C17FC483447444D7342B3D2B459DBB4443E045843670399DC219410340E92F4FBCE7C303C107C3A541CBBFA6BB69C2BEBD5D4512B9C43635B26F3A813CA2BE27C22A40CD41AF4022BED93B35C3F43FD33DBABFE03DDBB8AEB945C44AB5353056BFB2C328C8F241163C483C7DC53DBEF5434448D54445C32BC590BAF742A42BEB415A44713B6B3466C17CC429BE6BBFB736E3C07DC376BEE32FA23D07B8853D4CBC"> : tensor<20x20xf16>
    return %0 : tensor<20x20xf16>
  }
  func.func private @expected() -> tensor<20x20xf16> {
    %0 = stablehlo.constant dense<"0x6E4000FE00FE007E007E00FE993D00FE6F3D007E007E00FE3440007EDA3D0E3DC33F7341007E00FE4D3EAF4000FE6D3AAD39DE3A007E007E007E654100FE00FE007E007E007E00FE007E00FE00FE00FE7B3800FE007E663A007ECB3B007E00FEE93F5D3A007E00FE007E863E007E007E00FE00FE1D3D00FE00FE007E00FE007E007E3640563F00FE00FE007E007E007E00FE007E00FEC53B00FE007E313900FE007E603A00FE2640007E4D3F9C3F007E007E81413440007E007E00FE8F3B00FE00FE007E007EB03FDC40007E1940A73F00FE007E953F007E007E00FE007E007E3B40A13F007E007E007E007E007E173F00FE007E3C3D007E1B41007EE63F007E00FEBB3C007EDE40007EE5401740A73AFB3F5040433A007E007EC441BD4000FE007E007ED93E123C007E007E007E4C3C0D3C007E2B3F0B414B40007E593D00FE00FE00FE00FE00FEFE3F153C007EC23E007EF03FF940943E007E6A3D00FEBA3D007E3B3F00FE00FE007E85407C40007E007E007E7B3DD33C00FE007E1D4100FE00FE283FE93EF63A9C39007EDB3A1F3700FE6A380C3F843E203D2540007E00FE314100FE007E007E007ECE3C5B3E423F00FE8C3E00FE007E0A3D007E00FE007E00FE1D3E007E00FE007E00FE4C3D007ED33700FECD3D007E194100FE00FE00FE007EBC3F00FE007E2E4000FE00FE00FECA3C007E3D3F007E007E00FEE73E00FE00FE007E007E007EA53CFF38B93D007E007E743B00FE007E00FE00FE00FE00FE00FE007E007E007E00FE007E007E007E007E00FE007E00FE007E007E00FE00FECC4000FE00FE007E9D40007E00FE493CC33B8240007E00FE007EEA3C503E043E0A3C007E007E007EF13C00FE5E40007E007E00FE00FE007E00FEFB3F00FE007E007E6040594000FEF939A74000FEDB3FEA4000FE00FE007E593E483D00FE007E007E007E007ECA3E007E00FE007E007EBA4000FE00FE00FE00FEF137007E007E743DE93EFB3D007E00FE007E3E3D613B007E793B00FE00FE007E00FE00FE007E007E007E033F9C32F535007E007E1E40AB418440007E007E00FEAE3F00FEFE3E4D4000FE00FE007E007E007E007E00FE007E007E007E00FE003B00FEC43A007E"> : tensor<20x20xf16>
    return %0 : tensor<20x20xf16>
  }
}
