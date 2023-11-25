object dm_Rest: Tdm_Rest
  Height = 480
  Width = 640
  object HTTPClient: TNetHTTPClient
    UserAgent = 'Embarcadero URI Client/1.0'
    Left = 72
    Top = 48
  end
  object HTTPRequest: TNetHTTPRequest
    Asynchronous = True
    Client = HTTPClient
    Left = 184
    Top = 48
  end
end
