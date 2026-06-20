# Contribuindo

Obrigada pelo interesse em melhorar o agente de triagem! Este projeto evolui com
contribuições da comunidade jurídica e técnica.

## Como contribuir

1. **Abra uma issue antes de um PR grande.** Para mudanças em critérios de decisão,
   discuta primeiro — isso evita retrabalho e mantém o racional documentado.
2. **Faça um fork** e crie uma branch descritiva:
   ```bash
   git checkout -b ajuste/limiar-salario-setor
   ```
3. **Faça a alteração** (veja as diretrizes abaixo).
4. **Abra um Pull Request** explicando o **o quê** e, principalmente, o **porquê**.

## Tipos de contribuição

### Critérios de decisão (`agents/triagem-acordo-trabalhista.md` + `docs/criterios.md`)

Estes são o coração do projeto. Ao propor mudança:

- **Justifique com racional jurídico ou operacional.** Ex.: "elevar o limiar de
  salário do setor de R$ 3.500 para R$ 4.000 porque [...]".
- **Mantenha os dois arquivos sincronizados.** A definição canônica (executada pelo
  Claude Code) é `agents/triagem-acordo-trabalhista.md`; `docs/criterios.md` é a
  versão de leitura. Toda mudança de critério precisa aparecer nos dois.
- **Preserve a ordem da árvore de decisão** (Níveis 0 → 1 → 2 → 3) e as regras de
  desempate. Se a mudança altera a precedência, descreva o novo comportamento.
- **Novos setores/funções recomendados:** explique o perfil de litígio que torna
  aquele setor/função propício a acordo.

### Documentação (`README.md`, `docs/`)

Correções de clareza, exemplos e instruções de instalação são sempre bem-vindas.

### Ferramentas / MCP

Se adaptar o agente para outros servidores MCP (além de `pje-mni` e `tecjustica`),
documente os pré-requisitos no README.

## Diretrizes de estilo

- **Idioma:** português (pt-BR).
- **Frontmatter do agente:** não quebre o YAML. O campo `tools` é uma lista separada
  por vírgulas; o `name` deve continuar sendo `triagem-acordo-trabalhista`.
- **Mensagens de commit:** descritivas, em português. Prefixos úteis: `docs:`,
  `criterio:`, `fix:`, `feat:`.

## Aviso

Este agente faz **triagem técnica** e **não substitui o juízo do magistrado** nem
constitui aconselhamento jurídico. Contribuições devem preservar esse princípio e os
avisos correspondentes.

## Licença

Ao contribuir, você concorda que sua contribuição será licenciada sob a
[Apache-2.0](LICENSE), a mesma licença do projeto.
