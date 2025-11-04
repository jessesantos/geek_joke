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
-- As tabelas serão criadas pelo AdonisJS via
-- migrations (node ace migration:run).
--
-- Este arquivo serve apenas para:
-- 1. Habilitar extensões necessárias
-- 2. Configurar o banco de dados
-- 3. Preparar o ambiente para as migrations
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
-- VERIFICAÇÃO
-- ============================================

-- Listar extensões instaladas
SELECT * FROM pg_extension;

-- Verificar encoding do banco
SHOW server_encoding;

-- ============================================
-- FIM DO SCRIPT
-- ============================================
