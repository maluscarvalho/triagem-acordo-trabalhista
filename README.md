# Triagem de Processos Trabalhistas para Acordo / Conciliação

Subagente para **[Claude Code](https://docs.claude.com/en/docs/claude-code)** que faz a
**triagem técnica de processos trabalhistas** candidatos a uma **PAUTA ESPECIAL DE
ACORDO / CONCILIAÇÃO**.

A partir de um número de processo no formato CNJ, o agente:

1. Valida o número e consulta a **capa** e a **petição inicial** (via PJe-MNI ou
   TecJustica/PDPJ);
2. Extrai os dados relevantes (porte da reclamada, salário, setor, função, pedidos,
   valor da causa, natureza dos pedidos, reclamada subsidiária, pedidos que exigem
   perícia);
3. Mede a **pressão litigiosa** da reclamada (volume de processos e execuções ativas
   no DataLake/PDPJ do CNJ pelo CNPJ);
4. Aplica uma **árvore de decisão** em níveis de prioridade;
5. Emite um **RELATÓRIO COMPLETO** com veredito — **RECOMENDADO ✅ / NÃO RECOMENDADO ❌
   / NUNCA ⛔** — e fundamentação item a item.

> ⚖️ **Aviso.** O agente **não decide o mérito** e **não substitui o juízo do
> magistrado**. Ele faz uma triagem técnica baseada em critérios objetivos,
> sinalizando sempre quando faltar dado ou houver conflito entre critérios. A
> decisão final é sempre humana.

---

## Pré-requisitos

- **Claude Code** instalado ([guia oficial](https://docs.claude.com/en/docs/claude-code)).
- Dois servidores **MCP** configurados (o agente usa as ferramentas deles):
  - **`pje-mni`** — acesso ao PJe via MNI (capa, petição inicial, documentos).
    Requer credenciais MNI válidas para o(s) TRT(s) consultado(s).
  - **`tecjustica`** — acesso ao PDPJ/CNJ (visão geral, partes, documentos,
    busca de processos por CPF/CNPJ, precedentes).

Se o `pje-mni` não estiver disponível ou as credenciais não funcionarem para um TRT
específico, o agente faz *fallback* para o `tecjustica` (PDPJ).

---

## Instalação

Clone o repositório e copie o arquivo do agente para a pasta de agentes do Claude Code.

### Instalação por usuário (global — disponível em todas as pastas)

```bash
git clone https://github.com/maluscarvalho/triagem-acordo-trabalhista.git
cd triagem-acordo-trabalhista
mkdir -p ~/.claude/agents
cp agents/triagem-acordo-trabalhista.md ~/.claude/agents/
```

### Instalação por projeto (apenas no repositório atual)

```bash
mkdir -p .claude/agents
cp /caminho/para/triagem-acordo-trabalhista/agents/triagem-acordo-trabalhista.md .claude/agents/
```

Reinicie o Claude Code (ou abra uma nova sessão) para que o agente seja reconhecido.

---

## Como usar

Em uma sessão do Claude Code, basta pedir a triagem informando o número CNJ:

```
Faça a triagem para pauta de acordo do processo 0010368-93.2025.5.03.0160
```

Ou invoque o subagente diretamente:

```
Use o agente triagem-acordo-trabalhista no processo 0010368-93.2025.5.03.0160 (2º grau)
```

O agente devolve o **RELATÓRIO COMPLETO** padronizado (ver formato em
[`docs/criterios.md`](docs/criterios.md)).

---

## Critérios de decisão

A lógica completa — árvore de decisão por níveis, leitura da pressão litigiosa,
regras de desempate e formato do relatório — está documentada em
**[`docs/criterios.md`](docs/criterios.md)**.

Resumo dos níveis:

| Nível | Papel | Efeito |
|-------|-------|--------|
| **0** | Exclusão absoluta (reclamada subsidiária) | `NUNCA ⛔` |
| **1** | Bloqueios por perícia / natureza do pedido | `NÃO RECOMENDADO ❌` (salvo exceção) |
| **2** | Favoráveis fortes (ME/EPP, doméstico, setor/função + salário, pedidos negociáveis) | `RECOMENDADO ✅` |
| **3** | Favoráveis por composição dos pedidos / valor | `RECOMENDADO ✅` |
| **Pressão litigiosa** | Desempate / qualificação / informativo | Não bloqueia sozinha |

---

## Estrutura do repositório

```
triagem-acordo-trabalhista/
├── agents/
│   └── triagem-acordo-trabalhista.md   # definição do subagente (frontmatter + prompt)
├── docs/
│   └── criterios.md                    # árvore de decisão e formato do relatório
├── LICENSE                             # Apache-2.0
├── .gitignore
└── README.md
```

---

## Contribuindo

Sugestões de novos critérios, setores/funções recomendados ou ajustes nos limiares
são bem-vindas via *issues* e *pull requests*. Ao propor mudança em critério de
decisão, descreva o racional jurídico/operacional por trás dela.

---

## Licença

Distribuído sob a licença **Apache-2.0**. Veja [`LICENSE`](LICENSE).
