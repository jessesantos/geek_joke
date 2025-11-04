-- ============================================
-- Geek Joke API - Database Schema
-- ============================================
-- Este arquivo é executado automaticamente pelo
-- PostgreSQL na inicialização do container Docker
-- ============================================

-- Garantir que estamos no banco correto
\c geekjoke_db;

-- ============================================
-- EXTENSÕES
-- ============================================

-- UUID para geração de identificadores únicos (caso necessário no futuro)
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- pgcrypto para funções de hash (caso necessário)
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- ============================================
-- CONFIGURAÇÕES
-- ============================================

-- Definir timezone padrão
SET timezone = 'UTC';

-- ============================================
-- COMENTÁRIOS
-- ============================================

COMMENT ON DATABASE geekjoke_db IS 'Banco de dados para aplicação Geek Joke API - Fullstack Vue.js + AdonisJS';

-- ============================================
-- NOTA IMPORTANTE
-- ============================================
-- Este arquivo cria o schema completo do banco.
-- Pode ser usado de duas formas:
-- 1. Executado diretamente para setup inicial
-- 2. Como referência para as migrations do AdonisJS
-- ============================================

-- ============================================
-- SCHEMA PÚBLICO
-- ============================================
-- O schema 'public' já existe por padrão
-- Garantir permissões corretas

GRANT ALL PRIVILEGES ON SCHEMA public TO geekjoke_user;
GRANT ALL PRIVILEGES ON DATABASE geekjoke_db TO geekjoke_user;

-- Permitir que o usuário crie tabelas no schema public
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON TABLES TO geekjoke_user;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON SEQUENCES TO geekjoke_user;

-- ============================================
-- VERIFICAÇÃO INICIAL
-- ============================================

-- Listar extensões instaladas
SELECT * FROM pg_extension;

-- Verificar encoding do banco
SHOW server_encoding;

-- ============================================
-- TABELAS
-- ============================================

-- Tabela de Usuários
-- Armazena informações dos usuários do sistema
CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    full_name VARCHAR(255),
    email VARCHAR(254) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP
);

-- Índices para otimização
CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);
CREATE INDEX IF NOT EXISTS idx_users_created_at ON users(created_at);

-- Comentários da tabela users
COMMENT ON TABLE users IS 'Tabela de usuários do sistema Geek Joke API';
COMMENT ON COLUMN users.id IS 'Identificador único do usuário';
COMMENT ON COLUMN users.full_name IS 'Nome completo do usuário (opcional)';
COMMENT ON COLUMN users.email IS 'Email do usuário (usado para login)';
COMMENT ON COLUMN users.password IS 'Senha criptografada com Scrypt';
COMMENT ON COLUMN users.created_at IS 'Data de criação do registro';
COMMENT ON COLUMN users.updated_at IS 'Data da última atualização do registro';

-- ============================================

-- Tabela de Tokens de Acesso
-- Armazena tokens de autenticação OAuth 2.0
CREATE TABLE IF NOT EXISTS auth_access_tokens (
    id SERIAL PRIMARY KEY,
    tokenable_id INTEGER NOT NULL,
    type VARCHAR(255) NOT NULL,
    name VARCHAR(255),
    hash VARCHAR(255) NOT NULL,
    abilities TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP,
    last_used_at TIMESTAMP,
    expires_at TIMESTAMP,

    -- Foreign Key para users com CASCADE DELETE
    CONSTRAINT fk_auth_access_tokens_users
        FOREIGN KEY (tokenable_id)
        REFERENCES users(id)
        ON DELETE CASCADE
);

-- Índices para otimização
CREATE INDEX IF NOT EXISTS idx_auth_access_tokens_tokenable_id ON auth_access_tokens(tokenable_id);
CREATE INDEX IF NOT EXISTS idx_auth_access_tokens_hash ON auth_access_tokens(hash);
CREATE INDEX IF NOT EXISTS idx_auth_access_tokens_expires_at ON auth_access_tokens(expires_at);

-- Comentários da tabela auth_access_tokens
COMMENT ON TABLE auth_access_tokens IS 'Tabela de tokens de autenticação OAuth 2.0';
COMMENT ON COLUMN auth_access_tokens.id IS 'Identificador único do token';
COMMENT ON COLUMN auth_access_tokens.tokenable_id IS 'ID do usuário proprietário do token';
COMMENT ON COLUMN auth_access_tokens.type IS 'Tipo do token (ex: auth_token)';
COMMENT ON COLUMN auth_access_tokens.name IS 'Nome descritivo do token';
COMMENT ON COLUMN auth_access_tokens.hash IS 'Hash do token (nunca armazena o token em texto plano)';
COMMENT ON COLUMN auth_access_tokens.abilities IS 'Permissões do token em formato JSON';
COMMENT ON COLUMN auth_access_tokens.created_at IS 'Data de criação do token';
COMMENT ON COLUMN auth_access_tokens.updated_at IS 'Data da última atualização do token';
COMMENT ON COLUMN auth_access_tokens.last_used_at IS 'Data do último uso do token';
COMMENT ON COLUMN auth_access_tokens.expires_at IS 'Data de expiração do token';

-- ============================================
-- VERIFICAÇÃO FINAL
-- ============================================

-- Listar todas as tabelas criadas
SELECT tablename, schemaname
FROM pg_tables
WHERE schemaname = 'public'
ORDER BY tablename;

-- Verificar relacionamentos (Foreign Keys)
SELECT
    tc.table_name,
    kcu.column_name,
    ccu.table_name AS foreign_table_name,
    ccu.column_name AS foreign_column_name,
    rc.delete_rule
FROM information_schema.table_constraints AS tc
JOIN information_schema.key_column_usage AS kcu
    ON tc.constraint_name = kcu.constraint_name
JOIN information_schema.constraint_column_usage AS ccu
    ON ccu.constraint_name = tc.constraint_name
JOIN information_schema.referential_constraints AS rc
    ON rc.constraint_name = tc.constraint_name
WHERE tc.constraint_type = 'FOREIGN KEY'
    AND tc.table_schema = 'public'
ORDER BY tc.table_name;

-- ============================================
-- FIM DO SCRIPT
-- ============================================
