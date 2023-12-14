# Velocizzare deploy di mfa tramite sms su Azure AD

Lo script compila il campo "SMS/Phone" con il numero definito sul file csv.
NON abilita la funzione MFA, che deve essere attivata manualmente sul portale [Microsoft365](https://account.activedirectory.windowsazure.com/UserManagement/MultifactorVerification.aspx?BrandContextID=O365)

#### Necessaria installazione del modulo Microsoft.Graph
Da powershell:
Install-Module Microsoft.Graph

## EXEC
Compilare il file CSV come segue (non occorrono spazi nei prefissi). il file csv deve trovarsi nella stessa cartella dell'eseguibile
```
UPN,PhoneNumber
email1,+39XXXXXX
email2,+39XXXXXX
```

Avviare lo script come Global Admin, consentire a Graph di accedere al tenant.
Attendere l'esecuzione e verificare il file UpdatedMFA.log
