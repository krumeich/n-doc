#!/usr/bin/env texlua

dofile("init_test_bridge.lua")

testbridge = {}

bridge_cc_core = require("bridge_cc_core")

function testbridge.test_replacelabel_subsystem()
   bridge_cc_core.replacelabel("sub.tls", "fq", tex.expected("TLS-Server"))
   bridge_cc_core.replacelabel("sub.tls", "no", tex.expected("TLS-Server"))
end

function testbridge.test_replacelabel_subsystem_failure()
   bridge_cc_core.replacelabel("sub.xxx", "fq", tex.expected("\\textcolor{red}{sub.xxx is undefined}"))
   bridge_cc_core.replacelabel("sub.xxx", "no", tex.expected("\\textcolor{red}{sub.xxx is undefined}"))
end

function testbridge.test_replacelabel_module()
   bridge_cc_core.replacelabel("mod.tls.core", "fq", tex.expected("TLS-Server::\\-Core"))
   bridge_cc_core.replacelabel("mod.tls.core", "no", tex.expected("Core"))
end

function testbridge.test_replacelabel_module_failure()
   bridge_cc_core.replacelabel("mod.tls.xxx", "fq", tex.expected("\\textcolor{red}{mod.tls.xxx is undefined}"))
   bridge_cc_core.replacelabel("mod.tls.xxx", "no", tex.expected("\\textcolor{red}{mod.tls.xxx is undefined}"))
end

function testbridge.test_replacelabel_interface()
   bridge_cc_core.replacelabel("int.tls.core.accept", "fq", tex.expected("TLS-Server::\\-Core//\\-TLS-Connection-Accept"))
   bridge_cc_core.replacelabel("int.tls.core.accept", "no", tex.expected("TLS-Connection-Accept"))
end

function testbridge.test_replacelabel_interface_failure()
   bridge_cc_core.replacelabel("int.tls.core.xxx", "fq", tex.expected("\\textcolor{red}{int.tls.core.xxx is undefined}"))
   bridge_cc_core.replacelabel("int.tls.core.xxx", "no", tex.expected("\\textcolor{red}{int.tls.core.xxx is undefined}"))
end

function testbridge.test_replacelabelplain_module()
   bridge_cc_core.replacelabelplain("mod.tls.core", "fq", tex.expected("TLS-Server::Core"))
   bridge_cc_core.replacelabelplain("mod.tls.core", "no", tex.expected("Core"))
end

function testbridge.test_replacelabelplain_module_failure()
   bridge_cc_core.replacelabelplain("mod.tls.xxx", "fq", tex.expected("\\textcolor{red}{mod.tls.xxx is undefined}"))
   bridge_cc_core.replacelabelplain("mod.tls.xxx", "no", tex.expected("\\textcolor{red}{mod.tls.xxx is undefined}"))
end

function testbridge.test_get_module_status()
   bridge_cc_core.get_module_status("mod.tls.core", tex.expected("\\enfc{}"))
   bridge_cc_core.get_module_status("mod.signservice.core", tex.expected("\\nontsf{}"))
end

function testbridge.test_print_module_to_sfr_table()
   local expectedresult=[[\begin{enfsfrtable}Enforcing~SFR\\\midrule\relax\sfrlinknoindex{fcs_ckm.2/tls} & \sfrlinknoindex{fcs_cop.1/tls.auth}\\\sfrlinknoindex{fcs_cop.1/tls.aes} & \sfrlinknoindex{ftp_itc.1/tls}\\\end{enfsfrtable}]]
   bridge_cc_core.print_module_to_sfr_table("mod.tls.core", "enf", tex.expected(expectedresult))
end

function testbridge.test_print_modules_for_sfr_rows()
  local expectedresult_all = [[\midrule\relax\index{\sfrplain{fcs_ckm.1}@\sfr{fcs_ckm.1}|textbf}\hypertarget{fcs_ckm.1}{\sfr{fcs_ckm.1}} & Enforcing & \tdslink[fq]{mod.cryptsystem.keymgmt}\\& Supporting & \ndocnone\\\midrule\relax\index{\sfrplain{fcs_ckm.2/ike}@\sfr{fcs_ckm.2/ike}|textbf}\hypertarget{fcs_ckm.2/ike}{\sfr{fcs_ckm.2/ike}} & Enforcing & \tdslink[fq]{mod.vpn.core}\\& Supporting & \ndocnone\\\midrule\relax\index{\sfrplain{fcs_ckm.2/tls}@\sfr{fcs_ckm.2/tls}|textbf}\hypertarget{fcs_ckm.2/tls}{\sfr{fcs_ckm.2/tls}} & Enforcing & \tdslink[fq]{mod.tls.core}\\& Supporting & \ndocnone\\\midrule\relax\index{\sfrplain{fcs_ckm.4}@\sfr{fcs_ckm.4}|textbf}\hypertarget{fcs_ckm.4}{\sfr{fcs_ckm.4}} & Enforcing & \tdslink[fq]{mod.cryptsystem.keymgmt}\\& Supporting & \ndocnone\\\midrule\relax\index{\sfrplain{fcs_cop.1/hash}@\sfr{fcs_cop.1/hash}|textbf}\hypertarget{fcs_cop.1/hash}{\sfr{fcs_cop.1/hash}} & Enforcing & \tdslink[fq]{mod.cryptsystem.algorithms}\\& Supporting & \ndocnone\\\midrule\relax\index{\sfrplain{fcs_cop.1/hmac}@\sfr{fcs_cop.1/hmac}|textbf}\hypertarget{fcs_cop.1/hmac}{\sfr{fcs_cop.1/hmac}} & Enforcing & \tdslink[fq]{mod.cryptsystem.algorithms}\\& Supporting & \ndocnone\\\midrule\relax\index{\sfrplain{fcs_cop.1/tls.aes}@\sfr{fcs_cop.1/tls.aes}|textbf}\hypertarget{fcs_cop.1/tls.aes}{\sfr{fcs_cop.1/tls.aes}} & Enforcing & \tdslink[fq]{mod.tls.core}\\& Supporting & \ndocnone\\\midrule\relax\index{\sfrplain{fcs_cop.1/tls.auth}@\sfr{fcs_cop.1/tls.auth}|textbf}\hypertarget{fcs_cop.1/tls.auth}{\sfr{fcs_cop.1/tls.auth}} & Enforcing & \tdslink[fq]{mod.tls.core}\\& Supporting & \ndocnone\\\midrule\relax\index{\sfrplain{fcs_rng.1/hashdrbg}@\sfr{fcs_rng.1/hashdrbg}|textbf}\hypertarget{fcs_rng.1/hashdrbg}{\sfr{fcs_rng.1/hashdrbg}} & Enforcing & \tdslink[fq]{mod.cryptsystem.rng}\\& Supporting & \ndocnone\\\midrule\relax\index{\sfrplain{fdp_rip.1}@\sfr{fdp_rip.1}|textbf}\hypertarget{fdp_rip.1}{\sfr{fdp_rip.1}} & Enforcing & \tdslink[fq]{mod.selfprotect.memory}\\& Supporting & \ndocnone\\\midrule\relax\index{\sfrplain{fpt_tdc.1/tls.zert}@\sfr{fpt_tdc.1/tls.zert}|textbf}\hypertarget{fpt_tdc.1/tls.zert}{\sfr{fpt_tdc.1/tls.zert}} & Enforcing & \tdslink[fq]{mod.tls.cert}\\& Supporting & \ndocnone\\\midrule\relax\index{\sfrplain{fpt_tdc.1/zert}@\sfr{fpt_tdc.1/zert}|textbf}\hypertarget{fpt_tdc.1/zert}{\sfr{fpt_tdc.1/zert}} & Enforcing & \tdslink[fq]{mod.vpn.cert}\\& Supporting & \ndocnone\\\midrule\relax\index{\sfrplain{fpt_stm.1}@\sfr{fpt_stm.1}|textbf}\hypertarget{fpt_stm.1}{\sfr{fpt_stm.1}} & Enforcing & \tdslink[fq]{mod.ntpclient.core}\\& Supporting & \ndocnone\\\midrule\relax\index{\sfrplain{fpt_tst.1}@\sfr{fpt_tst.1}|textbf}\hypertarget{fpt_tst.1}{\sfr{fpt_tst.1}} & Enforcing & \tdslink[fq]{mod.selfprotect.selftest}\\& Supporting & \tdslink[fq]{mod.selfprotect.selftest}\\\midrule\relax\index{\sfrplain{ftp_itc.1/tls}@\sfr{ftp_itc.1/tls}|textbf}\hypertarget{ftp_itc.1/tls}{\sfr{ftp_itc.1/tls}} & Enforcing & \tdslink[fq]{mod.tls.core}\\& Supporting & \ndocnone\\\midrule\relax\index{\sfrplain{ftp_itc.1/vpn}@\sfr{ftp_itc.1/vpn}|textbf}\hypertarget{ftp_itc.1/vpn}{\sfr{ftp_itc.1/vpn}} & Enforcing & \tdslink[fq]{mod.vpn.core}\\& Supporting & \tdslink[fq]{mod.adminsystem.mgmt}\\\midrule\relax\index{\sfrplain{ftp_trp.1/admin}@\sfr{ftp_trp.1/admin}|textbf}\hypertarget{ftp_trp.1/admin}{\sfr{ftp_trp.1/admin}} & Enforcing & \tdslink[fq]{mod.adminsystem.webserver}\\& Supporting & \tdslink[fq]{mod.vpn.core}\\]]
   bridge_cc_core.print_modules_for_sfr_rows(tex.expected(expectedresult_all))
end

function testbridge.test_print_tsfi_for_sfr_rows()
   local expectedresult_all = [[\midrule\relax\hypertarget{fcs_ckm.1}{\sfr{fcs_ckm.1}} & \tsfilink{ls.lan.tls}&Key negotiation for TLS\\&\tsfilink{ls.wan.ipsec}&Key negotiation for VPN\\\midrule\relax\hypertarget{fcs_ckm.2/ike}{\sfr{fcs_ckm.2/ike}} & \tsfilink{ls.wan.ipsec}&Key distribution for VPN\\\midrule\relax\hypertarget{fcs_ckm.2/tls}{\sfr{fcs_ckm.2/tls}} & \tsfilink{ls.lan.tls}&Key distribution for TLS\\\midrule\relax\hypertarget{fcs_ckm.4}{\sfr{fcs_ckm.4}} & \tsfilink{ls.lan.tls}&Terminate TLS connections to LAN\\&\tsfilink{ls.wan.ipsec}&Terminate IPSEC connections to WAN\\\midrule\relax\hypertarget{fcs_cop.1/hash}{\sfr{fcs_cop.1/hash}} & \tsfilink{ls.wan.ipsec}&IPSec hash operations\\&\tsfilink{ls.lan.tls}&TLS hash operations\\\midrule\relax\hypertarget{fcs_cop.1/hmac}{\sfr{fcs_cop.1/hmac}} & \tsfilink{ls.wan.ipsec}&IPSec HMAC operations\\&\tsfilink{ls.lan.tls}&TLS HMAC operations\\\midrule\relax\hypertarget{fcs_cop.1/tls.aes}{\sfr{fcs_cop.1/tls.aes}} & \tsfilink{ls.lan.tls}&TLS connections\\\midrule\relax\hypertarget{fcs_cop.1/tls.auth}{\sfr{fcs_cop.1/tls.auth}} & \tsfilink{ls.lan.tls}&TLS connections\\\midrule\relax\hypertarget{fcs_rng.1/hashdrbg}{\sfr{fcs_rng.1/hashdrbg}} & \tsfilink{ls.lan.tls}&TLS connections\\&\tsfilink{ls.wan.ipsec}&Key negotiation for VPN\\\midrule\relax\hypertarget{fdp_rip.1}{\sfr{fdp_rip.1}} & \tsfilink{no_tsfi}&Not accessible via TSFI\\\midrule\relax\hypertarget{fpt_tdc.1/tls.zert}{\sfr{fpt_tdc.1/tls.zert}} & \tsfilink{ls.lan.tls}&Validate TLS certificate\\\midrule\relax\hypertarget{fpt_tdc.1/zert}{\sfr{fpt_tdc.1/zert}} & \tsfilink{ls.wan.ipsec}&Validate VPN certificate\\\midrule\relax\hypertarget{fpt_stm.1}{\sfr{fpt_stm.1}} & \tsfilink{ls.wan.ntp}&Access to time service\\\midrule\relax\hypertarget{fpt_tst.1}{\sfr{fpt_tst.1}} & \tsfilink{ls.lan.httpmgmt}&Call self-test\\\midrule\relax\hypertarget{ftp_itc.1/tls}{\sfr{ftp_itc.1/tls}} & \tsfilink{ls.lan.tls}&Secure connection to management interface\\\midrule\relax\hypertarget{ftp_itc.1/vpn}{\sfr{ftp_itc.1/vpn}} & \tsfilink{ls.wan.ipsec}&Secure IPSec tunnel\\\midrule\relax\hypertarget{ftp_trp.1/admin}{\sfr{ftp_trp.1/admin}} & \tsfilink{ls.lan.httpmgmt}&Connection to management interface\\]]
   bridge_cc_core.print_tsfi_for_sfr_rows(tex.expected(expectedresult_all))
end

function testbridge.test_print_sfr_for_tsfi_rows()
   local expectedresult_all = [[\midrule\relax\hypertarget{ls.lan.httpmgmt}{\tsfi{ls.lan.httpmgmt}} & \sfrlink{fpt_tst.1}&Call self-test\\&\sfrlink{ftp_trp.1/admin}&Connection to management interface\\\midrule\relax\hypertarget{ls.lan.tls}{\tsfi{ls.lan.tls}} & \sfrlink{fcs_ckm.1}&Key negotiation for TLS\\&\sfrlink{fcs_ckm.2/tls}&Key distribution for TLS\\&\sfrlink{fcs_ckm.4}&Terminate TLS connections to LAN\\&\sfrlink{fcs_cop.1/hash}&TLS hash operations\\&\sfrlink{fcs_cop.1/hmac}&TLS HMAC operations\\&\sfrlink{fcs_cop.1/tls.aes}&TLS connections\\&\sfrlink{fcs_cop.1/tls.auth}&TLS connections\\&\sfrlink{fcs_rng.1/hashdrbg}&TLS connections\\&\sfrlink{fpt_tdc.1/tls.zert}&Validate TLS certificate\\&\sfrlink{ftp_itc.1/tls}&Secure connection to management interface\\\midrule\relax\hypertarget{ls.wan.ipsec}{\tsfi{ls.wan.ipsec}} & \sfrlink{fcs_ckm.1}&Key negotiation for VPN\\&\sfrlink{fcs_ckm.2/ike}&Key distribution for VPN\\&\sfrlink{fcs_ckm.4}&Terminate IPSEC connections to WAN\\&\sfrlink{fcs_cop.1/hash}&IPSec hash operations\\&\sfrlink{fcs_cop.1/hmac}&IPSec HMAC operations\\&\sfrlink{fcs_rng.1/hashdrbg}&Key negotiation for VPN\\&\sfrlink{fpt_tdc.1/zert}&Validate VPN certificate\\&\sfrlink{ftp_itc.1/vpn}&Secure IPSec tunnel\\\midrule\relax\hypertarget{ls.wan.ntp}{\tsfi{ls.wan.ntp}} & \sfrlink{fpt_stm.1}&Access to time service\\\midrule\relax\hypertarget{no_tsfi}{\tsfi{no_tsfi}} & \sfrlink{fdp_rip.1}&Not accessible via TSFI\\]]
   bridge_cc_core.print_sfr_for_tsfi_rows(tex.expected(expectedresult_all))
end

function testbridge.test_print_subsys_to_sfr_table()
   local expectedresult = [[\begin{enfsfrsubsystable}Enforcing~SFR & Beschreibung\\\midrule\relax\sfrlinknoindex{fcs_ckm.2/tls} & Verbindungsaufbau, Schlüsselverteilung für TLS\\\sfrlinknoindex{fcs_cop.1/tls.aes} & AES für TLS bereitstellen\\\sfrlinknoindex{fcs_cop.1/tls.auth} & Authentisierung des TLS-Partners\\\sfrlinknoindex{fpt_tdc.1/tls.zert} & Zertifikatsprüfung\\\sfrlinknoindex{ftp_itc.1/tls} & TLS-Verbindungen starten/beenden\\\end{enfsfrsubsystable}]]
   bridge_cc_core.print_subsys_to_sfr_table("sub.tls", "enf", tex.expected(expectedresult))
end

function testbridge.test_print_module_to_bundle_table()
   local expectedresult = [[\begin{bundletable}Bundles\\\midrule\relax\bundle{openvpn}\\\end{bundletable}]]
   bridge_cc_core.print_module_to_bundle_table("mod.vpn.core", tex.expected(expectedresult))
end

function testbridge.test_print_sf_to_tsfi_table()
   local expectedresult = [[\tsfilink{ls.lan.tls}]]
   bridge_cc_core.print_sf_to_tsfi_table("sf.tls", tex.expected(expectedresult))
end

function testbridge.test_print_tsfi_to_sf_table()
   local expectedresult = [[\secfunclink{sf.cryptographicservices}, \secfunclink{sf.tls}]]
   bridge_cc_core.print_tsfi_to_sf_table("ls.lan.tls", tex.expected(expectedresult))
end

function testbridge.test_getSfr()
   bridge_cc_core.getSfr("fcs_cop.1.1/hmac", tex.expected([[FCS\_COP.1.1/HMAC]]))
end

function testbridge.test_getSfrText()
   bridge_cc_core.getSfrText("fcs_cop.1.1/hmac", tex.expected([[Cryptographic operation/HMAC]]))
end

function testbridge.test_removeSfrSubComponent()
   bridge_cc_core.removeSfrSubComponent([[fau_stg.4/ak]], tex.expected([[fau_stg.4/ak]]))
   bridge_cc_core.removeSfrSubComponent([[fcs_ckm.1.1/ak.aes]], tex.expected([[fcs_ckm.1/ak.aes]]))
   bridge_cc_core.removeSfrSubComponent([[fcs_ckm.1.1/nk]], tex.expected([[fcs_ckm.1/nk]]))
   bridge_cc_core.removeSfrSubComponent([[FCS_CKM.1.1/NK.TLS]], tex.expected([[fcs_ckm.1/nk.tls]]))
   bridge_cc_core.removeSfrSubComponent([[fcs_ckm.1.1/nk.zert]], tex.expected([[fcs_ckm.1/nk.zert]]))
   bridge_cc_core.removeSfrSubComponent([[fcs_ckm.1/ak.aes]], tex.expected([[fcs_ckm.1/ak.aes]]))
   bridge_cc_core.removeSfrSubComponent([[FCS_CKM.1/NK]], tex.expected([[fcs_ckm.1/nk]]))
end


function testbridge.test_getSecfunc()
   bridge_cc_core.getSecfunc("sf.cryptographicservices", tex.expected([[SF.Cryp\-to\-gra\-phic\-Ser\-vices]]))
end

function testbridge.test_getSecfuncText()
   bridge_cc_core.getSecfuncText("sf.cryptographicservices", tex.expected([[Kryptografische Dienste]]))
end

function testbridge.test_getObjective()
   bridge_cc_core.getObjective("o.timeservice", tex.expected([[O.Zeitdienst]]))
end

function testbridge.test_getObjectiveText()
   bridge_cc_core.getObjectiveText("o.timeservice", tex.expected([[Nutzung eines sicheren Zeitdienstes]]))
end

function testbridge.test_getObjectiveSource()
   bridge_cc_core.getObjectiveSource("o.timeservice", tex.expected([[4.1.1]]))
end

function testbridge.test_getSubjobj()
   bridge_cc_core.getSubjobj("s_admin", tex.expected([[S\_Administrator]]))
end

function testbridge.test_getSubjobjText()
   bridge_cc_core.getSubjobjText("s_admin", tex.expected([[Subjekt, das für einen Administrator handelt.]]))
end

function testbridge.test_getTsfi()
   bridge_cc_core.getTsfi("ls.lan.tls", tex.expected([[LS.LAN.TLS]]))
end

function testbridge.test_print_testcase_table()
   local expected_result = [[Adminsystem\_1 & \tdslink[fq]{mod.adminsystem.webserver} & \sfr{ftp_trp.1/admin} & \tsfi{ls.lan.httpmgmt}\\__1exAdminsystem\_2 & \tdslink[fq]{mod.adminsystem.webserver} & \sfr{ftp_trp.1/admin} & \tsfi{ls.lan.httpmgmt}\\__1exAdminsystem\_3 & \tdslink[fq]{mod.adminsystem.webserver} & \sfr{ftp_trp.1/admin} & \tsfi{ls.lan.httpmgmt}\\__1exCryptsystem\_1 & \tdslink[fq]{mod.cryptsystem.algorithms} & \sfr{fcs_cop.1/hash} & \tsfi{ls.lan.tls}, \tsfi{ls.wan.ipsec}\\__1exCryptsystem\_2 & \tdslink[fq]{mod.cryptsystem.algorithms} & \sfr{fcs_cop.1/hash} & \tsfi{ls.lan.tls}, \tsfi{ls.wan.ipsec}\\__1exCryptsystem\_3 & \tdslink[fq]{mod.cryptsystem.algorithms} & \sfr{fcs_cop.1/hmac} & \tsfi{ls.lan.tls}, \tsfi{ls.wan.ipsec}\\__1exCryptsystem\_4 & \tdslink[fq]{mod.cryptsystem.keymgmt} & \sfr{fcs_ckm.1} & \tsfi{ls.lan.tls}, \tsfi{ls.wan.ipsec}\\__1exCryptsystem\_5 & \tdslink[fq]{mod.cryptsystem.keymgmt} & \sfr{fcs_ckm.4} & \tsfi{ls.lan.tls}, \tsfi{ls.wan.ipsec}\\__1exCryptsystem\_6 & \tdslink[fq]{mod.cryptsystem.rng} & \sfr{fcs_rng.1/hashdrbg} & \tsfi{ls.lan.tls}, \tsfi{ls.wan.ipsec}\\__1exNTP\_1 & \tdslink[fq]{mod.ntpclient.core} & \sfr{fpt_stm.1} & \tsfi{ls.wan.ntp}\\__1exNTP\_2 & \tdslink[fq]{mod.ntpclient.core} & \sfr{fpt_stm.1} & \tsfi{ls.wan.ntp}\\__1exSelfprotect\_1 & \tdslink[fq]{mod.selfprotect.memory} & \sfr{fdp_rip.1} & \tsfi{no_tsfi}\\__1exSelfprotect\_2 & \tdslink[fq]{mod.selfprotect.selftest} & \sfr{fpt_tst.1} & \tsfi{ls.lan.httpmgmt}\\__1exTLS\_1 & \tdslink[fq]{mod.tls.core} & \sfr{ftp_itc.1/tls}, \sfr{fcs_ckm.2/tls}, \sfr{fcs_cop.1/tls.aes}, \sfr{fcs_cop.1/tls.auth} & \tsfi{ls.lan.tls}\\__1exTLS\_2 & \tdslink[fq]{mod.tls.core} & \sfr{ftp_itc.1/tls}, \sfr{fcs_ckm.2/tls}, \sfr{fcs_cop.1/tls.aes}, \sfr{fcs_cop.1/tls.auth} & \tsfi{ls.lan.tls}\\__1exTLS\_3 & \tdslink[fq]{mod.tls.cert} & \sfr{fpt_tdc.1/tls.zert} & \tsfi{ls.lan.tls}\\__1exTLS\_4 & \tdslink[fq]{mod.tls.cert} & \sfr{fpt_tdc.1/tls.zert} & \tsfi{ls.lan.tls}\\__1exTLS\_5 & \tdslink[fq]{mod.tls.cert} & \sfr{fpt_tdc.1/tls.zert} & \tsfi{ls.lan.tls}\\__1exVPN\_1 & \tdslink[fq]{mod.vpn.core} & \sfr{ftp_itc.1/vpn}, \sfr{fcs_ckm.2/ike} & \tsfi{ls.wan.ipsec}\\__1exVPN\_2 & \tdslink[fq]{mod.vpn.core} & \sfr{ftp_itc.1/vpn}, \sfr{fcs_ckm.2/ike} & \tsfi{ls.wan.ipsec}\\__1exVPN\_3 & \tdslink[fq]{mod.vpn.cert} & \sfr{fpt_tdc.1/zert} & \tsfi{ls.wan.ipsec}\\__1exVPN\_4 & \tdslink[fq]{mod.vpn.cert} & \sfr{fpt_tdc.1/zert} & \tsfi{ls.wan.ipsec}\\__1exVPN\_5 & \tdslink[fq]{mod.vpn.cert} & \sfr{fpt_tdc.1/zert} & \tsfi{ls.wan.ipsec}\\__1ex]]
   bridge_cc_core.print_testcase_table(tex.expected(expected_result:gsub("__1ex", "[1ex]")))
end

function testbridge.test_print_sfr_to_num_testcase_table()
   local expected_result = [[\sfr{fcs_ckm.1} & 1 & \sfr{fcs_cop.1/hmac} & 1 & \sfr{fpt_tdc.1/tls.zert} & 3 & \sfr{ftp_itc.1/vpn} & 2\\\sfr{fcs_ckm.2/ike} & 2 & \sfr{fcs_cop.1/tls.aes} & 2 & \sfr{fpt_tdc.1/zert} & 3 & \sfr{ftp_trp.1/admin} & 3\\\sfr{fcs_ckm.2/tls} & 2 & \sfr{fcs_cop.1/tls.auth} & 2 & \sfr{fpt_stm.1} & 2\\\sfr{fcs_ckm.4} & 1 & \sfr{fcs_rng.1/hashdrbg} & 1 & \sfr{fpt_tst.1} & 1\\\sfr{fcs_cop.1/hash} & 2 & \sfr{fdp_rip.1} & 1 & \sfr{ftp_itc.1/tls} & 2\\]]
   bridge_cc_core.print_sfr_to_num_testcase_table(tex.expected(expected_result:gsub("__1ex", "[1ex]")))
end

function testbridge.test_print_tsfi_to_num_testcase_table()
   local expected_result = [[\tsfi{ls.lan} & 0 & \tsfi{ls.lan.udp} & 0 & \tsfi{ls.wan.ipsec} & 11\\\tsfi{ls.lan.ether} & 0 & \tsfi{ls.led} & 0 & \tsfi{ls.wan.ntp} & 2\\\tsfi{ls.lan.httpmgmt} & 4 & \tsfi{ls.wan} & 0 & \tsfi{ls.wan.tcp} & 0\\\tsfi{ls.lan.ip} & 0 & \tsfi{ls.wan.dhcp} & 0 & \tsfi{ls.wan.udp} & 0\\\tsfi{ls.lan.tcp} & 0 & \tsfi{ls.wan.ether} & 0 & \tsfi{no_tsfi} & 1\\\tsfi{ls.lan.tls} & 11 & \tsfi{ls.wan.ip} & 0\\]]
   bridge_cc_core.print_tsfi_to_num_testcase_table(tex.expected(expected_result:gsub("__1ex", "[1ex]")))
end

function testbridge.test_print_module_to_num_testcase_table()
   local expected_result = [[\tdslink[fq]{mod.adminsystem.mgmt} & \supp{} & 0 & \tdslink[fq]{mod.cryptsystem.rng} & \enfc{} & 1 & \tdslink[fq]{mod.tls.cert} & \enfc{} & 3\\\tdslink[fq]{mod.adminsystem.webserver} & \enfc{} & 3 & \tdslink[fq]{mod.ntpclient.core} & \enfc{} & 2 & \tdslink[fq]{mod.tls.core} & \enfc{} & 2\\\tdslink[fq]{mod.cryptsystem.algorithms} & \enfc{} & 3 & \tdslink[fq]{mod.selfprotect.memory} & \enfc{} & 1 & \tdslink[fq]{mod.vpn.cert} & \enfc{} & 3\\\tdslink[fq]{mod.cryptsystem.keymgmt} & \enfc{} & 2 & \tdslink[fq]{mod.selfprotect.selftest} & \enfc{} & 1 & \tdslink[fq]{mod.vpn.core} & \enfc{} & 2\\]]
   bridge_cc_core.print_module_to_num_testcase_table(tex.expected(expected_result:gsub("__1ex", "[1ex]")))
end

function testbridge.test_print_sf_table_header()
   local expected_result = [[& \rot{\textsmaller[1]{\secfunclink{sf.administration}}} & \rot{\textsmaller[1]{\secfunclink{sf.cryptographicservices}}} & \rot{\textsmaller[1]{\secfunclink{sf.networkservices}}} & \rot{\textsmaller[1]{\secfunclink{sf.selfprotection}}} & \rot{\textsmaller[1]{\secfunclink{sf.tls}}} & \rot{\textsmaller[1]{\secfunclink{sf.vpn}}} ]]
   -- bridge.print_sfr_to_sf_table_header(tex.expected(expected_result:gsub("__1ex", "[1ex]")))
   bridge_cc_core.print_table_header("sf", "secfunclink", tex.expected(expected_result:gsub("__1ex", "[1ex]")))
end

function testbridge.test_print_obj_table_header()
   local expected_result = [[& \rot{\textsmaller[1]{\objlink{o.admin}}} & \rot{\textsmaller[1]{\objlink{o.cert_check}}} & \rot{\textsmaller[1]{\objlink{o.protection}}} & \rot{\textsmaller[1]{\objlink{o.timeservice}}} & \rot{\textsmaller[1]{\objlink{o.tlscrypto}}} & \rot{\textsmaller[1]{\objlink{o.vpn_auth}}} & \rot{\textsmaller[1]{\objlink{o.vpn_conf}}} & \rot{\textsmaller[1]{\objlink{o.vpn_integrity}}} & \rot{\textsmaller[1]{\objlink{oe.realtimeclock}}} ]]
   bridge_cc_core.print_table_header("obj", "objlink", tex.expected(expected_result:gsub("__1ex", "[1ex]")))
end

function testbridge.test_print_number_of_labels()
   bridge_cc_core.print_number_of_labels("sf", tex.expected(6))
end

function testbridge.test_print_sfr_to_obj_table_body()
   local expected_result = [[\textsmaller[1]{\sfrlinknoindex{fcs_ckm.1}} & \tno & \tno & \tno & \tno & \tcheck & \tcheck & \tcheck & \tcheck & \tno\\\textsmaller[1]{\sfrlinknoindex{fcs_ckm.2/ike}} & \tno & \tno & \tno & \tno & \tno & \tcheck & \tcheck & \tcheck & \tno\\\textsmaller[1]{\sfrlinknoindex{fcs_ckm.2/tls}} & \tno & \tno & \tno & \tno & \tcheck & \tno & \tno & \tno & \tno\\\textsmaller[1]{\sfrlinknoindex{fcs_ckm.4}} & \tno & \tno & \tno & \tno & \tcheck & \tcheck & \tcheck & \tcheck & \tno\\\textsmaller[1]{\sfrlinknoindex{fcs_cop.1/hash}} & \tno & \tcheck & \tno & \tno & \tno & \tno & \tno & \tno & \tno\\\textsmaller[1]{\sfrlinknoindex{fcs_cop.1/hmac}} & \tno & \tcheck & \tno & \tno & \tno & \tno & \tno & \tno & \tno\\\textsmaller[1]{\sfrlinknoindex{fcs_cop.1/tls.aes}} & \tno & \tno & \tno & \tno & \tcheck & \tno & \tno & \tno & \tno\\\textsmaller[1]{\sfrlinknoindex{fcs_cop.1/tls.auth}} & \tno & \tno & \tno & \tno & \tcheck & \tno & \tno & \tno & \tno\\\textsmaller[1]{\sfrlinknoindex{fcs_rng.1/hashdrbg}} & \tno & \tno & \tno & \tno & \tno & \tno & \tno & \tno & \tno\\\textsmaller[1]{\sfrlinknoindex{fdp_rip.1}} & \tno & \tno & \tno & \tno & \tno & \tno & \tno & \tno & \tno\\\textsmaller[1]{\sfrlinknoindex{fpt_tdc.1/tls.zert}} & \tno & \tno & \tno & \tno & \tcheck & \tno & \tno & \tno & \tno\\\textsmaller[1]{\sfrlinknoindex{fpt_tdc.1/zert}} & \tno & \tcheck & \tno & \tno & \tno & \tno & \tno & \tno & \tno\\\textsmaller[1]{\sfrlinknoindex{fpt_stm.1}} & \tno & \tno & \tno & \tcheck & \tno & \tno & \tno & \tno & \tno\\\textsmaller[1]{\sfrlinknoindex{fpt_tst.1}} & \tno & \tno & \tcheck & \tno & \tno & \tno & \tno & \tno & \tno\\\textsmaller[1]{\sfrlinknoindex{ftp_itc.1/tls}} & \tno & \tno & \tno & \tno & \tno & \tno & \tno & \tno & \tno\\\textsmaller[1]{\sfrlinknoindex{ftp_itc.1/vpn}} & \tno & \tno & \tno & \tno & \tno & \tcheck & \tcheck & \tcheck & \tno\\\textsmaller[1]{\sfrlinknoindex{ftp_trp.1/admin}} & \tcheck & \tno & \tno & \tno & \tcheck & \tno & \tno & \tno & \tno\\]]
   bridge_cc_core.print_table_body({label_row="mainsfr", label_header='obj', macro='sfrlinknoindex', selector=cc_core.getSfr2Obj}, tex.expected(expected_result:gsub("__1ex", "[1ex]")))
end

function testbridge.test_print_sfr_to_sf_table_body()
   local expected_result = [[\textsmaller[1]{\sfrlinknoindex{fcs_ckm.1}} & \tno & \tcheck & \tno & \tno & \tno & \tno\\\textsmaller[1]{\sfrlinknoindex{fcs_ckm.2/ike}} & \tno & \tno & \tno & \tno & \tno & \tcheck\\\textsmaller[1]{\sfrlinknoindex{fcs_ckm.2/tls}} & \tno & \tno & \tno & \tno & \tcheck & \tno\\\textsmaller[1]{\sfrlinknoindex{fcs_ckm.4}} & \tno & \tcheck & \tno & \tno & \tno & \tno\\\textsmaller[1]{\sfrlinknoindex{fcs_cop.1/hash}} & \tno & \tcheck & \tno & \tno & \tno & \tno\\\textsmaller[1]{\sfrlinknoindex{fcs_cop.1/hmac}} & \tno & \tcheck & \tno & \tno & \tno & \tno\\\textsmaller[1]{\sfrlinknoindex{fcs_cop.1/tls.aes}} & \tno & \tno & \tno & \tno & \tcheck & \tno\\\textsmaller[1]{\sfrlinknoindex{fcs_cop.1/tls.auth}} & \tno & \tno & \tno & \tno & \tcheck & \tno\\\textsmaller[1]{\sfrlinknoindex{fcs_rng.1/hashdrbg}} & \tno & \tcheck & \tno & \tno & \tno & \tno\\\textsmaller[1]{\sfrlinknoindex{fdp_rip.1}} & \tno & \tno & \tno & \tcheck & \tno & \tno\\\textsmaller[1]{\sfrlinknoindex{fpt_tdc.1/tls.zert}} & \tno & \tno & \tno & \tno & \tcheck & \tno\\\textsmaller[1]{\sfrlinknoindex{fpt_tdc.1/zert}} & \tno & \tno & \tno & \tno & \tno & \tcheck\\\textsmaller[1]{\sfrlinknoindex{fpt_stm.1}} & \tno & \tno & \tcheck & \tno & \tno & \tno\\\textsmaller[1]{\sfrlinknoindex{fpt_tst.1}} & \tno & \tno & \tno & \tcheck & \tno & \tno\\\textsmaller[1]{\sfrlinknoindex{ftp_itc.1/tls}} & \tno & \tno & \tno & \tno & \tcheck & \tno\\\textsmaller[1]{\sfrlinknoindex{ftp_itc.1/vpn}} & \tno & \tno & \tno & \tno & \tno & \tcheck\\\textsmaller[1]{\sfrlinknoindex{ftp_trp.1/admin}} & \tcheck & \tno & \tno & \tno & \tno & \tno\\]]
   bridge_cc_core.print_table_body({label_row="mainsfr", label_header="sf", macro="sfrlinknoindex", selector=cc_core.getSfr2Sf}, tex.expected(expected_result:gsub("__1ex", "[1ex]")))
end

function testbridge.test_print_spd_to_obj_table_body()
   local expected_result = [[\textsmaller[1]{\spdlink{t.wan.client}} & \tno & \tno & \tno & \tno & \tno & \tcheck & \tcheck & \tcheck & \tno\\\textsmaller[1]{\spdlink{t.lan.admin}} & \tcheck & \tno & \tcheck & \tno & \tcheck & \tno & \tno & \tno & \tno\\\textsmaller[1]{\spdlink{t.mani_cert}} & \tno & \tcheck & \tno & \tno & \tno & \tno & \tno & \tno & \tno\\\textsmaller[1]{\spdlink{t.mani_time}} & \tno & \tno & \tno & \tno & \tno & \tno & \tno & \tno & \tcheck\\\textsmaller[1]{\spdlink{osp.tls}} & \tno & \tno & \tcheck & \tno & \tcheck & \tno & \tno & \tno & \tno\\\textsmaller[1]{\spdlink{osp.timeservice}} & \tno & \tno & \tno & \tno & \tno & \tno & \tno & \tno & \tcheck\\\textsmaller[1]{\spdlink{a.guidance}} & \tno & \tno & \tno & \tno & \tno & \tno & \tno & \tno & \tno\\]]
   bridge_cc_core.print_table_body({label_row="spd", label_header="obj", macro="spdlink", selector=cc_core.getSpd2Obj}, tex.expected(expected_result:gsub("__1ex", "[1ex]")))
end


-- function printTlsConnectionTable()
--    bridge_cc_core.printTlsConnectionTable(tex)
-- end

-- function getTlsConnectionTableRow(key, document)
--    bridge_cc_core.getTlsConnectionTableRow(key, document, tex)
-- end

-- function printTlsParametersForModule(key)
--    bridge_cc_core.printTlsParametersForModule(key, tex)
-- end

-- function getError(key)
--    bridge_cc_core.getError(key, tex)
-- end

os.exit( lu.LuaUnit.run() )
