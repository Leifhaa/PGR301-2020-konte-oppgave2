# Konteeksamen 2020 PGR301

## Hvordan levere

Besvarelsen skal bestå av et dokument med følgende opplysninger

- Lenke til en fork  du lager av https://github.com/PGR301-2020/konte 
- Lenke til ditt eget repository du lager i oppgave 2

I din fork kan du slette denne README filen og erstatte den med din egen.

## Oppgave 1 - Docker 

I din fork av https://github.com/PGR301-2020/konte. Se i mappen *oppgave1-docker*

Her finner du en Spring Boot applikasjon som er satt opp som en veldig enkel HTTP server.
Når en nettleser åpne http://localhost:9999/ vil index.html som ligger i denne mappen 
vises og vise "Hello World".

### Oppgave A

Du skal skrive en Dockerfile som lager et Docker Container image av Spring Boot appen. 
Sensor vil *kun* gjøre følgede kommando fra denne mappen for å teste, altså ikke bygge applikasjonen med maven først.


```bash
docker build . --tag konte
```

### Oppgave B

Beskriv hvilken kommando ```docker run ... ``` sensor må skrive inn i terminalen sin for å starte en container fra det nyeste container image som er laget. 

På lokal  maskin skal applikasjonen lytte på port 8080. Spring Boot applikasjonen skal fortsatt lytte på 9999. 

Som du sikkert vil legge merke til, så vil du få en "404 not found" når du kjører applikasjonen i container. Forklar hvorfor dette skjer i README, 

Gjør nødvendige endringer i applikasjonen og Dockerfile for å fikse problemet. 

# Oppgave 2- GCP og Terraform

Før du starter på oppgaven, sørg for å ha Gloud SDK og Terraform innstalert. 

Nyttige lenker

* https://www.terraform.io/downloads.html
* https://cloud.google.com/sdk/docs/install

Oppgave

* Lag et nytt repository.
* Lag en ny mappe som heter "init"

I init-mappen skal du skrive nødvendig terraformkode for å lage en Google Cloud Storage *Bucket* som du i neste oppgave skal bruke til å lagre state for Terraform/Travis.

Viktig, Navn på bucket skal ikke hardkodes i terraform-filene men settes fra en terraform variabel deklarert slik

```hcl-terraform

variable "bucket_name" {
}

```

Denne variabelen skal få sin verdi fra en miljøvariabel satt med ```export XYZ_```(linux/mac) eller ```set XYZ```(windows). 

* I readme skal du beskrive hvordan sensor skal sette denne variabelen.
* I Readme: beskriv hva sensor må gjøre for å kunne bruke sin egen Service Account og GCP nøkkel-fil i Json format.

Sensor vi i denne oppgaven 

* Lage en fork av ditt repository
* Selv installere og konfigurere Gloud SDK og Terraform. (Gcloud init osv)
* Gjøre nødvendige endringer i filer i følge instruksjoner du har gitt i README
* Sette miljøvariabel for bucket navn i henhold til din README
* Kjøre ```terraform init ; terradform apply``` i init mappen. 
* Sensor sjekker at en bucket blir opprettet i sin GCP konto 
   
# Oppgave 3 - Travis Terraform pipeline 

I denne oppgaven skal du lage en Travis pipeline for infrastrukturkode som kan provisjonere GCP ressurser med Terraform. 

Prosjektet skal bruke bucket fra oppgave 2 som "backend" for state. Pipeline skal bruke ressurstypen 

```
resource "google_compute_instance" "name" {
}
```

For å provisjonere en virtuell server. (se https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_instance)

Travis pipeline skal 

- Installere Gcloud SDK 
- Autentisere seg mot Google Cloud Platform med en Service Account. 
- Sette et GCloud prosjekt 
- Laste ned,pakke ut og installere terraform slik at Travis kan kjøre Terraformkode
- Kjøre terraformkode i repositoryiet 

Viktig

* Travis skal bare gjøre kjøre påendringer i main/master branch 
* Verdien *machine_type* for terraform ressursen *google_compute_instance* skal settes fra en environmentvariabel satt i Travis. Se hva Sensor vil gjøre i beskrivelsen under
* Hint: Å lage en ny compute instance kan kreve at du legger på roller til Service Account i forhold til det vi har gjort i semesteret.

Sensor vil i denne oppgaven

- Lage en fork av ditt repository 
- Sjekke din README for å se hvilke hemmeligheter som må settes med travis encrypt, og travis encrypt-file - og følge 
andre instruksjoner. Det er viktig at README i repository forklarer på en god måte hva sensor må gjøre for å kunne bruke sin egen Google konto.  
- Sensor setter en environment variabel for Travisbygget  
 ```
travis env set TF_ENV_machine_type f1-micro --public
```
- Starte et bygg av main/master og sjekke at Travis kjører Terraform 
- Gjøre en edring på infrastruktor kode, på en annen branch. Sjekke at Travis ikke kjører Terraform

Lykke til !
