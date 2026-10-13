Attribute VB_Name = "ConvPdfWithFolder"
' ===== œ«·… ≈‰‘«¡ «·›Ê·œ— ·Ê „‘ „ÊÃÊœ =====
Sub EnsureFolderExists(ByVal folderPath As String)
    Dim fso As Object
    Set fso = CreateObject("Scripting.FileSystemObject")
    
    If Not fso.FolderExists(folderPath) Then
        fso.CreateFolder folderPath
    End If
End Sub

' ===== œ«·… Õ›Ÿ «·‰ÿ«ﬁ ﬂ‹ PDF =====
Sub SaveRangeAsPDF(ws As Worksheet, fileName As String, x As Range)
    Dim rng As Range
    Dim pdfPath As String
    Dim targetFolder As String
    
    '  ÕœÌœ «·‰ÿ«ﬁ «··Ì ⁄«Ì“  Õ›ŸÂ ﬂ‹ PDF
    Set rng = ws.Range("A1:E37")
    
    ' «”„ «·›Ê·œ— = „Õ ÊÏ A1 + „Õ ÊÏ C6
    targetFolder = ThisWorkbook.Path & "\" & CleanFileName(ws.Range("A1").Value & " - " & ws.Range("C6").Value)
    
    ' ≈‰‘«¡ «·›Ê·œ— ·Ê „‘ „ÊÃÊœ
    EnsureFolderExists targetFolder
    
    '  ÕœÌœ „”«— «·„·› œ«Œ· «·›Ê·œ—
    pdfPath = targetFolder & "\" & CleanFileName(fileName) & ".pdf"
    
    ' Õ›Ÿ «·‰ÿ«ﬁ ﬂ‹ PDF
    rng.ExportAsFixedFormat _
        Type:=xlTypePDF, _
        fileName:=pdfPath, _
        Quality:=xlQualityStandard, _
        IncludeDocProperties:=True, _
        IgnorePrintAreas:=False, _
        OpenAfterPublish:=False
End Sub

Sub TestSavePDF()
    Dim ws As Worksheet
    Dim resultPath As String
    
    Set ws = ThisWorkbook.Sheets("Sheet1")
    resultPath = SaveRangeAsPDF(ws, " ﬁ—Ì—_‘Â—Ì")
    
    MsgBox " „ Õ›Ÿ «·„·› ›Ì: " & resultPath
End Sub

' ==============================================
' œ«·…  ‰ŸÌ› «”„ «·„·› „‰ «·—„Ê“ «·€Ì— „”„ÊÕ »ÌÂ«
' ==============================================
Function CleanFileName(str As String) As String
    Dim invalidChars As Variant
    Dim i As Integer
    
    ' «·—„Ê“ «·€Ì— „”„ÊÕ »ÌÂ« ›Ì √”„«¡ «·„·›« 
    invalidChars = Array("\", "/", ":", "*", "?", """", "<", ">", "|")
    
    ' «” »œ«· ﬂ· —„“ €Ì— „”„ÊÕ »‹ "_"
    For i = LBound(invalidChars) To UBound(invalidChars)
        str = Replace(str, invalidChars(i), "_")
    Next i
    
    ' ≈—Ã«⁄ «·‰’ »⁄œ «· ‰ŸÌ›
    CleanFileName = str
End Function

