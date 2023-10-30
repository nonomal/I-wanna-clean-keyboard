;@Ahk2Exe-AddResource *10 %A_ScriptDir%\html\index.html
;@Ahk2Exe-SetVersion v3.03
;@Ahk2Exe-SetMainIcon iwck.ico
;@Ahk2Exe-SetName i wanna clean keyboard
;@Ahk2Exe-Base AutoHotkey64.exe
;@Ahk2Exe-ExeName iwck
;@Ahk2Exe-SetDescription iwck
#include setting.ahk

#Requires AutoHotkey v2.0
#NoTrayIcon
#MaxThreadsPerHotkey 1
#Include ./web_gui/Neutron.ahk

block := 0
InHook := InputHook("M L16")
if VNT == 1 {
	InHook.VisibleNonText := True
	title := "iwck*"
} else {
	InHook.VisibleNonText := False
	title := "iwck"
}
dpiScale := A_ScreenDPI / 96
winW := dpiScale * 350
winH := dpiScale * 247
neutron := NeutronWindow().Load("index.html")
	.Opt("-Resize")
	.OnEvent("Close", (neutron) => ExitApp())
	.Show("w" winW " h" winH, "iwck")

neutron.qs("html").setAttribute("style", "font-size:" Round(A_ScreenDPI * 100 / 192) "px")
if VNT == 1 {
	neutron.qs("div#vnt").classList.remove("hidden")
}
return

Clicked(neutron, event) {
	; MsgBox "You clicked: " event.target.id
	global
	if StrCompare(event.target.id, "btn_block") == 0 {
		if (block != 1) {
			block := 1
			neutron.qs("button#btn_block").classList.remove("unlocked")
			neutron.qs("button#btn_block").classList.add("locked")
			neutron.qs(".circles").classList.remove("unlocked")
			neutron.qs(".circles").classList.add("locked")
			SetTimer blockKeyboard, -1
		} Else {
			block := 0
			neutron.qs("button#btn_block").classList.remove("locked")
			neutron.qs("button#btn_block").classList.add("unlocked")
			neutron.qs(".circles").classList.remove("locked")
			neutron.qs(".circles").classList.add("unlocked")
			InHook.Stop()
		}
	}
}

blockKeyboard() {
	global block, InHook
	loop {
		InHook.Start()
		InHook.Wait()
		if (!block) {
			Return
		}
	}
}

#HotIf block == 1
LWin:: Return
RWin:: Return
*CapsLock:: Return
PrintScreen:: Return
Sleep:: Return

Tab:: Return
CapsLock:: Return
LShift:: Return
RShift:: Return
LCtrl:: Return
RCtrl:: Return
LAlt:: Return
RAlt:: Return
#HotIf
