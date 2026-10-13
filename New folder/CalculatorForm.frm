VERSION 5.00
Begin {C62A69F0-16DC-11CE-9E98-00AA00574A4F} CalculatorForm 
   Caption         =   "Emkay Calculator"
   ClientHeight    =   5295
   ClientLeft      =   120
   ClientTop       =   465
   ClientWidth     =   3975
   OleObjectBlob   =   "CalculatorForm.frx":0000
   StartUpPosition =   1  'CenterOwner
End
Attribute VB_Name = "CalculatorForm"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Dim calculatorButtons As Collection

Public FirstNumber As Double
Public Operation As String
Public NewNumber As Boolean

Private Sub UserForm_Initialize()

    Set calculatorButtons = New Collection

    txtDisplay.Value = ""

    FirstNumber = 0
    Operation = ""
    NewNumber = False

    With txtDisplay
        .Font.Name = "Tahoma"
        .Font.Size = 14
        .Font.Bold = True
    End With
cmdAdd.Default = True
    ShowButtons

End Sub

Private Sub ShowButtons()

    Dim newBtn As clsCalculatorButton
    Dim btn As MSForms.CommandButton

    Dim buttonWidth As Integer
    Dim buttonHeight As Integer
    Dim buttonSpace As Integer

    buttonWidth = 40
    buttonHeight = 32
    buttonSpace = 42

    frmButtons.Controls.Clear
    Set calculatorButtons = New Collection

    Set btn = CreateButton("7", 0, 0, buttonWidth, buttonHeight, buttonSpace)
    Set newBtn = New clsCalculatorButton
    Set newBtn.btn = btn
    Set newBtn.ParentForm = Me
    calculatorButtons.Add newBtn

    Set btn = CreateButton("8", 1, 0, buttonWidth, buttonHeight, buttonSpace)
    Set newBtn = New clsCalculatorButton
    Set newBtn.btn = btn
    Set newBtn.ParentForm = Me
    calculatorButtons.Add newBtn

    Set btn = CreateButton("9", 2, 0, buttonWidth, buttonHeight, buttonSpace)
    Set newBtn = New clsCalculatorButton
    Set newBtn.btn = btn
    Set newBtn.ParentForm = Me
    calculatorButtons.Add newBtn

    Set btn = CreateButton("˜", 3, 0, buttonWidth, buttonHeight, buttonSpace)
    Set newBtn = New clsCalculatorButton
    Set newBtn.btn = btn
    Set newBtn.ParentForm = Me
    calculatorButtons.Add newBtn

    Set btn = CreateButton("4", 0, 1, buttonWidth, buttonHeight, buttonSpace)
    Set newBtn = New clsCalculatorButton
    Set newBtn.btn = btn
    Set newBtn.ParentForm = Me
    calculatorButtons.Add newBtn

    Set btn = CreateButton("5", 1, 1, buttonWidth, buttonHeight, buttonSpace)
    Set newBtn = New clsCalculatorButton
    Set newBtn.btn = btn
    Set newBtn.ParentForm = Me
    calculatorButtons.Add newBtn

    Set btn = CreateButton("6", 2, 1, buttonWidth, buttonHeight, buttonSpace)
    Set newBtn = New clsCalculatorButton
    Set newBtn.btn = btn
    Set newBtn.ParentForm = Me
    calculatorButtons.Add newBtn

    Set btn = CreateButton("◊", 3, 1, buttonWidth, buttonHeight, buttonSpace)
    Set newBtn = New clsCalculatorButton
    Set newBtn.btn = btn
    Set newBtn.ParentForm = Me
    calculatorButtons.Add newBtn

    Set btn = CreateButton("1", 0, 2, buttonWidth, buttonHeight, buttonSpace)
    Set newBtn = New clsCalculatorButton
    Set newBtn.btn = btn
    Set newBtn.ParentForm = Me
    calculatorButtons.Add newBtn

    Set btn = CreateButton("2", 1, 2, buttonWidth, buttonHeight, buttonSpace)
    Set newBtn = New clsCalculatorButton
    Set newBtn.btn = btn
    Set newBtn.ParentForm = Me
    calculatorButtons.Add newBtn

    Set btn = CreateButton("3", 2, 2, buttonWidth, buttonHeight, buttonSpace)
    Set newBtn = New clsCalculatorButton
    Set newBtn.btn = btn
    Set newBtn.ParentForm = Me
    calculatorButtons.Add newBtn

    Set btn = CreateButton("-", 3, 2, buttonWidth, buttonHeight, buttonSpace)
    Set newBtn = New clsCalculatorButton
    Set newBtn.btn = btn
    Set newBtn.ParentForm = Me
    calculatorButtons.Add newBtn

    Set btn = CreateButton("0", 0, 3, buttonWidth, buttonHeight, buttonSpace)
    Set newBtn = New clsCalculatorButton
    Set newBtn.btn = btn
    Set newBtn.ParentForm = Me
    calculatorButtons.Add newBtn

    Set btn = CreateButton(".", 1, 3, buttonWidth, buttonHeight, buttonSpace)
    Set newBtn = New clsCalculatorButton
    Set newBtn.btn = btn
    Set newBtn.ParentForm = Me
    calculatorButtons.Add newBtn

    Set btn = CreateButton("=", 2, 3, buttonWidth, buttonHeight, buttonSpace)
    Set newBtn = New clsCalculatorButton
    Set newBtn.btn = btn
    Set newBtn.ParentForm = Me
    calculatorButtons.Add newBtn

    Set btn = CreateButton("+", 3, 3, buttonWidth, buttonHeight, buttonSpace)
    Set newBtn = New clsCalculatorButton
    Set newBtn.btn = btn
    Set newBtn.ParentForm = Me
    calculatorButtons.Add newBtn

End Sub

Private Function CreateButton(buttonCaption As String, _
                              column As Integer, _
                              row As Integer, _
                              buttonWidth As Integer, _
                              buttonHeight As Integer, _
                              buttonSpace As Integer) As MSForms.CommandButton

    Dim btn As MSForms.CommandButton

    Set btn = frmButtons.Controls.Add( _
        "Forms.CommandButton.1", _
        "btnCalc" & frmButtons.Controls.Count)

    With btn

        .Caption = buttonCaption
        .Width = buttonWidth
        .Height = buttonHeight

        .Font.Name = "Tahoma"
        .Font.Size = 11

        .Left = column * buttonSpace
        .Top = row * buttonSpace

    End With

    Set CreateButton = btn

End Function

'====================================================
'  ‰›Ì– «·⁄„·Ì… «·Õ”«»Ì…
'====================================================

Public Sub CalculateResult()

    Dim SecondNumber As Double
    Dim Result As Double

    If Operation = "" Then Exit Sub

    If Not IsNumeric(txtDisplay.Value) Then Exit Sub

    SecondNumber = CDbl(txtDisplay.Value)

    Select Case Operation

        Case "+"
            Result = FirstNumber + SecondNumber

        Case "-"
            Result = FirstNumber - SecondNumber

        Case "◊"
            Result = FirstNumber * SecondNumber

        Case "˜"

            If SecondNumber = 0 Then

                MsgBox "·« Ì„ﬂ‰ «·ﬁ”„… ⁄·Ï ’›—.", vbExclamation

                Exit Sub

            End If

            Result = FirstNumber / SecondNumber

    End Select

    txtDisplay.Value = Result

    FirstNumber = Result

    Operation = ""

    NewNumber = True

End Sub

'====================================================
' «Œ Ì«— «·⁄„·Ì…
'====================================================

Public Sub SetOperation(ByVal op As String)

    If Not IsNumeric(txtDisplay.Value) Then Exit Sub

    FirstNumber = CDbl(txtDisplay.Value)

    Operation = op

    NewNumber = True

End Sub

'====================================================
' “— ≈÷«›… «·‰ ÌÃ… ≈·Ï «·Œ·Ì…
'====================================================

Private Sub cmdAdd_Click()

    If Operation <> "" Then

        CalculateResult

    End If

    If IsNumeric(txtDisplay.Value) Then

        ActiveCell.Value = CDbl(txtDisplay.Value)

        Unload Me

    Else

        MsgBox "·«  ÊÃœ ‰ ÌÃ… —ﬁ„Ì… ·≈÷«› Â«.", vbExclamation

    End If

End Sub

'====================================================
' «·ﬂÌ»Ê—œ
'====================================================

Private Sub txtDisplay_KeyPress(ByVal KeyAscii As MSForms.ReturnInteger)

    Select Case KeyAscii

        Case 48 To 57

            If NewNumber Then

                txtDisplay.Value = ""
                NewNumber = False

            End If

            txtDisplay.Value = txtDisplay.Value & Chr(KeyAscii)

            KeyAscii = 0


        Case 46

            If InStr(txtDisplay.Value, ".") = 0 Then

                If NewNumber Then

                    txtDisplay.Value = "0"
                    NewNumber = False

                End If

                txtDisplay.Value = txtDisplay.Value & "."

            End If

            KeyAscii = 0


        Case 43

            SetOperation "+"

            KeyAscii = 0


        Case 45

            SetOperation "-"

            KeyAscii = 0


        Case 42

            SetOperation "◊"

            KeyAscii = 0


        Case 47

            SetOperation "˜"

            KeyAscii = 0


        Case 13

            cmdAdd_Click

            KeyAscii = 0


        Case Else

            KeyAscii = 0

    End Select

End Sub

Private Sub txtDisplay_KeyDown(ByVal KeyCode As MSForms.ReturnInteger, _
                               ByVal Shift As Integer)

    If KeyCode = vbKeyEscape Then

        Unload Me

        KeyCode = 0

    End If

End Sub

