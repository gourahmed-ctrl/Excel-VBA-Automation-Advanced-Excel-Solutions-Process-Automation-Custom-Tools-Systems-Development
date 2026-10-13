VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "clsCalculatorButton"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

Public WithEvents btn As MSForms.CommandButton
Attribute btn.VB_VarHelpID = -1
Public ParentForm As CalculatorForm

Private Sub btn_Click()

    Select Case btn.Caption

        Case "0", "1", "2", "3", "4", _
             "5", "6", "7", "8", "9"

            If ParentForm.NewNumber Then

                ParentForm.txtDisplay.Value = ""

                ParentForm.NewNumber = False

            End If

            ParentForm.txtDisplay.Value = _
                ParentForm.txtDisplay.Value & btn.Caption


        Case "."

            If InStr(ParentForm.txtDisplay.Value, ".") = 0 Then

                If ParentForm.NewNumber Then

                    ParentForm.txtDisplay.Value = "0"

                    ParentForm.NewNumber = False

                End If

                ParentForm.txtDisplay.Value = _
                    ParentForm.txtDisplay.Value & "."

            End If


        Case "+", "-", "×", "÷"

            ParentForm.SetOperation btn.Caption


        Case "="

            ParentForm.CalculateResult


        Case "C"

            ParentForm.txtDisplay.Value = ""

            ParentForm.FirstNumber = 0

            ParentForm.Operation = ""

            ParentForm.NewNumber = False

    End Select

End Sub

