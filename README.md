
# 🎬 Cinema App - Quality Engineering Challenge (PB AWS & AI for QE)

Este repositório contém todo o planejamento, documentação e código de testes manuais e automatizados desenvolvidos durante o **Challenge Final** da trilha **PB AWS & AI for QE - Compass UOL**.

## 🧪 Objetivo

Garantir a **qualidade funcional** da aplicação **Cinema App**, uma plataforma de reserva de ingressos de cinema, por meio de:

- Testes manuais (Postman e Front-End)
- Planejamento completo no Confluence
- Testes automatizados com **Robot Framework**
- Cobertura das **histórias de usuário** reais
- Aplicação de estratégias de QA, priorização, automação e inovação

---

## 🧠 Funcionalidades Testadas

A aplicação possui os seguintes grupos funcionais, **todos cobertos por testes**:

- 🧑 Autenticação e perfil (registro, login, atualização)
- 🎬 Filmes e sessões (listagem, cadastro, reserva)
- 🪑 Seleção de assentos
- 🎟️ Reservas (checkout, histórico, cancelamento)
- 🏢 Theaters (salas de exibição)
- 🔐 Controle de acesso (admin, usuário, visitante)

---

## 📚 Estrutura do Repositório

```
cinema-tests/
├── tests/
│   ├── backend/
│   │   ├── auth_tests.robot
│   │   ├── movie_tests.robot
│   │   ├── reservation_tests.robot
│   │   └── ...
│   └── frontend/
│       ├── ...
├── resources/
│   ├── keywords.robot
│   └── ...
├── variables/
│   └── variables.robot
├── .env.example
├── README.md
```

---

## ⚙️ Tecnologias e Ferramentas

| Área                  | Ferramenta/Ferramenta     |
|-----------------------|---------------------------|
| Testes de API         | Postman                   |
| Testes Automatizados  | Robot Framework + RequestsLibrary |
| Frontend              | React                     |
| Backend               | Node.js (Express + MongoDB Atlas) |
| Documentação          | Confluence Atlassian      |
| Integração Contínua   | (Opcional: GitHub Actions ou Jenkins) |

---

## 🚀 Como executar os testes automatizados

### 1. Requisitos

- Python 3.10+
- Robot Framework
- RequestsLibrary
- (opcional) dotenv para variáveis de ambiente

### 2. Instalação

```bash
pip install robotframework
pip install robotframework-requests
pip install python-dotenv
```

### 3. Configurar variáveis

Crie um arquivo `variables/variables.robot` com as seguintes variáveis:

```robot
*** Variables ***
${BASE_URL}         http://localhost:5000/api/v1
${USER_EMAIL}       user@example.com
${USER_PASSWORD}    password123
${ADMIN_EMAIL}      admin@example.com
${ADMIN_PASSWORD}   password123
```

> Certifique-se de que o backend esteja rodando localmente e que os usuários estejam cadastrados (você pode rodar o script de seed).

### 4. Executar os testes

```bash
robot tests/backend/
```

> Relatórios são gerados automaticamente:
> - `log.html`
> - `report.html`
> - `output.xml`

---

## ✅ Planejamento de Testes

Acesse o **plano completo de testes** aqui:

📄 **Confluence** → [Plano de Testes - Cinema App](https://adonyhibari48.atlassian.net/wiki/spaces/PDT/pages/22839401)

Inclui:

- 🔍 Análise de Requisitos (Histórias de Usuário)
- 🗺️ Mapa Mental com códigos de status
- 📋 Tabela de Casos de Teste por endpoint
- 🧩 Matriz de Risco
- 📊 Priorização de Execução
- 🤖 Testes Candidatos à Automação
- 🐞 Issues & Melhorias Mapeadas

---

## 🧠 Diferenciais Implementados

- ✅ Casos de teste totalmente alinhados com as **User Stories reais**
- ✅ Priorização baseada em **impacto e probabilidade**
- ✅ Matriz de risco e cobertura manual e automatizada
- ✅ Testes com validações completas de resposta (status, payload)
- ✅ Separação clara de responsabilidades entre frontend e backend
- ✅ Cobertura de **Happy Path + Fluxos Negativos essenciais**

---

## 👤 Desenvolvido por

**Ádony Lagares Guimarães**  
Especialista em Qualidade de Software | PB AWS & AI for QE  
[LinkedIn](https://www.linkedin.com/in/adonylagares) | GitHub: [@adonylagares](https://github.com/adonylagares)

---

## 📄 Licença

Este projeto é parte do Challenge final e não possui licença aberta para uso comercial. Para fins de estudo ou demonstração.
