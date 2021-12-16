---
title: "i-Smart iDempiere - Mobile  App "
date: 2020-04-24T22:47:10+02:00
draft: false
weight : 2500
pre: "<b>90. </b>"
---
# Progetto iDempiere Flutter 

#  Funzionalità da vedere

* [ ] Eseguire processo completa di idempiere APIREST
* [ ] Eseguire processo idempiere con parametri APIREST
* [ ] Calendario (vista giorno,week,mese,lista,)
    https://pub.dev/packages/syncfusion_flutter_calendar
* [ ] Invio Email vers base a) indirizzo test@test.it invia
      https://www.youtube.com/watch?v=yUeBPg8Z7I0
      https://www.youtube.com/watch?v=RDwst9icjAY

* [ ] Chat (wishing list)
* [ ] Attivare Acquisizione Fotocamera e allegare API REST 
   https://docs.flutter.dev/cookbook/plugins/picture-using-camera
* [ ] Allegare Documento (jpg,PDF) 
* [ ] Visualizzare Allegato (vedere ticket desktop app)
* [ ] Stampa report (da idempiere)  da vedere con AC (TOP)
* [ ] Stampa Diretta Bluetooth o IP (Step 2)
* [ ] Gestione Barcode QRcode (vedi processi produzione)
* [ ] Gestione NFC - Per segnare le ore ? - controllare plugin NFC 
      (in background ? )
* [ ] Notifiche    (vedere quello fatto con Vincenzo sulla Desktop APP )
* [ ] Gestione Lingua (step 2)
* [ ] Gestione Permessi 
* [ ] Sondaggi https://github.com/quickbirdstudios/survey_kit
 
## Login
* [ ] Logo App 
* [ ] Logo e Nome in alto a Sx
* [ ] Accesso via https
* [ ] Salvataggio Ruolo e login con solo ok se memorizzato password
* [ ] Non si visualizzano i Dati Server  
* [ ] Exit / Logout (step 2)


## Dashboard {#Dashnoard}
### Email/Notifiche
* [ ] Inbox Notifiche
   * [ ] Task / Lead Promeria / Notifica per Data/ora
* [ ] Impostare Letto
* [ ] Invia Messaggio 

### Calendario
* [ ] Calendario 
     - Task Lead
     - Task Business Partner


* [ ] ..
* [ ] ..
### Notifiche

### Bacheca
* [ ] Filtro fisso = user or team
* [ ] Filtri : Stato Lead
* [ ] Bacheca 
* [ ] Imposta "letto"

### BI Vendite
* [ ] Grafico Chart Fatturato 
* [ ] Grafico Chart 
### Prenotazione Risorse Aziendali 
* [ ] Elenco Risorse Aziendali [libere/tutte]
* [ ] Prenota Risorsa (data, durata) / Libera Prenotazione
* [ ] Poke Risorsa occupata
  
## 1-CRM
....Select /Vista i dati Lead

### Lead 
* Stato/note : Definito / 50%  Edit in corso
* Nome Oggetto : leads   
* API window lead Filtro fisso = isactive='Y'
* [ ] Filtro Base = All Miei Team
* [ ] Filtri Avanzata: Stato Lead
* [x] Visualizzare(Nome,Telefono,Email,Stato del Lead,Agente,Nome del BP)
* -Lista Agente : select name from ad_user where c_bpartner is not null and il BP is salesrep
* [ ] Creare,Modificare(Tutti) 
* [ ] Caricare da Contatto
* [ ] Eseguire Telefonata ( step 1)
* [ ] Invio Email (Step 2)
* [ ] Scarica Lead come Contatto Telefono,
* [ ] Crea Task Lead, (Step 2)
* [ ] Crea Opportunità Lead (Se BP completo) (Step 2)
* [ ] Mostra Task da fare (Step 2)
* [ ] Mostra Task eseguiti (Step 2)
* [ ] Mostra Opportunità - Vai a
* [ ] Mostra Offerte - Vai a (Step 2)
* [ ] Invio Msg Telegram (Step 3)
* [ ] Invio Msg SMS  (Step 3)
* [ ] Invio Msg Whatsapp

### Contatti BP (miei/tutti*)
* Stato/note : Definito / 10%  
* Nome Oggetto : contact
* API Window : Contact - Filtro fisso = isactive='Y'
* [ ] Filtro Base = Nessuno
* [ ] Filtri Avanzata: Nessuno
* [ ] Visualizzare : (Nome,Telefono,Email,Stato del Lead,Agente,Nome del BP)
* [ ] Creare (Assegnare BP), Modificare 
* [ ] Caricare da Contatto(Assegnare BP),
* [ ] Eseguire Telefonata,
* [ ] Invio Email
* [ ] Scarica come Contatto Telefono,
* [ ] Crea Task Business Partner,
* [ ] Crea Opportunità Business Partner 
* [ ] Mostra Task da fare
* [ ] Mostra Task eseguiti
* [ ] Mostra Opportunità - Vai a
* [ ] Mostra Offerte - Vai a 
* [ ] Invio Msg Telegram
* [ ] Invio Msg SMS
* [ ] Invio Msg Whatsapp

### Clienti BP
* Stato/note : Definito / 10%  
* Nome Oggetto : BusinessPartner
* API Window : businesspartner - Filtro fisso : C_Bpartner_id not null and islead='N' isactive='Y'
* [ ] Filtro Base = All Miei(agente=user)
* [ ] Filtri Avanzata: Gruppo Business Partner or Categoria BP
* [ ] Visualizzare BP (Nome,indirizzo(isbillto),Telefono,Email,Agente)
* [ ] Creare,Modificare BP(Nome,indirizzo, Telefono,email,Agente)
* [ ] Visualizzazione Contatti Vai a Contatti
* [ ] Crea Task  Business Partner
* [ ] Crea Opportunità  Business Partner
* [ ] Mostra Opportunità - Vai a
* [ ] Mostra Offerte - Vai a 

### Task Lead / BP
* Stato/note : Definito / 10%  
* Nome Oggetto : Task
* API window : Contact Activity - Filtro fisso : EndDate is null isactive='Y'
* [ ] Filtro Base = All miei Team
* [ ] Filtri Avanzata: Stato
* [ ] Visualizzare Task (Descrizione,Stato,Priorita,Tipoattività,DataInizio,;Salesrep,iscomplete
* [ ] Creare,Modificare (tutto)
* [ ] Impostare Y su iscomplete
* [ ] Se Lead Telefonare
* [ ] Invio Email 
* [ ] Promeria / Notifica per Data/ora
  
### Opportunità Lead  
* Stato/note : Definito / 10%  
* Nome Oggetto : Opportunity
* API window : Opportunity  Filtro fisso : isactive='Y'
* [ ] Filtro Base =All Miei Team
* [ ] Filtri Avanzata: Stao
* [ ] Visualizzare Opportunità (NrDocumento,Business Partner,Agente,Stato,Importo,Descrizione,Prodotto)
* [ ] Crea, Modificare (tutto)
* [ ] Crea Task 

### Offerta/Ordine di Vendita
* Stato/note : Definito / 10%  
* Nome Oggetto : Offer
* API window Sales Order  Filtro fisso :  isactive='Y'
* [ ] Filtro Base = All Miei Team
* [ ] Filtri Avanzata: ???
* [ ] Visualizzare Offerta (Nrdocumento,Business Partner,Data Ordine,Tipo Documento,Agente,Metodo di Pagemento,Termine di Pagamento)
* [ ] Visualizzare Righe Offerta(Prodotto,Descrizione,um,qty,prezzo listino,prezzo,sconto,iva)
* [ ] Crea, Modificare (tutto)
* [ ] Completare Offerta
* [ ] Riaprire Offerta
* [ ] Inviare Email con template email 

### Listino Prodotti
* Stato/note : Definito / 10%  
* Nome Oggetto : ProductPrice
* API model  : m_product  Filtro fisso : isactive='Y'  listino(vedi opzioni)
* [ ] Filtro Base = Categoria Prodotto
* [ ] Filtri Avanzata: Categoria Merceologica
* [ ] Visualizzare Prodotti ( Immagine, Value,name,descrizione,Prezzo,Giacenza)
* [ ]Visualizzare Righe Offerta(Prodotto,Descrizione,um,qty,prezzo listino,prezzo,sconto,iva)
* [ ] Crea, Modificare (tutto)
  
### Fatture di Vendita (miei/tutti*) (idem vendita)
* Stato/note : Definito / 10%  
* Nome Oggetto : InvoiceCustomer
* API window : invoicecustomer  Filtro fisso : isactive=Y 
* 
* [ ] Filtro Base = Stato documento
* [ ] Filtri Avanzata: 
* [ ] * [ ] Visualizzare Prodotti ( Immagine, Value,name,descrizione,Prezzo,Giacenza)
* [ ]Visualizzare Righe Offerta(Prodotto,Descrizione,um,qty,prezzo listino,prezzo,sconto,iva)

### Incasso / Pagamento (miei/tutti*)  (idem vendita)
* Stato/note : Definito / 10%  
* Nome Oggetto :
* API model :   .. Filtro fisso : 
* [ ] Filtro Base = ???
* [ ] Filtri Avanzata: ???

### Provvigione
* Stato/note : Definito / 10%  
* Nome Oggetto :
* API model :   .. Filtro fisso : 
* [ ] Filtro Base = ???
* [ ] Filtri Avanzata: ???

## 2 Vendite 
### Contatti BP (miei/tutti*)
 .. vedi Lead
### Clienti BP
 .. vedi Lead
### Offerta/Ordini di Vendita (miei/Team)
 .. vedi Lead
### Listino Prodotti/Prezzi
 .. vedi Lead
### Documento di Trasporto (miei/Team)
* Stato/note : Definito / 10%  
* Nome Oggetto :
* API model :   .. Filtro fisso : 
* [ ] Filtro Base = ???
* [ ] Filtri Avanzata: ???
  
### Fatture di Vendita (miei/Team)
 .. vedi Lead
### Incasso (miei/tutti*) (miei/Team) 
 .. vedi Lead

## 3-Ticket Task e Ore

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

## 4 Manutenzione Tecnico
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
* Nome Oggetto : 
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
  
## {{%expand"5 Manutenzione Portale"%}}
### - Dashboard Portale (no a menu)
* Stato/note : Definito / 10%  
* Nome Oggetto : tbd
* API model :   .. Filtro fisso : 
* [ ] Filtro Base = ???
* [ ] Filtri Avanzata: ???
#### - News  (Promo) (no a menu)
* Stato/note : Definito / 10%  
* Nome Oggetto :
* API model :   .. Filtro fisso : 
* [ ] Filtro Base = ???
* [ ] Filtri Avanzata: ???
#### - Fatture di Acquisto (Pagamento)
* Stato/note : Definito / 10%  
* Nome Oggetto :
* API model :   .. Filtro fisso : 
* [ ] Filtro Base = ???
* [ ] Filtri Avanzata: ???
#### - Indicatori ( Ultima visita / Prossima Visita)/anomalie) 
* Stato/note : Definito / 10%  
* Nome Oggetto :
* API model :   .. Filtro fisso : 
* [ ] Filtro Base = ???
* [ ] Filtri Avanzata: ???
### Offerte di Vendita (aperte/tutte)
* Stato/note : Definito / 10%  
* Nome Oggetto :
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
* Stato/note : Definito / 10%  
* Nome Oggetto :
* API model :   .. Filtro fisso : 
* [ ] Filtro Base = ???
* [ ] Filtri Avanzata: ???
 {{% /expand%}}


## {{%expand"6 Formazione"%}}
#### - Contratto di Formazione
* Stato/note : Definito / 10%  
* Nome Oggetto :
* API model :   .. Filtro fisso : 
* [ ] Filtro Base = ???
* [ ] Filtri Avanzata: ???
#### - Corsi di Formazione
* Stato/note :  / 10%  
* Nome Oggetto :
* API model :   .. Filtro fisso : 
* [ ] Filtro Base = ???
* [ ] Filtri Avanzata: ???
 {{% /expand%}}

## {{%expand"7 Formazione Portale"%}}
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

## {{%expand"8 Formazione Corsista"%}}
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

## {{%expand"9 Acquisti "%}}
#### - Lead Fornitore
* Stato/note :  / 10%  
* Nome Oggetto :
* API model :   .. Filtro fisso : 
* [ ] Filtro Base = ???
* [ ] Filtri Avanzata: ???
#### - Prodotto / Giacenza / Prezzi Acquisto
* Stato/note : Definito / 10%  
* Nome Oggetto :
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

## {{%expand"10  Logistica"%}}
#### - Prodotto / Giacenza
* Stato/note :  / 10%  
* Nome Oggetto :
* API model :   .. Filtro fisso : 
* [ ] Filtro Base = ???
* [ ] Filtri Avanzata: ???
#### - Inventario 
* Stato/note :  / 10%  
* Nome Oggetto :
* API model :   .. Filtro fisso : 
* [ ] Filtro Base = ???
* [ ] Filtri Avanzata: ???
#### - Spedizione Prodotti
* Stato/note : Definito / 10%  
* Nome Oggetto :
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
* Nome Oggetto :
* API model :   .. Filtro fisso : 
* [ ] Filtro Base = ???
* [ ] Filtri Avanzata: ???
    {{% /expand%}}

## {{%expand"11 Mezzi e Attrezzature"%}}
#### - Anagrafica Mezzi
* Stato/note :  / 10%  
* Nome Oggetto :
* API model :   .. Filtro fisso : 
* [ ] Filtro Base = ???
* [ ] Filtri Avanzata: ???
#### - Anagrafica Attrezzatura
* Stato/note :  / 10%  
* Nome Oggetto :
* API model :   .. Filtro fisso : 
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

## {{%expand"12 Produzione "%}}
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

## {{%expand"13 Contabilità "%}}
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

## {{%expand"14 Risorse Umane"%}}

### Responsabile 
* Stato/note :  / 10%  
* Nome Oggetto :
* API model :   .. Filtro fisso : 
* [ ] Filtro Base = ???
* [ ] Filtri Avanzata: ???
#### - Ritardi e Assenze
* Stato/note :  / 10%  
* Nome Oggetto :
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
* Nome Oggetto :
* API model :   .. Filtro fisso : 
* [ ] Filtro Base = ???
* [ ] Filtri Avanzata: ???
#### - Scheda Dipendente
* Nome Oggetto :
* API model :   .. Filtro fisso : 
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
* Nome Oggetto :
* API model :   .. Filtro fisso : 
* [ ] Filtro Base = ???
* [ ] Filtri Avanzata: ???

### Dipendente 
#### - Bacheca Personale
* Stato/note :  / 10%  
* Nome Oggetto :
* API model :   .. Filtro fisso : 
* [ ] Filtro Base = ???
* [ ] Filtri Avanzata: ???
#### - Timbracartellino (Qrcode, GPS,Foto)
* Stato/note :  / 10%  
* Nome Oggetto :
* API model :   .. Filtro fisso : 
* [ ] Filtro Base = ???
* [ ] Filtri Avanzata: ???
  
#### - Richiesta Permesso / Ferie /Malattia
* Stato/note :  / 10%  
* Nome Oggetto :
* API model :   .. Filtro fisso : 
* [ ] Filtro Base = ???
* [ ] Filtri Avanzata: ???
* [ ] 
#### - Sondaggi (light)
* how to https://github.com/quickbirdstudios/survey_kit
* Stato/note : DA DEFINIRE / 10%  
* Nome Oggetto :
* API model :   .. Filtro fisso : 
* [ ] Filtro Base = ???
* [ ] Filtri Avanzata: ???
* [ ] 
#### - Armadietto (busta paga)
* Stato/note : DA DEFINIRE  / 10%  
* Nome Oggetto : 
* API model :   .. Filtro fisso : 
* [ ] Filtro Base = ???
* [ ] Filtri Avanzata: ???
Formazione/Documenti ( documenti, Video x tutti / ufficio / ruolo )
 {{% /expand%}}

## 99 Setup e Opzioni
#### - Opzioni Server (Client)
* Stato/note :  / 10%  
* Nome Oggetto : Server Option 
* API model :  Filtro fisso : 
da 1-30 Y/N moduli (Crm,Vendite,...)
31 Accesso record ALL Y/N
- Listino Base : 1000023
-  
#### - Opzioni Utente
* Stato/note :  / 10%  
* Nome Oggetto : User Option
* API model :  ad_user Filtro fisso : 
- 


{{% pageinfo %}} ##CRM {{% /pageinfo %}}
