---
title: "i-Smart iDempiere - Mobile  App "
date: 2020-04-24T22:47:10+02:00
draft: false
weight : 2500
pre: "<b>90. </b>"
---
# Progetto iDempiere Flutter

 ## Funzionalità da vedere !!! (Vincenzo)


* [ ] Eseguire processo idempiere con parametri APIREST
* [ ] Attivare Acquisizione Fotocamera 
* [ ] Visualizzare Allegato (vedere ticket desktop app) (S2)
* [ ] Gestione Barcode QRcode (vedi processi produzione)
* [ ] Chat (wishing list)
* [ ] Stampa report (da idempiere)  da vedere con AC (TOP)
* [ ] Stampa Diretta Bluetooth o IP
      https://pub.dev/packages/bluetooth_print
* [ ] Gestione NFC - Per segnare le ore ? - controllare plugin NFC
* [ ] Sondaggi https://github.com/quickbirdstudios/survey_kit
* [ ] Flutter OFFLINE -
      - Login (OK) User=isofflinenbale(OFF) 
                  - sync/downlaod (?bp,led, !!! mp_task !!! )
                   Locale/Cache "202101111054MARCOLVal4hr" Tokenlocal per offline (4 h 
                   anche dei ruoli 
                   SetupPagina di sincronizzaizone - Lead N  - MPTASK Y  [Avvio sync/Auto] (idempiere)
       - Login [v]offline solo se l'utente è ismobilenable 
         Bypassare Ruoli 
         Pagine in offline (MP_Task, Lead , ...) ? quali sync , quando ?  
         

  

## Login ! (Vincenzo)

* [ ] Logo App , immagini login 
* [ ] Spostare Utente in alto a Sx  
* [ ] Accesso via https  
* [ ] Saltare la prima pagina e andare alla Login Page 
* [ ] Non si visualizzano i Dati Server  
* [ ] Exit(Tocca ancora per uscire ) 
* [ ] Logout (Attenzione cancella i dati di login )

## Dashboard (Vincenzo/Matteo)

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

### Calendario 

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

### Lead [CRUD](..)

* Stato/note : Funzionalità base OK 
* Descrizione : Gestione Totale [REWD] + Task + Opportunità + Converti in BP
* Nome Oggetto : leads
* API window lead Filtro fisso = IsSalesLead eq Y 

* [X] Filtro Base = All Miei Team
* [ ] Filtri Avanzata: Stato Lead
* [ ] Ricerca : Nome,Telefono,Nome BP
* [X] (R)Visualizzare
*   [X] Nome  (Header)
*   [X] Stato del Lead (Header) 
*   [X] Nome del BP
*   [X] Telefono 
*   [X] Email
*   [X] Agente
* [X] (U)Modificare(Tutti i campi)
* [X] (C)Creare 
* [ ] Creare Default LoginUser come Agente
* [X] (D)Cancellare
* [ ] Caricare da Contatto 
* [X] Eseguire Telefonata 
* [X] Invio Email 
* [ ] Scarica Lead come Contatto Telefono 
* [ ] Converti Lead in BP
* [ ] Crea Task Lead, 
* [ ] Crea Opportunità Lead (Se BP completo) 
* [ ] Mostra Task da fare -Vai a
* [ ] Mostra Task eseguiti 
* [ ] Mostra Opportunità - Vai a 
* [ ] Mostra Offerte - Vai a 
* [ ] Invio Msg Telegram 
* [ ] Invio Msg SMS  
* [ ] Invio Msg Whatsapp 

### Contatti [R](CUD..)

* Stato/note : Manca CUD
* Descrizione : Gestione Completa Contatti Clienti
* Nome Oggetto : contact
* API model: ad_user - Filtro fisso = isactive='Y'

* [ ] Filtro Base = All Miei Team
* [ ] Filtri Avanzata: Nessuno
* [ ] Ricerca
* [X] (R)Visualizzare : 
*   [X] Nome (Header)
*   [X] Nome del Business Partner (Header)
*   [X] Telefono
*   [X] Email
*   [ ] Agente
* [ ] (C)Creare (Assegnare BP) 
* [ ] (U)Modificare
    [ ] Nome  (Header)
*   [ ] Stato del Lead (Header) 
*   [ ] Nome del BP
*   [ ] Telefono 
*   [ ] Email
*   [ ] Agente
* [ ] (D)Cancellare
* [ ] Caricare da Contatto(Assegnare BP) 
* [X] Eseguire Telefonata (S1)
* [X] Invio Email (S1)
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

### Clienti [R](CUD) !!!

* Stato/note : Non visualizzo metodo, termini e indirizzo 
* Descrizione : Gestione Completa Bussiness Partner Clienti
* Nome Oggetto : BusinessPartner
* API model : c_bpartner - Filtro fisso : iscustomer=Y and isactive='Y'

* [ ] Filtro Base = All Miei(agente=user)
* [ ] Filtri Avanzata: Gruppo Business Partner or Categoria BP
* [ ] Ricerca
* [ ] Visualizzare BP
    [ ] Nome
    [ ] Metodo Pagamento 
    [ ] Termine di Pagamento
    [ ] indirizzo(isbillto)
    [ ] Telefono
    [ ] Email
    [ ] Agente
* [ ] Creare
* [ ] Modificare 
    [ ] Nome
    [ ] Indirizzo
    [ ] Metodo di Pagamento
    [ ] Termine di Pagamento
    [ ] Telefono
    [ ] Email
    [ ] Agente
* [ ] Visualizzazione Contatti -> Vai a Contatti
* [ ] Crea Task  Business Partner
* [ ] Crea Opportunità  Business Partner (S2)
* [ ] Mostra Opportunità - Vai a (S2)
* [ ] Mostra Offerte - Vai a (S2)

### Task Lead [R] (CUD)

* Stato/note : 
* Descrizione : Gestione Task 
* Nome Oggetto : Task
* API model  : JP_Todo - Filtro fisso : EndDate is null isactive='Y'

* [ ] Filtro Base = All miei Team
* [ ] Filtri Avanzata: Stato
* [ ] Ricerca
* [ ] (R)Visualizzare Task 
    [ ] Descrizione
    [ ] Stato
    [ ] Priorita
    [ ] Tipoattività
    [ ] DataInizi
    [ ] Salesrep
* [ ] (C)Creare
* [ ] (U)Modificare
* [ ] (D)Cancellazione (se non completato)
* [ ] (P) Completare (Update Stato)
* [ ] Se Lead Telefonare
* [ ] Invio Email
* [ ] Promemoria / Notifica per Data/ora

### Opportunità Lead / BP [R] (CUD)

* Stato/note :
* Descrizione : Gestione completa Opportunità 
* Nome Oggetto : Opportunity
* API window : Opportunity  Filtro fisso : isactive='Y'

* [ ] Filtro Base =All Miei Team
* [ ] Filtri Avanzata: Stato
* [ ] Ricerca : 
* [X] (R)Visualizzare Opportunità 
    [ ] NrDocumento
    [ ] Business Partner
    [ ] Descrizione
    [ ] Prodotto
    [ ] Agente,
    [ ] Stato
    [ ] Importo 
* [ ] (C)Crea
* [ ] (U) Modificare (tutto)
* [ ] (D) Cancellare
* [ ] Crea Task su Opportunità
* [ ] Crea Offerta (se ho il prodotto)

### Offerta/Ordine di Vendita [R-CO](CUD)

* Stato/note : 
* Descrizione : Gestione Completa Ordine con Complete
* Nome Oggetto : Offer
* API model c_order  Filtro fisso:  isactive='Y' < #GiorniOfferta

* [ ] Filtro Base = All Miei Team
* [ ] Filtri Avanzata: Bozza/Completato/Fatturato/Pagato
* [ ] Ricerca : 
* [X] (R)Visualizzare Offerta 
    [X] Nrdocumento
    [X] Data Ordine,
    [ ] Business Partner
    [ ] Tipo Documento
    [ ] Agente
    [ ] Metodo di Pagemento
    [ ] Termine di Pagamento)
* [ ] Visualizzare Righe Offerta
    [ ] Prodotto,Descrizione,um,qty,prezzo listino,prezzo,sconto,iva)
* [ ] (C) Crea
* [ ] (U) Modificare (testata e righe)
* [ ] (D) Cancellare (Solo se Bozza)
* [X] (P) Completare Offerta
* [ ] (P) Riaprire Offerta(solo se Standard Order e non Spedito)
* [ ] Inviare Email con template email
* [ ] Vai a Fattura

### Listino Prodotti [R](CUD)

* Stato/note : 
* Descrizione : Gestione completa Prodotto 
* Nome Oggetto : ProductList
* API model  : m_product  Filtro fisso : isactive='Y'  listino(vedi opzioni)

* [ ] Filtro Base = Categoria Prodotto
* [ ] Filtri Avanzata: Categoria Merceologica
* [ ] Ricerca : 
* [ ] (R)Visualizzare Prodotti 
    [ ] Immagine
    [ ] Value
    [ ] Name
    [ ] Descrizione
    [ ] Prezzo
    [ ] Giacenza
* [ ] (C)Crea
* [ ] (U) Modificare (tutto)


### Documento di Trasporto [R](CUD)


* Stato/note : Definito 
* Descrizione :
* Nome Oggetto : Shipment
* API window :  ShipmentCustomer  Filtro fisso : isactive=Y

* [ ] Filtro Base = ???
* [ ] Filtri Avanzata: ???
* [ ] Ricerca : 
* [ ] Visualizzare DDT 
    [ ] NrDocumento
    [ ] Data,BP)
* [ ] (R)Visualizzare Righe 
    [ ] Prodotto
    [ ] Descrizione
    [ ] um
    [ ] qty,
    [ ] prezzo listino
    [ ] prezzo
    [ ] sconto
    [ ]iva
* [ ] (C)Crea
* [ ] (U)Modificare (tutto)
* [ ] (P)Completare Documento

### Fatture di Vendita [R](CUD)
* Stato/note : 
* Descrizione :
* Nome Oggetto : InvoiceCustomer
* API window : invoicecustomer  Filtro fisso : isactive=Y

* [ ] Filtro Base = Stato documento
* [ ] Filtri Avanzata:
* [ ] Ricerca : 
* [ ] (R)Visualizzare Fattura di Vendita
    [ ] Nr Documento
    [ ] Data Fattura
    [ ] Business Partner 
    [ ] Importo Totale 
    [ ] Scadenza
    [ ] Pagato
* [ ] (R)Visualizzare Righe 
    [ ] Prodotto
    [ ] Descrizione
    [ ] Um
    [ ] Qty
    [ ] Prezzo listino,
    [ ] Prezzo,
    [ ] Sconto
* [ ] (C)Crea a mano DA QUI O PROCESSO A PARTE . CREA da ODV ?
* [ ] (U)Modificare (tutto)
* [ ] (P)Completare Documento
* [ ] (P)Paga Fattura (Conto corrente - Importo)
### Incasso [R](CUD)

* Stato/note : 
* Descrizione :
* Nome Oggetto : Payment
* API window : Payment   Filtro fisso : isactive=Y

* [ ] Filtro Base = ???
* [ ] Filtri Avanzata: ???
* [ ] Ricerca : 
* [ ] (R)Visualizzare Pagamento
    [ ] Nr Documento
    [ ] Tipo Documento
    [ ] Data Transazione
    [ ] Business Partner 
    [ ] Importo Totale 
    [ ] Fattura
* [ ] (C)Crea a mano DA QUI O PROCESSO A PARTE . ?
* [ ] (U)Modificare (tutto)
* [ ] (P)Completare Documento

### Provvigione [R] ()

* Stato/note : Definito / 10%
* Descrizione : Visualizzazione Provvigioni (No Crea/No Modifica/No Processi)
* Nome Oggetto : Commission
* API model :   .. Filtro fisso :

* [ ] Filtro Base = Mese / Anno
* [ ] Filtri Avanzata: ???
* [ ] Ricerca : 
* [ ] (R)Visualizzare Pagamento
    [ ] Nr Documento
    [ ] Tipo Documento
    [ ] Data Transazione
    [ ] Business Partner 
    [ ] Importo Totale 
    [ ] Fattura


##  2 Ticket Task e Ore

Nome Oggetto : Ticket
get API : Ticket (count(*),count(*)Miei, Count(*)Last 7day,
Ticket

### Ticket New [..](CRUD)

* Stato/note : 
* Descrizione :
* Nome Oggetto : TicketNew
* API model :   R_Request Filtro fisso : salesrepo_id=login or Team 

* [ ] Filtro Base = TIPO
* [ ] Filtri Avanzata: ???
* [ ] Ricerca : 
* [ ] (R)Visualizzare Pagamento
    [ ] Nr Documento
* [ ] (C)Crea a mano DA QUI O PROCESSO A PARTE . ?
* [ ] (U)Modificare ...
* [ ] (P)...
  


### Task TODO (miei/Team) TBD

* Stato/note : Definito / 10%
* Descrizione :
* Nome Oggetto : taskTODO
* API model :   JP_Todo Filtro fisso :

* [ ] Filtro Base = ???
* [ ] Filtri Avanzata: ???
* [ ] Ricerca : 
* [ ] (R)Visualizzare Pagamento
    [ ] Nr Documento
* [ ] (C)Crea a mano DA QUI O PROCESSO A PARTE . ?
* [ ] (U)Modificare ...
* [ ] (P)...

### Riepilogo Ore [] (CRUD) 

* Stato/note : 
* Descrizione :
* Nome Oggetto : ResourceAssignment
* API model :   s_resourceassignment Filtro fisso :

* [ ] Filtro Base = ???
* [ ] Filtri Avanzata: ???
* [ ] Ricerca : 
* [ ] (R)Visualizzare Pagamento
    [ ] Nr Documento
* [ ] (C)Crea a mano DA QUI O PROCESSO A PARTE . ?
* [ ] (U)Modificare ...
* [ ] (P)...

##   3 Manutenzione Tecnico

Nome Oggetto : Maintenance
get API :

### -  Calendario Tecnico ((miei/Team)

* Stato/note : Definito / 10%
* Descrizione :
* Nome Oggetto : calendar
* API model :  lit_mp_ot_v .. Filtro fisso :

* [ ] Filtro Base = ???
* [ ] Filtri Avanzata: ???
* [ ] Ricerca : 
* [ ] (R)Visualizzare Pagamento
    [ ] Nr Documento
* [ ] (C)Crea a mano DA QUI O PROCESSO A PARTE . ?
* [ ] (U)Modificare ...
* [ ] (P)...
* [ ] 
### -  Intervento Manutenzione [OFFLINE]

* Stato/note : 
* Descrizione :
* Nome Oggetto : mptask
* API model :    Filtro fisso :

* [ ] Filtro Base = ???
* [ ] Filtri Avanzata: ???
* [ ] Ricerca : 
* [ ] (R)Visualizzare Pagamento
    [ ] Nr Documento
* [ ] (C)Crea a mano DA QUI O PROCESSO A PARTE . ?
* [ ] (U)Modificare ...
* [ ] (P)...
### -  Anomalia Manutenzione

* Stato/note : Definito / 10%
* Descrizione :
* Nome Oggetto : mpanomaly
* API model :   .. Filtro fisso :

* [ ] Filtro Base = ???
* [ ] Filtri Avanzata: ???
* [ ] Ricerca : 
* [ ] (R)Visualizzare Pagamento
    [ ] Nr Documento
* [ ] (C)Crea a mano DA QUI O PROCESSO A PARTE . ?
* [ ] (U)Modificare ...
* [ ] (P)...
### -  Magazzino Furgone

* Stato/note : Definito / 10%
* Descrizione :
* Nome Oggetto : mpwarehouse
* API model :   .. Filtro fisso :

* [ ] Filtro Base = ???
* [ ] Filtri Avanzata: ???
* [ ] Ricerca : 
* [ ] (R)Visualizzare Pagamento
    [ ] Nr Documento
* [ ] (C)Crea a mano DA QUI O PROCESSO A PARTE . ?
* [ ] (U)Modificare ...
* [ ] (P)...
### -  Prelievo da Magazzino Centrale

* Stato/note : Definito / 10%
* Descrizione :
* Nome Oggetto : mppicking
* API model :   .. Filtro fisso :

* [ ] Filtro Base = ???
* [ ] Filtri Avanzata: ???
* [ ] Ricerca : 
* [ ] (R)Visualizzare Pagamento
    [ ] Nr Documento
* [ ] (C)Crea a mano DA QUI O PROCESSO A PARTE . ?
* [ ] (U)Modificare ...
* [ ] (P)...
### -  Carico/Scarico

* Stato/note : Definito / 10%
* Descrizione :
* Nome Oggetto : internaluseinventory
* API model :   .. Filtro fisso :

* [ ] Filtro Base = ???
* [ ] Filtri Avanzata: ???
* [ ] Ricerca : 
* [ ] (R)Visualizzare Pagamento
    [ ] Nr Documento
* [ ] (C)Crea a mano DA QUI O PROCESSO A PARTE . ?
* [ ] (U)Modificare ...
* [ ] (P)...
### -  Carico Scheda tecnica

* Stato/note : Definito / 10%
* Descrizione :
* Nome Oggetto : mpimportitem
* API model :   .. Filtro fisso :

* [ ] Filtro Base = ???
* [ ] Filtri Avanzata: ???
* [ ] Ricerca : 
* [ ] (R)Visualizzare Pagamento
    [ ] Nr Documento
* [ ] (C)Crea a mano DA QUI O PROCESSO A PARTE . ?
* [ ] (U)Modificare ...
* [ ] (P)...

##  4 Portale Cliente

Nome Oggetto : Portal_MP
get API :


### - Dashboard Portale (no a menu)

* Stato/note : Definito / 10%
* Descrizione :
* Nome Oggetto : tbd
* API model :   .. Filtro fisso :

* [ ] Filtro Base = ???
* [ ] Filtri Avanzata: ???
* [ ] Ricerca : 
* [ ] (R)Visualizzare Pagamento
    [ ] Nr Documento
* [ ] (C)Crea a mano DA QUI O PROCESSO A PARTE . ?
* [ ] (U)Modificare ...
* [ ] (P)...
  
#### - News  (Promo) (no a menu)

* Stato/note : Definito / 10%
* Descrizione :
* Nome Oggetto : tbd
* API model :   .. Filtro fisso :

* [ ] Filtro Base = ???
* [ ] Filtri Avanzata: ???
* [ ] Ricerca : 
* [ ] (R)Visualizzare Pagamento
    [ ] Nr Documento
* [ ] (C)Crea a mano DA QUI O PROCESSO A PARTE . ?
* [ ] (U)Modificare ...
* [ ] (P)...


#### - Fatture di Acquisto (Pagamento)

* Stato/note : Definito / 10%
* Descrizione :
* Nome Oggetto : invoicepo
* API model :   .. Filtro fisso :

* [ ] Filtro Base = ???
* [ ] Filtri Avanzata: ???
* [ ] Ricerca : 
* [ ] (R)Visualizzare Pagamento
    [ ] Nr Documento
* [ ] (C)Crea a mano DA QUI O PROCESSO A PARTE . ?
* [ ] (U)Modificare ...
* [ ] (P)...



#### - Indicatori ( Ultima visita / Prossima Visita)/anomalie)

* Stato/note : Definito / 10%
* Descrizione :
* Nome Oggetto : tbd
* API model :   .. Filtro fisso :

* [ ] Filtro Base = ???
* [ ] Filtri Avanzata: ???
* [ ] Ricerca : 
* [ ] (R)Visualizzare Pagamento
    [ ] Nr Documento
* [ ] (C)Crea a mano DA QUI O PROCESSO A PARTE . ?
* [ ] (U)Modificare ...
* [ ] (P)...


#### Offerte di Vendita (aperte/tutte)

* Stato/note : Definito / 10%
* Descrizione :
* Nome Oggetto : portaloffer
* API model :   .. Filtro fisso :

* [ ] Filtro Base = ???
* [ ] Filtri Avanzata: ???
* [ ] Ricerca : 
* [ ] (R)Visualizzare Pagamento
    [ ] Nr Documento
* [ ] (C)Crea a mano DA QUI O PROCESSO A PARTE . ?
* [ ] (U)Modificare ...
* [ ] (P)...


### Ticket (portale) TBD


#### Ticket (portale) [](CRUD)

* Stato/note : Definito / 10%
* Descrizione :
* Nome Oggetto : CustomerTicket
* API model :  r_request  Filtro fisso :

* [ ] Filtro Base = ???
* [ ] Filtri Avanzata: ???
* [ ] * [ ] Ricerca : 
* [ ] (R)Visualizzare Pagamento
    [ ] Nr Documento
* [ ] (C)Crea Ticket + allega foto
  
* [ ] (U)Modificare ...
* [ ] (P)...
  
### - Manutenzione

* Stato/note : Definito / 10%
* Descrizione :
* Nome Oggetto :
* API model :   .. Filtro fisso :

* [ ] Filtro Base = ???
* [ ] Filtri Avanzata: ???
* [ ] Ricerca : 
* [ ] (R)Visualizzare Pagamento
    [ ] Nr Documento
* [ ] (C)Crea a mano DA QUI O PROCESSO A PARTE . ?
* [ ] (U)Modificare ...
* [ ] (P)...


#### - Contratto

* Stato/note : Definito / 10%
* Descrizione :
* Nome Oggetto : ContractMP
* API model :   c_contract Filtro fisso :

* [ ] Filtro Base = ???
* [ ] Filtri Avanzata: ???
* [ ] Ricerca : 
* [ ] (R)Visualizzare Pagamento
    [ ] Nr Documento
* [ ] (C)Crea a mano DA QUI O PROCESSO A PARTE . ?
* [ ] (U)Modificare ...
* [ ] (P)...


#### - Impianto

* Stato/note : Definito / 10%
* Descrizione :
* Nome Oggetto :
* API model :   .. Filtro fisso :

* [ ] Filtro Base = ???
* [ ] Filtri Avanzata: ???
* [ ] Ricerca : 
* [ ] (R)Visualizzare Pagamento
    [ ] Nr Documento
* [ ] (C)Crea a mano DA QUI O PROCESSO A PARTE . ?
* [ ] (U)Modificare ...
* [ ] (P)...


#### - Anomalie

* Stato/note : Definito / 10%
* Descrizione :
* Nome Oggetto :
* API model :   .. Filtro fisso :

* [ ] Filtro Base = ???
* [ ] Filtri Avanzata: ???
* [ ] Ricerca : 
* [ ] (R)Visualizzare Pagamento
    [ ] Nr Documento
* [ ] (C)Crea a mano DA QUI O PROCESSO A PARTE . ?
* [ ] (U)Modificare ...
* [ ] (P)...

##   Formazione Portale

#### - Corsi di Formazione 

* Stato/note :  / 10%
* Nome Oggetto :
* API model :   .. Filtro fisso :

* [ ] Filtro Base = ???
* [ ] Filtri Avanzata: ???
* [ ] Ricerca : 
* [ ] (R)Visualizzare Pagamento
    [ ] Nr Documento
* [ ] (C)Crea a mano DA QUI O PROCESSO A PARTE . ?
* [ ] (U)Modificare ...
* [ ] (P)...
  
#### - Attestati Corsisti

* Stato/note :  / 10%
* Nome Oggetto :
* API model :   .. Filtro fisso :

* [ ] Filtro Base = ???
* [ ] Filtri Avanzata: ???
* [ ] Ricerca : 
* [ ] (R)Visualizzare Pagamento
    [ ] Nr Documento
* [ ] (C)Crea a mano DA QUI O PROCESSO A PARTE . ?
* [ ] (U)Modificare ...
* [ ] (P)...


#### - Proposta Nuovi Corsi

* Stato/note :  / 10%
* Nome Oggetto : CourseTraining
* API model : MP_Maintain  .. Filtro fisso :

* [ ] Filtro Base = ???
* [ ] Filtri Avanzata: ???
* [ ] Ricerca : 
* [ ] (R)Visualizzare Pagamento
    [ ] Nr Documento
* [ ] (C)Crea a mano DA QUI O PROCESSO A PARTE . ?
* [ ] (U)Modificare ...
* [ ] (P)...


##  5 Formazione Corsista

#### - Presenza Corso

* Stato/note :  / 10%
* Nome Oggetto :
* API model :   .. Filtro fisso :

* [ ] Filtro Base = ???
* [ ] Filtri Avanzata: ???
* [ ] Ricerca : 
* [ ] (R)Visualizzare Pagamento
    [ ] Nr Documento
* [ ] (C)Crea a mano DA QUI O PROCESSO A PARTE . ?
* [ ] (U)Modificare ...
* [ ] (P)...


#### - Attestato

* Stato/note :  / 10%
* Nome Oggetto :
* API model :   .. Filtro fisso :

* [ ] Filtro Base = ???
* [ ] Filtri Avanzata: ???
* [ ] Ricerca : 
* [ ] (R)Visualizzare Pagamento
    [ ] Nr Documento
* [ ] (C)Crea a mano DA QUI O PROCESSO A PARTE . ?
* [ ] (U)Modificare ...
* [ ] (P)...

<<<<<<< HEAD
##  6 Acquisti 
=======
##  8 Acquisti 
Purchase
>>>>>>> redme

#### - Lead Fornitore [R] (CUD)

* Stato/note : 
* Nome Oggetto : ad_user isleadvendor=Y
* API model :   .. Filtro fisso :

* [ ] Filtro Base = ???
* [ ] Filtri Avanzata: ???
* [ ] Ricerca : 
* [ ] (R)Visualizzare Pagamento
    [ ] Nr Documento
* [ ] (C)Crea a mano DA QUI O PROCESSO A PARTE . ?
* [ ] (U)Modificare ...
* [ ] (P)...


#### - Prodotto / Giacenza / Prezzi Acquisto

* Stato/note : Definito / 10%
* Nome Oggetto : productwarehouseprice
* API model :   .. Filtro fisso :

* [ ] Filtro Base = ???
* [ ] Filtri Avanzata: ???
* [ ] Ricerca : 
* [ ] (R)Visualizzare Pagamento
    [ ] Nr Documento
* [ ] (C)Crea a mano DA QUI O PROCESSO A PARTE . ?
* [ ] (U)Modificare ...
* [ ] (P)...


#### - Prodotti SottoScorta -> Crea ODA

* Stato/note :  / 10%
* Nome Oggetto :
* API model :   .. Filtro fisso :

* [ ] Filtro Base = ???
* [ ] Filtri Avanzata: ???
* [ ] Ricerca : 
* [ ] (R)Visualizzare Pagamento
    [ ] Nr Documento
* [ ] (C)Crea a mano DA QUI O PROCESSO A PARTE . ?
* [ ] (U)Modificare ...
* [ ] (P)...


#### - Richiesta di Acquisto

* Stato/note :  / 10%
* Nome Oggetto :
* API model :   .. Filtro fisso :

* [ ] Filtro Base = ???
* [ ] Filtri Avanzata: ???
* [ ] Ricerca : 
* [ ] (R)Visualizzare Pagamento
    [ ] Nr Documento
* [ ] (C)Crea a mano DA QUI O PROCESSO A PARTE . ?
* [ ] (U)Modificare ...
* [ ] (P)...


#### - Ordini di Acquisto

* Stato/note : Definito / 10%
* Nome Oggetto :
* API model :  c_order Filtro fisso : issotrx='N'

* [ ] Filtro Base = ???
* [ ] Filtri Avanzata: ???
* [ ] Ricerca : 
* [ ] (R)Visualizzare Pagamento
    [ ] Nr Documento
* [ ] (C)Crea a mano DA QUI O PROCESSO A PARTE . ?
* [ ] (U)Modificare ...
* [ ] (P)...



<<<<<<< HEAD
## 7  Logistica
=======
## 9  Logistica  
    Supplychain

>>>>>>> redme

#### - Prodotto / Giacenza

* Stato/note :  / 10%
* Nome Oggetto : productwarehouse
* API model :   .. Filtro fisso :

* [ ] Filtro Base = ???
* [ ] Filtri Avanzata: ???
* [ ] Ricerca : 
* [ ] (R)Visualizzare Pagamento
    [ ] Nr Documento
* [ ] (C)Crea a mano DA QUI O PROCESSO A PARTE . ?
* [ ] (U)Modificare ...
* [ ] (P)...





#### - Spedizione Prodotti

* Stato/note : Definito / 10%
* Nome Oggetto : s
* API model :   .. Filtro fisso :

* [ ] Filtro Base = ???
* [ ] Filtri Avanzata: ???
* [ ] Ricerca : 
* [ ] (R)Visualizzare Pagamento
    [ ] Nr Documento
* [ ] (C)Crea a mano DA QUI O PROCESSO A PARTE . ?
* [ ] (U)Modificare ...
* [ ] (P)...

#### - Entrata Merce

* Stato/note : Definito / 10%
* Nome Oggetto : materialreceipt
* API model :   .. Filtro fisso :

* [ ] Filtro Base = ???
* [ ] Filtri Avanzata: ???
* [ ] Ricerca : 
* [ ] (R)Visualizzare Pagamento
    [ ] Nr Documento
* [ ] (C)Crea a mano DA QUI O PROCESSO A PARTE . ?
* [ ] (U)Modificare ...
* [ ] (P)...

#### - Trasferimento

* Stato/note :  / 10%
* Nome Oggetto :
* API model :   .. Filtro fisso :

* [ ] Filtro Base = ???
* [ ] Filtri Avanzata: ???
* [ ] Ricerca : 
* [ ] (R)Visualizzare Pagamento
    [ ] Nr Documento
* [ ] (C)Crea a mano DA QUI O PROCESSO A PARTE . ?
* [ ] (U)Modificare ...
* [ ] (P)...


#### - Consumi

* Stato/note : Definito / 10%
* Nome Oggetto :
* API model :   .. Filtro fisso :

* [ ] Filtro Base = ???
* [ ] Filtri Avanzata: ???
* [ ] Ricerca : 
* [ ] (R)Visualizzare Pagamento
    [ ] Nr Documento
* [ ] (C)Crea a mano DA QUI O PROCESSO A PARTE . ?
* [ ] (U)Modificare ...
* [ ] (P)...

#### - Inventario

* Stato/note :  / 10%
* Nome Oggetto : inventory
* API model :   .. Filtro fisso :

* [ ] Filtro Base = ???
* [ ] Filtri Avanzata: ???
* [ ] Ricerca : 
* [ ] (R)Visualizzare Pagamento
    [ ] Nr Documento
* [ ] (C)Crea a mano DA QUI O PROCESSO A PARTE . ?
* [ ] (U)Modificare ...
* [ ] (P)...



<<<<<<< HEAD

##  8 Mezzi e Attrezzature

=======
##  10 Mezzi e Attrezzature
Vehicle Equipment
>>>>>>> redme
#### - Mezzi

* Stato/note :  Definito/ 10%
* Nome Oggetto : Vehicle
* API window :   Vehicles Filtro fisso : isactive=Y

* [ ] Filtro Base = ???
* [ ] Filtri Avanzata: ???
* [ ] Ricerca per TARGA,NAME
* [ ] Ricerca : 
* [ ] (R)Visualizzare Pagamento
    [ ] Targa
    [ ] Nome
    [ ] Tipo Asset
    [ ]
* [ ] (C)Crea a mano DA QUI O PROCESSO A PARTE . ?
* [ ] (U)Modificare ...
* [ ] (P)...



#### - Attrezzatura

* Stato/note : Definito/ 10%
* Nome Oggetto :Equipment
* API windo : Equipment  Filtro fisso : isactive=Y

* [ ] Filtro Base = ???
* [ ] Filtri Avanzata: ???
* [ ] Ricerca : 
* [ ] (R)Visualizzare Pagamento
    [ ] Nr Documento
* [ ] (C)Crea a mano DA QUI O PROCESSO A PARTE . ?
* [ ] (U)Modificare ...
* [ ] (P)...


#### - Presa in carico/Spostamento Mezzo/Attrezzatura e Rilascio

* Stato/note :  / 10%
* Nome Oggetto :
* API model :   .. Filtro fisso :

* [ ] Filtro Base = ???
* [ ] Filtri Avanzata: ???
* [ ] Ricerca : 
* [ ] (R)Visualizzare Pagamento
    [ ] Nr Documento
* [ ] (C)Crea a mano DA QUI O PROCESSO A PARTE . ?
* [ ] (U)Modificare ...
* [ ] (P)...


#### - Scadenze

* Stato/note :  / 10%
* Nome Oggetto :
* API model :   .. Filtro fisso :

* [ ] Filtro Base = ???
* [ ] Filtri Avanzata: ???
* [ ] Ricerca : 
* [ ] (R)Visualizzare Pagamento
    [ ] Nr Documento
* [ ] (C)Crea a mano DA QUI O PROCESSO A PARTE . ?
* [ ] (U)Modificare ...
* [ ] (P)...

##  9 Produzione

#### - Ordine di Produzione

* Stato/note :  / 10%
* Nome Oggetto :
* API model :   .. Filtro fisso :

* [ ] Filtro Base = ???
* [ ] Filtri Avanzata: ???
* [ ] Ricerca : 
* [ ] (R)Visualizzare Pagamento
    [ ] Nr Documento
* [ ] (C)Crea a mano DA QUI O PROCESSO A PARTE . ?
* [ ] (U)Modificare ...
* [ ] (P)...
#### - Prelievo da Ord. di Prod.

* Stato/note :  / 10%
* Nome Oggetto :
* API model :   .. Filtro fisso :

* [ ] Filtro Base = ???
* [ ] Filtri Avanzata: ???
* [ ] Ricerca : 
* [ ] (R)Visualizzare Pagamento
    [ ] Nr Documento
* [ ] (C)Crea a mano DA QUI O PROCESSO A PARTE . ?
* [ ] (U)Modificare ...
* [ ] (P)...
#### - Dich. di Prod.

* Stato/note :  / 10%
* Nome Oggetto :
* API model :   .. Filtro fisso :

* [ ] Filtro Base = ???
* [ ] Filtri Avanzata: ???
* [ ] Ricerca : 
* [ ] (R)Visualizzare Pagamento
    [ ] Nr Documento
* [ ] (C)Crea a mano DA QUI O PROCESSO A PARTE . ?
* [ ] (U)Modificare ...
* [ ] (P)...
#### - Prelievo e Dichi.di Prod.

* Stato/note :  / 10%
* Nome Oggetto :
* API model :   .. Filtro fisso :

* [ ] Filtro Base = ???
* [ ] Filtri Avanzata: ???
* [ ] Ricerca : 
* [ ] (R)Visualizzare Pagamento
    [ ] Nr Documento
* [ ] (C)Crea a mano DA QUI O PROCESSO A PARTE . ?
* [ ] (U)Modificare ...
* [ ] (P)...
#### - Avanzamento di Produzione

* Stato/note :  / 10%
* Nome Oggetto :
* API model :   .. Filtro fisso :

* [ ] Filtro Base = ???
* [ ] Filtri Avanzata: ???
* [ ] Ricerca : 
* [ ] (R)Visualizzare Pagamento
    [ ] Nr Documento
* [ ] (C)Crea a mano DA QUI O PROCESSO A PARTE . ?
* [ ] (U)Modificare ...
* [ ] (P)...

##  10 Contabilità 

* Nome Oggetto : Finance
#### - Fattura di Acquisto

* Stato/note :  / 10%
* Nome Oggetto :
* API model :   .. Filtro fisso :

* [ ] Filtro Base = ???
* [ ] Filtri Avanzata: ???
* [ ] Ricerca : 
* [ ] (R)Visualizzare Pagamento
    [ ] Nr Documento
* [ ] (C)Crea a mano DA QUI O PROCESSO A PARTE . ?
* [ ] (U)Modificare ...
* [ ] (P)...


#### - Fattura di Vendita

* Stato/note :  / 10%
* Nome Oggetto :
* API model :   .. Filtro fisso :

* [ ] Filtro Base = ???
* [ ] Filtri Avanzata: ???
* [ ] Ricerca : 
* [ ] (R)Visualizzare Pagamento
    [ ] Nr Documento
* [ ] (C)Crea a mano DA QUI O PROCESSO A PARTE . ?
* [ ] (U)Modificare ...
* [ ] (P)...
#### - Incassi e Pagamenti  (in scadenza / tutti ?)

* Stato/note : / 10%
* Nome Oggetto :
* API model :   .. Filtro fisso :

* [ ] Filtro Base = ???
* [ ] Filtri Avanzata: ???
* [ ] Ricerca : 
* [ ] (R)Visualizzare Pagamento
    [ ] Nr Documento
* [ ] (C)Crea a mano DA QUI O PROCESSO A PARTE . ?
* [ ] (U)Modificare ...
* [ ] (P)...
#### - Partite Aperte

* Stato/note :  / 10%
* Nome Oggetto :
* API model :   .. Filtro fisso :

* [ ] Filtro Base = ???
* [ ] Filtri Avanzata: ???
* [ ] Ricerca : 
* [ ] (R)Visualizzare Pagamento
    [ ] Nr Documento
* [ ] (C)Crea a mano DA QUI O PROCESSO A PARTE . ?
* [ ] (U)Modificare ...
* [ ] (P)...
#### - Movimenti Bancari

* Stato/note :  / 10%
* Nome Oggetto :
* API model :   .. Filtro fisso :

* [ ] Filtro Base = ???
* [ ] Filtri Avanzata: ???
* [ ] Ricerca : 
* [ ] (R)Visualizzare Pagamento
    [ ] Nr Documento
* [ ] (C)Crea a mano DA QUI O PROCESSO A PARTE . ?
* [ ] (U)Modificare ...
* [ ] (P)...
#### - Cash Flow

* Stato/note :  / 10%
* Nome Oggetto :
* API model :   .. Filtro fisso :

* [ ] Filtro Base = ???
* [ ] Filtri Avanzata: ???
 * [ ] Ricerca : 
* [ ] (R)Visualizzare Pagamento
    [ ] Nr Documento
* [ ] (C)Crea a mano DA QUI O PROCESSO A PARTE . ?
* [ ] (U)Modificare ...
* [ ] (P)...

## 11 Risorse Umane
* Stato/note : Definito / 10%
* Nome Oggetto : HR


#### - Ritardi e Assenze [TBD]

* Stato/note :  / 10%
* Nome Oggetto : VISTA !!!
* API model :   .. Filtro fisso :

* [ ] Filtro Base = ???
* [ ] Filtri Avanzata: ???
* [ ] Ricerca : 
* [ ] (R)Visualizzare Pagamento
    [ ] Nr Documento
* [ ] (C)Crea a mano DA QUI O PROCESSO A PARTE . ?
* [ ] (U)Modificare ...
* [ ] (P)...


#### - Chat [TBD]

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
* [ ] Ricerca : 
* [ ] (R)Visualizzare Pagamento
    [ ] Nr Documento
* [ ] (C)Crea a mano DA QUI O PROCESSO A PARTE . ?
* [ ] (U)Modificare ...
* [ ] (P)...


#### - Scheda Dipendente

* Nome Oggetto : Employee
* API model :   Profilemployee Filtro fisso :

* [ ] Filtro Base = ???
* [ ] Filtri Avanzata: ???
* [ ] Ricerca : 
* [ ] (R)Visualizzare Pagamento
    [ ] Nr Documento
* [ ] (C)Crea a mano DA QUI O PROCESSO A PARTE . ?
* [ ] (U)Modificare ...
* [ ] (P)...


#### - Dotazione Dipendente

* Nome Oggetto :
* API model :   .. Filtro fisso :

* [ ] Filtro Base = ???
* [ ] Filtri Avanzata: ???
* [ ] Ricerca : 
* [ ] (R)Visualizzare Pagamento
    [ ] Nr Documento
* [ ] (C)Crea a mano DA QUI O PROCESSO A PARTE . ?
* [ ] (U)Modificare ...
* [ ] (P)...
#### - Bacheca ( aziendale, ufficio/report , personale)

* Nome Oggetto :
* API model :   .. Filtro fisso :

* [ ] Filtro Base = ???
* [ ] Filtri Avanzata: ???
* [ ] Ricerca : 
* [ ] (R)Visualizzare Pagamento
    [ ] Nr Documento
* [ ] (C)Crea a mano DA QUI O PROCESSO A PARTE . ?
* [ ] (U)Modificare ...
* [ ] (P)...
#### - Ricerca personale (assunzione, curriculum )

* Nome Oggetto : ad_user!
* API model :   .. Filtro fisso :

* [ ] Filtro Base = ???
* [ ] Filtri Avanzata: ???
* [ ] Ricerca : 
* [ ] (R)Visualizzare Pagamento
    [ ] Nr Documento
* [ ] (C)Crea a mano DA QUI O PROCESSO A PARTE . ?
* [ ] (U)Modificare ...
* [ ] (P)...
## 12 Dipendente

#### - Bacheca Personale

!!!

* Stato/note :  / 10%
* Nome Oggetto :tbd
* API model :   .. Filtro fisso :

* [ ] Filtro Base = ???
* [ ] Filtri Avanzata: ???
* [ ] Ricerca : 
* [ ] (R)Visualizzare Pagamento
    [ ] Nr Documento
* [ ] (C)Crea a mano DA QUI O PROCESSO A PARTE . ?
* [ ] (U)Modificare ...
* [ ] (P)...

#### - Timbracartellino (Qrcode, GPS,Foto)


* Stato/note :  / 10%
* Nome Oggetto :
* API model :   .. Filtro fisso :

* [ ] Filtro Base = ???
* [ ] Filtri Avanzata: ???
* [ ] Ricerca : 
* [ ] (R)Visualizzare Pagamento
    [ ] Nr Documento
* [ ] (C)Crea a mano DA QUI O PROCESSO A PARTE . ?
* [ ] (U)Modificare ...
* [ ] (P)...
#### - Richiesta Permesso / Ferie /Malattia

!! Definire tabelle/maschere su idempiere !!!!!!!!!!!!!!!!!!!

* Stato/note :  / 10%
* Nome Oggetto :
* API model :   .. Filtro fisso :

* [ ] Filtro Base = ???
* [ ] Filtri Avanzata: ???
* [ ] Ricerca : 
* [ ] (R)Visualizzare Pagamento
    [ ] Nr Documento
* [ ] (C)Crea a mano DA QUI O PROCESSO A PARTE . ?
* [ ] (U)Modificare ...
* [ ] (P)...
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
* [ ] Ricerca : 
* [ ] (R)Visualizzare Pagamento
    [ ] Nr Documento
* [ ] (C)Crea a mano DA QUI O PROCESSO A PARTE . ?
* [ ] (U)Modificare ...
* [ ] (P)...

## 13 Punto Vendita

#### Ordine da PV (CRUD)
* Stato/note : 
* Nome Oggetto : MOrderPO
* API model :   lit_c_order Filtro fisso : issotrx=N
* (copy from c_order )

* [ ] Filtro Base = Bozza/InCompletamento - Completati last 7 days
* [ ] Filtri Avanzata: TBD
* [ ] Ricerca : Documentno,
* [ ] (R)Visualizzare Ordine Mobile
    [ ] Nr Documento
    [ ] Rappresentate/Operatore=LoginUser
    [ ] Tipo Documento = Ordine di acquisto
    [ ] Stato del Documento
    [ ] data Ordine
    [ ] Date Prevosta Consegna
    [ ] Totale Ordine
* [ ] Linea
*   [ ] Prodotto
*   [ ] Qtà
*   [ ] Udm
*   [ ] Prezzo
*   [ ] Sconto
* [ ] (C)Crea 
* [ ] (U)Modificare ...
* [ ] (P) Complete Ordine 
* [ ] Stampa ?

#### Trasferimento PV
* Stato/note : DA DEFINIRE  / 10%
* Nome Oggetto :
* API model :   .. Filtro fisso :

* [ ] Filtro Base = ???
* [ ] Filtri Avanzata: ???
  Formazione/Documenti ( documenti, Video x tutti / ufficio / ruolo )
* [ ] Ricerca : 
* [ ] (R)Visualizzare Pagamento
    [ ] Nr Documento
* [ ] (C)Crea a mano DA QUI O PROCESSO A PARTE . ?
* [ ] (U)Modificare ...
* [ ] (P)...
#### Consumo PV
* Stato/note : DA DEFINIRE  / 10%
* Nome Oggetto :
* API model :   .. Filtro fisso :

* [ ] Filtro Base = ???
* [ ] Filtri Avanzata: ???
  Formazione/Documenti ( documenti, Video x tutti / ufficio / ruolo )
* [ ] Ricerca : 
* [ ] (R)Visualizzare Pagamento
    [ ] Nr Documento
* [ ] (C)Crea a mano DA QUI O PROCESSO A PARTE . ?
* [ ] (U)Modificare ...
* [ ] (P)...
* [ ] #### Consumo PV
* Stato/note : DA DEFINIRE  / 10%
* Nome Oggetto :
* API model :   .. Filtro fisso :

#### Reso Fornitore

* [ ] Filtro Base = ???
* [ ] Filtri Avanzata: ???
  Formazione/Documenti ( documenti, Video x tutti / ufficio / ruolo )
* [ ] Ricerca : 
* [ ] (R)Visualizzare Pagamento
    [ ] Nr Documento
* [ ] (C)Crea a mano DA QUI O PROCESSO A PARTE . ?
* [ ] (U)Modificare ...
* [ ] (P)...
## 99 Setup e Opzioni

#### - Opzioni Server (Client)

!! Fare maschera su idempiere come Parametrizzazione Azienda

* Nome Oggetto : Server Option
* API model :  Filtro fisso :
  da 1-30 Y/N moduli (Crm,Vendite,...)
  ismobileenable =Y/M
************************
---D=0001=1
--U-=0010=2
--UD=0011=3
-R--=0100=4
-R-D=0101=5
-RU-=0110=6
-RUD=0111=7
C---=1000=8
C--D=1001=9
C-U-=1010=A
C-UD=1011=B
CR--=1100=C
CR-D=1101=D
CRU-=1110=E
CRUD=1111=F 
***********************
---1 = Team 
--1- = All
0000=0   Solo Miei 
0001=1   Team + Miei
0010=2   All + Miei
0011=3   All + Team + Miei
0100=4   Complete + Miei
0101=5   Complete + Team + Miei
0110=6   Complete + All + Miei
0111=7   Complete + All + Team + Miei

************************
  1 Calendar 		    : F (CRUD)  
  2 Email    		    : F
  3 CRM*****************: 4 *** 1 CRM
  4 LEAD  		        : F3 
  5 Contatti    	    : F3
  6 Clienti		        : F3
  7 Task Lead(JPTODO)	: F3
  8 Opportunità 	    : F3
  9 Offerta di Vendita 	: F3
 10 Listino Prodotti	: 4
 11 Doc. di Trasporto   : F3
 12 Fatt.di Vendita 	: 4
 13 Incasso		        : F3
 14 Provvigione		    : 4
 15 ..			        : 0 
 16 ..			        : 0
 17 Ticket**************: 1 *** 2 Ticket 
 18 Ticketnew/Request	: F3
 19 TaskTodo		    : F3
 20 Ore			        : F3
 21 ..
 22 ..	
 23 Manut. Tecnico******: 1 *** 3 Man.Tecnico
 24 Cal. Tecnico        : F3
 25 Int. di manutenzione: F3
 26 Anomalia            : F3
 27 Magazino Furgone    : F
 28 Prelievo            : F 
 29 Carico/scarico      : F
 30 carico scheda tecnica
 31 ..
 32 ..
 33 Portale cliente*****: 1 *** 4 Portale Cliente
 -- sezione dashboard
 34 News                : R
 35 Fatture di Acquisto : R
 36 Indicatori          : 1
 37 Offerta di Vendita  : R
 -- sezione ticket
 38 Ticket              : F
 -- sezione contratto e manutenzione
 39 Contratto           : R
 40 Manutenzione        : R
 41 Anomalie            : R
 --- sezione formazione
 42 Corsi di Formazione : R 
 43 Corsisti e Attestati: R
 44 Proposta Nuovi Corsi: R
 45 
 46
 47
 48
 49
 50
 51
 52
 53 Formazione Corsita***: 1 *** 5 Formazione Corsista
 54 Presenza Corso       : F3
 55 Attestato
 56 
 57
 58
 59 Acquisti ************: 1 *** 6 Acquisti
 60 Lead Fornitore       : F
 61 Prodotto             : R
 62 Prodotti Sottoscarta : R
 63 
 64 Logistica ***********: 1 *** 7 Logistica
 65 Prodotto             : F
 67 Spedizione Prodotti  :
 68 Entrata Merci        :
 68 Trasferimento        :
 69 Consumo              :
 66 Inventario           :
 67
 68
 69 Mezzi ***************: 1 *** 8 Mezzi e Attrezzatura
 70 Mezzi
 71 Attrezzatura
 72 Presa in Carico/Spostamento
 73 Scadenze
 74
 75
 76 Prodzione*********** : 1 *** 9 Produzione
 77 Ordine di Prodzione
 78 Prelievo
 79 Dichiarazione di Produzione
 80 Preliveo e Dichiarazione
 81 Avanzamento di Produzione
 82
 83
 84 Contabilità********* : 1 *** 10 Contabilità
 85 Fatture di Acquisto
 86 Fatture di Vendita
 87 Incassi e Pagamenti
 88 Partite Aperte
 89 Movimenti Bancari
 90 Cash Flow
 91
 92
 93 Risorse Umane ****** : 1 *** 11 Risorse Umane
 94 Ritardi e Assenze 
 95 Chat
 96 Ticket HR
 97 Scheda Dipendente
 98 Dotazione Dipendente
 99 Bacheca 
 100 Ricerca Personale
 101
 102
 103
 104 Dipendente *******: 1 *** 12 Dipendente
 105 Bacheca Personale
 106 Timbracartellino 
 107 Richiesta Permesso
 108 Sondaggi
 109 Armadietto
 110
 111
 112 Punto Vendita *** : 1 **  13 Punto Vendita
 113 Ordine da PV
 114 Trasferimento PV
 115 Consumo PV
 116 Reso Fornitore
 117



#### - Opzioni Utente

* Stato/note :  / 10%
* Nome Oggetto : User Option
* API model :  ad_user Filtro fisso :
  1

{{% pageinfo %}} ##CRM {{% /pageinfo %}}

## Gestione Offline

Maschera per gestire le opzione di sincronizzione

* 
* Product/Prodotti [RU] No[CD]  [C_Product] (Filtro)
* Business Partner [RU] No[CD]  [C_BPartner] (Filtro : I Miei)
* WorkOrder/Odl di manutenzione [RU] [C?] NO[D] [MP_OT_V] (Filtro) (Da creare Marco)
*     Create : MP_Maintain_Resource
*     Create : MP_OT_Task
   ...a) Calendario (apertura)  // b) LISTA 
* Not Compliance/Anomalie - [LIT_NC] (Tabella da fare 2pack Marco)
* JP_TODO [RUCD]  (Filtro : Miei) 

-- Step 2
* Inventario 
* S/Carico  
* Sales Order/ Ordini di Vendita 


