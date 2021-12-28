---
title: "i-Smart iDempiere - Mobile  App "
date: 2020-04-24T22:47:10+02:00
draft: false
weight : 2500
pre: "<b>90. </b>"
---
# Progetto iDempiere Flutter

 ## Funzionalità da vedere !!! (Vincenzo)

* [ ] Eseguire processo completa di idempiere APIREST (da window)
* [ ] Eseguire processo idempiere con parametri APIREST
* [ ] Attivare Acquisizione Fotocamera e allegare API REST (S2)
  https://docs.flutter.dev/cookbook/plugins/picture-using-camera
* [ ] Allegare Documento (jpg,PDF)  (S2)
* [ ] Visualizzare Allegato (vedere ticket desktop app) (S2)
* [ ] Gestione Lingua (step 2)
  https://docs.flutter.dev/development/accessibility-and-localization/internationalization
* [ ] Notifiche    (vedere quello fatto con Vincenzo sulla Desktop APP )
* [ ] Gestione Barcode QRcode (vedi processi produzione)
* [ ] Chat (wishing list)
* [ ] Stampa report (da idempiere)  da vedere con AC (TOP)
* [ ] Stampa Diretta Bluetooth o IP
      https://pub.dev/packages/bluetooth_print
* [ ] Gestione NFC - Per segnare le ore ? - controllare plugin NFC
* [ ] Sondaggi https://github.com/quickbirdstudios/survey_kit

## Login ! (Vincenzo)

* [ ] Logo App , immagini login 
* [ ] Spostare Utente in alto a Sx  
* [ ] Accesso via https  
* [X] Salvataggio Ruolo e login con solo ok se memorizzato password
* [ ] Saltare la prima pagina e andare alla Login Page 
* [ ] Non si visualizzano i Dati Server  
* [ ] Exit(Tocca ancora per uscire ) / 
* [ ] Logout (Attenzione cancella i dati di login )

## Dashboard (Vincenzo/Matteo)

[X] DELETE You have 10 undone (Vincenzo-Matteo)
[X] DELETE - 1st Sprint (Matteo)
[X] DELETE Team Member  (Matteo)
[X] DELETE Get Premium  (Matteo)
get API : LIT_Mobile_Dashboard [Marco/Matteo]
Select 'TODO',count(*),User from JP_TODO where status<>CO  group by User
Union
Select 'OFFER',count(*),SalesRep from C_Order where status<>CO group by SalesRep
Union 
Select 'MP_TASK',count(*),SalesRep from MP_TASK where status
Union
Select 'PROJECT',count(*),SalesRep from C_Project where status
### Task : Nr Task non completati / Nr Task in Progress -> vai a Task
     model : JP_TODO filter : AND  JP_ToDo_Status='NY' AND TRUNC(JP_ToDo_ScheduledStartDate)<= TRUNC(SysDate)-1 
### Offerte di Vendita : Nr Offerte in bozza-mie -> vai a Offerta di Vendita
### Ordini di Manutenzione : Nr Ordini di Manutenzioni 
### Progetti Attivi : Nr
### Recent Messages -->  
### Bacheca : tabella : AD_BroadcastMessage (ho letto)
 * [ ] Invia Nota / Messaggio 

### Calendario (S1)

* [ ] Calendario
  - Task Lead
  - Task Business Partner


### BI Vendite (S2)

* [ ] Grafico Chart Fatturato (Vincenzo)
   https://pub.dev/packages/charts_flutter

### Risorse Aziendali !!! (Matteo)

!! Fare Maschera su iDempiere [Marco-Matteo]

* Stato/note : Definito / 50%
* Nome Oggetto : AssetResource
* API model a_asset Filtro fisso = isactive='Y' isresource=Y

* [ ] Filtro Base = All Miei
* [ ] Filtri Avanzata: Tipo : A_Asset_Type_ID
* [ ] Ricerca : Nome , Targa
* [ ] Visualizzare(Inventoryno,Nome)
* [ ] Modificare
* [ ] Creare
* [ ] Cancellare (?)

* [ ] Elenco Risorse Aziendali
* [ ] Prenota Risorsa (data, durata) / Libera Prenotazione
* [ ] Poke Risorsa occupata

## 1 CRM

Nome Oggetto : CRM
get API :   Lead (count(*),count(*)Miei, Count(*)Last 7day
Select count(*),salesrepo from ad_user where islead=Y group by salesrep
union
Select count(*),

-Contatti BP count(*)
-Clienti BP count (*)
-Task Lead
-Opportunità
-Offerta/Ordini count(*)
-Listino Prodotti count(*)PirceChanged
-Spedizioni count(*)7days
-Fattura Vendita (count)(*)Last7da
-Incassi count(*)Last7day Sum(*)Last7day

### Lead

* Stato/note : Definito 
* Nome Oggetto : leads
* API window lead Filtro fisso = IsSalesLead eq Y 

* [X] Filtro Base = All Miei Team
* [ ] Filtri Avanzata: Stato Lead
* [ ] Ricerca : Nome,Telefono,Nome BP
* [X] Visualizzare(Nome,Telefono,Email,Stato del Lead,Agente,Nome del BP)

* -Lista Agente : select name from ad_user where c_bpartner is not null and il BP is salesrep

* [X] Modificare(Tutti)
* [X] Creare
* [X] Cancellare
* [ ] Caricare da Contatto (S2)
* [X] Eseguire Telefonata ( S1)
* [X] Invio Email (S1)
* [ ] Scarica Lead come Contatto Telefono (S2)
* [ ] Converti Lead in BP
* [ ] Crea Task Lead, (S2)
* [ ] Crea Opportunità Lead (Se BP completo) (S2)
* [ ] Mostra Task da fare (S2)
* [ ] Mostra Task eseguiti (S2)
* [ ] Mostra Opportunità - Vai a (S3)
* [ ] Mostra Offerte - Vai a (S2)
* [ ] Invio Msg Telegram (S3)
* [ ] Invio Msg SMS  (S3)
* [ ] Invio Msg Whatsapp (S3)

### Contatti BP 

* Stato/note : Definito / 10%
* Nome Oggetto : contact
* API model: ad_user - Filtro fisso = isactive='Y'

* [ ] Filtro Base = All Miei Team
* [ ] Filtri Avanzata: Nessuno
* [ ] Visualizzare : (Nome,Telefono,Email,Stato del Lead,Agente,Nome del BP)
* [ ] Creare (Assegnare BP)
* [ ] Modificare
* [ ] Caricare da Contatto(Assegnare BP) (S2)
* [ ] Eseguire Telefonata (S1)
* [ ] Invio Email (S1)
* [ ] Scarica come Contatto Telefono,
* [ ] Crea Task Business Partner,
* [ ] Crea Opportunità Business Partner (S2)
* [ ] Mostra Task da fare (S2)
* [ ] Mostra Task eseguiti (S2)
* [ ] Mostra Opportunità - Vai a (S3)
* [ ] Mostra Offerte - Vai a (S2)
* [ ] Invio Msg Telegram (S3)
* [ ] Invio Msg SMS (S3)
* [ ] Invio Msg Whatsapp (S3)

### Clienti BP

* Stato/note : Definito / 10%
* Nome Oggetto : BusinessPartner
* API model : c_bpartner - Filtro fisso : t null and islead='N' isactive='Y'

* [ ] Filtro Base = All Miei(agente=user)
* [ ] Filtri Avanzata: Gruppo Business Partner or Categoria BP
* [ ] Visualizzare BP (Nome,indirizzo(isbillto),Telefono,Email,Agente)
* [ ] Creare
* [ ] Modificare BP(Nome,indirizzo, Telefono,email,Agente)
* [ ] Visualizzazione Contatti Vai a Contatti
* [ ] Crea Task  Business Partner
* [ ] Crea Opportunità  Business Partner (S2)
* [ ] Mostra Opportunità - Vai a (S2)
* [ ] Mostra Offerte - Vai a (S2)

### Task Lead / BP

* Stato/note : Definito / 10%
* Nome Oggetto : Task
* API model  : JP_Todo - Filtro fisso : EndDate is null isactive='Y'

* [ ] Filtro Base = All miei Team
* [ ] Filtri Avanzata: Stato
* [ ] Visualizzare Task (Descrizione,Stato,Priorita,Tipoattività,DataInizio,;Salesrep,iscomplete
* [ ] Creare
* [ ] Modificare (tutto)
* [ ] Bottone xImpostare Y su iscomplete
* [ ] Se Lead Telefonare
* [ ] Invio Email
* [ ] Promemoria / Notifica per Data/ora

### Opportunità Lead  BP

* Stato/note : Definito / 10%
* Nome Oggetto : Opportunity
* API window : Opportunity  Filtro fisso : isactive='Y'

* [ ] Filtro Base =All Miei Team
* [ ] Filtri Avanzata: Stato
* [ ] Visualizzare Opportunità (NrDocumento,Business Partner,Agente,Stato,Importo,Descrizione,Prodotto)
* [ ] Crea
* [ ] Modificare (tutto)
* [ ] Crea Task
* [ ] Crea Offerta

### Offerta/Ordine di Vendita

* Stato/note : Definito / 10%
* Nome Oggetto : Offer
* API model c_order  Filtro fisso:  isactive='Y' < #GiorniOfferta

* [ ] Filtro Base = All Miei Team
* [ ] Filtri Avanzata: Bozza/Completato/Fatturato/Pagato
* [ ] Visualizzare Offerta (Nrdocumento,Business Partner,Data Ordine,Tipo Documento,Agente,Metodo di Pagemento,Termine di Pagamento)
* [ ] Visualizzare Righe Offerta(Prodotto,Descrizione,um,qty,prezzo listino,prezzo,sconto,iva)
* [ ] Crea
* [ ] Modificare (tutto)
* [ ] Completare Offerta
* [ ] Riaprire Offerta(solo se Standard Order e non Spedito)
* [ ] Inviare Email con template email

### Listino Prodotti !!!

* Stato/note : Definito / 10%
* Nome Oggetto : ProductPrice
* API model  : m_product  Filtro fisso : isactive='Y'  listino(vedi opzioni)

* [ ] Filtro Base = Categoria Prodotto
* [ ] Filtri Avanzata: Categoria Merceologica
* [ ] Visualizzare Prodotti ( Immagine, Value,name,descrizione,Prezzo,Giacenza)
* [ ] Visualizzare Righe Offerta(Prodotto,Descrizione,um,qty,prezzo listino,prezzo,sconto,iva)
* [ ] Crea
* [ ] Modificare (tutto)

### Documento di Trasporto (miei/Team) 

Tradurre in Documento di Trasporto
* Stato/note : Definito 
* Nome Oggetto : Shipment
* API window :  ShipmentCustomer  Filtro fisso : isactive=Y

* [ ] Filtro Base = ???
* [ ] Filtri Avanzata: ???
* [ ] Visualizzare DDT ( Documentno,data,BP)
* [ ] Visualizzare Righe Offerta(Prodotto,Descrizione,um,qty,prezzo listino,prezzo,sconto,iva)
* [ ] Crea
* [ ] Modificare (tutto)
* [ ] Completare Documento

### Fatture di Vendita (miei/tutti*) (idem vendita)

* Stato/note : Definito / 10%
* Nome Oggetto : InvoiceCustomer
* API window : invoicecustomer  Filtro fisso : isactive=Y

* [ ] Filtro Base = Stato documento
* [ ] Filtri Avanzata:
* [ ] Visualizzare Prodotti ( Immagine, Value,name,descrizione,Prezzo,Giacenza)
* [ ] Visualizzare Righe Offerta(Prodotto,Descrizione,um,qty,prezzo listino,prezzo,sconto,iva)

### Incasso / Pagamento (miei/tutti*)  (idem vendita)

* Stato/note : Definito / 10%
* Nome Oggetto : Payment
* API window : Payment   Filtro fisso : isactive=Y

* [ ] Filtro Base = ???
* [ ] Filtri Avanzata: ???

### Provvigione

* Stato/note : Definito / 10%
* Nome Oggetto : Commission
* API model :   .. Filtro fisso :

* [ ] Filtro Base = ???
* [ ] Filtri Avanzata: ???

##  2 Ticket Task e Ore

Nome Oggetto : Ticket
get API : Ticket (count(*),count(*)Miei, Count(*)Last 7day,
Ticket

### Ticket (miei/Team) (tecnico)

* Stato/note : Definito / 10%
* Nome Oggetto :Ticket
* API model :   .. Filtro fisso :

* [ ] Filtro Base = ???
* [ ] Filtri Avanzata: ???

### Ticket (portale)

* Stato/note : Definito / 10%
* Nome Oggetto : CustomerTicket
* API model :   .. Filtro fisso :

* [ ] Filtro Base = ???
* [ ] Filtri Avanzata: ???

### Task (miei/Team)

* Stato/note : Definito / 10%
* Nome Oggetto : Task
* API model :   .. Filtro fisso :

* [ ] Filtro Base = ???
* [ ] Filtri Avanzata: ???

### Riepilogo Ore (miei/Team)

* Stato/note : Definito / 10%
* Nome Oggetto : ResourceAssignment
* API model :   .. Filtro fisso :

* [ ] Filtro Base = ???
* [ ] Filtri Avanzata: ???
  {{% /expand%}}

##   3 Manutenzione Tecnico

Nome Oggetto : Maintenance
get API :

### -  Calendario Tecnico ((miei/Team)

* Stato/note : Definito / 10%
* Nome Oggetto : calendar
* API model :   .. Filtro fisso :

* [ ] Filtro Base = ???
* [ ] Filtri Avanzata: ???

### -  Intervento Manutenzione

* Stato/note : Definito / 10%
* Nome Oggetto : mptask
* API model :   .. Filtro fisso :

* [ ] Filtro Base = ???
* [ ] Filtri Avanzata: ???

### -  Anomalia Manutenzione

* Stato/note : Definito / 10%
* Nome Oggetto : mpanomaly
* API model :   .. Filtro fisso :

* [ ] Filtro Base = ???
* [ ] Filtri Avanzata: ???

### -  Magazzino Furgone

* Stato/note : Definito / 10%
* Nome Oggetto : mpwarehouse
* API model :   .. Filtro fisso :

* [ ] Filtro Base = ???
* [ ] Filtri Avanzata: ???

### -  Prelievo da Magazzino Centrale

* Stato/note : Definito / 10%
* Nome Oggetto : mppicking
* API model :   .. Filtro fisso :

* [ ] Filtro Base = ???
* [ ] Filtri Avanzata: ???

### -  Carico/Scarico

* Stato/note : Definito / 10%
* Nome Oggetto : internaluseinventory
* API model :   .. Filtro fisso :

* [ ] Filtro Base = ???
* [ ] Filtri Avanzata: ???

### -  Carico Scheda tecnica

* Stato/note : Definito / 10%
* Nome Oggetto : mpimportitem
* API model :   .. Filtro fisso :

* [ ] Filtro Base = ???
* [ ] Filtri Avanzata: ???
  {{% /expand%}}

##  4 Manutenzione Portale

Nome Oggetto : Portal_MP
get API :

### - Dashboard Portale (no a menu)

* Stato/note : Definito / 10%
* Nome Oggetto : tbd
* API model :   .. Filtro fisso :

* [ ] Filtro Base = ???
* [ ] Filtri Avanzata: ???

#### - News  (Promo) (no a menu)

* Stato/note : Definito / 10%
* Nome Oggetto : tbd
* API model :   .. Filtro fisso :

* [ ] Filtro Base = ???
* [ ] Filtri Avanzata: ???

#### - Fatture di Acquisto (Pagamento)

* Stato/note : Definito / 10%
* Nome Oggetto : invoicepo
* API model :   .. Filtro fisso :

* [ ] Filtro Base = ???
* [ ] Filtri Avanzata: ???

#### - Indicatori ( Ultima visita / Prossima Visita)/anomalie)

* Stato/note : Definito / 10%
* Nome Oggetto : tbd
* API model :   .. Filtro fisso :

* [ ] Filtro Base = ???
* [ ] Filtri Avanzata: ???

### Offerte di Vendita (aperte/tutte)

* Stato/note : Definito / 10%
* Nome Oggetto : portaloffer
* API model :   .. Filtro fisso :

* [ ] Filtro Base = ???
* [ ] Filtri Avanzata: ???

### - Manutenzione

* Stato/note : Definito / 10%
* Nome Oggetto :
* API model :   .. Filtro fisso :

* [ ] Filtro Base = ???
* [ ] Filtri Avanzata: ???

### - Contratto

* Stato/note : Definito / 10%
* Nome Oggetto :
* API model :   .. Filtro fisso :

* [ ] Filtro Base = ???
* [ ] Filtri Avanzata: ???

### - Impianto

* Stato/note : Definito / 10%
* Nome Oggetto :
* API model :   .. Filtro fisso :

* [ ] Filtro Base = ???
* [ ] Filtri Avanzata: ???

### - Anomalie

* Stato/note : Definito / 10%
* Nome Oggetto :
* API model :   .. Filtro fisso :

* [ ] Filtro Base = ???
* [ ] Filtri Avanzata: ???

### - Ticket (crea)

* Stato/note : Definito / 100%
* Nome Oggetto :
* API model :   .. Filtro fisso :

* [ ] Filtro Base = ???
* [ ] Filtri Avanzata: ???
  {{% /expand%}}

##  5 Formazione
Nome Oggetto : Course
get API :

#### - Contratto di Formazione
* Nome Oggetto : CourseContract
* API model : c_contract Filtro fisso :

* [ ] Filtro Base = ???
* [ ] Filtri Avanzata: ???

#### - Corsi di Formazione

* Stato/note :  / 10%
* Nome Oggetto : CourseTraining
* API model : MP_Maintain  .. Filtro fisso :

* [ ] Filtro Base = ???
* [ ] Filtri Avanzata: ???
  {{% /expand%}}

##  6 Formazione Portale

#### - Corsi in Scadenza

* Stato/note :  / 10%
* Nome Oggetto :
* API model :   .. Filtro fisso :

* [ ] Filtro Base = ???
* [ ] Filtri Avanzata: ???

#### - Attestati Corsisti

* Stato/note :  / 10%
* Nome Oggetto :
* API model :   .. Filtro fisso :

* [ ] Filtro Base = ???
* [ ] Filtri Avanzata: ???
  {{% /expand%}}

##  7 Formazione Corsista

#### - Presenza Corso

* Stato/note :  / 10%
* Nome Oggetto :
* API model :   .. Filtro fisso :

* [ ] Filtro Base = ???
* [ ] Filtri Avanzata: ???

#### - Attestato

* Stato/note :  / 10%
* Nome Oggetto :
* API model :   .. Filtro fisso :

* [ ] Filtro Base = ???
* [ ] Filtri Avanzata: ???
  {{% /expand%}}

##  8 Acquisti 

#### - Lead Fornitore

* Stato/note :  / 10%
* Nome Oggetto : ad_user isleadvendor=Y
* API model :   .. Filtro fisso :

* [ ] Filtro Base = ???
* [ ] Filtri Avanzata: ???

#### - Prodotto / Giacenza / Prezzi Acquisto

* Stato/note : Definito / 10%
* Nome Oggetto : productwarehouseprice
* API model :   .. Filtro fisso :

* [ ] Filtro Base = ???
* [ ] Filtri Avanzata: ???

#### - Prodotti SottoScorta -> Crea ODA

* Stato/note :  / 10%
* Nome Oggetto :
* API model :   .. Filtro fisso :

* [ ] Filtro Base = ???
* [ ] Filtri Avanzata: ???

#### - Richiesta di Acquisto

* Stato/note :  / 10%
* Nome Oggetto :
* API model :   .. Filtro fisso :

* [ ] Filtro Base = ???
* [ ] Filtri Avanzata: ???

#### - Ordini di Acquisto

* Stato/note : Definito / 10%
* Nome Oggetto :
* API model :   .. Filtro fisso :

* [ ] Filtro Base = ???
* [ ] Filtri Avanzata: ???
  {{% /expand%}}

## 9  Logistica

#### - Prodotto / Giacenza

* Stato/note :  / 10%
* Nome Oggetto : productwarehouse
* API model :   .. Filtro fisso :

* [ ] Filtro Base = ???
* [ ] Filtri Avanzata: ???

#### - Inventario

* Stato/note :  / 10%
* Nome Oggetto : inventory
* API model :   .. Filtro fisso :

* [ ] Filtro Base = ???
* [ ] Filtri Avanzata: ???

#### - Spedizione Prodotti

* Stato/note : Definito / 10%
* Nome Oggetto : s
* API model :   .. Filtro fisso :

* [ ] Filtro Base = ???
* [ ] Filtri Avanzata: ???

#### - Trasferimento

* Stato/note :  / 10%
* Nome Oggetto :
* API model :   .. Filtro fisso :

* [ ] Filtro Base = ???
* [ ] Filtri Avanzata: ???

#### - Consumi

* Stato/note : Definito / 10%
* Nome Oggetto :
* API model :   .. Filtro fisso :

* [ ] Filtro Base = ???
* [ ] Filtri Avanzata: ???

#### - Entrata Merce

* Stato/note : Definito / 10%
* Nome Oggetto : materialreceipt
* API model :   .. Filtro fisso :

* [ ] Filtro Base = ???
* [ ] Filtri Avanzata: ???
  {{% /expand%}}

##  10 Mezzi e Attrezzature

#### - Mezzi

* Stato/note :  Definito/ 10%
* Nome Oggetto : Vehicle
* API window :   Vehicles Filtro fisso : isactive=Y

* [ ] Filtro Base = ???
* [ ] Filtri Avanzata: ???
* [ ] Ricerca per TARGA,NAME
* [ ] Visualizza : [Targa,Name,AssetType,BPartner,]
* [ ] Modifica ( No Delete)
* [ ]

#### - Attrezzatura

* Stato/note : Definito/ 10%
* Nome Oggetto :Equipment
* API windo : Equipment  Filtro fisso : isactive=Y

* [ ] Filtro Base = ???
* [ ] Filtri Avanzata: ???

#### - Presa in carico/Spostamento Mezzo/Attrezzatura e Rilascio

* Stato/note :  / 10%
* Nome Oggetto :
* API model :   .. Filtro fisso :

* [ ] Filtro Base = ???
* [ ] Filtri Avanzata: ???

#### - Scadenze

* Stato/note :  / 10%
* Nome Oggetto :
* API model :   .. Filtro fisso :

* [ ] Filtro Base = ???
* [ ] Filtri Avanzata: ???
  {{% /expand%}}

##  11 Produzione

#### - Ordine di Produzione

* Stato/note :  / 10%
* Nome Oggetto :
* API model :   .. Filtro fisso :

* [ ] Filtro Base = ???
* [ ] Filtri Avanzata: ???

#### - Prelievo da Ord. di Prod.

* Stato/note :  / 10%
* Nome Oggetto :
* API model :   .. Filtro fisso :

* [ ] Filtro Base = ???
* [ ] Filtri Avanzata: ???

#### - Dich. di Prod.

* Stato/note :  / 10%
* Nome Oggetto :
* API model :   .. Filtro fisso :

* [ ] Filtro Base = ???
* [ ] Filtri Avanzata: ???

#### - Prelievo e Dichi.di Prod.

* Stato/note :  / 10%
* Nome Oggetto :
* API model :   .. Filtro fisso :

* [ ] Filtro Base = ???
* [ ] Filtri Avanzata: ???

#### - Avanzamento di Produzione

* Stato/note :  / 10%
* Nome Oggetto :
* API model :   .. Filtro fisso :

* [ ] Filtro Base = ???
* [ ] Filtri Avanzata: ???
  {{% /expand%}}

##  12 Contabilità 

* Nome Oggetto : Finance
#### - Fattura di Acquisto

* Stato/note :  / 10%
* Nome Oggetto :
* API model :   .. Filtro fisso :

* [ ] Filtro Base = ???
* [ ] Filtri Avanzata: ???

#### - Fattura di Vendita

* Stato/note :  / 10%
* Nome Oggetto :
* API model :   .. Filtro fisso :

* [ ] Filtro Base = ???
* [ ] Filtri Avanzata: ???

#### - Incassi e Pagamenti  (in scadenza / tutti ?)

* Stato/note : / 10%
* Nome Oggetto :
* API model :   .. Filtro fisso :

* [ ] Filtro Base = ???
* [ ] Filtri Avanzata: ???

#### - Partite Aperte

* Stato/note :  / 10%
* Nome Oggetto :
* API model :   .. Filtro fisso :

* [ ] Filtro Base = ???
* [ ] Filtri Avanzata: ???

#### - Movimenti Bancari

* Stato/note :  / 10%
* Nome Oggetto :
* API model :   .. Filtro fisso :

* [ ] Filtro Base = ???
* [ ] Filtri Avanzata: ???

#### - Cash Flow

* Stato/note :  / 10%
* Nome Oggetto :
* API model :   .. Filtro fisso :

* [ ] Filtro Base = ???
* [ ] Filtri Avanzata: ???
  {{% /expand%}}

## 13 Risorse Umane
* Stato/note : Definito / 10%
* Nome Oggetto : HR


#### - Ritardi e Assenze

* Stato/note :  / 10%
* Nome Oggetto : VISTA !!!
* API model :   .. Filtro fisso :

* [ ] Filtro Base = ???
* [ ] Filtri Avanzata: ???

#### - Chat

* Stato/note :  / 10%
* Nome Oggetto :
* API model :   .. Filtro fisso :

* [ ] Filtro Base = ???
* [ ] Filtri Avanzata: ???

#### - Ticket HR ( Ferie,Permessi,Malattia,altro..)

* Nome Oggetto : HR_Ticket -> Calendario
  fACCIO LA RICHEISTA DAL CALENDARIO
* API model :   .. Filtro fisso :

* [ ] Filtro Base = ???
* [ ] Filtri Avanzata: ???

#### - Scheda Dipendente

* Nome Oggetto : Employee
* API model :   Profilemployee Filtro fisso :

* [ ] Filtro Base = ???
* [ ] Filtri Avanzata: ???

#### - Dotazione Dipendente

* Nome Oggetto :
* API model :   .. Filtro fisso :

* [ ] Filtro Base = ???
* [ ] Filtri Avanzata: ???

#### - Bacheca ( aziendale, ufficio/report , personale)

* Nome Oggetto :
* API model :   .. Filtro fisso :

* [ ] Filtro Base = ???
* [ ] Filtri Avanzata: ???

#### - Ricerca personale (assunzione, curriculum )

* Nome Oggetto : ad_user!
* API model :   .. Filtro fisso :

* [ ] Filtro Base = ???
* [ ] Filtri Avanzata: ???

## Dipendente

#### - Bacheca Personale

!!!

* Stato/note :  / 10%
* Nome Oggetto :tbd
* API model :   .. Filtro fisso :

* [ ] Filtro Base = ???
* [ ] Filtri Avanzata: ???

#### - Timbracartellino (Qrcode, GPS,Foto)

!!! SSDFSDFSDFSDFFSD

* Stato/note :  / 10%
* Nome Oggetto :
* API model :   .. Filtro fisso :

* [ ] Filtro Base = ???
* [ ] Filtri Avanzata: ???

#### - Richiesta Permesso / Ferie /Malattia

!! Definire tabelle/maschere su idempiere !!!!!!!!!!!!!!!!!!!

* Stato/note :  / 10%
* Nome Oggetto :
* API model :   .. Filtro fisso :

* [ ] Filtro Base = ???
* [ ] Filtri Avanzata: ???
* [ ]

#### - Sondaggi (light)

!! Definire tabelle/maschere su idempiere !!!!!!!!!!!!!!!!!!!

* how to https://github.com/quickbirdstudios/survey_kit
* Stato/note : DA DEFINIRE / 10%
* Nome Oggetto :
* API model :   .. Filtro fisso :

* [ ] Filtro Base = ???
* [ ] Filtri Avanzata: ???

#### - Armadietto (busta paga)

!! Definire cos'è un armadietto !!!!!!!!!!!!!!!!!!!!!!!!!!!

* Stato/note : DA DEFINIRE  / 10%
* Nome Oggetto :
* API model :   .. Filtro fisso :

* [ ] Filtro Base = ???
* [ ] Filtri Avanzata: ???
  Formazione/Documenti ( documenti, Video x tutti / ufficio / ruolo )
  {{% /expand%}}

## 99 Setup e Opzioni

#### - Opzioni Server (Client)

!! Fare maschera su idempiere come Parametrizzazione Azienda

* Nome Oggetto : Server Option
* API model :  Filtro fisso :
  da 1-30 Y/N moduli (Crm,Vendite,...)
  1 CRM Y/N
  2 (libero)
  3 Ticket-Task-Ore Y/N
  4 Manutenzione-Tecnico Y/N
  5 Manutenzione-Portale Y/N
  6 Formazione Y/N
  7 Formazione Portale Y/N
  8 Formazione Corsista Y/N
  9 Acquisti Y/N
  10 Logistica Y/N
  11 Mezzi e Attrezzatura Y/N
  12 Prodzione Y/N
  13 Contabilità Y/N
  14 Risorse Umane Y/N
  15 Dipendente Y/N
  16-30 (libero)
  31 ##FilterAll  Y/N
  32-33-34-35-36-37 #BasePriceList : 1000023
  38 #OfferDays :30

#### - Opzioni Utente

* Stato/note :  / 10%
* Nome Oggetto : User Option
* API model :  ad_user Filtro fisso :
  1

{{% pageinfo %}} ##CRM {{% /pageinfo %}}
