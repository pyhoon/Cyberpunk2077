B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=9.85
@EndOfDesignText@
#Region Shared Files
#CustomBuildAction: folders ready, %WINDIR%\System32\Robocopy.exe,"..\..\Shared Files" "..\Files"
'Ctrl + click to sync files: ide://run?file=%WINDIR%\System32\Robocopy.exe&args=..\..\Shared+Files&args=..\Files&FilesSync=True
#End Region

#Macro: Title, Export B4XPages, ide://run?File=%B4X%\Zipper.jar&Args=%PROJECT_NAME%.zip

Sub Class_Globals
	' Core Layout Containers
    Private Root As B4XView
    Private xui As XUI
    
    ' Cyberpunk Hex Color Palettes
    Private COLOR_BG_RED As Int = 0xFF0A0000
    Private COLOR_ACCENT_RED As Int = 0xFFFF0505
    Private COLOR_TEXT_RED As Int = 0xFFFF3333
    
    Private COLOR_BG_CYAN As Int = 0xFF000B14
    Private COLOR_ACCENT_CYAN As Int = 0xFF00F0FF
    Private COLOR_TEXT_CYAN As Int = 0xFF00A3FF
    Private COLOR_GREEN As Int = 0xFF00FF66
    
    ' Canvas Drawing Nodes
    Private RamCanvasView As B4XView
    Private BorderCanvasView As B4XView
    Private CustomRamCanvas As B4XCanvas
    Private CustomBorderCanvas As B4XCanvas
    
    ' Active State Memory Configurations
    Private CurrentBgColor As Int
    Private CurrentAccentColor As Int
    Private CurrentTextColor As Int
    Private IsThreatMode As Boolean = True
    Private IsGlitching As Boolean = False
    
    ' Telemetry Interface Subviews
    Private LblTitle As B4XView
    Private LblTrackTitle As B4XView
    Private LblArtist As B4XView
    Private LblRamStats As B4XView
    Private LblTemperature As B4XView
    Private BtnThemeToggle As B4XView
    Private AppGridPanel As B4XView
    
    ' Monochromatic Grid Definition Variables
    Private AppNames As List
    Private AppIcons As List
End Sub

Public Sub Initialize
    ' Map default dataset structures
    AppNames = Array As String("BIG DATA", "NETRUNNER", "CYBEROS", "DECK_SYS")
    ' FontAwesome Unicode Hex symbols to serve as crisp vector graphics
    AppIcons = Array As String(Chr(0xF0E8), Chr(0xF120), Chr(0xF109), Chr(0xF013))
End Sub

' This event fires automatically on app launch across all target OS families
Private Sub B4XPage_Created (Root1 As B4XView)
    Root = Root1
    ApplyThemeColors(True)
    BuildCyberdeckUI
End Sub

' Automatically scale vector geometries when window sizes vary
Private Sub B4XPage_Resize (Width As Int, Height As Int)
    RefreshCustomCanvases
End Sub

' Sweeps runtime variable states to toggle system profiles
Private Sub ApplyThemeColors(ThreatMode As Boolean)
    IsThreatMode = ThreatMode
    If IsThreatMode Then
        CurrentBgColor = COLOR_BG_RED
        CurrentAccentColor = COLOR_ACCENT_RED
        CurrentTextColor = COLOR_TEXT_RED
    Else
        CurrentBgColor = COLOR_BG_CYAN
        CurrentAccentColor = COLOR_ACCENT_CYAN
        CurrentTextColor = COLOR_TEXT_CYAN
    End If
End Sub

' Instantiates the functional modular block layout matrices
Private Sub BuildCyberdeckUI
    Root.RemoveAllViews
    Root.Color = CurrentBgColor
    
    ' 1. Drawing Layers Canvas Setup
    BorderCanvasView = xui.CreatePanel("")
    Root.AddView(BorderCanvasView, 0, 0, Root.Width, Root.Height)
    CustomBorderCanvas.Initialize(BorderCanvasView)
    
    Dim Padding As Int = 15dip
    
    ' 2. Top Banner Header Diagnostic Status Displays
    LblTitle = CreateLabel("CYBERDECK RAM:", 14, CurrentTextColor, Bit.Or(Gravity.LEFT, Gravity.CENTER_VERTICAL))
    Root.AddView(LblTitle, Padding, Padding, 150dip, 30dip)
    
    LblRamStats = CreateLabel(IIf(IsThreatMode, "66 (24)", "67 (33)"), 14, CurrentTextColor, Bit.Or(Gravity.RIGHT, Gravity.CENTER_VERTICAL))
    Root.AddView(LblRamStats, Root.Width - 100dip - Padding, Padding, 100dip, 30dip)
    
    ' 3. RAM Segment Canvas Allocation
    RamCanvasView = xui.CreatePanel("")
    Root.AddView(RamCanvasView, Padding, Padding + 35dip, Root.Width - (Padding * 2), 25dip)
    CustomRamCanvas.Initialize(RamCanvasView)
    
    ' 4. Integrated Simulated Audio Metadata Panels
    Dim MediaTop As Int = 140dip
    LblTrackTitle = CreateLabel("I Really Want To Stay At Your House", 16, CurrentTextColor, Gravity.LEFT)
    Root.AddView(LblTrackTitle, Padding + 10dip, MediaTop + 15dip, Root.Width - (Padding * 2) - 20dip, 30dip)
    
    LblArtist = CreateLabel("// BY LUCY & DAVID", 11, CurrentAccentColor, Gravity.LEFT)
    Root.AddView(LblArtist, Padding + 10dip, MediaTop + 45dip, Root.Width - (Padding * 2) - 20dip, 20dip)
    
    ' 5. Monochromatic App Grid Controller Insertion
    Dim GridTop As Int = 240dip
    Dim GridHeight As Int = 180dip
    AppGridPanel = xui.CreatePanel("")
    Root.AddView(AppGridPanel, Padding, GridTop, Root.Width - (Padding * 2), GridHeight)
    CreateMonochromaticAppGrid
    
    ' 6. Environmental Temperature Telemetry Readout
    LblTemperature = CreateLabel("19 °C", 36, CurrentTextColor, Gravity.CENTER)
    Root.AddView(LblTemperature, Root.Width - 160dip - Padding, GridTop + GridHeight + 20dip, 160dip, 60dip)
    
    ' 7. Protocol Activation Action Switch Button
    Dim BtnWidth As Int = 220dip
    Dim BtnHeight As Int = 50dip
    BtnThemeToggle = xui.CreatePanel("BtnThemeToggle")
    BtnThemeToggle.Color = xui.Color_Transparent
    Root.AddView(BtnThemeToggle, (Root.Width - BtnWidth) / 2, Root.Height - BtnHeight - 40dip, BtnWidth, BtnHeight)
    
    Dim LblBtnText As Label
    LblBtnText.Initialize("")
    Dim B4XBtnText As B4XView = LblBtnText
    B4XBtnText.Text = "TOGGLE DECK PROTOCOL"
    B4XBtnText.TextSize = 13
    B4XBtnText.TextColor = CurrentTextColor
    B4XBtnText.Gravity = Gravity.CENTER
    BtnThemeToggle.AddView(B4XBtnText, 0, 0, BtnWidth, BtnHeight)
    
    RefreshCustomCanvases
End Sub

' Builds the adaptive, touch-responsive grid system programmatically
Private Sub CreateMonochromaticAppGrid
    AppGridPanel.RemoveAllViews
    
    Dim Columns As Int = 2
    Dim TotalApps As Int = AppNames.Size
    Dim TotalRows As Int = Ceil(TotalApps / Columns)
    
    Dim ItemWidth As Float = AppGridPanel.Width / Columns
    Dim ItemHeight As Float = AppGridPanel.Height / TotalRows
    
    For i = 0 To TotalApps - 1
        Dim Row As Int = i / Columns
        Dim Col As Int = i Mod Columns
        
        ' Build structural panel wrapper
        Dim ItemPanel As B4XView = xui.CreatePanel("AppItem")
        ItemPanel.Tag = AppNames.Get(i) 
        AppGridPanel.AddView(ItemPanel, Col * ItemWidth, Row * ItemHeight, ItemWidth - 4dip, ItemHeight - 4dip)
        
        ' Apply a translucent background glow (10% alpha opacity mask)
        ItemPanel.Color = Bit.And(CurrentAccentColor, 0x1AFFFFFF)
        
        ' App identifier text
        Dim LblName As B4XView = CreateLabel(AppNames.Get(i), 11, CurrentTextColor, Gravity.CENTER)
        ItemPanel.AddView(LblName, 0, ItemHeight - 25dip, ItemWidth, 20dip)
        
        ' Vector glyph assignment
        Dim LblIcon As B4XView = CreateLabel(AppIcons.Get(i), 20, CurrentAccentColor, Gravity.CENTER)
        LblIcon.Font = xui.CreateFontAwesome(20)
        ItemPanel.AddView(LblIcon, 0, 5dip, ItemWidth, ItemHeight - 30dip)
    Next
End Sub

' Instantiates stylized standard string layout fields securely
Private Sub CreateLabel(Text As String, Size As Float, Color As Int, Alignment As Int) As B4XView
    Dim Lbl As Label
    Lbl.Initialize("")
    Dim XView As B4XView = Lbl
    XView.Text = Text
    XView.TextSize = Size
    XView.TextColor = Color
    XView.Gravity = Alignment
    XView.Font = xui.CreateFont(Typeface.MONOSPACE, Size)
    Return XView
End Sub

' Controls drawing loop workflows across all custom graphics nodes
Private Sub RefreshCustomCanvases
    If CustomBorderCanvas.IsInitialized Then
        CustomBorderCanvas.Clear
        DrawCyberdeckBorders
        CustomBorderCanvas.Invalidate
    End If
    
    If CustomRamCanvas.IsInitialized Then
        CustomRamCanvas.Clear
        DrawRamBlocks(16)
        CustomRamCanvas.Invalidate
    End If
End Sub

' Renders mechanical hard-angled frames using standard Vector paths
Private Sub DrawCyberdeckBorders
    Dim PWidth As Float = BorderCanvasView.Width
    Dim PHeight As Float = BorderCanvasView.Height
    Dim StrokeWidth As Float = 2dip
    
    ' Draw Top Header Diagnostic Enclosure
    Dim TopPath As B4XPath
    TopPath.Initialize(10dip, 10dip)
    TopPath.LineTo(PWidth - 10dip, 10dip)
    TopPath.LineTo(PWidth - 10dip, 110dip)
    TopPath.LineTo(PWidth - 30dip, 130dip) ' Angled bracket telemetry accent cut
    TopPath.LineTo(10dip, 130dip)
    TopPath.LineTo(10dip, 10dip)
    CustomBorderCanvas.DrawPath(TopPath, CurrentAccentColor, False, StrokeWidth)
    
    ' Draw Action Switch Container Borders
    Dim BTop As Float = BtnThemeToggle.Top - 5dip
    Dim BBottom As Float = BtnThemeToggle.Top + BtnThemeToggle.Height + 5dip
    Dim BLeft As Float = BtnThemeToggle.Left - 10dip
    Dim BRight As Float = BtnThemeToggle.Left + BtnThemeToggle.Width + 10dip
    
    Dim TogglePath As B4XPath
    TogglePath.Initialize(BLeft + 15dip, BTop)
    TogglePath.LineTo(BRight, BTop)
    TogglePath.LineTo(BRight, BBottom - 15dip)
    TogglePath.LineTo(BRight - 15dip, BBottom)
    TogglePath.LineTo(BLeft, BBottom)
    TogglePath.LineTo(BLeft, BTop + 15dip)
    TogglePath.LineTo(BLeft + 15dip, BTop)
    
    Dim ToggleOutlineColor As Int = CurrentAccentColor
    If Not(IsThreatMode) Then ToggleOutlineColor = COLOR_GREEN
    CustomBorderCanvas.DrawPath(TogglePath, ToggleOutlineColor, False, StrokeWidth)
End Sub

' Renders divided segment matrices for system resource blocks
Private Sub DrawRamBlocks(TotalBlocks As Int)
    Dim CanvasWidth As Float = RamCanvasView.Width
    Dim CanvasHeight As Float = RamCanvasView.Height
    Dim BlockGap As Float = 4dip
    Dim TotalGapsWidth As Float = BlockGap * (TotalBlocks - 1)
    Dim BlockWidth As Float = (CanvasWidth - TotalGapsWidth) / TotalBlocks
    
    For i = 0 To TotalBlocks - 1
        Dim LeftPos As Float = i * (BlockWidth + BlockGap)
        Dim RectTarget As B4XRect
        RectTarget.Initialize(LeftPos, 0, LeftPos + BlockWidth, CanvasHeight)
        
        ' Core dynamic segmentation fills (11 Solid Blocks, 5 Empty Outlines)
        If i < 11 Then
            CustomRamCanvas.DrawRect(RectTarget, CurrentAccentColor, True, 0)
        Else
            CustomRamCanvas.DrawRect(RectTarget, CurrentAccentColor, False, 1dip)
        End If
    Next
End Sub

' Asynchronous high-frequency terminal screen flicker matrix loop
Private Sub TriggerGlitchSequence
    If IsGlitching Then Return
    IsGlitching = True
    
    Dim OriginalTextColor As Int = CurrentTextColor
    Dim OriginalAccentColor As Int = CurrentAccentColor
    
    For i = 1 To 4
        ' Frame Phase A: Static Flash Mode
        UpdateUIElementsColor(xui.Color_White, CurrentAccentColor)
        Sleep(40)
        
        ' Frame Phase B: Blank Command Interruption
        UpdateUIElementsColor(xui.Color_Transparent, xui.Color_DarkGray)
        Sleep(25)
        
        ' Frame Phase C: Sub-Terminal Override Colors
        UpdateUIElementsColor(COLOR_GREEN, OriginalTextColor)
        Sleep(35)
    Next
    
    ' Restore native system telemetry variables securely
    IsGlitching = False
    UpdateUIElementsColor(OriginalTextColor, OriginalAccentColor)
End Sub

' Atomic properties mapping assistant to maintain UI updates safely during loops
Private Sub UpdateUIElementsColor(TextCol As Int, AccentCol As Int)
    LblTitle.TextColor = TextCol
    LblRamStats.TextColor = TextCol
    LblTrackTitle.TextColor = TextCol
    LblArtist.TextColor = AccentCol
    LblTemperature.TextColor = TextCol
    
    If BtnThemeToggle.NumberOfViews > 0 Then
        Dim LblBtnText As B4XView = BtnThemeToggle.GetView(0)
        LblBtnText.TextColor = TextCol
    End If
    
    CreateMonochromaticAppGrid
End Sub

' Universal action event callback handler (Maps to mobile taps and desktop mouse presses automatically)
Sub BtnThemeToggle_Click
    If IsGlitching Then Return
    
    ' Invert color state models
    ApplyThemeColors(Not(IsThreatMode))
    Root.Color = CurrentBgColor
    
    ' Repaint vector structures
    RefreshCustomCanvases
    
    ' Fire terminal sequence
    TriggerGlitchSequence
End Sub

' App grid element execution routing logic block
Sub AppItem_Click
    Dim ClickedPanel As B4XView = Sender
    Dim TargetAppName As String = ClickedPanel.Tag
    Log("Executing Cyberdeck Link Protocol Target: " & TargetAppName)
End Sub