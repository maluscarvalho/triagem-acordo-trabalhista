# Critérios de triagem — detalhamento

Este documento descreve a lógica de decisão aplicada pelo agente. A definição
canônica (que o Claude Code executa) está em
[`../agents/triagem-acordo-trabalhista.md`](../agents/triagem-acordo-trabalhista.md);
este arquivo é a versão de leitura para revisão e discussão dos critérios.

---

## 1. Checklist de dados extraídos

- **Reclamada(s):** nome, **CNPJ** (obrigatório para a pressão litigiosa), porte
  (ME / EPP / MEI / empregador doméstico / pessoa física / empresa comum), situação
  cadastral (ativa / fechada / inapta / suspensa) e se há **sócios no polo passivo**.
- **Reclamada subsidiária?** — dado crítico de exclusão.
- **Múltiplos reclamados?**
- **Valor da causa.**
- **Salário** informado na inicial.
- **Setor / ramo de atividade.**
- **Função / cargo** do reclamante.
- **Pedidos:** classificados em rescisórios, indenizatórios (dano moral/material),
  salariais, adicionais (insalubridade/periculosidade), equiparação, e pedidos que
  **exigem perícia** (técnica ou médica).
- **Maior parte do pedido (em valor).**
- **Pressão litigiosa:** volume de processos e execuções ativas no PDPJ pelo CNPJ.

> Se um dado essencial não for localizado, o agente declara **"dado não localizado"**
> e segue com o que houver, sinalizando o impacto na conclusão.

---

## 2. Pressão litigiosa da reclamada

Captura dois sinais comportamentais objetivos — **volume de litígios** e **pressão
financeira por execução** — que indicam o incentivo sistêmico da empresa para acordar.

**Volume de processos ativos (polo passivo, classe trabalhista):**

| Faixa | Leitura |
|-------|---------|
| 1–4 | Pressão **baixa** — litígios pontuais; sinal neutro |
| 5–14 | Pressão **moderada** — passivo recorrente; leve incentivo |
| 15+ | Pressão **alta** — litígio estrutural; incentivo significativo |

**Execuções ativas** (execução de título extrajudicial, cumprimento de sentença, etc.):

| Faixa | Leitura |
|-------|---------|
| 0 | Sinal neutro |
| 1–3 | Pressão financeira **imediata** — dívidas judiciais constituídas |
| 4+ | Pressão financeira **severa** — incentivo urgente para negociar |

**Limitações** (sempre declaradas no relatório): o PDPJ/DataLake CNJ não cobre todos
os TRTs nem processos anteriores à integração; os números são o **mínimo identificado**.
Reclamada pessoa física ou MEI sem CNPJ → etapa pulada.

**Papel na decisão:** a pressão litigiosa **não bloqueia** e **não substitui** os
Níveis 0–3. Serve para (a) desempatar casos borderline, (b) qualificar a recomendação
e (c) informar a estratégia da audiência.

---

## 3. Árvore de decisão (aplicar nesta ordem)

### Nível 0 — Exclusão absoluta
- **Reclamada subsidiária no polo passivo → `NUNCA`.** Prevalece sobre tudo.

### Nível 1 — Bloqueios por perícia / natureza do pedido (`NÃO RECOMENDADO`, salvo exceção)
- Insalubridade/periculosidade controversa que exige perícia → `NÃO RECOMENDADO`,
  **exceto** se (valor da causa < R$ 50.000 **E** reclamada ME/EPP).
- Maioria do pedido (em valor) = adicional de periculosidade → `NÃO RECOMENDADO`.
- Maioria do pedido (em valor) = adicional de insalubridade → `NÃO RECOMENDADO`.
- Maioria do pedido (em valor) = equiparação salarial → `NÃO RECOMENDADO`.
- Pedido com perícia médica → `NÃO RECOMENDADO`.
- Pedidos complexos / múltiplos reclamados → fator desfavorável (não bloqueia sozinho).

### Nível 2 — Favoráveis fortes (`RECOMENDADO`, independe do valor da causa)
- Reclamada **ME ou EPP**.
- **Empregador doméstico, pessoa física ou MEI**.
- Empresa **fechada/inapta/suspensa com sócios no polo passivo**.
- **Setor recomendado + salário < R$ 3.500,00**.
- **Função recomendada + salário < R$ 2.500,00**.
- Pedidos com **ampla margem de negociação** (reversão de justa causa, rescisão
  indireta, vínculo de emprego, assédio moral, etc.) — mesmo com valor > R$ 80.000.

> Listas completas de setores e funções recomendados estão na definição do agente.

### Nível 3 — Favoráveis por composição dos pedidos / valor (`RECOMENDADO`)
- Apenas **verbas rescisórias** (férias, 13º, multa do art. 477, FGTS).
- **Dano moral + rescisórias** como maior parte **e** valor da causa < R$ 80.000.
- Pedido de **dano moral** ou **dano material**.
- **Maioria dos pedidos** rescisória ou indenizatória.

---

## 4. Regras de desempate

- Nível 0 (subsidiária) **sempre** vence → `NUNCA`.
- Bloqueio de perícia só cai pela exceção expressa (valor < R$ 50.000 **E** ME/EPP).
  Status ME/EPP sozinho **não** afasta a perícia.
- Um favorável forte do Nível 2 supera a mera "complexidade" do Nível 1, mas **não**
  supera bloqueios de perícia / adicional / equiparação majoritários.
- Dúvida real ou dado faltante que mude o resultado → o agente **explicita a dúvida**
  e indica qual dado a resolveria.

---

## 5. Formato do relatório

```
═══════════════════════════════════════════════
TRIAGEM PARA PAUTA DE ACORDO — Processo nº <CNJ>
═══════════════════════════════════════════════

▸ VEREDITO: RECOMENDADO ✅ | NÃO RECOMENDADO ❌ | NUNCA ⛔
▸ DADOS EXTRAÍDOS
▸ PRESSÃO LITIGIOSA (PDPJ/DataLake CNJ — mínimo identificado)
▸ ANÁLISE ITEM A ITEM (Níveis 0–3 + pressão litigiosa)
▸ CONFLITOS / DÚVIDAS / DADOS FALTANTES
▸ CONCLUSÃO
```

O modelo completo, com todos os campos, está na definição do agente.
