// RUN: stablehlo-translate --deserialize %s.0_9_0.bc | stablehlo-opt -inline | stablehlo-translate --interpret
// RUN: diff <(stablehlo-translate --deserialize %s.0_9_0.bc | stablehlo-opt) <(stablehlo-opt %s)
// RUN: diff <(stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = call @inputs() : () -> tensor<20x30xf32>
    %1 = call @expected() : () -> tensor<20x30xf32>
    %2 = stablehlo.multiply %0, %0 : tensor<20x30xf32>
    %3 = stablehlo.constant dense<1.000000e+00> : tensor<f32>
    %4 = stablehlo.broadcast_in_dim %3, dims = [] : (tensor<f32>) -> tensor<20x30xf32>
    %5 = stablehlo.divide %4, %2 : tensor<20x30xf32>
    %6 = stablehlo.custom_call @check.eq(%5, %1) : (tensor<20x30xf32>, tensor<20x30xf32>) -> tensor<i1>
    return %6 : tensor<i1>
  }
  func.func private @inputs() -> tensor<20x30xf32> {
    %0 = stablehlo.constant dense<"0xE16F43BF9FD1E5BF120217BF981C433F9D82CEBF21682F40F8432D3FAE012B406BCB97C0D2A81041B7A14040E0950BC0EC8953BF28389FC06BE08A3FF13A3440DBBD03BE49199C40B729D53EF38F6C40E6D028C05D8397BE796806C091055F3FAEDD9CBEBF9C87C0C7F5E1C047031B40463AC9BEA8C8BBBF7BB8A03FB93F6B3FF2A70240BF359CC03B0F3FC0AE3031C0AE545B3FEBA1B5C08B6109BD0ECE86C0AB957E3F24A825C0B4298FBFFD6AA83E5FC4D33F0F3F463F075B613F9303113FEBC4EABF80ADD3BF896B0DC00101AA3E916E1A404B7309403CC16A404784B7BF4EC87C3FA77D4B3FEAF008BF1476953F99C4804047D059BF4C4678403AB90DC0AF310A41CCAB22BD578BD43F7B08B7BFD8B83340499F17BF8A2E5640CF381AC06E58B0402D25D93FFCC54F3ECDAD063F341DE040F19C943F2233264003F44C40D1C8A3BFA14CE33F7B418E3F5EFFC6C0790945C08D805C3F59C35E40BCC9EEBED613A73FAEF00940854E1EBE1722A53FD0730E416D591440222780C038698F3DF6D972BFF18ECEC00169E9C0A55E40407B5E16C09C213C40D6F7AC3FB7C57140503B9FBF73183CC0F6664BC04A1104C0D5438CC0F6C6AD40065C97BFB42DD83F526AFEBFA7BD5C400DCBFDBEA92DABC08C7D2F3F5A2029C042C406C1B06804C01B93853EC974C83E6E9985C06B3FCE3F013411419A84C840B7F34940BD87073FC96691407798A53F98F89ABF2782243FF0261A3F35DF1E4093297BBC48F9D5C0C7EF6FC07C25883F1B403240806599BE99DF773E6ED20F403F2705C0BAC949C01392983B04B051C0B9EF63C0F95EC5BF30FB0740E0EBF83FC2A9003F18E198C05F5D0A40F36C1040665892C06A62C4BF855A00C04F7FB5405348794083D3C1BEB8875B3F456870BEC0AD8B4011CEA3C092343240B0DE563F05F1EEBF4F031A401F5866C03A9D633FDFD180BF25B387BF674F0A40E4694DBF81B48FBF2821CBC0828DD7BF2A18EDBF2D9798BD69BBA73FD65438C08217AB3F14949740FA71124042F8C9BF603F2E4058FF8F40C7F38C40E9E84140B0E40FC08E930C4034DA0CC0BB6BEABF9039B8BFA454043FE4F98EBF6406B3BF42E847BE704200409869D7BE5D24D73F316631C0EFE107BDF64DF8BE11B7543D503A49C04898A040057128BF4B639A40E895AEBDF759D8BFCBDB3AC0A0D1824004022540FAFDD4C00E49B640F61010C002251740DCF2CC3E3A5490C0E33B46C0E18F0A3FEA4E4840D3FE8640A31C8EC0507F4DC0DAAC45C057EAA93F6116C43E359371C073220BC0F692913FEAC50E3FFDE35B3F707F36C085F275403FB9C83F458133C0CA0AB4C05D59E43FC0C5143FEB210BC0D51198C00ADE2F3F92ADC0BFE70E1B3FEA9787C0A132873FDD9C6B3F76330AC0B32D923F12FB37BFC9FEBBC014012EC0301F28C02A2423C05A243340FED9E93F03158F3FF3C3C43F78E89AC02985A93FC7B4823F814223BF9B3C21409F7E87BD1F84A43F20FD963F8C891140A0D99DC09C2C0CC07543A33F8F2C24BF4762AEBF9E2822C0B58593C008F0573F2D99FCBF310C313E8C423E40C801EDBF88AF9240D15F3EBF733B55BF6D652EBFFAA50ABE2F5654C0C01E22BFE2F7CEBFEBD5B63F6B0726404FD4543FD234944057146DBE89769E4006E7A6409279C8BF803885BF9B464D40E2AA35409CE406C060078540079D7A4026C6B74037D0CFBFD59BA2C03A34CA3F37BB3CC01F39EA3E5F9BA93FFED47D4050F101C00518824043732A40BFC486C077D928BEAB570740311BD5C06F161BC0043510BD73C0CF3F2D1E68C0C59284C08A519EBF791280BFE9A1453EE63D0CC0B1B3FABFCEB7F1BF97B7473D43B57F40A4565C40D196B7BF2225673F97DCA2C01EAEFDBF7B73603EFF64A43FBCA1B7BF05164CBF7B6635BF89E7B63F2BA3B5BDEA0542C05C270BC0C51B48BF24ACF4BD5F409B4002225140872B0BC088C73940CBCE9EC0E5C906C0CC112640D9C76DC04F418DBF85DD04C0541537400C7ABDBF66551F40594D15C0514133C0175204C0A04F1340048A00C0FFC4B93FE08A003F574FA2BFEAE81B3FFFFF5BBF123121C05DA8DB4006FC12409F0B6CC04CA7DE407729ABBF3D57ADBF185699C057F22DBF555A30BD4E29D0BE3F4042C0B2E9F6BF59A629BF9104F8BFF99E78BF636827C08E5E17C0E61D46BE3025C03E06DCCFBEFFFBFF3FF62F2640B723FBBFDB64AFBD8C83D43DE9BA8CBFBB81933F299191C05CF65B40F13AF0BF6C3AB13F9276A3C0BA46E3BF984AD0BF98BDBE3F276A763FFBC6C83F655A3EC023C3E73F20D6063F933199409005FF3EB8E948C0A21586C0CFB384BF74CD47409827BAC0E42E7D403D3513400DC62440D6DB43C0A99FFEC00D8FEABF30644DC0E0E79040347583BFE1D5EB3FDCE630C0AED4B23F7C62E03FC1EA3AC0FA4988C0D967A93F8E7DFD408664FABF2004A7404D2045C0BA51D03E742BD23FA54383BFCEEE3BBF09F164409F268D40BB0C413FD92A9940E7D7B8C08BCF2B40335236C023F62EC07ED9973F2AC699BF71BFBC40ACD27340735C084003C10E401676D73F35A74F405A70A3BF6D521C3D200BB23F8E92353F6F22B8BF45068340257BA9BF77428DC0C44A473EE10DB03FF54E99C0E538933ED0703140C22D73C0669FDDBEA125DB3EA08E7C3FE02F83BF7B2FA2C0F3575BBFAC6E3AC02D0E85C0940F39C0B83208406D2F18407C98793FA8F058C028EDFC3FB7CFD73F533301C0833F22C0F8E960402A5635C0F01BA73F430A88BFA118AD3F4EB633C00708C5C0C4029340559D5C4030893CC0E99805408A729040366378C0DA3557C0437684C0D9229BC0FDB1CF3FA9380F3F3FE4C63E023872BF822D03BFAC2A52C0C37BB9BE03CB963EA2EEE2C0AEAA2C400EB48D40573C07406686B5C05CA180405ED138BEF69E8BBFE1BEC23F6AA594409E839E3F7E760140415B2C401FFED13EB1E07F3FE6989ABF225C19409C5E28C04886A640B58986C0455F7E3FB3AEEBC0CF6DE840B8B0FF3FD8EB8740A06E23C005177C3E44EC8A3E2A1138C0028E0CBEF483374046999C40AAED94BF0922603E24D307403FBEAC40C60AB3BEA146F53E0999C63FD0CB23BF7CCC8540F9EB40C05B7005C05091343E4F970AC0155BCBBED63F53400E77DABFFCC5194163A6F63F465F294041A195C0FB8A6FC061EC67BF106D803F95E170BF647F17C052C184404A40FA3F61CECD4040C0183F2FD33D3FAD04714064B86B3F00992EBFDC28E3BFCC2EA13FF97914C0F540013F2D1F764026A7A1C0C4C4203F435D0341917BBCBFD40054C03814D24082E8CA3FDA39853F8FA41BBF4A8FCDBF5AA9A5C00F1F92BFC641D0BF4D254840558ABB3DE39A1CBF19292240"> : tensor<20x30xf32>
    return %0 : tensor<20x30xf32>
  }
  func.func private @expected() -> tensor<20x30xf32> {
    %0 = stablehlo.constant dense<"0x479FDB3F2FD39E3ED4EE3740EE5ADC3F7EB3C43E8A52083E70B60B409A6D0F3E2308363D806E483CC810E23DA044573EEA75BB3F5673253D9A78593F901F013E42AA7142B9212C3D629DB84027E6953DAD2C133E70B53641EC2B683E4FA7A83FC3732A411111643DBB4BA43C4E8D2E3E082ACF4079E3ED3EC35F223FD493973F97B2753E06E32B3D28CDE53D9397053EAB60AE3F4546FE3C5D3B5E4488CE663D5C6D813F6ED7183EDAA44C3F00DF13417D0EBB3E1E71D53FAC2DA53FEF7347409232983EEB36BB3E14B8513EFB1F11411CDE2F3EFC015E3E5837983D7414F93E7D47833FEA94CA3F81A95F4086C23B3FA1F47C3DBBD0B03FF816883D64D2503EE79F5B3CED801E44E9B0B93ED665FA3EC4DA013E2C723640D1DCB63DCD58303E01E0063DCEE7B13E1251C241233D67407703A73CC1E83D3F35D8173E81B3C73D255B1C3F8E5DA23E1E434F3F5DD5D33CE611D83DA487AC3FA30BA93D1F1E9340D940163F176F5C3E1A5D2742F9CF193FC2B04E3CC4953E3EC0637F3DBCEF4B43573C8E3F039CC43C9DF9993C87AEE23DE47F393EB902ED3D88310C3F1A828F3DC76C253FD019ED3D20C2CA3D4B79703EF72F553D1EE40A3D7614373F0980B33E7A99813E2D28AC3D573C8240F0230F3D4631084086A2123E18F0663C3E3C6F3EF6136B4103C3D040B4FD6A3DBD33C53EF9EE463C15A2D03C43AECD3DCA5764401D64463D60F4183F60A52E3F9EFB1A40B3813040CD2C263E6FFA8445E337B73C66B6913DDA47623FF001043EF43F3241D4878841CAC54A3E69916C3EE403CE3D502F3447FFC8BE3D8675A13DDC56D73EB4D4623E2862873E365E7D403C75333D4D155B3ED014493E25D7433D1F82D93E6B977E3E49A7FE3CD0FD863DA949DF409F0FAE3F7B2491410FFB563D1F511C3D0713043E7AB1B53FC3ED923E66D3303EEA199E3DA5EAA13F83C07C3FCDC5633F91415B3E8ECEC63F471A4B3F924DCB3C398BB43E1B3A953E442334433615153F10E2F63D04490F3F278D363DC292433E02A5CD3E6A240A3E60474A3D091D533D6418DF3D58924A3E6E3E543EB969533E77A6983E2F2BF73EC0846F40CF2D4D3F26DE023FEBE8D1410FF77E3E72C7B440DE3BB53E0747053E0C296344920E88409964B943F329CF3DE6A0223D69D41340CCF72F3D9C9B09439F36B33E1140F03D2116753DCA0B1A3E3CE9B83CD274FC3CEA154A3ED699373EBFB5C740B859493DF377D53DB3755A40FA11D13DE227663DA4AE4F3D1EA5C63D50ADD63DB546113FEF2ADA4022BE8F3D60AA583EC7EB453F4FC34D40AA7DAD3F72DEFB3D69AD8A3DB434D03E382B023EAB64013D44E0A03E9F803D4008AC583EB85F353DFC9B0740F7F4E13E23732E405221643DA277653F151C973F429A5B3E9F49443F35D3F73F915AED3C66870A3E7564143E60971D3E64B2023EF664993E0FE04C3FB2AAD83EBEC92E3D54F4113F5B82753FD35C1D401256213E85766443E8F71A3FE1FA373F6205463E5755283DA076553EFC5A1D3F629D1B4024ED093FC7811F3E58BA403DA0E6B33F7F78833EA9CE0542A4BCE73D4C56953EC1EE423D6875E73FAE7EB83F28E8094016305A42ED0DBA3D33951F40D5D4C33E67F0FA3E3528183EAB31B93FF6F33E3DEB3E95419E08273D9391163D0BB9D03E25546C3FED12C73D2D2DFE3D6081663ED1026D3DC08F853D0562F83CF23DC23E0FA01E3D192BCD3E8A81EB3D76E898401DCE113F2432823D2367783E67D3773DAC5D103E6CEE663DBF1D13421BFA643E8DB6B83C32622E3EEAB049446D5BC23EBEB19B3D75A46E3DB856273F2BB67F3F16C5D6410242553E9B77853E9E928F3E454FD243DE4A803D4DC9AC3D28E2F83EF3019D3F03221E3D0E5A823E2983A6419C321B3F91C4F83EDE66C93F03EDFE3F13C0FA3EC642FE42B5D5DE3D169B583EE77CD13F5A208C4209042E3D70CCBF3D1D8E583EAB0CF33D294F263DC8DC663E3115183EE95D943D8A35523F3C986D3EB242FA3D17A8E93EA136253E05293C3E2B88023EFC8D6F3EF547413E68DB7D3E4D13F33E02D87D40B5351F3F988C2C408151AD3F2B6D213EE7DBAD3C1124423E678E963D3D36A93CF52A0F3F61970B3FC863323DE19E0A4018DD0644D197C140F44FDE3D4E98893E3FBB1140245F883EF5B5873F3AA9153E560E373E98B8D5412D36E340E027C2400104803E01DE173EA400853EA157084388BEB942C9C7533FBCC4403FACF0453DB160AD3D465B913EE488053FA3F81C3DFD65A23EF459C13E0892E63EE2268A3F3818D03E9782E73D272C9C3EE9B26640DEB8323DE1FB804048D0CF3D264B693DAF2D6E3F4121D23D1312F23C30DD823D468D413EFD7B1A3E6DADDA3D3463813C8178983E99D9C63D37C0473DAAB5723F0DD3963E2907063EF226033F649CA63E9D19F03DBCCE613DDB26123F058C823C0ECC853E1F5D163DDEDFD73DB84CC14026E9BD3E136D733FEF82ED3F630BA03D0E85523D6A16E13F92C8323D7084F53CB2160E3E805BFC3D6704093E67E6353F2160313FFE76EB3CBF1A8D3D9391613E70D14D3E7DB2B43EB18AC23D95041D3FF9A32B448C50043F4F71FE3F4C69F73E5551743D9505123F1832523D3135D3415352073F6474323DA98341411237053E62DA8D3D28CAAA4094ABAE407B83833F77B6733F48741F3D795BAE3FA159F13D97EA6C3DCBF0F43DE21B623E3519353E28A7863FFC3DB23D3F21833E841CB43EC8437B3EC7541F3EE6D3A53DE61AFF3D4832163F72A2623F6FFC0B3F70DE013E1215D83C4412423DA35AAC3D96FEEB3D89FF6A3E3F05493D4BF7873D6B1EB53D3A0B6F3D4B462E3D7F76C23E1E7A4C40260FD440CBFA8E3F42BF734090EABD3D65D3F3403E7538412BE4A23CEFAE0C3EA3E1503DAF56653E6493FE3C4D7F7D3DCE95F5419C28573F362FDD3E1BD33D3D0EED263F533F7A3EB5300D3E2E3BBE40551F803FD97D2F3FBB55323EC0F4133EB840173D46B9673DBDA4813F3705973C21479B3C6D4F803EED07633DE7071D3E6400844183535941B997F73D2F4F54425515F93DCE082B3D1B1B3D3F43FCA6418A5A633E128F0C3DBED702410C708B40E4AFD43E6D551C40824A6A3DE262E13D768E6B3E26A40042475E5A3ED1D9CA407DF9BB3D2CC3AF3E8B60313C71E3893EA735123E3A563B3D2131923DA1F49B3FEB4D7E3F6E92903F05BF363E37FD6D3DD0F2853E990CC63C70C23340DACCE83F5768903DCCF8963FBC960940B390A23EB971213F40423E3ECA0E7B401B7B8A3DAE81203DF34622402B0E733CB220EC3EDDA3BA3D2B13BE3C27BFCB3E5A4F6C3F49242D403E86C63E32D5183DF670443F556AC13EF368D13DB181EE4248052B40D6801F3E"> : tensor<20x30xf32>
    return %0 : tensor<20x30xf32>
  }
}