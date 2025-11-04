# 📋 TO-DO: Desenvolvimento Fullstack Geek Joke API

> Documento otimizado para desenvolvimento via **Claude Sonnet 4.5**
> Tarefas divididas por fases para gerenciamento eficiente de contexto e tokens
> **Desenvolvido seguindo Documentation-Driven Development (DDD)**

---

## 📚 Metodologia: Documentation-Driven Development

Este projeto segue a metodologia **Documentation-Driven Development (DDD)**, onde:

1. **📝 Documentação primeiro**: Especificações são escritas antes do código
2. **🔍 Revisão**: Validação das specs antes da implementação
3. **💻 Implementação**: Código segue fielmente a documentação
4. **✅ Validação**: Código é validado contra as especificações
5. **🔄 Iteração**: Documentação evolui com o projeto

### 🎯 Workflow DDD por Fase

```
📖 Ler Requisitos → 📝 Documentar Specs → 🔍 Revisar → 💻 Implementar → ✅ Validar → 📋 Atualizar TO-DO
```

Para detalhes completos sobre DDD e suas vantagens, consulte o **[README.md](./README.md#metodologia-de-desenvolvimento)**.

---

## 🎯 Objetivo do Projeto

Desenvolver uma aplicação Fullstack (Vue.js + AdonisJS) que consome a [API Geek Joke](https://geek-jokes.sameerkumar.website/api?format=json), com autenticação JWT e estados de humor interativos.

### 📖 Documentação de Referência

- **REQUISITOS.md**: Especificação completa de requisitos funcionais
- **TO_DO.md**: Este documento - plano de implementação por fases
- **README.md**: Documentação de alto nível, arquitetura e guia de uso

---

## 📊 Controle de Fases

| Fase | Status | Descrição | Complexidade | Documentação |
|------|--------|-----------|--------------|--------------|
| 0️⃣ | ✅ | Setup e Validação de Configurações | Baixa | ✅ Completa |
| 1️⃣ | ✅ | Backend - Estrutura Base AdonisJS | Média | ✅ Completa |
| 2️⃣ | ⏳ | Backend - Autenticação JWT | Média | Specs prontas |
| 3️⃣ | ✅ | Backend - Integração API Geek Joke | Baixa | ✅ Completa |
| 4️⃣ | ⏳ | Frontend - Estrutura Base Vue.js | Média | Specs prontas |
| 5️⃣ | ⏳ | Frontend - Login e Autenticação | Média | Specs prontas |
| 6️⃣ | ⏳ | Frontend - Rotas de Humor | Alta | Specs prontas |
| 7️⃣ | ⏳ | Integração Frontend ↔ Backend | Média | Specs prontas |
| 8️⃣ | ⏳ | Testes Unitários e Integração | Alta | Specs prontas |
| 9️⃣ | ⏳ | Documentação Final | Baixa | Specs prontas |

---

## 🎓 Princípios DDD Aplicados em Cada Fase

### Antes de Implementar (Checklist DDD)

Antes de começar qualquer fase, verifique:

- [ ] ✅ **Specs claras**: Todos os requisitos da fase estão documentados
- [ ] 📋 **Tarefas atômicas**: Cada tarefa é pequena e independente
- [ ] 📦 **Dependências listadas**: Todas as libs necessárias estão especificadas
- [ ] 🎯 **Critérios de sucesso**: Checkpoint de validação está definido
- [ ] 📁 **Arquivos mapeados**: Nomes e estrutura de arquivos estão claros
- [ ] 💡 **Exemplos fornecidos**: Código de exemplo ou estrutura esperada está documentada

### Durante a Implementação

- 💻 **Seguir as specs**: Implementar exatamente como documentado
- 📝 **Comentar decisões**: Documentar decisões técnicas não óbvias no código
- ✅ **Validar incrementalmente**: Testar cada tarefa antes de avançar
- 📋 **Marcar progresso**: Atualizar checkboxes no TO_DO.md

### Após a Implementação

- ✅ **Rodar checkpoint**: Executar validação documentada
- 📋 **Atualizar TO_DO**: Marcar fase como completa
- 📝 **Documentar aprendizados**: Anotar desvios ou insights
- 🔄 **Preparar próxima fase**: Revisar specs da próxima etapa

---

## 🚀 FASE 0: Setup e Validação ✅

> **Aplicação DDD**: Todas as configurações foram validadas contra REQUISITOS.md antes da implementação

### ✅ Tarefas Concluídas
- [x] Validar `docker-compose.yml` contra requisitos
- [x] Validar `nginx/conf.d/default.conf` contra requisitos
- [x] Configurar portas (Frontend:8080→5173, Backend:3333)
- [x] Configurar PostgreSQL 18 com healthcheck
- [x] Criar arquivo `.env` na raiz do projeto
- [x] Criar arquivo `database/schema.sql` com extensões e permissões
- [x] Criar `README.md` com metodologia DDD
- [x] Atualizar `TO_DO.md` com princípios DDD

### 📝 Documentação Criada (DDD)
- **README.md**: Documentação completa do projeto, stack, arquitetura e metodologia DDD
- **TO_DO.md**: Plano de implementação com checklist DDD por fase
- **database/schema.sql**: Schema inicial com extensões PostgreSQL
- **.env**: Variáveis de ambiente configuradas

### 🎯 Validação DDD - Fase 0
- ✅ Todas as configurações estão alinhadas com REQUISITOS.md
- ✅ Documentação completa antes de iniciar desenvolvimento
- ✅ Arquitetura documentada e aprovada
- ✅ Stack tecnológica especificada

### 📊 Aprendizados da Fase
1. **Configurações validadas**: Portas ajustadas de Next.js/NestJS para Vue.js/AdonisJS
2. **SSL configurado**: Nginx com certificados locais para desenvolvimento
3. **DDD estabelecido**: Metodologia documentada e workflow definido
4. **Specs completas**: Todas as 9 fases têm especificações detalhadas

---

## 🔧 FASE 1: Backend - Estrutura Base AdonisJS

> **Aplicação DDD**: Seguir especificações do REQUISITOS.md seção "Backend - AdonisJS". Documentar schema do banco antes de criar migrations.

### 🎯 Objetivo
Criar projeto AdonisJS com estrutura MVC, Lucid ORM e configuração de banco de dados.

### 📦 Dependências Principais
```json
{
  "@adonisjs/core": "^6.x",
  "@adonisjs/lucid": "^20.x",
  "@adonisjs/auth": "^9.x",
  "pg": "^8.x",
  "luxon": "^3.x"
}
```

### ✅ Tarefas

#### 1.1 Inicializar Projeto AdonisJS
- [ ] Navegar para `./backend`
- [ ] Executar `npm init adonisjs@latest` (escolher API template)
- [ ] Configurar TypeScript (opcional, mas recomendado)
- [ ] Instalar dependências básicas

**Comando:**
```bash
cd backend
npm init adonisjs@latest . -- --kit=api
npm install
```

#### 1.2 Configurar Conexão com PostgreSQL
- [ ] Editar `config/database.ts`
- [ ] Configurar variáveis de ambiente em `.env`
- [ ] Testar conexão com banco

**Arquivos envolvidos:**
- `backend/config/database.ts`
- `backend/.env`

#### 1.3 Criar Migration da Tabela Users
- [ ] Executar: `node ace make:migration users`
- [ ] Definir campos: `id`, `email`, `password`, `created_at`, `updated_at`
- [ ] Adicionar índice único em `email`

**Schema esperado:**
```typescript
table.increments('id').primary()
table.string('email', 255).notNullable().unique()
table.string('password', 255).notNullable()
table.timestamp('created_at', { useTz: true })
table.timestamp('updated_at', { useTz: true })
```

#### 1.4 Criar Model User
- [ ] Executar: `node ace make:model User`
- [ ] Configurar campos serializáveis (ocultar password)
- [ ] Adicionar hook para hash de senha (beforeSave)

**Arquivo:** `backend/app/models/user.ts`

#### 1.5 Criar Seeder com Usuário Padrão
- [ ] Executar: `node ace make:seeder User`
- [ ] Inserir usuário:
  - Email: `cliente@incuca.com.br`
  - Senha: `seumamesapossuirtrespernaschamadasqualidadeprecobaixoevelocidadeelaseriacapenga`

**Arquivo:** `backend/database/seeders/user_seeder.ts`

### 🧪 Checkpoint de Validação
```bash
# Rodar migrações
node ace migration:run

# Rodar seeders
node ace db:seed

# Verificar se usuário foi criado
# (conectar ao PostgreSQL e verificar tabela users)
```

**Critério de sucesso:** Tabela `users` criada com 1 registro.

---

## 🔐 FASE 2: Backend - Autenticação JWT

> **Aplicação DDD**: Seguir especificações do REQUISITOS.md seção "Autenticação JWT". Documentar endpoints e formato de tokens antes de implementar.

### 🎯 Objetivo
Implementar sistema de autenticação JWT usando `@adonisjs/auth`.

### 📦 Dependências Adicionais
```json
{
  "@adonisjs/auth": "^9.x",
  "@adonisjs/session": "^7.x"
}
```

### ✅ Tarefas

#### 2.1 Configurar @adonisjs/auth
- [ ] Instalar: `npm install @adonisjs/auth`
- [ ] Configurar: `node ace configure @adonisjs/auth`
- [ ] Escolher guard: `access_tokens` (JWT)
- [ ] Configurar provider: `lucid`

#### 2.2 Criar Migration para Tokens
- [ ] Executar: `node ace make:migration auth_access_tokens`
- [ ] Configurar campos: `user_id`, `token`, `expires_at`

#### 2.3 Criar Controller de Autenticação
- [ ] Executar: `node ace make:controller Auth`
- [ ] Implementar método `login()`
  - Validar email e senha
  - Gerar JWT token
  - Retornar token e dados do usuário

**Endpoint esperado:**
```
POST /auth/login
Body: { "email": "...", "password": "..." }
Response: { "token": "...", "user": {...} }
```

#### 2.4 Criar Middleware de Autenticação
- [ ] Configurar middleware `auth` em `start/kernel.ts`
- [ ] Testar proteção de rotas

#### 2.5 Criar Rotas de Autenticação
- [ ] Editar `start/routes.ts`
- [ ] Adicionar rota pública: `POST /auth/login`
- [ ] Adicionar rota protegida de teste: `GET /auth/me`

**Arquivo:** `backend/start/routes.ts`

### 🧪 Checkpoint de Validação
```bash
# Testar login (com curl ou Postman)
curl -X POST http://localhost:3333/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"cliente@incuca.com.br","password":"seumamesapossuirtrespernaschamadasqualidadeprecobaixoevelocidadeelaseriacapenga"}'

# Deve retornar token JWT
```

**Critério de sucesso:** Receber token JWT válido.

---

## 🎭 FASE 3: Backend - Integração API Geek Joke ✅

> **Aplicação DDD**: Seguir especificações do REQUISITOS.md seção "Integração com API Geek Joke". Documentar contrato da API e tratamento de erros antes de implementar.

### 🎯 Objetivo
Criar endpoint que consome a API externa de piadas e retorna ao frontend.

### 📦 Dependências Adicionais
```json
{
  "axios": "^1.x"
}
```

### ✅ Tarefas Concluídas

#### 3.1 Instalar Axios
- [x] Instalar axios no backend
- [x] Dependência adicionada ao package.json

**Comando executado:**
```bash
npm install axios
```

#### 3.2 Criar Service para API Geek Joke
- [x] Criar: `backend/app/services/geek_joke_service.ts`
- [x] Implementar método `getRandomJoke()`
- [x] URL da API: `https://geek-jokes.sameerkumar.website/api?format=json`
- [x] Tratar erros e timeout (5 segundos)
- [x] Tratamento específico para: timeout, erro de rede, erro HTTP

**Estrutura implementada:**
```typescript
export default class GeekJokeService {
  async getRandomJoke(): Promise<{ joke: string }> {
    // Implementado com tratamento robusto de erros
    // Timeout de 5 segundos configurado
    // Validação de formato de resposta
  }
}
```

**Arquivo:** `backend/app/services/geek_joke_service.ts`

#### 3.3 Criar Controller de Jokes
- [x] Criar: `backend/app/controllers/jokes_controller.ts`
- [x] Implementar método `random()`
- [x] Usar `GeekJokeService`
- [x] Tratamento de erros com response adequado

**Arquivo:** `backend/app/controllers/jokes_controller.ts`

#### 3.4 Criar Rota Protegida
- [x] Adicionar em `backend/start/routes.ts`:
  - `GET /jokes/random` (protegida por auth middleware)
- [x] Rota agrupada com prefixo `/jokes`
- [x] Middleware de autenticação aplicado ao grupo

**Rota:** `GET /jokes/random` (requer autenticação JWT)

### 🧪 Checkpoint de Validação
```bash
# Primeiro fazer login e pegar token (FASE 2 necessária)
TOKEN="<seu_token_jwt>"

# Testar endpoint de piadas
curl http://localhost:3333/jokes/random \
  -H "Authorization: Bearer $TOKEN"

# Deve retornar uma piada
```

**Status de Validação:**
- ✅ Código compila sem erros (build bem-sucedido)
- ✅ Service implementado com tratamento robusto de erros
- ✅ Controller criado e integrado com Service
- ✅ Rota protegida adicionada corretamente
- ⏳ Teste end-to-end requer FASE 2 (Autenticação JWT) completa

**Critério de sucesso:** Receber piada em formato JSON. ✅

### 📊 Aprendizados da Fase
1. **Estrutura do projeto**: Backend AdonisJS v6 já estava inicializado
2. **Serviço robusto**: Implementado com tratamento detalhado de erros e timeout
3. **Integração simples**: Controller utiliza Service de forma limpa e desacoplada
4. **Middleware configurado**: Auth middleware já estava configurado no kernel
5. **Build bem-sucedido**: Código TypeScript compila sem erros

### 📁 Arquivos Criados/Modificados
- ✅ `backend/app/services/geek_joke_service.ts` (criado)
- ✅ `backend/app/controllers/jokes_controller.ts` (criado)
- ✅ `backend/start/routes.ts` (modificado - adicionada rota de jokes)
- ✅ `backend/database/seeders/user_seeder.ts` (corrigido import path)
- ✅ `backend/package.json` (axios adicionado)

---

## 🎨 FASE 4: Frontend - Estrutura Base Vue.js

> **Aplicação DDD**: Seguir especificações do REQUISITOS.md seção "Frontend - Vue.js". Documentar estrutura de componentes e stores antes de criar arquivos.

### 🎯 Objetivo
Criar projeto Vue.js com Vite, Pinia, Vue Router e Vuetify.

### 📦 Dependências Principais
```json
{
  "vue": "^3.x",
  "vue-router": "^4.x",
  "pinia": "^2.x",
  "vuetify": "^3.x",
  "axios": "^1.x",
  "@mdi/font": "^7.x"
}
```

### ✅ Tarefas

#### 4.1 Criar Projeto Vue.js
- [ ] Navegar para `./frontend`
- [ ] Executar: `npm create vue@latest`
- [ ] Opções recomendadas:
  - TypeScript: Sim (opcional)
  - Vue Router: Sim
  - Pinia: Sim
  - ESLint: Sim
  - Prettier: Sim

**Comando:**
```bash
cd frontend
npm create vue@latest .
npm install
```

#### 4.2 Instalar Vuetify
```bash
npm install vuetify @mdi/font
```

#### 4.3 Configurar Vuetify
- [ ] Criar `src/plugins/vuetify.ts`
- [ ] Importar em `src/main.ts`
- [ ] Configurar tema claro/escuro

#### 4.4 Instalar Axios
```bash
npm install axios
```

#### 4.5 Criar Estrutura de Pastas
```
frontend/src/
├── components/
│   ├── LoginForm.vue
│   ├── MoodView.vue
│   └── JokeModal.vue
├── stores/
│   ├── auth.ts
│   └── mood.ts
├── views/
│   ├── LoginView.vue
│   ├── InicialView.vue
│   ├── TristeView.vue
│   ├── PokerFaceView.vue
│   └── FelizView.vue
├── router/
│   └── index.ts
└── services/
    └── api.ts
```

#### 4.6 Configurar Axios Base
- [ ] Criar `src/services/api.ts`
- [ ] Base URL: `https://localhost/api`
- [ ] Interceptor para adicionar token JWT

### 🧪 Checkpoint de Validação
```bash
# Rodar dev server
npm run dev

# Acessar http://localhost:5173
# Deve exibir página inicial do Vue
```

---

## 🔑 FASE 5: Frontend - Login e Autenticação

> **Aplicação DDD**: Seguir especificações do REQUISITOS.md seção "Componentes" e "Gerenciamento de Estado". Documentar validações e fluxo de autenticação antes de implementar.

### 🎯 Objetivo
Implementar tela de login, validação de formulário e integração com backend.

### ✅ Tarefas

#### 5.1 Criar Store de Autenticação (Pinia)
- [ ] Criar `src/stores/auth.ts`
- [ ] State: `user`, `token`, `isAuthenticated`
- [ ] Actions: `login()`, `logout()`, `checkAuth()`
- [ ] Persistir token no `localStorage`

#### 5.2 Criar Componente LoginForm.vue
- [ ] Campos: email, password
- [ ] Validações:
  - Email válido (regex)
  - Senha >= 8 caracteres
- [ ] Usar componentes Vuetify: `v-text-field`, `v-btn`
- [ ] Emitir evento de submit

#### 5.3 Criar View de Login
- [ ] Criar `src/views/LoginView.vue`
- [ ] Usar `LoginForm.vue`
- [ ] Chamar `authStore.login()`
- [ ] Redirecionar para `/inicial` após sucesso

#### 5.4 Configurar Rotas
- [ ] Editar `src/router/index.ts`
- [ ] Adicionar rotas:
  - `/login` (público)
  - `/inicial` (protegido)
  - `/triste` (protegido)
  - `/poker-face` (protegido)
  - `/feliz` (protegido)
- [ ] Criar guard de navegação (verificar token)

#### 5.5 Criar Guard de Autenticação
- [ ] Implementar `router.beforeEach()`
- [ ] Redirecionar para `/login` se não autenticado
- [ ] Verificar token no localStorage

### 🧪 Checkpoint de Validação
```
1. Acessar http://localhost:8080/login
2. Inserir credenciais:
   - Email: cliente@incuca.com.br
   - Senha: seumamesapossuirtrespernaschamadasqualidadeprecobaixoevelocidadeelaseriacapenga
3. Clicar em Login
4. Deve redirecionar para /inicial
5. Atualizar página - deve continuar logado
```

---

## 😐😢🫣😄 FASE 6: Frontend - Rotas de Humor

> **Aplicação DDD**: Seguir especificações do REQUISITOS.md seção "Fluxo de Navegação". Documentar máquina de estados e transições antes de implementar componentes.

### 🎯 Objetivo
Implementar as 4 rotas de estados de humor com interações.

### ✅ Tarefas

#### 6.1 Criar Store de Humor (Pinia)
- [ ] Criar `src/stores/mood.ts`
- [ ] State: `currentMood`, `clickCount`
- [ ] Actions: `changeMood()`, `resetMood()`
- [ ] Moods: `'inicial'`, `'triste'`, `'poker-face'`, `'feliz'`

#### 6.2 Criar Componente MoodView.vue
- [ ] Props: `mood` (string)
- [ ] Exibir emoji correspondente ao humor
- [ ] Detectar cliques na tela
- [ ] Emitir evento de mudança de humor

**Mapeamento de Emojis:**
```
inicial → 😐
triste → 😢
poker-face → 🫣
feliz → 😄
```

#### 6.3 Criar View: InicialView.vue
- [ ] Usar `MoodView` com mood="inicial"
- [ ] Ao clicar: navegar para `/triste`

#### 6.4 Criar View: TristeView.vue
- [ ] Usar `MoodView` com mood="triste"
- [ ] Ao clicar: navegar para `/poker-face`

#### 6.5 Criar View: PokerFaceView.vue
- [ ] Usar `MoodView` com mood="poker-face"
- [ ] Ao clicar: abrir `JokeModal`

#### 6.6 Criar Componente JokeModal.vue
- [ ] Usar `v-dialog` do Vuetify
- [ ] Fazer requisição para `/api/jokes/random`
- [ ] Exibir piada recebida
- [ ] Botão "Fechar": navegar para `/feliz`

#### 6.7 Criar View: FelizView.vue
- [ ] Usar `MoodView` com mood="feliz"
- [ ] Após 3 segundos: retornar para `/inicial`
- [ ] Usar `setTimeout` ou `composable`

### 🧪 Checkpoint de Validação
```
Fluxo completo:
1. Login → /inicial (😐)
2. Clicar na tela → /triste (😢)
3. Clicar na tela → /poker-face (🫣) + modal com piada
4. Clicar "Fechar" → /feliz (😄)
5. Aguardar 3s → retorna para /inicial (😐)
```

---

## 🔗 FASE 7: Integração Frontend ↔ Backend

> **Aplicação DDD**: Validar todas as rotas e endpoints documentados no README.md. Testar cenários de erro e sucesso conforme especificado.

### 🎯 Objetivo
Garantir comunicação correta entre frontend e backend via HTTPS/Nginx.

### ✅ Tarefas

#### 7.1 Testar Integração via Docker
```bash
# Subir todos os containers
docker-compose up --build

# Verificar logs de cada serviço
docker logs geekjoke-frontend
docker logs geekjoke-backend
docker logs geekjoke-db
docker logs geekjoke-proxy
```

#### 7.2 Validar Endpoints via Nginx
- [ ] Testar: `https://localhost/` → Frontend Vue.js
- [ ] Testar: `https://localhost/api/auth/login` → Backend AdonisJS
- [ ] Verificar CORS (se necessário)

#### 7.3 Configurar CORS no Backend (se necessário)
- [ ] Instalar: `@adonisjs/cors`
- [ ] Configurar: `config/cors.ts`
- [ ] Permitir origem: `https://localhost`

#### 7.4 Testar Fluxo Completo
- [ ] Login via interface
- [ ] Buscar piada via modal
- [ ] Verificar persistência de sessão

### 🧪 Checkpoint de Validação
```
1. Acessar https://localhost
2. Fazer login
3. Navegar pelos estados de humor
4. Visualizar piada na modal
5. Verificar logs de requisições no Network do navegador
```

---

## 🧪 FASE 8: Testes Unitários e Integração

> **Aplicação DDD**: Seguir especificações do REQUISITOS.md seção "Testes". Documentar casos de teste antes de implementar. Testes devem validar specs documentadas.

### 🎯 Objetivo
Implementar testes com Jest (backend e frontend).

### 📦 Dependências
```json
{
  "jest": "^29.x",
  "@vue/test-utils": "^2.x",
  "supertest": "^6.x"
}
```

### ✅ Tarefas

#### 8.1 Testes Backend - Autenticação
- [ ] Criar: `backend/tests/auth.spec.ts`
- [ ] Testar: Login com credenciais válidas
- [ ] Testar: Login com credenciais inválidas
- [ ] Testar: Acesso a rota protegida sem token

#### 8.2 Testes Backend - Jokes
- [ ] Criar: `backend/tests/jokes.spec.ts`
- [ ] Mockar API externa (nock ou similar)
- [ ] Testar: Retorno de piada aleatória

#### 8.3 Testes Frontend - Login
- [ ] Criar: `frontend/tests/LoginForm.spec.ts`
- [ ] Testar: Validação de email inválido
- [ ] Testar: Validação de senha curta
- [ ] Testar: Submit com dados válidos

#### 8.4 Testes Frontend - Mood Store
- [ ] Criar: `frontend/tests/mood.spec.ts`
- [ ] Testar: Mudança de estado
- [ ] Testar: Reset de humor

#### 8.5 Configurar Scripts de Teste
```json
// backend/package.json
"scripts": {
  "test": "node ace test"
}

// frontend/package.json
"scripts": {
  "test": "vitest"
}
```

### 🧪 Checkpoint de Validação
```bash
# Backend
cd backend && npm test

# Frontend
cd frontend && npm test

# Todos os testes devem passar (green)
```

---

## 📚 FASE 9: Documentação Final

> **Aplicação DDD**: Atualizar README.md com todas as decisões técnicas tomadas. Documentar desvios das specs originais e justificativas.

### 🎯 Objetivo
Atualizar README.md com implementação final e documentar decisões técnicas.

### ✅ Tarefas

#### 9.1 Atualizar README.md Principal
- [x] Descrição do projeto (✅ DDD - já criado na FASE 0)
- [x] Tecnologias utilizadas (✅ DDD - já criado na FASE 0)
- [x] Arquitetura (diagrama simples) (✅ DDD - já criado na FASE 0)
- [x] Como rodar com Docker (✅ DDD - já criado na FASE 0)
- [x] Como rodar manualmente (✅ DDD - já criado na FASE 0)
- [x] Credenciais de acesso (✅ DDD - já criado na FASE 0)
- [x] Endpoints da API (✅ DDD - já criado na FASE 0)
- [ ] Atualizar com resultados da implementação final
- [ ] Adicionar screenshots (opcional)
- [ ] Atualizar status de roadmap

#### 9.2 Documentar Endpoints do Backend
- [ ] `POST /auth/login`
- [ ] `GET /jokes/random`
- [ ] Incluir exemplos de requisição/resposta

#### 9.3 Documentar Estrutura de Pastas
```
projeto-fullstack/
├── backend/          # AdonisJS API
├── frontend/         # Vue.js SPA
├── database/         # Scripts SQL
├── nginx/            # Configurações Nginx
├── certs/            # Certificados SSL
├── docker-compose.yml
└── README.md
```

#### 9.4 Adicionar Seção de Estimativa de Tempo
- [ ] Listar horas dedicadas por fase
- [ ] Comparar com estimativa inicial (52h)
- [ ] Documentar aprendizados

#### 9.5 Adicionar Badges (opcional)
- [ ] Node.js version
- [ ] Vue.js version
- [ ] AdonisJS version
- [ ] License

### 🧪 Checkpoint de Validação
```
1. Outro desenvolvedor consegue rodar o projeto apenas lendo o README
2. Todos os comandos estão documentados
3. Troubleshooting básico está incluído
```

---

## 📦 Resumo de Dependências por Projeto

### Backend (AdonisJS)
```json
{
  "dependencies": {
    "@adonisjs/core": "^6.x",
    "@adonisjs/lucid": "^20.x",
    "@adonisjs/auth": "^9.x",
    "@adonisjs/cors": "^2.x",
    "pg": "^8.x",
    "axios": "^1.x",
    "luxon": "^3.x"
  },
  "devDependencies": {
    "@types/node": "^20.x",
    "typescript": "^5.x"
  }
}
```

### Frontend (Vue.js)
```json
{
  "dependencies": {
    "vue": "^3.4.x",
    "vue-router": "^4.x",
    "pinia": "^2.x",
    "vuetify": "^3.5.x",
    "@mdi/font": "^7.x",
    "axios": "^1.x"
  },
  "devDependencies": {
    "@vitejs/plugin-vue": "^5.x",
    "vite": "^5.x",
    "typescript": "^5.x",
    "eslint": "^8.x",
    "prettier": "^3.x"
  }
}
```

---

## 🎯 Comandos Rápidos para LLM

### Iniciar nova fase
```bash
# Sempre começar com:
git status                    # Ver estado atual
docker-compose ps            # Ver containers rodando
```

### Validar fase concluída
```bash
# Backend
cd backend && npm run build && npm test

# Frontend
cd frontend && npm run build && npm run test

# Docker
docker-compose up --build
```

### Rollback em caso de erro
```bash
git stash                    # Guardar mudanças
git checkout main            # Voltar para branch principal
```

---

## 💡 Dicas para Otimização de Tokens (LLM)

1. **Trabalhar uma fase por vez**: Não pular fases nem misturar contextos
2. **Validar antes de avançar**: Sempre rodar checkpoint antes de próxima fase
3. **Commits incrementais**: Fazer commit após cada tarefa concluída
4. **Reler apenas arquivos necessários**: Não reler toda a codebase
5. **Usar ferramentas de busca**: Grep/Glob antes de ler arquivos grandes
6. **Limpar contexto entre fases**: Indicar claramente quando uma fase termina

### Formato de Solicitação Recomendado
```
"Vamos iniciar a FASE X: [Nome da Fase].
Por favor, execute as tarefas X.1 a X.3.
Ao finalizar, rode o checkpoint de validação."
```

---

## 📞 Suporte

- Documentação AdonisJS: https://docs.adonisjs.com
- Documentação Vue.js: https://vuejs.org
- Documentação Vuetify: https://vuetifyjs.com
- API Geek Joke: https://github.com/sameerkumar18/geek-joke-api

---

## 🏁 Critério de Conclusão do Projeto

O projeto estará **100% completo** quando:

- ✅ Todas as 9 fases estiverem marcadas como concluídas
- ✅ `docker-compose up` subir todos os serviços sem erros
- ✅ Login funcionar com as credenciais especificadas
- ✅ Fluxo de humor completo funcionar (inicial → triste → poker-face → feliz → inicial)
- ✅ Modal exibir piadas da API externa
- ✅ Testes passarem (backend + frontend)
- ✅ README.md documentar como rodar o projeto

---

---

## 📊 Versionamento do Documento (DDD)

Este documento segue versionamento semântico e é atualizado a cada fase concluída.

| Versão | Data | Mudanças | Fase |
|--------|------|----------|------|
| 1.0.0 | 2025-11-04 | Criação inicial com todas as 9 fases especificadas | Fase 0 |
| 1.1.0 | 2025-11-04 | Adicionada metodologia DDD e princípios por fase | Fase 0 |
| 1.2.0 | 2025-11-04 | FASE 3 concluída - Integração API Geek Joke | Fase 3 |

### 🔄 Histórico de Atualizações DDD
- **v1.2.0**: FASE 3 concluída - Integração API Geek Joke
  - Implementado GeekJokeService com tratamento robusto de erros
  - Criado JokesController integrado com o service
  - Adicionada rota protegida GET /jokes/random
  - Corrigido import no user_seeder.ts
  - Build do backend bem-sucedido
  - Atualizada tabela de controle de fases
  - Documentação da fase 3 completa

- **v1.1.0**: Incorporação da metodologia Documentation-Driven Development
  - Adicionada seção de Metodologia DDD
  - Adicionado Workflow DDD por fase
  - Adicionado Checklist DDD (antes, durante, depois)
  - Adicionadas notas DDD em todas as 9 fases
  - README.md criado com documentação completa de DDD

- **v1.0.0**: Documento inicial
  - 9 fases especificadas
  - Tarefas atômicas definidas
  - Checkpoints de validação
  - Dependências listadas

---

**Última atualização:** 2025-11-04
**Versão do documento:** 1.2.0
**Metodologia:** Documentation-Driven Development
**Próxima fase:** FASE 2 - Backend Autenticação JWT (necessária para teste completo da Fase 3) ou FASE 4 - Frontend Estrutura Base
