-- Mock data per sviluppo (non caricare in produzione)

--la password per gli utenti di test è: password123
INSERT INTO users (username, email, password_hash) VALUES (
    'testuser',
    'test@example.com',
    '$2b$12$DKwi5hPYq.C3XTWDaI265ezVG4K3XElwqqKAZOJJdugHq2NkI6DpS'
),
(
    'testuser2',
    'test2@example.com',
    '$2b$12$DKwi5hPYq.C3XTWDaI265ezVG4K3XElwqqKAZOJJdugHq2NkI6DpS'
);


INSERT INTO articles (title, content, author_id, tags) VALUES
(
    'Introduzione a pgvector',
    'pgvector è un''estensione PostgreSQL che aggiunge il supporto per vettori ad alta dimensionalità. Permette di eseguire ricerche di similarità coseno e distanza euclidea direttamente nel database, eliminando la necessità di sistemi esterni come Pinecone o Weaviate.',
    1,
    ARRAY['postgresql', 'vector', 'ai']
),
(
    'FastAPI e SQLAlchemy',
    'FastAPI si integra con SQLAlchemy tramite il pattern Depends() per la gestione delle sessioni. Il generator get_db() garantisce che la sessione venga chiusa correttamente anche in caso di eccezione, evitando connection leak nel pool.',
    1,
    ARRAY['python', 'fastapi', 'sqlalchemy']
),
(
    'Embedding e ricerca semantica',
    'La ricerca semantica supera i limiti della ricerca full-text tradizionale. Invece di cercare parole chiave esatte, converte testi in vettori numerici (embedding) che catturano il significato. Due frasi semanticamente simili avranno vettori vicini nello spazio vettoriale.',
    1,
    ARRAY['ai', 'embedding', 'nlp', 'vector']
),
(
    'Articolo di testuser2',
    'Questo articolo appartiene a testuser2 e non dovrebbe essere cancellabile da testuser.',
    2,
    ARRAY['test', 'autorizzazione']
);

  -- Articoli aggiuntivi per test semantico

  INSERT INTO articles (title, content, author_id, tags) VALUES

  -- AI / Machine Learning (11 aggiuntivi)
  (
      'Reti neurali convoluzionali',
      'Le CNN sono architetture neurali specializzate nell''elaborazione di immagini. I layer
  convoluzionali applicano filtri che imparano a riconoscere feature locali come bordi e texture,
  riducendo il numero di parametri rispetto a reti fully-connected. Sono alla base di sistemi come
   ResNet e EfficientNet.',
      1,
      ARRAY['ai', 'deep-learning', 'cnn']
  ),
  (
      'Transformer e meccanismo di attenzione',
      'L''architettura Transformer introdotta nel 2017 ha rivoluzionato il NLP. Il meccanismo di
  self-attention permette al modello di pesare l''importanza di ogni token rispetto agli altri,
  catturando dipendenze a lungo raggio nel testo. È alla base di GPT, BERT e di tutti i moderni
  LLM.',
      1,
      ARRAY['ai', 'nlp', 'transformer', 'llm']
  ),
  (
      'Fine-tuning di modelli LLM',
      'Il fine-tuning adatta un modello pre-addestrato su un dominio specifico. Tecniche come LoRA
   permettono di aggiornare solo una frazione dei parametri, riducendo la memoria GPU necessaria.
  È utile quando si vuole specializzare un modello su un dominio tecnico come il codice o la
  medicina.',
      1,
      ARRAY['ai', 'llm', 'fine-tuning']
  ),
  (
      'RAG - Retrieval Augmented Generation',
      'RAG combina ricerca su knowledge base esterna e generazione di testo da LLM. Il sistema
  recupera documenti rilevanti alla query e li include nel contesto del modello, riducendo le
  allucinazioni. È la tecnica alla base di sistemi come NotebookLM e Perplexity.',
      1,
      ARRAY['ai', 'rag', 'llm', 'retrieval']
  ),
  (
      'Ollama - modelli LLM in locale',
      'Ollama permette di eseguire modelli LLM in locale senza dipendenze cloud. Supporta modelli
  come LLaMA, Mistral e nomic-embed-text per gli embedding. L''API è compatibile con lo stile
  OpenAI, facilitando la migrazione da provider cloud a deployment on-premise.',
      1,
      ARRAY['ai', 'ollama', 'llm', 'local']
  ),
  (
      'Overfitting e tecniche di regolarizzazione',
      'L''overfitting si verifica quando un modello memorizza i dati di training invece di
  generalizzare. Le tecniche per combatterlo includono dropout, L1/L2 regularization, early
  stopping e data augmentation. Un buon validation set è fondamentale per rilevare l''overfitting
  prima del deploy.',
      1,
      ARRAY['ai', 'machine-learning', 'regularization']
  ),
  (
      'Metriche di valutazione per modelli ML',
      'La scelta della metrica dipende dal problema. Per classificazione si usano precision,
  recall e F1-score. In contesti sbilanciati come fraud detection, l''accuracy è fuorviante: un
  modello che predice sempre negativo raggiunge il 99% di accuracy ma è inutile.',
      1,
      ARRAY['ai', 'machine-learning', 'metrics']
  ),
  (
      'Transfer learning',
      'Il transfer learning riutilizza un modello pre-addestrato su un task per risolverne un
  altro correlato. In computer vision si usano reti pre-addestrate su ImageNet come feature
  extractor. In NLP, modelli come BERT vengono fine-tuned su task specifici con dataset molto più
  piccoli.',
      1,
      ARRAY['ai', 'transfer-learning', 'deep-learning']
  ),
  (
      'K-means clustering',
      'K-means partiziona i dati in K gruppi assegnando ogni punto al centroide più vicino e
  ricalcolando iterativamente i centroidi. La scelta di K si determina con il metodo del gomito o
  la silhouette score. È utile per segmentazione clienti e anomaly detection.',
      1,
      ARRAY['ai', 'machine-learning', 'clustering']
  ),
  (
      'Gradient descent e backpropagation',
      'Il gradient descent ottimizza i parametri di una rete neurale minimizzando la loss
  function. La backpropagation calcola il gradiente della loss rispetto a ogni peso tramite la
  chain rule propagando l''errore all''indietro. Varianti come Adam adattano il learning rate per
  ogni parametro.',
      1,
      ARRAY['ai', 'deep-learning', 'optimization']
  ),
  (
      'Reinforcement learning',
      'Il reinforcement learning addestra un agente a prendere decisioni in un ambiente per
  massimizzare una ricompensa cumulativa. L''agente impara per tentativi ed errori senza esempi
  etichettati. È alla base di AlphaGo e dell''RLHF usato per allineare gli LLM.',
      1,
      ARRAY['ai', 'reinforcement-learning', 'rl']
  ),

  -- Oracle / Retail / XStore
  (
      'Oracle XStore POS - architettura generale',
      'Oracle XStore è un sistema POS enterprise per il retail. L''architettura è client-server
  con un database locale Derby per la modalità offline e sincronizzazione con il database centrale
   Oracle. I componenti principali sono XAdmin per la configurazione, XStore per le operazioni di
  cassa e XCenter per la comunicazione con l''HQ.',
      1,
      ARRAY['oracle', 'xstore', 'pos', 'retail']
  ),
  (
      'XStore - modalità offline',
      'XStore supporta la modalità offline per garantire continuità operativa in caso di
  interruzione della connessione al server centrale. Le transazioni vengono salvate nel database
  Derby locale e sincronizzate con l''HQ al ripristino della connessione. La configurazione del
  timeout e delle politiche di retry è critica per evitare perdita di dati.',
      1,
      ARRAY['oracle', 'xstore', 'offline', 'retail']
  ),
  (
      'Oracle Retail - struttura del database',
      'Il database Oracle Retail usa uno schema centralizzato con tabelle per negozi, articoli,
  transazioni e clienti. I moduli principali sono RMS per l''assortimento, RTM per le transazioni
  e RCM per la gestione clienti. L''integrazione tra i moduli avviene tramite batch notturni e
  messaggi JMS.',
      1,
      ARRAY['oracle', 'retail', 'database', 'rms']
  ),
  (
      'XStore - gestione transazioni di vendita',
      'Una transazione XStore è composta da header, righe articolo, pagamenti e tasse. Il ciclo di
   vita passa per stati: OPEN, SUSPENDED, COMPLETED, VOIDED. I problemi più comuni sono le
  transazioni bloccate in stato SUSPENDED per timeout e le discrepanze di cassa per interruzioni
  durante il pagamento.',
      1,
      ARRAY['oracle', 'xstore', 'transazioni', 'retail']
  ),
  (
      'Configurazione stampanti fiscali in XStore',
      'XStore supporta diverse stampanti fiscali tramite driver configurabili in XAdmin. La
  configurazione richiede il mapping tra il codice reparto XStore e i reparti fiscali della
  stampante. I problemi più frequenti sono il disallineamento dei contatori fiscali dopo un reset
  e la gestione dei documenti commerciali vs fiscali.',
      1,
      ARRAY['oracle', 'xstore', 'stampante-fiscale', 'retail']
  ),
  (
      'Oracle Retail Merchandising System - RMS',
      'RMS è il core di Oracle Retail per la gestione dell''assortimento. Gestisce la gerarchia
  merceologica, i listini prezzi, le offerte promozionali e il riordino automatico.
  L''integrazione con XStore avviene tramite file di download giornalieri che aggiornano articoli
  e prezzi nei negozi.',
      1,
      ARRAY['oracle', 'retail', 'rms', 'merchandising']
  ),
  (
      'Gestione inventario in Oracle Retail SIM',
      'Oracle Retail Store Inventory Management gestisce le movimentazioni di magazzino in
  negozio. Le operazioni principali sono ricevimento merce, trasferimenti tra negozi, rettifiche
  inventario e inventario fisico. La quadratura con il sistema contabile avviene tramite
  interfaccia verso Oracle Financials.',
      1,
      ARRAY['oracle', 'retail', 'sim', 'inventario']
  ),
  (
      'XStore - gestione resi',
      'I resi in XStore possono essere con scontrino (return with receipt) o senza (blind return).
   Con scontrino il sistema richiama la transazione originale e riversa gli articoli. Senza
  scontrino si applica la politica configurata in XAdmin, che può prevedere rimborsi su gift card
  invece che in contanti.',
      1,
      ARRAY['oracle', 'xstore', 'resi', 'retail']
  ),
  (
      'Oracle Retail Price Management - RPM',
      'RPM gestisce le strategie di pricing nel retail Oracle. Supporta prezzi base, prezzi
  promozionali, clearance pricing e price override in cassa. Le regole di pricing hanno una
  gerarchia di priorità e scadenze temporali. L''integrazione con XStore avviene tramite il
  download dei price event.',
      1,
      ARRAY['oracle', 'retail', 'rpm', 'pricing']
  ),
  (
      'XStore - procedura di fine giornata',
      'L''end of day chiude i turni di cassa, calcola i totali per metodo di pagamento e invia le
  transazioni all''HQ tramite XCenter. I problemi più comuni sono EOD bloccati per transazioni
  aperte e discrepanze nei totali per articoli con tasse speciali. Il log di XCenter è
  fondamentale per il troubleshooting.',
      1,
      ARRAY['oracle', 'xstore', 'eod', 'retail']
  ),
  (
      'XStore - configurazione metodi di pagamento',
      'XStore supporta pagamenti con contanti, carte di credito tramite POS esterno, gift card,
  voucher e pagamenti misti. La configurazione del tender type in XAdmin include limiti per
  transazione, valute accettate e regole di arrotondamento. L''integrazione con i terminali POS
  avviene tramite protocollo IPC o OPI.',
      1,
      ARRAY['oracle', 'xstore', 'pagamenti', 'retail']
  ),
  (
      'XStore - log e troubleshooting',
      'XStore genera log su più livelli: applicativo log4j, database locale Derby e log di
  sistema. I file principali sono xstore.log per le operazioni di cassa e xcenter.log per la
  comunicazione con l''HQ. La sequenza di analisi è: verifica stato servizi, analisi log
  applicativi, verifica connettività database.',
      1,
      ARRAY['oracle', 'xstore', 'log', 'troubleshooting']
  ),
  (
      'Oracle Retail Order Management System',
      'OMS gestisce gli ordini omnicanale coordinando vendite in negozio, e-commerce e call
  center. Supporta scenari come click-and-collect, ship-from-store e return-anywhere.
  L''integrazione con XStore permette al cassiere di visualizzare e gestire gli ordini
  direttamente dalla cassa.',
      1,
      ARRAY['oracle', 'retail', 'oms', 'omnichannel']
  ),
  (
      'XAdmin - configurazione negozio',
      'XAdmin è il tool di configurazione centralizzata di XStore. Gestisce la struttura del
  negozio (registri, drawer, stampanti), i parametri operativi e le politiche di vendita. Le
  modifiche vengono distribuite ai negozi tramite download automatico. La gestione delle versioni
  di configurazione è critica in ambienti multi-negozio.',
      1,
      ARRAY['oracle', 'xstore', 'xadmin', 'configurazione']
  ),
  (
      'Oracle XStore - gestione operatori e turni',
      'XStore gestisce gli operatori tramite profili con permessi granulari configurati in XAdmin.
   Il sistema di timekeeping registra entrate, uscite e pause. I ruoli tipici sono cashier,
  supervisor e manager, con livelli di override differenti per operazioni sensibili come sconti,
  annulli e resi senza scontrino.',
      1,
      ARRAY['oracle', 'xstore', 'operatori', 'retail']
  ),

  -- Linux / Sysadmin
  (
      'Gestione processi in Linux',
      'In Linux ogni processo ha un PID univoco e un PPID che identifica il processo padre. I
  comandi principali sono ps aux per listare i processi, kill per inviare segnali e nice/renice
  per modificare la priorità. SIGTERM (15) è il segnale di terminazione graceful, SIGKILL (9)
  forza la terminazione immediata senza pulizia.',
      1,
      ARRAY['linux', 'processi', 'sysadmin']
  ),
  (
      'Filesystem Linux - struttura FHS',
      'Il Filesystem Hierarchy Standard definisce la struttura delle directory in Linux. Le
  directory principali sono /etc per i file di configurazione, /var per i dati variabili come log
  e spool, /usr per i programmi e /proc come filesystem virtuale per le informazioni sui
  processi.',
      1,
      ARRAY['linux', 'filesystem', 'fhs', 'sysadmin']
  ),
  (
      'Systemd - gestione dei servizi',
      'Systemd è il sistema di init e service manager delle distribuzioni Linux moderne. I comandi
   principali sono systemctl start/stop/restart/status per gestire i servizi e systemctl
  enable/disable per la partenza automatica al boot. I file di unit sono in /etc/systemd/system/ e
   /usr/lib/systemd/system/.',
      1,
      ARRAY['linux', 'systemd', 'servizi', 'sysadmin']
  ),
  (
      'Cron job e automazione in Linux',
      'Cron è il daemon per la pianificazione di task periodici. La sintassi del crontab è: minuto
   ora giorno mese giorno_settimana comando. Ogni utente ha il proprio crontab (crontab -e),
  mentre /etc/cron.d/ contiene i crontab di sistema. Systemd timer è l''alternativa moderna con
  dipendenze e logging integrato.',
      1,
      ARRAY['linux', 'cron', 'automazione', 'sysadmin']
  ),
  (
      'SSH - configurazione e hardening',
      'Le best practice di hardening SSH includono: disabilitare il login root (PermitRootLogin
  no), usare autenticazione a chiave pubblica, cambiare la porta default e usare AllowUsers per
  limitare gli utenti abilitati. fail2ban aggiunge protezione contro brute force bloccando gli IP
  dopo troppi tentativi falliti.',
      1,
      ARRAY['linux', 'ssh', 'security', 'sysadmin']
  ),
  (
      'Gestione utenti e gruppi in Linux',
      'Gli utenti Linux sono definiti in /etc/passwd con UID, GID, home directory e shell. Le
  password hashate sono in /etc/shadow. I comandi principali sono useradd, usermod, userdel per
  gli utenti e groupadd, groupmod per i gruppi. sudo permette l''esecuzione di comandi con
  privilegi elevati tramite /etc/sudoers.',
      1,
      ARRAY['linux', 'utenti', 'gruppi', 'sysadmin']
  ),
  (
      'LVM - Logical Volume Manager',
      'LVM aggiunge un layer di astrazione tra i dischi fisici e il filesystem. I Physical Volume
  sono i dischi, raggruppati in Volume Group. Da un VG si creano Logical Volume ridimensionabili a
   caldo. LVM permette snapshot consistenti per i backup e la migrazione dei dati tra dischi senza
   downtime.',
      1,
      ARRAY['linux', 'lvm', 'storage', 'sysadmin']
  ),
  (
      'Firewall con iptables e nftables',
      'iptables è il firewall tradizionale di Linux basato su netfilter. Le regole sono
  organizzate in tabelle (filter, nat, mangle) e catene (INPUT, OUTPUT, FORWARD). nftables è il
  successore moderno con sintassi unificata e migliori performance. ufw e firewalld sono frontend
  che semplificano la gestione delle regole.',
      1,
      ARRAY['linux', 'firewall', 'iptables', 'security']
  ),
  (
      'Monitoring con top, htop e iostat',
      'top e htop mostrano in tempo reale l''utilizzo di CPU e memoria per processo. iostat mostra
   le statistiche di I/O per disco. vmstat fornisce statistiche su memoria, swap, I/O e CPU. Per
  il monitoring storico, sar registra le metriche di sistema a intervalli configurabili tramite il
   pacchetto sysstat.',
      1,
      ARRAY['linux', 'monitoring', 'performance', 'sysadmin']
  ),
  (
      'Backup con rsync',
      'rsync è lo strumento standard per la sincronizzazione e il backup incrementale in Linux.
  Trasferisce solo le differenze tra sorgente e destinazione, riducendo il traffico di rete.
  L''opzione --delete rimuove i file cancellati dalla sorgente. Con SSH come transport layer,
  rsync è sicuro anche su reti non affidabili.',
      1,
      ARRAY['linux', 'backup', 'rsync', 'sysadmin']
  ),
  (
      'Gestione pacchetti - pacman e apt',
      'pacman è il package manager di Arch Linux: pacman -S per installare, pacman -R per
  rimuovere, pacman -Syu per aggiornare il sistema. apt è il package manager di Debian/Ubuntu.
  Entrambi gestiscono le dipendenze automaticamente e verificano l''integrità dei pacchetti
  tramite firma digitale.',
      1,
      ARRAY['linux', 'pacman', 'apt', 'pacchetti']
  ),
  (
      'Log di sistema con journalctl',
      'journalctl è il tool per consultare il log centralizzato di systemd. I filtri principali
  sono -u per filtrare per servizio, -f per il follow in tempo reale e --since/--until per range
  temporali. I log sono strutturati e persistono tra i reboot in /var/log/journal/.',
      1,
      ARRAY['linux', 'log', 'journalctl', 'sysadmin']
  ),
  (
      'Mount e fstab in Linux',
      'Il file /etc/fstab definisce i filesystem montati automaticamente al boot, con colonne per
  dispositivo, mount point, tipo filesystem, opzioni, dump e fsck order. Con UUID invece del nome
  dispositivo si evitano problemi di riordino dei dischi al reboot. Il comando mount -a rilegge
  fstab senza riavviare.',
      1,
      ARRAY['linux', 'mount', 'fstab', 'filesystem']
  ),
  (
      'Shell scripting Bash',
      'Bash è la shell di default nella maggior parte delle distribuzioni Linux. Uno script inizia
   con lo shebang #!/bin/bash. Le strutture principali sono: variabili, condizionali
  (if/elif/else), cicli (for/while), funzioni e gestione degli errori con set -e. I parametri
  posizionali $1, $2 ricevono gli argomenti da riga di comando.',
      1,
      ARRAY['linux', 'bash', 'scripting', 'automazione']
  ),
  (
      'Tuning del kernel con sysctl',
      'sysctl permette di modificare i parametri del kernel Linux a runtime senza riavvio. I
  parametri principali per le performance sono vm.swappiness, net.core.somaxconn e fs.file-max. Le
   modifiche permanenti vanno in /etc/sysctl.conf o /etc/sysctl.d/. sysctl -p ricarica la
  configurazione senza reboot.',
      1,
      ARRAY['linux', 'kernel', 'sysctl', 'tuning']
  ),

  -- Architettura software
  (
      'Pattern Repository',
      'Il pattern Repository astrae il layer di accesso ai dati, separando la logica di business
  dalla persistenza. Il repository espone metodi come find(), save(), delete() senza esporre i
  dettagli dell''ORM o del database. Questo facilita il testing tramite mock del repository e
  permette di cambiare database senza toccare la business logic.',
      1,
      ARRAY['architettura', 'pattern', 'repository', 'design-pattern']
  ),
  (
      'CQRS - Command Query Responsibility Segregation',
      'CQRS separa le operazioni di scrittura (Command) da quelle di lettura (Query) usando
  modelli distinti. Il lato Command valida e applica le modifiche allo stato, il lato Query
  ottimizza la lettura con proiezioni denormalizzate. Particolarmente utile in sistemi ad alto
  carico dove read e write hanno requisiti molto diversi.',
      1,
      ARRAY['architettura', 'cqrs', 'pattern', 'distributed']
  ),
  (
      'Event Sourcing',
      'Event Sourcing persiste lo stato dell''applicazione come sequenza di eventi immutabili
  invece di salvare lo stato corrente. Lo stato attuale si ricostruisce riproducendo gli eventi
  dall''inizio. Permette audit trail completo e proiezioni multiple dallo stesso stream di eventi.
   Spesso combinato con CQRS.',
      1,
      ARRAY['architettura', 'event-sourcing', 'pattern', 'events']
  ),
  (
      'Microservizi vs architettura monolitica',
      'I microservizi decompongono un''applicazione in servizi indipendenti deployabili
  separatamente, con ownership dei dati isolata per servizio. Il vantaggio è la scalabilità
  indipendente e la resilienza ai guasti. Lo svantaggio è la complessità operativa: service
  discovery, comunicazione distribuita e tracing.',
      1,
      ARRAY['architettura', 'microservizi', 'monolite', 'distributed']
  ),
  (
      'API Gateway',
      'L''API Gateway è il punto di ingresso unico per i client di un''architettura a
  microservizi. Gestisce autenticazione, rate limiting, routing verso i servizi interni e
  aggregazione di risposte. Soluzioni comuni sono Kong, AWS API Gateway e Nginx. Evita che ogni
  servizio reimplementi le stesse funzionalità trasversali.',
      1,
      ARRAY['architettura', 'api-gateway', 'microservizi', 'pattern']
  ),
  (
      'Circuit Breaker pattern',
      'Il Circuit Breaker previene le chiamate a un servizio degradato, proteggendo il sistema da
  cascading failure. Ha tre stati: CLOSED (normale), OPEN (blocca le chiamate dopo N errori) e
  HALF-OPEN (testa se il servizio è tornato disponibile). Resilience4j è l''implementazione più
  diffusa in Java.',
      1,
      ARRAY['architettura', 'circuit-breaker', 'resilience', 'pattern']
  ),
  (
      'Dependency Injection',
      'La Dependency Injection inverte il controllo della creazione delle dipendenze: invece di
  crearle internamente, un oggetto le riceve dall''esterno. Migliora la testabilità (si iniettano
  mock) e il disaccoppiamento. Spring, FastAPI Depends() e Angular sono framework che usano DI
  nativamente.',
      1,
      ARRAY['architettura', 'dependency-injection', 'pattern', 'design-pattern']
  ),
  (
      'Domain Driven Design - DDD',
      'DDD mette al centro il dominio di business. I concetti chiave sono: Ubiquitous Language
  (vocabolario condiviso tra dev e business), Bounded Context (confini espliciti del modello),
  Aggregate (cluster di entità con un root) e Domain Event. È un approccio alla progettazione più
  che un pattern specifico.',
      1,
      ARRAY['architettura', 'ddd', 'domain-driven-design', 'pattern']
  ),
  (
      'Clean Architecture',
      'Clean Architecture di Robert Martin organizza il codice in cerchi concentrici: Entities
  (regole di business core), Use Cases (flussi applicativi), Interface Adapters e
  Frameworks/Drivers. La Dependency Rule impone che le dipendenze puntino sempre verso il centro,
  mai verso l''esterno.',
      1,
      ARRAY['architettura', 'clean-architecture', 'pattern', 'solid']
  ),
  (
      'Pattern Saga per transazioni distribuite',
      'Il pattern Saga gestisce le transazioni distribuite in architetture a microservizi dove non
   è possibile usare transazioni ACID classiche. Una saga è una sequenza di transazioni locali
  collegate da eventi. In caso di fallimento vengono eseguite compensating transaction per
  annullare i passi precedenti.',
      1,
      ARRAY['architettura', 'saga', 'transazioni', 'distributed']
  ),
  (
      'Service Mesh',
      'Un Service Mesh gestisce la comunicazione service-to-service tramite proxy sidecar (Envoy).
   Offre load balancing, circuit breaking, mutual TLS, retry automatici e distributed tracing
  senza modificare il codice applicativo. Istio e Linkerd sono le implementazioni più diffuse.',
      1,
      ARRAY['architettura', 'service-mesh', 'microservizi', 'istio']
  ),
  (
      'Twelve-Factor App',
      'Twelve-Factor è una metodologia per costruire applicazioni SaaS scalabili. I fattori chiave
   sono: configurazione in variabili d''ambiente, processi stateless, dipendenze dichiarate
  esplicitamente e log come stream di eventi. È la base concettuale del deployment su piattaforme
  cloud come Heroku e Railway.',
      1,
      ARRAY['architettura', 'twelve-factor', 'cloud', 'best-practice']
  ),
  (
      'Pattern Outbox per messaggi garantiti',
      'Il pattern Outbox garantisce la consistenza tra una transazione database e la pubblicazione
   di un messaggio su un message broker. L''evento viene salvato in una tabella outbox nella
  stessa transazione del dato, poi un processo separato lo pubblica. Elimina il problema del
  dual-write senza transazioni distribuite.',
      1,
      ARRAY['architettura', 'outbox', 'messaging', 'pattern']
  ),
  (
      'Pattern Observer e Pub/Sub',
      'Il pattern Observer definisce una dipendenza uno-a-molti: quando un oggetto cambia stato,
  tutti gli osservatori vengono notificati. Pub/Sub è la versione distribuita con un broker tra
  publisher e subscriber. Kafka, RabbitMQ e Redis Pub/Sub sono implementazioni comuni in
  architetture event-driven.',
      1,
      ARRAY['architettura', 'observer', 'pubsub', 'events']
  ),
  (
      'Strangler Fig pattern',
      'Lo Strangler Fig è un pattern di migrazione incrementale da un sistema legacy a uno nuovo.
  Il nuovo sistema viene costruito attorno al legacy intercettando gradualmente le chiamate. Il
  legacy viene dismesso lentamente senza big bang rewrite, riducendo il rischio della
  migrazione.',
      1,
      ARRAY['architettura', 'strangler-fig', 'migrazione', 'legacy']
  ),

  -- SQL / Database generale
  (
      'Indici B-tree e hash in PostgreSQL',
      'L''indice B-tree è il tipo default in PostgreSQL, ottimale per query con operatori di
  confronto (=, <, >, BETWEEN, LIKE con prefisso). L''indice hash è più veloce per sole
  uguaglianze ma non supporta range query. Gli indici rallentano le scritture: vanno creati solo
  sulle colonne effettivamente usate nelle query.',
      1,
      ARRAY['sql', 'postgresql', 'indici', 'performance']
  ),
  (
      'EXPLAIN e analisi del query plan',
      'EXPLAIN mostra il piano di esecuzione scelto dal query planner senza eseguire la query.
  EXPLAIN ANALYZE esegue la query e mostra i tempi reali. I nodi da monitorare sono Seq Scan su
  tabelle grandi (segnala indice mancante), nested loop su dataset grandi e sort su colonne non
  indicizzate.',
      1,
      ARRAY['sql', 'postgresql', 'explain', 'performance']
  ),
  (
      'Transazioni ACID',
      'Le proprietà ACID garantiscono la consistenza dei dati. Atomicità: tutto o niente.
  Consistenza: il database passa da uno stato valido a un altro. Isolamento: le transazioni
  concorrenti non si interferiscono. Durabilità: una transazione committed sopravvive ai crash.
  PostgreSQL implementa l''isolamento tramite MVCC.',
      1,
      ARRAY['sql', 'acid', 'transazioni', 'database']
  ),
  (
      'Normalizzazione - forme normali',
      'La normalizzazione riduce la ridondanza nei database relazionali. La 1NF elimina i gruppi
  ripetuti. La 2NF rimuove le dipendenze parziali dalla chiave primaria. La 3NF elimina le
  dipendenze transitive. In pratica, la denormalizzazione controllata è spesso necessaria per le
  performance in sistemi OLAP.',
      1,
      ARRAY['sql', 'normalizzazione', 'database', 'teoria']
  ),
  (
      'JOIN in SQL - tipi e differenze',
      'INNER JOIN restituisce solo le righe con corrispondenza in entrambe le tabelle. LEFT JOIN
  include tutte le righe della tabella sinistra anche senza corrispondenza. FULL OUTER JOIN
  include tutte le righe di entrambe le tabelle. CROSS JOIN produce il prodotto cartesiano. I JOIN
   su colonne indicizzate vengono ottimizzati automaticamente.',
      1,
      ARRAY['sql', 'join', 'database', 'query']
  ),
  (
      'Window functions avanzate in SQL',
      'Le window function calcolano valori su un insieme di righe senza collassarle. LEAD() e
  LAG() accedono alle righe successive e precedenti nella finestra. SUM() OVER (PARTITION BY ...
  ORDER BY ...) calcola totali cumulativi per gruppo. Sono molto usate in analisi e reporting.',
      1,
      ARRAY['sql', 'window-functions', 'analisi', 'postgresql']
  ),
  (
      'Stored procedures e functions in PostgreSQL',
      'In PostgreSQL le funzioni (CREATE FUNCTION) ritornano un valore e possono essere usate
  nelle query. Le stored procedure (CREATE PROCEDURE, introdotte in PG 11) supportano il controllo
   esplicito delle transazioni con COMMIT e ROLLBACK. PL/pgSQL è il linguaggio procedurale
  nativo.',
      1,
      ARRAY['sql', 'postgresql', 'stored-procedure', 'plpgsql']
  ),
  (
      'Partitioning delle tabelle in PostgreSQL',
      'Il partitioning suddivide una tabella grande in partizioni più piccole. PostgreSQL supporta
   partitioning per range, per lista e per hash. Le query con filtri sulla colonna di partizione
  accedono solo alle partizioni rilevanti (partition pruning), migliorando drasticamente le
  performance su tabelle molto grandi.',
      1,
      ARRAY['sql', 'postgresql', 'partitioning', 'performance']
  ),
  (
      'Deadlock e gestione dei lock',
      'Un deadlock si verifica quando due transazioni si aspettano a vicenda per rilasciare un
  lock. PostgreSQL rileva automaticamente i deadlock e termina una delle transazioni. Per
  prevenirli: acquisire i lock sempre nello stesso ordine, usare transazioni brevi e SELECT FOR
  UPDATE per dichiarare l''intenzione di modificare.',
      1,
      ARRAY['sql', 'postgresql', 'deadlock', 'concorrenza']
  ),
  (
      'Connection pooling con PgBouncer',
      'PostgreSQL crea un processo per ogni connessione client, rendendo costoso gestire migliaia
  di connessioni. PgBouncer mantiene un pool di connessioni aperte al database e le riusa tra i
  client. Le modalità sono session pooling, transaction pooling (più efficiente) e statement
  pooling.',
      1,
      ARRAY['sql', 'postgresql', 'pgbouncer', 'performance']
  ),
  (
      'Replication in PostgreSQL',
      'PostgreSQL supporta la streaming replication per creare repliche in hot standby. Il primary
   invia i WAL alle repliche in tempo reale. La replica può essere sincrona (committed solo dopo
  ack) o asincrona (default, più performante). Le repliche possono essere usate per le query di
  sola lettura.',
      1,
      ARRAY['sql', 'postgresql', 'replication', 'ha']
  ),
  (
      'Backup e restore in PostgreSQL',
      'pg_dump crea un backup logico di un singolo database in formato SQL o custom. pg_basebackup
   crea un backup fisico dell''intero cluster. Per il point-in-time recovery si combinano
  pg_basebackup e l''archiviazione continua dei WAL. Il restore si fa con pg_restore o psql.',
      1,
      ARRAY['sql', 'postgresql', 'backup', 'recovery']
  ),
  (
      'VACUUM e autovacuum in PostgreSQL',
      'PostgreSQL usa MVCC: le righe aggiornate o cancellate vengono marcate come dead tuples
  invece di essere rimosse immediatamente. VACUUM recupera lo spazio occupato. VACUUM FULL
  compatta la tabella ma richiede un lock esclusivo. Autovacuum esegue VACUUM automaticamente in
  background.',
      1,
      ARRAY['sql', 'postgresql', 'vacuum', 'maintenance']
  ),
  (
      'Indici parziali e indici composti',
      'Un indice parziale include solo le righe che soddisfano una condizione WHERE, riducendo le
  dimensioni dell''indice. Un indice composto copre più colonne: l''ordine delle colonne è critico
   perché l''indice può essere usato solo per prefissi della sequenza di colonne definita.',
      1,
      ARRAY['sql', 'postgresql', 'indici', 'optimization']
  ),
  (
      'CTE ricorsive in SQL',
      'Le CTE ricorsive permettono di interrogare strutture gerarchiche come alberi e grafi. La
  sintassi usa WITH RECURSIVE con un termine base e un termine ricorsivo uniti da UNION ALL. Un
  esempio tipico è la navigazione di categorie merceologiche o organigrammi. Richiedono sempre una
   condizione di terminazione.',
      1,
      ARRAY['sql', 'cte', 'ricorsive', 'postgresql']
  ),

  -- Hardware
  (
      'Architettura CPU - pipeline e superscalarità',
      'La pipeline della CPU suddivide l''esecuzione di un''istruzione in stadi (fetch, decode,
  execute, writeback), permettendo l''esecuzione parallela di più istruzioni. Le CPU superscalari
  hanno più unità di esecuzione parallele. La branch prediction riduce i costi dei salti
  condizionali mal predetti.',
      1,
      ARRAY['hardware', 'cpu', 'architettura', 'pipeline']
  ),
  (
      'Cache CPU - L1, L2, L3',
      'La gerarchia di cache riduce la latenza di accesso alla memoria. L1 (32-64KB per core) ha
  latenza di 4-5 cicli. L2 (256KB-1MB) ha latenza di 12 cicli. L3 (condivisa tra core, 8-64MB) ha
  latenza di 40-50 cicli. La RAM supera i 200 cicli. La cache miss è una delle principali cause di
   degrado delle performance.',
      1,
      ARRAY['hardware', 'cpu', 'cache', 'performance']
  ),
  (
      'RAM - DDR4 vs DDR5',
      'DDR5 raddoppia la larghezza di banda rispetto a DDR4 con velocità che partono da 4800 MT/s
  contro i 3200 MT/s di DDR4. DDR5 introduce ECC on-die e canali interni raddoppiati. La latenza
  assoluta di DDR5 è leggermente superiore a DDR4 alle stesse frequenze, ma il throughput
  complessivo è significativamente migliore.',
      1,
      ARRAY['hardware', 'ram', 'ddr4', 'ddr5']
  ),
  (
      'Storage - SSD NVMe vs SATA',
      'Gli SSD NVMe comunicano direttamente con la CPU tramite PCIe, raggiungendo velocità
  sequenziali di 5-7 GB/s (PCIe 4.0). Gli SSD SATA sono limitati dall''interfaccia a circa 550
  MB/s. Gli HDD rimangono economicamente vantaggiosi solo per storage a freddo ad alta capacità.',
      1,
      ARRAY['hardware', 'storage', 'ssd', 'nvme']
  ),
  (
      'RAID - livelli e caratteristiche',
      'RAID 0 (striping) migliora le performance ma senza ridondanza. RAID 1 (mirroring) duplica i
   dati su due dischi. RAID 5 usa la parità distribuita su 3+ dischi, tollerando il guasto di un
  disco. RAID 10 combina mirroring e striping per alta performance e ridondanza.',
      1,
      ARRAY['hardware', 'raid', 'storage', 'ridondanza']
  ),
  (
      'GPU - differenze con CPU e casi d''uso',
      'La GPU è ottimizzata per il parallelismo massivo: una RTX 4090 ha 16384 CUDA core contro
  gli 8-16 core di una CPU moderna. La CPU eccelle in task sequenziali con branch complexity; la
  GPU eccelle in operazioni parallele omogenee come moltiplicazioni di matrici per il deep
  learning.',
      1,
      ARRAY['hardware', 'gpu', 'cuda', 'parallel-computing']
  ),
  (
      'Alimentatori - efficienza e certificazione 80 Plus',
      'La certificazione 80 Plus garantisce un''efficienza minima dell''80% a diversi carichi. I
  livelli sono Bronze (82%), Gold (87%), Platinum (90%) e Titanium (92%). Per un server sempre
  acceso, la differenza tra Bronze e Platinum si traduce in centinaia di euro all''anno di costi
  energetici.',
      1,
      ARRAY['hardware', 'alimentatore', 'efficienza', 'server']
  ),
  (
      'Dissipazione termica - CPU cooling',
      'Il thermal design power indica la potenza termica che il sistema di raffreddamento deve
  smaltire. Il raffreddamento ad aria usa heatsink con heatpipe e ventole. Il raffreddamento a
  liquido è più efficiente ma più complesso. La pasta termica tra CPU e heatsink è critica: una
  stesura errata può aumentare la temperatura di 10-15°C.',
      1,
      ARRAY['hardware', 'cooling', 'dissipazione', 'termica']
  ),
  (
      'Schede madri - chipset e socket',
      'Il chipset determina le funzionalità supportate: numero di lane PCIe, porte USB, supporto
  overclock. Il socket definisce la compatibilità con i processori: AM5 per AMD Ryzen 7000,
  LGA1700 per Intel 12a/13a generazione. I chipset di fascia alta tipicamente supportano più
  generazioni di CPU.',
      1,
      ARRAY['hardware', 'scheda-madre', 'chipset', 'socket']
  ),
  (
      'PCIe - generazioni e compatibilità',
      'PCIe è l''interfaccia standard per GPU, SSD NVMe e schede di espansione. PCIe 4.0 raddoppia
   la banda di PCIe 3.0 (2 GB/s per lane vs 1 GB/s). PCIe 5.0 raddoppia nuovamente. L''interfaccia
   è backward compatible: una GPU PCIe 4.0 funziona in uno slot PCIe 3.0 a velocità ridotta.',
      1,
      ARRAY['hardware', 'pcie', 'interfaccia', 'compatibilita']
  ),
  (
      'UPS - protezione elettrica per server',
      'Un UPS protegge i server da interruzioni di corrente, sovratensioni e variazioni di
  frequenza. Gli UPS online (double conversion) rigenerano completamente l''alimentazione
  garantendo isolamento totale dalla rete. Il monitoraggio tramite SNMP permette lo shutdown
  graceful automatico in caso di blackout prolungato.',
      1,
      ARRAY['hardware', 'ups', 'server', 'power']
  ),
  (
      'Server rack e blade server',
      'I server rack sono misurati in unità U (1U = 44.45mm). I blade server concentrano più
  schede compute in un chassis condiviso con alimentazione e networking centralizzati, riducendo
  il cabling. I tower server sono adatti per ambienti senza rack ma sono meno scalabili.',
      1,
      ARRAY['hardware', 'server', 'rack', 'blade']
  ),
  (
      'Hypervisor tipo 1 e tipo 2',
      'Un hypervisor di tipo 1 gira direttamente sull''hardware senza OS sottostante: VMware ESXi,
   Microsoft Hyper-V, KVM. L''hypervisor di tipo 2 gira sopra un OS host: VirtualBox, VMware
  Workstation. Tipo 1 ha performance superiori ed è usato in produzione; tipo 2 è per sviluppo e
  test.',
      1,
      ARRAY['hardware', 'virtualizzazione', 'hypervisor', 'vmware']
  ),
  (
      'Troubleshooting hardware - POST e beep code',
      'Il POST viene eseguito dal BIOS/UEFI all''avvio e verifica CPU, RAM e dispositivi
  essenziali. In caso di errore emette beep code il cui significato varia per produttore. I
  problemi più comuni sono RAM non riconosciuta, GPU non rilevata per connettore PCIe mancante e
  CPU overheating.',
      1,
      ARRAY['hardware', 'troubleshooting', 'post', 'bios']
  ),
  (
      'Benchmark e stress test hardware',
      'I benchmark misurano le performance in condizioni controllate. Cinebench misura le
  performance CPU. CrystalDiskMark misura gli storage. Memtest86 testa l''integrità della RAM.
  Prime95 e FurMark sono stress test per CPU e GPU, utili per verificare la stabilità dopo
  overclock o modifiche al raffreddamento.',
      1,
      ARRAY['hardware', 'benchmark', 'stress-test', 'performance']
  ),

  -- Sistemi operativi
  (
      'Scheduler CPU - algoritmi di scheduling',
      'Lo scheduler CPU decide quale processo eseguire in ogni istante. Gli algoritmi principali
  sono Round Robin (ogni processo riceve un time slice) e CFS (Completely Fair Scheduler, default
  in Linux, distribuisce la CPU proporzionalmente ai pesi). Lo scheduling preemptivo interrompe i
  processi in esecuzione.',
      1,
      ARRAY['os', 'scheduler', 'cpu', 'processi']
  ),
  (
      'Memoria virtuale e paging',
      'La memoria virtuale crea l''illusione che ogni processo abbia un proprio spazio di
  indirizzamento continuo. Il paging suddivide la memoria fisica e virtuale in pagine di
  dimensione fissa (tipicamente 4KB). Un page fault si verifica quando una pagina richiesta non è
  in RAM e deve essere caricata dallo swap.',
      1,
      ARRAY['os', 'memoria-virtuale', 'paging', 'memoria']
  ),
  (
      'Deadlock nei sistemi operativi',
      'Un deadlock richiede quattro condizioni simultanee: mutua esclusione, hold and wait, no
  preemption e circular wait. Le strategie di gestione sono prevenzione, avoidance (algoritmo del
  banchiere) e detection con recovery. In pratica la maggior parte dei SO rileva e gestisce i
  deadlock invece di prevenirli.',
      1,
      ARRAY['os', 'deadlock', 'concorrenza', 'teoria']
  ),
  (
      'Filesystem con journaling',
      'Il journaling registra le modifiche al filesystem in un journal prima di applicarle,
  garantendo la consistenza dopo un crash. ext4, NTFS e XFS usano il journaling. Le modalità sono
  writeback (solo metadata), ordered (metadata dopo i dati, default ext4) e full journal (sia dati
   che metadata).',
      1,
      ARRAY['os', 'filesystem', 'journaling', 'storage']
  ),
  (
      'Interrupt e system call',
      'Le interrupt sono segnali hardware o software che interrompono l''esecuzione normale della
  CPU per gestire eventi asincroni. Le system call sono l''interfaccia tra i programmi in user
  space e il kernel: permettono operazioni privilegiate come I/O su file, allocazione di memoria e
   creazione di processi.',
      1,
      ARRAY['os', 'interrupt', 'system-call', 'kernel']
  ),
  (
      'Thread vs processi',
      'Un processo ha il proprio spazio di indirizzamento, risorse e file descriptor. I thread
  condividono lo spazio di indirizzamento del processo ma hanno stack e registri propri. I thread
  sono più leggeri da creare e la comunicazione tra thread è più veloce tramite memoria condivisa.
   Un crash di un thread può corrompere l''intero processo.',
      1,
      ARRAY['os', 'thread', 'processi', 'concorrenza']
  ),
  (
      'IPC - Inter Process Communication',
      'I meccanismi IPC permettono ai processi di comunicare. I principali sono: pipe
  (comunicazione unidirezionale), socket (locale o di rete), message queue (buffer asincrono),
  shared memory (la più veloce, richiede sincronizzazione esplicita) e signal (notifiche
  asincrone).',
      1,
      ARRAY['os', 'ipc', 'processi', 'comunicazione']
  ),
  (
      'Bootloader GRUB',
      'GRUB è il bootloader standard delle distribuzioni Linux. Il processo di boot è: BIOS/UEFI →
   MBR/EFI partition → GRUB → kernel → initramfs → systemd. GRUB permette di scegliere tra più
  kernel o sistemi operativi. La configurazione è in /etc/grub.d/ e viene compilata con
  grub-mkconfig.',
      1,
      ARRAY['os', 'grub', 'boot', 'linux']
  ),
  (
      'Kernel monolitico vs microkernel',
      'In un kernel monolitico (Linux, Windows) tutto gira in kernel space: driver, filesystem,
  networking. È più veloce ma meno isolato. In un microkernel (QNX) il kernel gestisce solo IPC e
  scheduling base, i driver girano in user space. L''isolamento migliora la stabilità ma introduce
   overhead di comunicazione.',
      1,
      ARRAY['os', 'kernel', 'monolitico', 'microkernel']
  ),
  (
      'Namespace e cgroups in Linux',
      'I namespace isolano le risorse di sistema per gruppo di processi: PID namespace, network
  namespace, mount namespace e user namespace. I cgroups limitano e misurano le risorse (CPU,
  memoria, I/O) di gruppi di processi. Namespace e cgroups insieme sono la base dei container
  Docker.',
      1,
      ARRAY['os', 'namespace', 'cgroups', 'container']
  ),
  (
      'Semafori e mutex',
      'Mutex garantisce che solo un thread alla volta esegua una sezione critica. Il semaforo è
  più generale: può permettere a N thread simultanei. Un semaforo binario è equivalente a un
  mutex. In Linux i futex implementano i mutex senza system call nel caso non conteso,
  minimizzando l''overhead.',
      1,
      ARRAY['os', 'semafori', 'mutex', 'concorrenza']
  ),
  (
      'Swap e gestione della memoria virtuale',
      'Lo swap è un''area su disco usata come estensione della RAM quando la memoria fisica è
  esaurita. vm.swappiness (0-100) controlla la propensione del kernel a usare lo swap: valori
  bassi privilegiano la RAM. Con SSD NVMe lo swap è tollerabile per workload moderati ma mai per
  database.',
      1,
      ARRAY['os', 'swap', 'memoria', 'linux']
  ),
  (
      'SELinux e AppArmor - MAC',
      'SELinux e AppArmor implementano il Mandatory Access Control come layer aggiuntivo oltre ai
  permessi UNIX tradizionali. SELinux usa label su ogni oggetto del filesystem e policy che
  definiscono gli accessi. AppArmor usa profili per applicazione più semplici da gestire. Red Hat
  usa SELinux, Ubuntu preferisce AppArmor.',
      1,
      ARRAY['os', 'selinux', 'apparmor', 'security']
  ),
  (
      'Container vs macchine virtuali',
      'I container condividono il kernel dell''host OS e usano namespace e cgroups per
  l''isolamento, risultando molto leggeri. Le VM hanno un kernel e OS completo virtualizzato,
  garantendo isolamento totale. I container sono più veloci da avviare e più efficienti in termini
   di risorse; le VM sono più sicure per workload con requisiti di isolamento stretti.',
      1,
      ARRAY['os', 'container', 'vm', 'docker']
  ),
  (
      'Gestione della memoria - allocatori',
      'L''allocatore di memoria gestisce l''heap del processo. malloc() in glibc usa pool di
  dimensioni fisse per allocazioni piccole e mmap() per quelle grandi. La frammentazione della
  memoria è il problema principale degli allocatori general-purpose. jemalloc e tcmalloc sono
  alternative ad alte performance usate in produzione.',
      1,
      ARRAY['os', 'memoria', 'allocatore', 'heap']
  ),

  -- Microsoft Windows
  (
      'Active Directory - struttura e componenti',
      'Active Directory è il servizio di directory Microsoft per la gestione centralizzata di
  utenti, computer e risorse di rete. La struttura gerarchica è Forest → Domain → Organizational
  Unit. I Domain Controller replicano il database AD tramite LDAP. I trust relationship permettono
   l''autenticazione tra domini diversi.',
      1,
      ARRAY['windows', 'active-directory', 'ad', 'ldap']
  ),
  (
      'Group Policy - GPO',
      'Le Group Policy Object definiscono configurazioni applicate automaticamente agli oggetti
  AD. Coprono sicurezza (password policy), software deployment e script di logon. L''ordine di
  applicazione è LSDOU: Local, Site, Domain, Organizational Unit. gpresult /R mostra le policy
  applicate a un computer.',
      1,
      ARRAY['windows', 'gpo', 'group-policy', 'active-directory']
  ),
  (
      'PowerShell scripting',
      'PowerShell è la shell e il linguaggio di scripting Microsoft basato su oggetti .NET. I
  cmdlet seguono la convenzione Verb-Noun (Get-Process, Set-Item, Remove-ADUser). La pipeline
  passa oggetti tra i comandi mantenendo i tipi. PowerShell Remoting (WinRM) permette
  l''esecuzione remota su più macchine.',
      1,
      ARRAY['windows', 'powershell', 'scripting', 'automazione']
  ),
  (
      'Windows Registry - struttura',
      'Il Registry è il database gerarchico di configurazione di Windows. Le hive principali sono
  HKEY_LOCAL_MACHINE (configurazione sistema) e HKEY_CURRENT_USER (configurazione utente
  corrente). regedit è il tool grafico; reg.exe e PowerShell permettono la gestione da riga di
  comando.',
      1,
      ARRAY['windows', 'registry', 'configurazione', 'windows-internals']
  ),
  (
      'Task Scheduler - automazione in Windows',
      'Il Task Scheduler pianifica l''esecuzione automatica di script e programmi. I trigger
  supportati sono: orario, evento del log di Windows, avvio e logon. schtasks.exe permette la
  gestione da riga di comando. Le task sono memorizzate come XML in C:\Windows\System32\Tasks.',
      1,
      ARRAY['windows', 'task-scheduler', 'automazione', 'schtasks']
  ),
  (
      'Windows Event Log',
      'Il Windows Event Log registra eventi di sistema, sicurezza e applicazione. Il log Security
  registra login, modifiche ai permessi e audit policy. Gli event ID più importanti per la
  sicurezza sono 4624 (login success), 4625 (login failure) e 4740 (account lockout). Get-WinEvent
   in PowerShell permette filtri avanzati.',
      1,
      ARRAY['windows', 'event-log', 'monitoring', 'security']
  ),
  (
      'IIS - Internet Information Services',
      'IIS è il web server Microsoft integrato in Windows Server. Supporta HTTP/HTTPS, FTP e
  WebSockets. La configurazione è in applicationHost.config. I componenti principali sono i siti
  (binding IP/porta/hostname), i pool di applicazioni (worker process isolati) e i moduli per
  autenticazione e URL rewrite.',
      1,
      ARRAY['windows', 'iis', 'web-server', 'windows-server']
  ),
  (
      'Windows Defender e sicurezza endpoint',
      'Windows Defender Antivirus è integrato in Windows 10/11 e Windows Server 2016+. Microsoft
  Defender for Endpoint aggiunge EDR con analisi comportamentale. Le policy di Defender si
  configurano tramite GPO o Intune. Windows Defender Firewall gestisce le regole per traffico in
  ingresso e uscita.',
      1,
      ARRAY['windows', 'defender', 'security', 'endpoint']
  ),
  (
      'Hyper-V - virtualizzazione Windows',
      'Hyper-V è l''hypervisor di tipo 1 di Microsoft, disponibile in Windows Server e Windows
  10/11 Pro. Le VM usano dischi virtuali in formato VHDX (fino a 64TB). Le funzionalità avanzate
  includono live migration senza downtime, replica e checkpoint. Le Generation 2 VM usano UEFI e
  supportano Secure Boot.',
      1,
      ARRAY['windows', 'hyper-v', 'virtualizzazione', 'windows-server']
  ),
  (
      'Windows Server Update Services - WSUS',
      'WSUS centralizza la distribuzione degli aggiornamenti Windows evitando che ogni client
  scarichi da Internet. Gli aggiornamenti vengono approvati manualmente o automaticamente per
  gruppi di computer. L''integrazione con GPO reindirizza i client al server WSUS. La manutenzione
   periodica è essenziale per le performance.',
      1,
      ARRAY['windows', 'wsus', 'aggiornamenti', 'windows-server']
  ),
  (
      'NTFS - permessi e ACL',
      'NTFS gestisce i permessi tramite Access Control List composte da Access Control Entry. I
  permessi principali sono Full Control, Modify, Read & Execute, Read e Write. I permessi si
  ereditano dalla cartella padre ma possono essere sovrascritti. icacls.exe e Set-Acl in
  PowerShell permettono la gestione da riga di comando.',
      1,
      ARRAY['windows', 'ntfs', 'permessi', 'acl']
  ),
  (
      'Remote Desktop Protocol - RDP',
      'RDP è il protocollo Microsoft per l''accesso remoto al desktop di Windows sulla porta TCP
  3389. Le best practice di sicurezza sono: cambiare la porta default, abilitare NLA (Network
  Level Authentication) e limitare gli utenti con accesso tramite GPO. Remote Desktop Gateway
  permette l''accesso RDP attraverso HTTPS.',
      1,
      ARRAY['windows', 'rdp', 'remote-desktop', 'security']
  ),
  (
      'Windows Server - ruoli e feature',
      'Windows Server organizza le funzionalità in ruoli (DNS, DHCP, AD DS, File Server, IIS) e
  feature (Failover Clustering, RSAT). Server Manager e PowerShell (Install-WindowsFeature)
  gestiscono l''installazione. Server Core è la versione senza GUI, più sicura e con minor
  superficie di attacco.',
      1,
      ARRAY['windows', 'windows-server', 'ruoli', 'feature']
  ),
  (
      'WMI - Windows Management Instrumentation',
      'WMI espone informazioni su hardware, software e configurazione di sistema tramite query WQL
   (SQL-like). Get-CimInstance in PowerShell interroga WMI localmente o da remoto. Le classi
  principali sono Win32_ComputerSystem, Win32_Process, Win32_Service e
  Win32_NetworkAdapterConfiguration.',
      1,
      ARRAY['windows', 'wmi', 'powershell', 'management']
  ),
  (
      'BitLocker - full disk encryption',
      'BitLocker cifra l''intero volume di sistema usando AES-128 o AES-256. La chiave di recovery
   viene salvata in Active Directory o su USB. Il TPM archivia la chiave di cifratura e verifica
  l''integrità del boot prima di sbloccare il disco. BitLocker To Go protegge le unità
  removibili.',
      1,
      ARRAY['windows', 'bitlocker', 'encryption', 'security']
  ),

  -- Networking
  (
      'Modello OSI - i 7 livelli',
      'Il modello OSI descrive le funzioni di rete in 7 livelli: Fisico (bit su cavo), Data Link
  (frame, MAC address), Rete (pacchetti IP, router), Trasporto (TCP/UDP), Sessione, Presentazione
  (cifratura) e Applicazione (HTTP, DNS). In pratica si usa il modello TCP/IP a 4 livelli che
  collassa i livelli 5-7.',
      1,
      ARRAY['networking', 'osi', 'tcp-ip', 'fondamenti']
  ),
  (
      'TCP - three-way handshake e controllo flusso',
      'La connessione TCP si stabilisce con il three-way handshake: SYN (client), SYN-ACK
  (server), ACK (client). Il controllo di flusso usa la sliding window: il ricevente comunica
  quanti byte può ricevere. Il controllo di congestione con algoritmi come BBR adatta la velocità
  alle condizioni della rete.',
      1,
      ARRAY['networking', 'tcp', 'handshake', 'protocolli']
  ),
  (
      'DNS - risoluzione dei nomi',
      'Il DNS traduce i nomi di dominio in indirizzi IP tramite una gerarchia di server. La
  risoluzione iterativa parte dai root server, poi i TLD e infine il nameserver autoritativo. I
  record principali sono A (IPv4), AAAA (IPv6), MX (mail), CNAME (alias) e TXT (verifica e SPF).',
      1,
      ARRAY['networking', 'dns', 'risoluzione', 'protocolli']
  ),
  (
      'DHCP - assegnazione automatica degli indirizzi',
      'DHCP assegna automaticamente indirizzo IP, subnet mask, gateway e DNS ai client. Il
  processo DORA: Discover, Offer, Request, Acknowledge. Il lease time determina per quanto il
  client mantiene l''IP. L''IP helper (DHCP relay) permette di servire più subnet con un unico
  server DHCP.',
      1,
      ARRAY['networking', 'dhcp', 'ip', 'protocolli']
  ),
  (
      'VLAN - segmentazione della rete',
      'Le VLAN (802.1Q) segmentano logicamente una rete fisica in più reti virtuali isolate. Il
  tag VLAN di 4 byte viene aggiunto all''header Ethernet. I trunk port trasportano più VLAN tra
  switch. Le VLAN migliorano la sicurezza, semplificano la gestione e ottimizzano il traffico
  broadcast.',
      1,
      ARRAY['networking', 'vlan', 'switching', 'segmentazione']
  ),
  (
      'Routing - protocolli dinamici BGP e OSPF',
      'OSPF è un protocollo di routing link-state per reti interne: ogni router conosce la
  topologia completa e calcola il percorso ottimale con Dijkstra. BGP è il protocollo di routing
  tra sistemi autonomi che gestisce il routing su Internet scegliendo i percorsi in base a policy
  di business.',
      1,
      ARRAY['networking', 'routing', 'bgp', 'ospf']
  ),
  (
      'Firewall - stateful inspection e next-gen',
      'Un firewall stateful mantiene una tabella delle connessioni attive e permette
  automaticamente i pacchetti di risposta. Il Next-Generation Firewall aggiunge ispezione
  applicativa Layer 7, IPS e URL filtering. pfSense e OPNsense sono firewall open source; Palo
  Alto e Fortinet sono i principali vendor enterprise.',
      1,
      ARRAY['networking', 'firewall', 'security', 'ngfw']
  ),
  (
      'VPN - tipi e protocolli',
      'IPSec opera a livello 3 e cifra i pacchetti IP: usato per site-to-site VPN tra router
  aziendali. OpenVPN opera a livello 4 tramite TLS. WireGuard è il protocollo più moderno con
  crittografia ChaCha20 e performance superiori. L2TP/IPSec e PPTP sono protocolli legacy da
  evitare.',
      1,
      ARRAY['networking', 'vpn', 'ipsec', 'wireguard']
  ),
  (
      'Load balancing - algoritmi e tecnologie',
      'Il load balancer distribuisce il traffico tra più server backend. Gli algoritmi principali
  sono Round Robin (rotazione sequenziale), Least Connections (al server con meno connessioni
  attive) e IP Hash (stesso client sempre allo stesso server). HAProxy e Nginx sono i load
  balancer software più diffusi.',
      1,
      ARRAY['networking', 'load-balancing', 'haproxy', 'nginx']
  ),
  (
      'NAT e PAT',
      'NAT sostituisce l''indirizzo IP sorgente nei pacchetti, permettendo a una rete privata di
  accedere a Internet con un solo IP pubblico. PAT aggiunge la traduzione della porta sorgente,
  permettendo a molti client di condividere un singolo IP pubblico differenziandosi per numero di
  porta.',
      1,
      ARRAY['networking', 'nat', 'pat', 'routing']
  ),
  (
      'QoS - Quality of Service',
      'QoS prioritizza il traffico di rete per garantire bandwidth e latenza ai servizi critici.
  DSCP marca i pacchetti IP con una classe di servizio. Traffic shaping limita la banda per
  classe. VoIP e videoconferenza richiedono bassa latenza (sotto 150ms) e basso jitter per
  funzionare correttamente.',
      1,
      ARRAY['networking', 'qos', 'traffic-shaping', 'voip']
  ),
  (
      'Wireshark - analisi dei pacchetti',
      'Wireshark è il principale tool di packet analysis. Cattura il traffico di rete e lo
  decodifica mostrando i protocolli a ogni livello. I filtri di visualizzazione usano la sintassi:
   ip.addr == 192.168.1.1, tcp.port == 443. tshark è la versione da riga di comando per ambienti
  senza GUI.',
      1,
      ARRAY['networking', 'wireshark', 'packet-analysis', 'troubleshooting']
  ),
  (
      'IPv6 - indirizzamento e transizione',
      'IPv6 usa indirizzi a 128 bit in notazione esadecimale (2001:db8::1). Elimina NAT grazie
  allo spazio di indirizzamento enorme e introduce autoconfiguration (SLAAC). I meccanismi di
  transizione da IPv4 sono dual-stack (il più comune), tunneling e translation (NAT64).',
      1,
      ARRAY['networking', 'ipv6', 'indirizzamento', 'transizione']
  ),
  (
      'Spanning Tree Protocol - STP',
      'STP (802.1D) previene i loop nella rete switch eleggendo un root bridge e bloccando le
  porte ridondanti. RSTP è la versione rapida con convergenza in secondi invece di minuti. I
  problemi comuni sono topology change continue per porte instabili e root bridge election
  inatteso.',
      1,
      ARRAY['networking', 'stp', 'switching', 'layer2']
  ),
  (
      'SSL/TLS - handshake e certificati',
      'TLS cifra le comunicazioni autenticando il server tramite certificati X.509. L''handshake
  TLS 1.3 richiede solo 1 RTT. I cipher suite moderni usano ECDHE per forward secrecy e AES-GCM o
  ChaCha20-Poly1305 per la cifratura simmetrica. HSTS forza l''uso di HTTPS impedendo il downgrade
   a HTTP.',
      1,
      ARRAY['networking', 'tls', 'ssl', 'security']
  );
