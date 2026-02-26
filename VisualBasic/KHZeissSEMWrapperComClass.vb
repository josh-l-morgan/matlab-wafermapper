<ComClass(ComClass1.ClassId, ComClass1.InterfaceId, ComClass1.EventsId)> _
Public Class ComClass1

#Region "COM GUIDs"
    ' These  GUIDs provide the COM identity for this class 
    ' and its COM interfaces. If you change them, existing 
    ' clients will no longer be able to access the class.
    Public Const ClassId As String = "86591d6d-43b4-4d0e-8d8f-ac21e978648f"
    Public Const InterfaceId As String = "3beb4428-7327-4a7b-a19c-b03a350646a3"
    Public Const EventsId As String = "4b85d4c1-7c94-4aec-bfac-62cc0c1bed4f"
#End Region

    ' A creatable COM class must have a Public Sub New() 
    ' with no parameters, otherwise, the class will not be 
    ' registered in the COM registry and cannot be created 
    ' via CreateObject.
    Public Sub New()
        MyBase.New()
    End Sub

End Class


