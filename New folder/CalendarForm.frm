VERSION 5.00
Begin {C62A69F0-16DC-11CE-9E98-00AA00574A4F} CalendarForm 
   Caption         =   "Emkay Calendar"
   ClientHeight    =   7440
   ClientLeft      =   120
   ClientTop       =   465
   ClientWidth     =   4845
   OleObjectBlob   =   "CalendarForm.frx":0000
   StartUpPosition =   1  'CenterOwner
End
Attribute VB_Name = "CalendarForm"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Dim selCell As Range
Public currentMonth As Date
Public selectedDate As Date
Dim calendarButtons As Collection

Private Sub UserForm_Initialize()

    Set selCell = ActiveCell
    currentMonth = Date
    Set calendarButtons = New Collection

    txtDate.Value = ""
    selectedDate = 0

    With lblMonth
        .Font.Name = "Tahoma"
        .Font.Size = 14
        .Font.Bold = True
    End With

    With txtDate
        .Font.Name = "Tahoma"
        .Font.Size = 11
        .Font.Bold = True
    End With

    ShowCalendar currentMonth

End Sub

Private Sub ShowCalendar(d As Date)

    Dim i As Integer
    Dim firstDay As Integer
    Dim daysInMonth As Integer
    Dim newBtn As clsCalendarButton
    Dim btn As MSForms.CommandButton

    frmDays.Controls.Clear
    Set calendarButtons = New Collection

    lblMonth.Caption = Format(d, "mmmm yyyy")

    firstDay = Weekday(DateSerial(Year(d), Month(d), 1)) - 1
    daysInMonth = Day(DateSerial(Year(d), Month(d) + 1, 0))

    For i = 1 To daysInMonth

        Set btn = frmDays.Controls.Add( _
            "Forms.CommandButton.1", _
            "btnDay" & i)

        With btn

            .Caption = i

            .Width = 30
            .Height = 28

            .Font.Name = "Tahoma"
            .Font.Size = 12
            .Font.Bold = True
            .Top = Int((i + firstDay - 1) / 7) * 33
            .Left = ((i + firstDay - 1) Mod 7) * 33

        End With

        Set newBtn = New clsCalendarButton

        Set newBtn.btn = btn
        Set newBtn.ParentForm = Me

        calendarButtons.Add newBtn

    Next i

End Sub

Private Sub cmdAdd_Click()

    If selectedDate = 0 Then

        MsgBox "„‰ ›÷·ﬂ «Œ —  «—ÌŒ« „‰ «· ﬁÊÌ„ √Ê·«.", vbExclamation

        Exit Sub

    End If

    With selCell

        .NumberFormat = "dd/mm/yyyy"
        .Value = CDbl(CDate(selectedDate))

    End With

    Unload Me

End Sub

Private Sub cmdPrev_Click()

    currentMonth = DateAdd("m", -1, currentMonth)

    ShowCalendar currentMonth

End Sub

Private Sub cmdNext_Click()

    currentMonth = DateAdd("m", 1, currentMonth)

    ShowCalendar currentMonth

End Sub

