B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=9.85
@EndOfDesignText@
#CustomBuildAction: folders ready, %WINDIR%\System32\Robocopy.exe,"..\..\Shared Files" "..\Files"
'Ctrl + click to sync files: ide://run?file=%WINDIR%\System32\Robocopy.exe&args=..\..\Shared+Files&args=..\Files&FilesSync=True
#End Region

#Macro: Title, Export B4XPages, ide://run?File=%B4X%\Zipper.jar&Args=%PROJECT_NAME%.zip

Sub Class_Globals
    Private Root As B4XView
    Private xui As XUI

    ' Arasaka Red (threat) palette
    Private COLOR_BG_RED As Int = 0xFF0A0000
    Private COLOR_PANEL_RED As Int = 0xFF1E0606
    Private COLOR_ACCENT_RED As Int = 0xFFFF0505
    Private COLOR_TEXT_RED As Int = 0xFFFF3333
    Private COLOR_DIM_RED As Int = 0xFF8A2A2A

    ' NightCity Cyan (calm) palette
    Private COLOR_BG_CYAN As Int = 0xFF000B14
    Private COLOR_PANEL_CYAN As Int = 0xFF06121C
    Private COLOR_ACCENT_CYAN As Int = 0xFF00F0FF
    Private COLOR_TEXT_CYAN As Int = 0xFF7DEFFF
    Private COLOR_DIM_CYAN As Int = 0xFF2A7A99

    Private COLOR_GREEN As Int = 0xFF00FF66

    Private CurrentBgColor As Int
    Private CurrentPanelColor As Int
    Private CurrentAccentColor As Int
    Private CurrentTextColor As Int
    Private CurrentDimColor As Int
    Private IsThreatMode As Boolean = True

    ' Dashboard data
    Private NodeTitles As List
    Private NodeSubs As List
    Private NodeIcons As List
    Private AppNames As List
    Private AppIcons As List
    Private ShortcutLeft As List
    Private ShortcutRight As List
    Private ThreatLeft As List
    Private ThreatRight As List

    ' Runtime
    Private clv As CustomListView
    Private RamCanvas As B4XCanvas
    Private RamView As B4XView
    Private RadarCanvas As B4XCanvas
    Private RadarView As B4XView
    Private EqCanvas As B4XCanvas
    Private EqView As B4XView
    Private RadarAngle As Int = 0
    Private RadarToken As Int = 0
    Private LayoutBuilt As Boolean = False
    Private LastW As Int = 0
    Private LastH As Int = 0
    Private LastLandscape As Boolean = False
End Sub

Public Sub Initialize
    NodeTitles = Array As String("SEARCH DATABASE", "ACTIVATE SENSOR", "ACTIVATE WALLET", "ACTIVATE MESSAGE", "ACTIVATE CALL", "OVERCLOCK PROTOCOL")
    NodeSubs = Array As String("DATAPOOL", "OPTICS KEROSHI", "EDDIES: 84,210", "DIRECT FEED", "SECURE HOLO", "NETRUN ENGINE")
    NodeIcons = Array As String(Chr(0xF1C0), Chr(0xF06E), Chr(0xF09D), Chr(0xF0E0), Chr(0xF095), Chr(0xF0E7))
    AppNames = Array As String("BIG DATA", "NETRUNNER", "CYBEROS", "DECK_SYS")
    AppIcons = Array As String(Chr(0xF0E8), Chr(0xF120), Chr(0xF109), Chr(0xF013))
    ShortcutLeft = Array As String("BIG DATA [FEED]", "HOLOCALL MATRIX", "NIGHT CITY ICE", "ARASAKA PROXY")
    ShortcutRight = Array As String("ONLINE", "STANDBY", "DECRYPT", "ROUTED")
    ThreatLeft = Array As String("SECURE ZONE", "PUBLIC ACCESS", "RESTRICTED SECTOR", "MAX HAZARD DANGER")
    ThreatRight = Array As String("OFFLINE", "OFFLINE", "OFFLINE", "ACTIVE")
End Sub

Private Sub B4XPage_Created (Root1 As B4XView)
    Root = Root1
	Root.LoadLayout("1")
    ApplyThemeColors(False)
    BuildLayout
End Sub

Private Sub B4XPage_Resize (Width As Int, Height As Int)
    If Width < 100 Or Height < 100 Then Return
    If LayoutBuilt = False Then
        LastW = Width
        LastH = Height
        LastLandscape = Width > Height
        BuildLayout
        Return
    End If
    Dim Land As Boolean = Width > Height
    Dim DW As Int = Abs(Width - LastW)
    Dim DH As Int = Abs(Height - LastH)
    If Land <> LastLandscape Or DW > 80dip Or DH > 140dip Then
        LastW = Width
        LastH = Height
        LastLandscape = Land
        BuildLayout
    Else
        RefreshCanvases
    End If
End Sub

Private Sub ApplyThemeColors(ThreatMode As Boolean)
    IsThreatMode = ThreatMode
    If IsThreatMode Then
        CurrentBgColor = COLOR_BG_RED
        CurrentPanelColor = COLOR_PANEL_RED
        CurrentAccentColor = COLOR_ACCENT_RED
        CurrentTextColor = COLOR_TEXT_RED
        CurrentDimColor = COLOR_DIM_RED
    Else
        CurrentBgColor = COLOR_BG_CYAN
        CurrentPanelColor = COLOR_PANEL_CYAN
        CurrentAccentColor = COLOR_ACCENT_CYAN
        CurrentTextColor = COLOR_TEXT_CYAN
        CurrentDimColor = COLOR_DIM_CYAN
    End If
End Sub

Private Sub RamText As String
    If IsThreatMode Then Return "66 (24)" Else Return "67 (33)"
End Sub

' ---------- Layout shell ----------

Private Sub BuildLayout
    If Root.Width < 100 Or Root.Height < 100 Then Return
    RadarToken = RadarToken + 1
    LayoutBuilt = True
    LastW = Root.Width
    LastH = Root.Height
    LastLandscape = Root.Width > Root.Height
    Root.RemoveAllViews
    Root.Color = CurrentBgColor
    'clv.Initialize(Me, "")
    clv.PressedColor = Bit.And(CurrentAccentColor, 0x33FFFFFF)
    'clv.DividerColor = xui.Color_Transparent
    clv.AsView.Color = CurrentBgColor
    Root.AddView(clv.AsView, 0, 0, Root.Width, Root.Height)
    clv.Clear
    If LastLandscape Then
        BuildLandscape
    Else
        BuildPortrait
    End If
    AnimateLoop(RadarToken)
End Sub

Private Sub BuildPortrait
    Dim W As Float = clv.AsView.Width
    AddItem(HeaderPanel(W, 96), 96, "")
    AddItem(RamPanel(W, 46), 46, "")
    AddItem(CallPanel(W, 158), 158, "")
    AddItem(GridPanel(W, 236, 2), 236, "")
    AddItem(TempPanel(W, 148), 148, "")
    AddItem(NodesTitlePanel(W, 30), 30, "")
    Dim i As Int = 0
    Do While i < NodeTitles.Size
        AddItem(NodeRow(W, 66, i), 66, "node:" & i)
        i = i + 1
    Loop
    AddItem(FooterPanel(W, 122), 122, "theme")
End Sub

Private Sub BuildLandscape
    Dim W As Float = clv.AsView.Width
    AddItem(HeaderPanel(W, 96), 96, "")
    AddItem(RamPanel(W, 46), 46, "")
    AddItem(TwoColRow(W, 252, "SYS", "RADAR"), 252, "")
    AddItem(TwoColRow(W, 176, "CALL", "AMBIENT"), 176, "")
    AddItem(TwoColRow(W, 190, "SHORTCUTS", "THREAT"), 190, "")
    AddItem(TwoColRow(W, 176, "GRID4", "TEMP"), 176, "")
    AddItem(NodesTitlePanel(W, 30), 30, "")
    Dim i As Int = 0
    Do While i < NodeTitles.Size
        AddItem(NodeRow(W, 66, i), 66, "node:" & i)
        i = i + 1
    Loop
    AddItem(FooterPanel(W, 122), 122, "theme")
End Sub

Private Sub TwoColRow(W As Float, H As Int, LeftKind As String, RightKind As String) As B4XView
    Dim Pad As Float = 12dip
    Dim row As B4XView = ItemBase(W, H)
    Dim cw As Float = (W - Pad * 3) / 2
    FillKind(AddFrameAt(row, Pad, 0, cw, H, ""), LeftKind)
    FillKind(AddFrameAt(row, Pad * 2 + cw, 0, cw, H, ""), RightKind)
    Return row
End Sub

Private Sub FillKind(Container As B4XView, Kind As String)
    If Kind = "SYS" Then FillSys(Container)
    If Kind = "RADAR" Then FillRadar(Container)
    If Kind = "CALL" Then FillCall(Container)
    If Kind = "AMBIENT" Then FillAmbient(Container)
    If Kind = "SHORTCUTS" Then FillShortcuts(Container)
    If Kind = "THREAT" Then FillThreat(Container)
    If Kind = "GRID4" Then FillGrid(Container, 4)
    If Kind = "TEMP" Then FillTemp(Container)
End Sub

Private Sub AddItem(Pnl As B4XView, H As Int, Value As Object)
    Pnl.Height = H ' enforce item height contract
    clv.Add(Pnl, Value)
End Sub

' ---------- Panel primitives ----------

Private Sub ItemBase(W As Float, H As Float) As B4XView
    Dim p As B4XView = xui.CreatePanel("")
    p.SetLayoutAnimated(0, 0, 0, W, H)
    p.Color = CurrentBgColor
    Return p
End Sub

Private Sub AddFrameAt(Parent As B4XView, X As Float, Y As Float, W As Float, H As Float, Event As String) As B4XView
    Dim o As B4XView = xui.CreatePanel(Event)
    o.Color = CurrentAccentColor
    Parent.AddView(o, X, Y, W, H)
    Dim inner As B4XView = xui.CreatePanel("")
    inner.Color = CurrentPanelColor
    o.AddView(inner, 2dip, 2dip, W - 4dip, H - 4dip)
    Return inner
End Sub

Private Sub AddFrameTo(Parent As B4XView, W As Float, H As Float, Event As String) As B4XView
    Dim Pad As Float = 12dip
    Return AddFrameAt(Parent, Pad, 0, W - Pad * 2, H, Event)
End Sub

Private Sub MkLabel(Txt As String, Size As Float, Color As Int, Bold As Boolean) As B4XView
    Dim Lbl As Label
    Lbl.Initialize("")
    Dim v As B4XView = Lbl
    v.Text = Txt
    v.TextSize = Size
    v.TextColor = Color
    If Bold Then
        v.Font = xui.CreateDefaultBoldFont(Size)
    Else
        v.Font = xui.CreateDefaultFont(Size)
    End If
    Return v
End Sub

Private Sub MkIcon(Txt As String, Size As Float, Color As Int) As B4XView
    Dim Lbl As Label
    Lbl.Initialize("")
    Dim v As B4XView = Lbl
    v.Text = Txt
    v.Font = xui.CreateFontAwesome(Size)
    v.TextColor = Color
    v.SetTextAlignment("CENTER", "CENTER")
    Return v
End Sub

Private Sub SectionTitle(Txt As String) As B4XView
    Dim v As B4XView = MkLabel(Txt, 12, CurrentAccentColor, True)
    v.SetTextAlignment("CENTER", "LEFT")
    Return v
End Sub

' ---------- Panel builders ----------

Private Sub HeaderPanel(W As Float, H As Int) As B4XView
    Dim p As B4XView = ItemBase(W, H)
    Dim c As B4XView = AddFrameTo(p, W, H, "")
    FillHeader(c)
    Return p
End Sub

Private Sub FillHeader(c As B4XView)
    Dim iw As Float = c.Width
    Dim LblTime As B4XView = MkLabel(DateTime.Time(DateTime.Now), 15, CurrentTextColor, True)
    c.AddView(LblTime, 10dip, 4dip, 110dip, 24dip)
    LblTime.SetTextAlignment("CENTER", "LEFT")
    Dim LblSig As B4XView = MkLabel("SIGNAL: 5G NET // VO-WIFI 99%", 10, CurrentDimColor, False)
    c.AddView(LblSig, 120dip, 4dip, iw - 130dip, 24dip)
    LblSig.SetTextAlignment("CENTER", "RIGHT")
    Dim LblRam As B4XView = MkLabel("CYBERDECK RAM: " & RamText, 15, CurrentTextColor, True)
    c.AddView(LblRam, 10dip, 30dip, iw - 20dip, 28dip)
    LblRam.SetTextAlignment("CENTER", "CENTER")
    Dim LblVer As B4XView = MkLabel("CYBERDECK v4.01 [MILITECH]", 10, CurrentDimColor, False)
    c.AddView(LblVer, 10dip, 60dip, iw - 20dip, 20dip)
    LblVer.SetTextAlignment("CENTER", "CENTER")
End Sub

Private Sub RamPanel(W As Float, H As Int) As B4XView
    Dim p As B4XView = ItemBase(W, H)
    Dim Pad As Float = 12dip
    Dim v As B4XView = xui.CreatePanel("")
    p.AddView(v, Pad, 8dip, W - Pad * 2, H - 16dip)
    Dim rc As B4XCanvas
    rc.Initialize(v)
    RamCanvas = rc
    RamView = v
    DrawRamBar
    Return p
End Sub

Private Sub CallPanel(W As Float, H As Int) As B4XView
    Dim p As B4XView = ItemBase(W, H)
    Dim c As B4XView = AddFrameTo(p, W, H, "")
    FillCall(c)
    Return p
End Sub

Private Sub FillCall(c As B4XView)
    Dim iw As Float = c.Width
    Dim ih As Float = c.Height
    Dim LblHead As B4XView = MkLabel("CALL: David     FLATLINED", 12, CurrentTextColor, True)
    c.AddView(LblHead, 10dip, 6dip, iw - 20dip, 22dip)
    LblHead.SetTextAlignment("CENTER", "LEFT")
    Dim av As B4XView = MkIcon(Chr(0xF007), 26, CurrentTextColor)
    c.AddView(av, 10dip, 34dip, 44dip, 44dip)
    Dim LblLucy As B4XView = MkLabel("// LUCY MESSAGE", 10, CurrentDimColor, False)
    c.AddView(LblLucy, 62dip, 32dip, iw - 72dip, 18dip)
    LblLucy.SetTextAlignment("CENTER", "LEFT")
    Dim EqW As Float = 108dip
    Dim LblTrack As B4XView = MkLabel("I Really Want To Stay At Your House", 13, CurrentTextColor, True)
    c.AddView(LblTrack, 62dip, 52dip, iw - 72dip - EqW - 8dip, 44dip)
    LblTrack.SetTextAlignment("TOP", "LEFT")
    Dim ev As B4XView = xui.CreatePanel("")
    c.AddView(ev, iw - 10dip - EqW, ih - 10dip - 36dip, EqW, 36dip)
    Dim ec As B4XCanvas
    ec.Initialize(ev)
    EqCanvas = ec
    EqView = ev
    DrawEq
End Sub

Private Sub GridPanel(W As Float, H As Int, Cols As Int) As B4XView
    Dim p As B4XView = ItemBase(W, H)
    FillGridInto(p, W, H, Cols)
    Return p
End Sub

Private Sub FillGrid(c As B4XView, Cols As Int)
    FillGridInto(c, c.Width, c.Height, Cols)
End Sub

Private Sub FillGridInto(Parent As B4XView, W As Float, H As Float, Cols As Int)
    Dim Pad As Float = 12dip
    Dim gap As Float = 8dip
    Dim total As Int = AppNames.Size
    Dim rows As Int = (total - 1) / Cols + 1
    Dim cw As Float = (W - Pad * 2 - gap * (Cols - 1)) / Cols
    Dim ch As Float = (H - gap * (rows - 1)) / rows
    Dim idx As Int = 0
    Dim r As Int = 0
    Do While r < rows
        Dim cc As Int = 0
        Do While cc < Cols
            If idx >= total Then Return
            Dim X As Float = Pad + cc * (cw + gap)
            Dim Y As Float = r * (ch + gap)
            Dim outer As B4XView = xui.CreatePanel("")
            outer.Color = CurrentAccentColor
            Parent.AddView(outer, X, Y, cw, ch)
            Dim nm As String = AppNames.Get(idx)
            Dim inner As B4XView = xui.CreatePanel("")
            inner.Color = CurrentPanelColor
            outer.AddView(inner, 2dip, 2dip, cw - 4dip, ch - 4dip)
            Dim IconTxt As String = AppIcons.Get(idx)
            Dim ic As B4XView = MkIcon(IconTxt, 24, CurrentAccentColor)
            inner.AddView(ic, 0, 8dip, cw - 4dip, 36dip)
            Dim lb As B4XView = MkLabel(nm, 11, CurrentTextColor, True)
            inner.AddView(lb, 0, ch - 34dip, cw - 4dip, 22dip)
            lb.SetTextAlignment("CENTER", "CENTER")
            idx = idx + 1
            cc = cc + 1
        Loop
        r = r + 1
    Loop
End Sub

Private Sub TempPanel(W As Float, H As Int) As B4XView
    Dim p As B4XView = ItemBase(W, H)
    Dim c As B4XView = AddFrameTo(p, W, H, "")
    FillTemp(c)
    Return p
End Sub

Private Sub FillTemp(c As B4XView)
    Dim iw As Float = c.Width
    Dim LblT As B4XView = MkLabel("19 °C", 34, CurrentTextColor, True)
    c.AddView(LblT, 12dip, 8dip, 150dip, 52dip)
    LblT.SetTextAlignment("CENTER", "LEFT")
    Dim sun As B4XView = MkIcon(Chr(0xF185), 30, CurrentAccentColor)
    c.AddView(sun, iw - 58dip, 10dip, 46dip, 46dip)
    Dim LblA As B4XView = MkLabel("ACID RAIN: MODERATE", 11, CurrentDimColor, False)
    c.AddView(LblA, 12dip, 66dip, iw - 24dip, 20dip)
    LblA.SetTextAlignment("CENTER", "LEFT")
    Dim LblB As B4XView = MkLabel("SMOG DENSITY: 88 PPM", 11, CurrentDimColor, False)
    c.AddView(LblB, 12dip, 88dip, iw - 24dip, 20dip)
    LblB.SetTextAlignment("CENTER", "LEFT")
    Dim LblC As B4XView = MkLabel(DateTime.Time(DateTime.Now), 10, CurrentDimColor, False)
    c.AddView(LblC, 12dip, 110dip, iw - 24dip, 18dip)
    LblC.SetTextAlignment("CENTER", "LEFT")
End Sub

Private Sub NodesTitlePanel(W As Float, H As Int) As B4XView
    Dim p As B4XView = ItemBase(W, H)
    Dim t As B4XView = SectionTitle("// CYBERNETIC NODES")
    p.AddView(t, 12dip, 0, W - 24dip, H)
    Return p
End Sub

Private Sub NodeRow(W As Float, H As Int, idx As Int) As B4XView
    Dim p As B4XView = ItemBase(W, H)
    Dim c As B4XView = AddFrameTo(p, W, H, "")
    FillNode(c, idx)
    Return p
End Sub

Private Sub FillNode(c As B4XView, idx As Int)
    Dim iw As Float = c.Width
    Dim ih As Float = c.Height
    Dim IconTxt As String = NodeIcons.Get(idx)
    Dim ic As B4XView = MkIcon(IconTxt, 20, CurrentAccentColor)
    c.AddView(ic, 6dip, (ih - 44dip) / 2, 44dip, 44dip)
    Dim t As String = NodeTitles.Get(idx)
    Dim LblT As B4XView = MkLabel("[" & Pad2(idx + 1) & "]  " & t, 12, CurrentTextColor, True)
    c.AddView(LblT, 56dip, 8dip, iw - 56dip - 34dip, 24dip)
    LblT.SetTextAlignment("CENTER", "LEFT")
    Dim s As String = NodeSubs.Get(idx)
    Dim LblS As B4XView = MkLabel(s, 10, CurrentDimColor, False)
    c.AddView(LblS, 56dip, 32dip, iw - 56dip - 34dip, 20dip)
    LblS.SetTextAlignment("CENTER", "LEFT")
    Dim dot As Int = CurrentAccentColor
    If idx = 5 Then dot = COLOR_GREEN
    Dim d As B4XView = MkIcon(Chr(0xF111), 11, dot)
    c.AddView(d, iw - 30dip, (ih - 20dip) / 2, 20dip, 20dip)
End Sub

Private Sub Pad2(n As Int) As String
    If n < 10 Then Return "0" & n Else Return "" & n
End Sub

Private Sub FooterPanel(W As Float, H As Int) As B4XView
    Dim p As B4XView = ItemBase(W, H)
    Dim iw As Float = W - 24dip
    Dim LblS As B4XView = MkLabel("SECURITY: ICE LEVEL 4", 10, CurrentDimColor, False)
    p.AddView(LblS, 12dip, 0, iw, 20dip)
    LblS.SetTextAlignment("CENTER", "LEFT")
    Dim LblR As B4XView = MkLabel("STATUS: COMBAT READY", 10, COLOR_GREEN, True)
    p.AddView(LblR, 12dip, 20dip, iw, 20dip)
    LblR.SetTextAlignment("CENTER", "LEFT")
    Dim b As B4XView = xui.CreatePanel("")
    b.Color = CurrentAccentColor
    p.AddView(b, 12dip, 48dip, iw, 52dip)
    Dim bi As B4XView = xui.CreatePanel("")
    bi.Color = CurrentPanelColor
    b.AddView(bi, 2dip, 2dip, iw - 4dip, 48dip)
    Dim bt As B4XView = MkLabel("TOGGLE DECK PROTOCOL", 13, CurrentTextColor, True)
    bi.AddView(bt, 0, 0, iw - 4dip, 48dip)
    bt.SetTextAlignment("CENTER", "CENTER")
    Dim LblF As B4XView = MkLabel("HEX: 0xDEADBEEF // NC-PD SYNC OK", 9, CurrentDimColor, False)
    p.AddView(LblF, 12dip, 104dip, iw, 16dip)
    LblF.SetTextAlignment("CENTER", "CENTER")
    Return p
End Sub

Private Sub FillSys(c As B4XView)
    Dim iw As Float = c.Width
    Dim t As B4XView = SectionTitle("SYS PROTOCOL 2077")
    c.AddView(t, 10dip, 6dip, iw - 20dip, 24dip)
    Dim rows As List = Array As String("TARGET: NIGHT CITY CYBERWARE", "DAEMON HOOK: ENGAGED [PORT 8042]", "0x7F4A 0x89C1 0x04EE 0xA31B", "ICE BREAKER: SHADOWRUNNER v2.4")
    Dim y As Float = 36dip
    Dim i As Int = 0
    Do While i < rows.Size
        Dim r As String = rows.Get(i)
        Dim lb As B4XView = MkLabel(r, 10, CurrentDimColor, False)
        c.AddView(lb, 10dip, y, iw - 20dip, 20dip)
        lb.SetTextAlignment("CENTER", "LEFT")
        y = y + 24dip
        i = i + 1
    Loop
    Dim LblD As B4XView = MkLabel("ZONE: DANGER", 12, CurrentAccentColor, True)
    c.AddView(LblD, 10dip, y + 8dip, iw - 20dip, 26dip)
    LblD.SetTextAlignment("CENTER", "LEFT")
End Sub

Private Sub FillAmbient(c As B4XView)
    Dim iw As Float = c.Width
    Dim t As B4XView = SectionTitle("// NIGHT CITY AMBIENT")
    c.AddView(t, 10dip, 6dip, iw - 20dip, 24dip)
    Dim rows As List = Array As String("ACID RAIN: MODERATE", "SMOG DENSITY: 88 PPM", "WATSON / KABUKI // SECTOR 04")
    Dim y As Float = 36dip
    Dim i As Int = 0
    Do While i < rows.Size
        Dim r As String = rows.Get(i)
        Dim lb As B4XView = MkLabel(r, 11, CurrentTextColor, False)
        c.AddView(lb, 10dip, y, iw - 20dip, 22dip)
        lb.SetTextAlignment("CENTER", "LEFT")
        y = y + 26dip
        i = i + 1
    Loop
End Sub

Private Sub FillShortcuts(c As B4XView)
    Dim iw As Float = c.Width
    Dim t As B4XView = SectionTitle("// NET RUNNER SHORTCUTS")
    c.AddView(t, 10dip, 6dip, iw - 20dip, 24dip)
    Dim y As Float = 36dip
    Dim i As Int = 0
    Do While i < ShortcutLeft.Size
        Dim l As String = ShortcutLeft.Get(i)
        Dim r As String = ShortcutRight.Get(i)
        Dim ll As B4XView = MkLabel(l, 11, CurrentTextColor, False)
        c.AddView(ll, 10dip, y, iw - 110dip, 22dip)
        ll.SetTextAlignment("CENTER", "LEFT")
        Dim rl As B4XView = MkLabel(r, 11, CurrentAccentColor, True)
        c.AddView(rl, iw - 100dip, y, 90dip, 22dip)
        rl.SetTextAlignment("CENTER", "RIGHT")
        y = y + 28dip
        i = i + 1
    Loop
End Sub

Private Sub FillThreat(c As B4XView)
    Dim iw As Float = c.Width
    Dim t As B4XView = SectionTitle("// THREAT LEVEL ASSESSMENT")
    c.AddView(t, 10dip, 6dip, iw - 20dip, 24dip)
    Dim y As Float = 36dip
    Dim i As Int = 0
    Do While i < ThreatLeft.Size
        Dim l As String = ThreatLeft.Get(i)
        Dim r As String = ThreatRight.Get(i)
        Dim lc As Int = CurrentDimColor
        Dim rc As Int = CurrentDimColor
        If i = 3 Then
            lc = CurrentAccentColor
            rc = COLOR_GREEN
        End If
        Dim ll As B4XView = MkLabel(l, 11, lc, i = 3)
        c.AddView(ll, 10dip, y, iw - 100dip, 22dip)
        ll.SetTextAlignment("CENTER", "LEFT")
        Dim rl As B4XView = MkLabel(r, 11, rc, True)
        c.AddView(rl, iw - 90dip, y, 80dip, 22dip)
        rl.SetTextAlignment("CENTER", "RIGHT")
        y = y + 28dip
        i = i + 1
    Loop
End Sub

Private Sub FillRadar(c As B4XView)
    Dim v As B4XView = xui.CreatePanel("")
    c.AddView(v, 6dip, 6dip, c.Width - 12dip, c.Height - 12dip)
    Dim bc As B4XCanvas
    bc.Initialize(v)
    RadarCanvas = bc
    RadarView = v
    DrawRadar
End Sub

' ---------- Canvas painters ----------

Private Sub DrawRamBar
    If Initialized(RamCanvas) = False Or Initialized(RamView) = False Then Return
    If RamView.Width < 20 Then Return
    RamCanvas.ClearRect(RamCanvas.TargetRect)
    Dim Total As Int = 16
    Dim Filled As Int = 11
    If IsThreatMode = False Then Filled = 10
    Dim gap As Float = 4dip
    Dim bw As Float = (RamView.Width - gap * (Total - 1)) / Total
    Dim H As Float = RamView.Height
    For i = 0 To Total - 1
        Dim r As B4XRect
        r.Initialize(i * (bw + gap), 0, i * (bw + gap) + bw, H)
        If i < Filled Then
            RamCanvas.DrawRect(r, CurrentAccentColor, True, 0)
        Else
            RamCanvas.DrawRect(r, CurrentAccentColor, False, 1dip)
        End If
    Next
    RamCanvas.Invalidate
End Sub

Private Sub DrawRadar
    If Initialized(RadarCanvas) = False Or Initialized(RadarView) = False Then Return
    Dim cx As Float = RadarView.Width / 2
    Dim cy As Float = RadarView.Height / 2
    Dim R As Float = cx
    If cy < cx Then R = cy
    R = R - 8dip
    If R < 10dip Then Return
    RadarCanvas.ClearRect(RadarCanvas.TargetRect)
    Dim sweep As Int = Bit.And(CurrentAccentColor, 0x66FFFFFF)
    Dim sp As B4XPath
    sp.Initialize(cx, cy)
    Dim a As Int = RadarAngle - 50
    Do While a <= RadarAngle
        sp.LineTo(cx + CosD(a) * R, cy + SinD(a) * R)
        a = a + 5
    Loop
    sp.LineTo(cx, cy)
    RadarCanvas.DrawPath(sp, sweep, True, 0)
    RadarCanvas.DrawCircle(cx, cy, R, CurrentAccentColor, False, 2dip)
    RadarCanvas.DrawCircle(cx, cy, R * 0.66, CurrentAccentColor, False, 1dip)
    RadarCanvas.DrawCircle(cx, cy, R * 0.33, CurrentAccentColor, False, 1dip)
    RadarCanvas.DrawLine(cx - R, cy, cx + R, cy, CurrentAccentColor, 1dip)
    RadarCanvas.DrawLine(cx, cy - R, cx, cy + R, CurrentAccentColor, 1dip)
    RadarCanvas.DrawCircle(cx + CosD(40) * R * 0.55, cy + SinD(40) * R * 0.55, 4dip, COLOR_GREEN, True, 0)
    RadarCanvas.DrawCircle(cx + CosD(150) * R * 0.8, cy + SinD(150) * R * 0.8, 4dip, CurrentAccentColor, True, 0)
    RadarCanvas.DrawCircle(cx + CosD(260) * R * 0.35, cy + SinD(260) * R * 0.35, 4dip, COLOR_GREEN, True, 0)
    RadarCanvas.DrawText("NC-GRID", cx, cy + 4dip, xui.CreateDefaultBoldFont(11), CurrentTextColor, "CENTER")
    RadarCanvas.Invalidate
End Sub

Private Sub DrawEq
    If Initialized(EqCanvas) = False Or Initialized(EqView) = False Then Return
    If EqView.Width < 20 Or EqView.Height < 10 Then Return
    EqCanvas.ClearRect(EqCanvas.TargetRect)
    Dim n As Int = 14
    Dim bw As Float = EqView.Width / n
    Dim maxH As Int = EqView.Height - 2dip
    For i = 0 To n - 1
        Dim bh As Int = Rnd(5dip, maxH)
        Dim r As B4XRect
        r.Initialize(i * bw + 1dip, EqView.Height - bh, (i + 1) * bw - 1dip, EqView.Height)
        EqCanvas.DrawRect(r, CurrentAccentColor, True, 0)
    Next
    EqCanvas.Invalidate
End Sub

Private Sub RefreshCanvases
    If Initialized(RamCanvas) And Initialized(RamView) Then
        RamCanvas.Resize(RamView.Width, RamView.Height)
        DrawRamBar
    End If
    If Initialized(RadarCanvas) And Initialized(RadarView) Then
        RadarCanvas.Resize(RadarView.Width, RadarView.Height)
        DrawRadar
    End If
    If Initialized(EqCanvas) And Initialized(EqView) Then
        EqCanvas.Resize(EqView.Width, EqView.Height)
        DrawEq
    End If
End Sub

Private Sub AnimateLoop(Token As Int)
    Do While Token = RadarToken
        RadarAngle = RadarAngle + 15
        If RadarAngle >= 360 Then RadarAngle = 0
        DrawRadar
        DrawEq
        Sleep(90)
    Loop
End Sub

' ---------- Events ----------

' All taps arrive here: the list swallows child-view clicks and reports
' them itself, carrying the Value given in AddItem.
Sub clv_ItemClick(Index As Int, Value As Object)
    Dim v As String = Value
    If v = "" Then Return
    If v = "theme" Then
        ApplyThemeColors(Not(IsThreatMode))
        BuildLayout
        Return
    End If
    If v.StartsWith("node:") Then
        Dim idx As Int = v.SubString(5)
        Log("Cyberdeck node: " & NodeTitles.Get(idx))
    End If
End Sub
