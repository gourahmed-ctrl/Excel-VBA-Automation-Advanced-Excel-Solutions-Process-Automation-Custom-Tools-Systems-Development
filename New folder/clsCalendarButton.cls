VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "clsCalendarButton"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

Public WithEvents btn As MSForms.CommandButton
Attribute btn.VB_VarHelpID = -1
Public ParentForm As CalendarForm

Private Sub btn_Click()

    If IsNumeric(btn.Caption) Then

        Dim selectedDate As Date

        selectedDate = DateSerial( _
            Year(ParentForm.currentMonth), _
            Month(ParentForm.currentMonth), _
            CInt(btn.Caption))

        ParentForm.selectedDate = selectedDate

        ParentForm.txtDate.Value = _
            Format(selectedDate, "[$-ar-eg]dddd - dd - mmmm - yyyy")

    End If

End Sub

