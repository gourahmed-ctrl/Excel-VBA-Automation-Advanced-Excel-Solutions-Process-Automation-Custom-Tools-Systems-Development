Attribute VB_Name = "ConvPdf"
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

' ==============================================
' œ«·… Õ›Ÿ «·‰ÿ«ﬁ ﬂ‹ PDF ›Ì ‰›” „”«— «·„·›
' ==============================================
Sub SaveRangeAsPDF(ws As Worksheet, fileName As String)
    Dim rng As Range
    Dim pdfPath As String
    
    '  ÕœÌœ «·‰ÿ«ﬁ «··Ì ⁄«Ì“  Õ›ŸÂ ﬂ‹ PDF
    Set rng = ws.Range("A1:E37")
    
    '  ÕœÌœ „”«— «·„·› œ«Œ· ‰›” „Ã·œ «·„’‰›
    pdfPath = ThisWorkbook.Path & "\" & CleanFileName(fileName) & ".pdf"
    
    ' Õ›Ÿ «·‰ÿ«ﬁ ﬂ‹ PDF
    rng.ExportAsFixedFormat _
        Type:=xlTypePDF, _
        fileName:=pdfPath, _
        Quality:=xlQualityStandard, _
        IncludeDocProperties:=True, _
        IgnorePrintAreas:=False, _
        OpenAfterPublish:=False
End Sub
Sub TestPDF()
    Dim ws As Worksheet
    Set ws = ThisWorkbook.Sheets("Chptr1")
    
    ' ÂÌÕ›Ÿ «·‰ÿ«ﬁ A1:E37 „‰ «·‘Ì  Chptr1 ﬂ‹ PDF
    Call SaveRangeAsPDF(ws, " ﬁ—Ì—_‘Â—Ì")
End Sub


