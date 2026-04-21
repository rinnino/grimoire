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
