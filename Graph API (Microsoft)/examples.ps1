## Listar extensiones
$apiUrl = 'https://graph.microsoft.com/v1.0/devices/<ObjectID>/extensions'
$Data = Invoke-RestMethod -Headers @{Authorization = "Bearer $token"} -Uri $apiUrl -Method Get
$Data.value | fl



## Añadir extensiones
$apiUrl = 'https://graph.microsoft.com/v1.0/devices/<ObjectID>/extensions'
$body = '{
  "@odata.type": "microsoft.graph.openTypeExtension",
  "id": "prueba.extension",
  "value": "testing"
}'
Invoke-RestMethod -Headers @{Authorization = "Bearer $token"; "Content-type" = "application/json"} -Uri $apiUrl -Method Post -Body $body



## Actualizar datos de una extensión
$apiUrl = 'https://graph.microsoft.com/v1.0/devices/<ObjectID>/extensions/prueba.extension'
$body = '{
  "@odata.type": "microsoft.graph.openTypeExtension",
  "id": "prueba.extension",
  "value": "testing1",
  "value2": "testing2"
}'
Invoke-RestMethod -Headers @{Authorization = "Bearer $token"; "Content-type" = "application/json"} -Uri $apiUrl -Method Patch -Body $body



## Eliminar extensión
$apiUrl = 'https://graph.microsoft.com/v1.0/devices/<ObjectID>/extensions/prueba.extension'
Invoke-RestMethod -Headers @{Authorization = "Bearer $token"; "Content-type" = "application/json"} -Uri $apiUrl -Method Delete
