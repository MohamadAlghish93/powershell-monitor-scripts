# Query Active Directory Using Powershell

### **Search in active directory**


$LDAPSEARCH = New-Object System.DirectoryServices.DirectorySearcher
$LDAPSEARCH.FindAll()


---

### **Filter by domain name**


$LDAPSEARCH = New-Object System.DirectoryServices.DirectorySearcher 
$LDAPSEARCH.SearchRoot = "LDAP://DC=fabric,DC=local"
$LDAPSEARCH.FindAll()


---

### **Filter by acount name**


$LDAPSEARCH = New-Object System.DirectoryServices.DirectorySearcher 
$LDAPSEARCH.SearchRoot = "LDAP://DC=fabric,DC=local"
$LDAPSEARCH.Filter = "(objectclass=user)"
$LDAPSEARCH.FindAll()


---

### **Get list users information **


$LDAPSEARCH = New-Object System.DirectoryServices.DirectorySearcher 
$LDAPSEARCH.SearchRoot = "LDAP://DC=TECH,DC=LOCAL"
$LDAPSEARCH.Filter = "(objectclass=user)"
$LDAPSEARCH_RESULTS = $LDAPSEARCH.FindAll()
$RESULTS = foreach ($LINE in $LDAPSEARCH_RESULTS) {
$LINE_ENTRY = $LINE.GetDirectoryEntry()
$LINE_ENTRY | Select-Object @{ Name = "sAMAccountName";  Expression = { $_.sAMAccountName }},
@{ Name = "userPrincipalName";  Expression = { $_.userPrincipalName }},
@{ Name = "name";  Expression = { $_.name }},
@{ Name = "distinguishedName"; Expression = { $_.distinguishedName | Select-Object -First 1 }}
}
$RESULTS


---

### **Get list group information**


$LDAPSEARCH = New-Object System.DirectoryServices.DirectorySearcher 
$LDAPSEARCH.SearchRoot = "LDAP://DC=fabric,DC=local"
$LDAPSEARCH.Filter = "(objectclass=group)"
$LDAPSEARCH.FindAll()


---

### **Get membership of user inside group**


$samAccountName = "TARASOL Users"
# $samAccountName = "TARASOL Admins"
$group = ([adsisearcher]"samAccountName=$samAccountName").FindAll()
$group.Properties.member



$Group = [ADSI]"LDAP://CN=TARASOL Users,OU=HHPO Tarasol Groups,DC=fabric,DC=local"
$Members = $Group.Member | ForEach-Object {[ADSI]"LDAP://$_"}

echo $Members
